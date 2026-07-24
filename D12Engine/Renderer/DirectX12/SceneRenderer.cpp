#include "pch.h"
#include "SceneRenderer.h"

#include "D3D12Context.h"
#include "EngineCore/GameTimer.h"
#include "EngineCore/Scene/Scene.h"
#include "EngineCore/Logging/Logger.h"

#include "Renderer/DirectX12/MACRO.h"
#include "Renderer/DirectX12/GeometryGenerator.h"
#include "Renderer/DirectX12/RenderData.h"
#include "Renderer/DirectX12/PipelineStateFactory.h"

#include "AssetPipeline/Importers/FbxImporter.h"

#include <filesystem>
#include <cassert>
#include <cmath>

using namespace Microsoft::WRL;
using namespace DirectX;

SceneRenderer::SceneRenderer(Scene& scene) : mScene(scene)
{
}

bool SceneRenderer::Initialize(D3D12Context& context, DXGI_FORMAT colorFormat, DXGI_FORMAT depthFormat)
{
	if (mInitialized) return true;

	mColorFormat = colorFormat;
	mDepthFormat = depthFormat;
	
	mWaves = std::make_unique<GpuWaves>(
		context.GetDevice(),
		context.GetCommandList(),
		256, 256, 0.25f, 0.03f, 2.0f, 0.2f);

	mBlurFilter = std::make_unique<BlurFilter>(
		context.GetDevice(),
		mViewportWidth, mViewportWidth,
		mColorFormat);

	mSobelFilter = std::make_unique<SobelFilter>(
		context.GetDevice(),
		mViewportWidth, mViewportWidth,
		mColorFormat);

	mCamera.SetPosition(15.0f, 20.0f, -30.0f);
	mCamera.Pitch(0.5f);
	mCamera.RotateY(-0.5f);

	//LoadSkinnedModel_dx12ex(context);
	LoadTextures(context);

	BuildDescriptorHeaps(context);
	BuildRootSignature(context);
	BuildShadersAndInputLayout();
	BuildGeometry(context);
	BuildMaterials(context);
	BuildRenderItems();
	BuildFrameResources(context);
	BuildPSOs(context);

	CreateQueryHeap(context);

	mTimer.Reset();
	mInitialized = true;

	return true;
}

void SceneRenderer::Shutdown()
{
	if (!mInitialized) return;

	//추후 해제로직
	
	mInitialized = false;
}

void SceneRenderer::OnResize(D3D12Context& context, const D3D12RenderTarget& renderTarget)
{
	int width = renderTarget.GetWidth();
	int height = renderTarget.GetHeight();
	mViewportWidth = std::max(1, width);
	mViewportHeight = std::max(1, height);

	mCamera.SetLens(DirectX::XM_PIDIV4, AspectRatio(), 1.0f, 1000.0f);

	BoundingFrustum::CreateFromMatrix(mCamFrustum, mCamera.GetProj());

	mBlurFilter->OnResize(mViewportWidth, mViewportHeight);
	mSobelFilter->OnResize(mViewportWidth, mViewportHeight);
}

void SceneRenderer::Tick(D3D12Context& context, D3D12RenderTarget& renderTarget, const Scene& scene)
{
	mTimer.Tick();

	mCurrFrameResourceIndex = context.GetCurrentFrameIndex();
	mCurrFrameResource = mFrameResources[mCurrFrameResourceIndex].get();

	Update(scene, mTimer.DeltaTime());
	Render(context, renderTarget, scene);
}

float SceneRenderer::AspectRatio() const
{
	return static_cast<float>(mViewportWidth) / mViewportHeight;
}

void SceneRenderer::SetRenderSetting(SceneRenderMode mode)
{
	mRenderSettings.Mode = mode;
}

void SceneRenderer::ToggleSobel()
{
	mRenderSettings.SobelEnabled = !mRenderSettings.SobelEnabled;
}

void SceneRenderer::NextBlurCount()
{
	mRenderSettings.NextBlurCount();
}

void SceneRenderer::PickRenderItem(int vx, int vy)
{
	mGizmo.Pick(vx, vy, mRenderItemLayer);
}

void SceneRenderer::ZoomCamera(int wheelDelta)
{
	constexpr float wheelSpeed = 0.01f;
	mCamera.MoveForward(wheelDelta * wheelSpeed);
}

void SceneRenderer::RotateCamera(POINT mouseDelta)
{
	float dx = DirectX::XMConvertToRadians(0.5f * mouseDelta.x);
	float dy = DirectX::XMConvertToRadians(0.5f * mouseDelta.y);

	mCamera.Pitch(dy);
	mCamera.RotateY(dx);
}

void SceneRenderer::MoveSun(float deltaTheta, float deltaPhi)
{
	mSunTheta += deltaTheta * mTimer.DeltaTime();
	mSunPhi += deltaPhi * mTimer.DeltaTime();

	mSunPhi = MathHelper::Clamp(mSunPhi, 1.0f, XM_PIDIV2);
}

void SceneRenderer::ChangeMsaa(const D3D12Context& context)
{
	BuildPSOs(context);
}

void SceneRenderer::Update(const Scene& scene, float deltaTime)
{
	if (!mInitialized) return;

	mCamera.UpdateViewMatrix();

	SyncSceneObjectTransforms();
	mGizmo.Update(&mCamera, mViewportWidth, mViewportHeight);

	// 이 시점이면 이 FrameResource slot의 이전 GPU 작업은 완료됨.
	ReadbackTimestampData(mCurrFrameResourceIndex);

	AnimateMaterials();
	UpdateShadowTransform();
	UpdateSkinnedCBs();
	UpdateMainPassCB();
	UpdateReflectedPassCB();
	UpdateInstanceBuffer();
	UpdateMaterialBuffer();
}

void SceneRenderer::Render(D3D12Context& context, D3D12RenderTarget& renderTarget, const Scene& scene)
{
	if (!mInitialized) return;

	ID3D12GraphicsCommandList* mCommandList = context.GetCommandList();
	ID3D12CommandQueue* mCommandQueue = context.GetCommandQueue();

	//Timestamp start
	UINT baseQuery = mCurrFrameResourceIndex * 4;

	UINT FullStart = baseQuery + 0;
	UINT FullEnd = baseQuery + 1;
	UINT SceneStart = baseQuery + 2;
	UINT SceneEnd = baseQuery + 3;
	D3D12_QUERY_TYPE queryType = D3D12_QUERY_TYPE_TIMESTAMP;
	mCommandList->EndQuery(mTimestampQueryHeap.Get(), queryType, FullStart);

	std::vector<ID3D12DescriptorHeap*> descriptorHeap = { context.GetSrvUavHeap() };
	mCommandList->SetDescriptorHeaps(static_cast<UINT>(descriptorHeap.size()), descriptorHeap.data());
	mCommandList->SetGraphicsRootSignature(mRootSignature.Get());

	UpdateWavesGPU(mCommandList);
	mCommandList->SetGraphicsRootDescriptorTable(6, mWaves->DisplacementMap());	//시뮬한 높이 값 바인딩

	auto passCB = mCurrFrameResource->PassCB->Resource();
	UINT passCBByteSize = D3D12Util::CalcConstantBufferByteSize(sizeof(PassConstants));

	UINT treeArrayTexIndex = TextureManager::GetInstance().Find(L"Resource/Textures/Treearray2.dds")->Srv.Index;
	CD3DX12_GPU_DESCRIPTOR_HANDLE hTable(context.GetSrvUavHeap()->GetGPUDescriptorHandleForHeapStart());
	mCommandList->SetGraphicsRootDescriptorTable(3, hTable);
	hTable.Offset(treeArrayTexIndex, context.GetCbvSrvUavDescriptorSize());
	mCommandList->SetGraphicsRootDescriptorTable(7, hTable);

	auto instanceBufferAddress = mCurrFrameResource->InstanceBuffer->Resource()->GetGPUVirtualAddress();
	mCommandList->SetGraphicsRootShaderResourceView(5, instanceBufferAddress);

	auto matBuffer = mCurrFrameResource->MaterialBuffer->Resource();
	mCommandList->SetGraphicsRootShaderResourceView(4, matBuffer->GetGPUVirtualAddress());

	mCommandList->EndQuery(
		mTimestampQueryHeap.Get(),
		queryType,
		SceneStart);

	for (int layer = 0; layer < (int)RenderLayer::Count; layer++)
	{
		RenderLayer renderLayer = (RenderLayer)layer;
		assert(mLayerPSOs[layer][(int)SceneRenderMode::Lit] && "모든 RenderLayer에는 Lit PSO가 필요합니다.");

		mCommandList->SetGraphicsRootConstantBufferView(0, passCB->GetGPUVirtualAddress());
		if (renderLayer == RenderLayer::Reflected)
			mCommandList->SetGraphicsRootConstantBufferView(0, passCB->GetGPUVirtualAddress() + passCBByteSize);

		mCommandList->OMSetStencilRef(0);
		if(renderLayer == RenderLayer::MirrorStencil || renderLayer == RenderLayer::TessWall ||
			renderLayer == RenderLayer::MirrorBaseFill || renderLayer == RenderLayer::Reflected)
			mCommandList->OMSetStencilRef(1);

		ID3D12PipelineState* pso = ResolvePSO(renderLayer, mRenderSettings.Mode);
		mCommandList->SetPipelineState(pso);

		DrawRenderItems(mCommandList, mRenderItemLayer[layer]);

		if (mRenderSettings.Mode == SceneRenderMode::VertexNormal)
		{
			mCommandList->SetPipelineState(mGraphicsPSOs[(int)GraphicsPass::VertexNormalVisualize].Get());
			DrawRenderItems_VertexNormalDebug(mCommandList, mRenderItemLayer[layer]);
		}
	}

	if (!mGizmo.GetSelectedInstances().empty())
	{
		mCommandList->OMSetStencilRef(0x80);

		// 선택 원본 메시를 stencil에 기록
		mCommandList->SetPipelineState(mGraphicsPSOs[(int)GraphicsPass::SelectedMask].Get());
		DrawSelectedInstance(mCommandList);

		// stencil != 1 인 부분에만 부풀린 외곽선 출력
		mCommandList->SetPipelineState(mGraphicsPSOs[(int)GraphicsPass::SelectedOutline].Get());
		DrawSelectedInstance(mCommandList);
	}

	if (mRenderSettings.Mode == SceneRenderMode::DepthComplexity)
	{
		mCommandList->SetGraphicsRootSignature(mRootSignature_debug.Get());
		mCommandList->SetPipelineState(mGraphicsPSOs[(int)GraphicsPass::DepthComplexityVisualize].Get());
		DrawDebugColorTriangle(mCommandList);
	}

	mCommandList->EndQuery(
		mTimestampQueryHeap.Get(),
		queryType,
		SceneEnd);

	if (context.mMsaaOption.IsEnable())
		renderTarget.ResolveMsaaToColorBuffer(mCommandList);

	if (mRenderSettings.SobelEnabled)
	{
		renderTarget.TransitionIfNeeded(
			mCommandList,
			renderTarget.GetColorResource(),
			renderTarget.GetColorState(),
			D3D12_RESOURCE_STATE_GENERIC_READ);

		mSobelFilter->Excute(mCommandList,
			mPostProcessRootSignature.Get(),
			mComputePSOs[(int)ComputePass::SobelExcute].Get(),
			(CD3DX12_GPU_DESCRIPTOR_HANDLE)renderTarget.GetSRVGpu());

		mSobelFilter->Composite(mCommandList,
			mPostProcessRootSignature.Get(),
			mComputePSOs[(int)ComputePass::SobelComposite].Get(),
			(CD3DX12_GPU_DESCRIPTOR_HANDLE)renderTarget.GetSRVGpu(),
			mSobelFilter->SobelOutputSrv());

		renderTarget.TransitionIfNeeded(
			mCommandList,
			renderTarget.GetColorResource(),
			renderTarget.GetColorState(),
			D3D12_RESOURCE_STATE_COPY_DEST);

		mCommandList->CopyResource(renderTarget.GetColorResource(), mSobelFilter->CompositeOutput());

		renderTarget.TransitionIfNeeded(
			mCommandList,
			renderTarget.GetColorResource(),
			renderTarget.GetColorState(),
			D3D12_RESOURCE_STATE_RENDER_TARGET);
	}

	if (mRenderSettings.GetBlurCount() != 0)
	{
		mBlurFilter->Excute(mCommandList, mPostProcessRootSignature.Get(),
			mComputePSOs[(int)ComputePass::BlurHorizontal].Get(),
			mComputePSOs[(int)ComputePass::BlurVertical].Get(),
			renderTarget.GetColorResource(), renderTarget.GetColorState(),
			mRenderSettings.GetBlurCount());

		renderTarget.TransitionIfNeeded(
			mCommandList,
			renderTarget.GetColorResource(),
			renderTarget.GetColorState(),
			D3D12_RESOURCE_STATE_COPY_DEST);

		mCommandList->CopyResource(renderTarget.GetColorResource(), mBlurFilter->SobelOutput());

		renderTarget.TransitionIfNeeded(
			mCommandList,
			renderTarget.GetColorResource(),
			renderTarget.GetColorState(),
			D3D12_RESOURCE_STATE_RENDER_TARGET);
	}

	renderTarget.PrepareForSampling(mCommandList);

	//Timestamp end
	mCommandList->EndQuery(mTimestampQueryHeap.Get(), queryType, FullEnd);

	mCommandList->ResolveQueryData(
		mTimestampQueryHeap.Get(),
		queryType,
		baseQuery,
		4,
		mTimestampReadbackBuffer.Get(),
		sizeof(UINT64) * baseQuery);
}

void SceneRenderer::ReadbackTimestampData(int frameResourceIndex)
{
	if (mTimestampReadbackBuffer == nullptr)
		return;

	if (mGpuTimestampFrequency == 0)
		return;

	// 아직 이 frame resource slot으로 한 번도 Draw/Resolve가 끝난 적 없으면 읽을 값 없음.
	//if (mCurrFrameResource->FenceValue == 0)
	//	return;

	const UINT queryCountPerFrame = 4;
	const UINT baseQuery = frameResourceIndex * queryCountPerFrame;

	const UINT fullStartIndex = baseQuery + 0;
	const UINT fullEndIndex = baseQuery + 1;
	const UINT sceneStartIndex = baseQuery + 2;
	const UINT sceneEndIndex = baseQuery + 3;

	const UINT64 readStart = sizeof(UINT64) * baseQuery;
	const UINT64 readEnd = sizeof(UINT64) * (baseQuery + queryCountPerFrame);

	D3D12_RANGE readRange = {};
	readRange.Begin = readStart;
	readRange.End = readEnd;

	UINT64* mappedData = nullptr;

	ThrowIfFailed(mTimestampReadbackBuffer->Map(
		0,
		&readRange,
		reinterpret_cast<void**>(&mappedData)));

	const UINT64 fullStart = mappedData[fullStartIndex];
	const UINT64 fullEnd = mappedData[fullEndIndex];
	const UINT64 sceneStart = mappedData[sceneStartIndex];
	const UINT64 sceneEnd = mappedData[sceneEndIndex];

	mTimestampReadbackBuffer->Unmap(0, nullptr);

	// 첫 몇 프레임 또는 query 누락 방어.
	if (fullEnd > fullStart)
	{
		mFullGpuMs =
			double(fullEnd - fullStart) * 1000.0 /
			double(mGpuTimestampFrequency);
	}

	if (sceneEnd > sceneStart)
	{
		mSceneGpuMs =
			double(sceneEnd - sceneStart) * 1000.0 /
			double(mGpuTimestampFrequency);
	}
}

void SceneRenderer::LoadTextures(D3D12Context& context)
{
	double start = mTimer.TotalTime();

	std::vector<std::filesystem::path> paths =
	{
		L"Resource/Textures/White1x1.dds",
		L"Resource/Textures/MipmapTest.dds",
		L"Resource/Textures/Bricks.dds",
		L"Resource/Textures/Stone.dds",
		L"Resource/Textures/Tile.dds",
		L"Resource/Textures/Grass.dds",
		L"Resource/Textures/Water1.dds",
		L"Resource/Textures/Swirling.dds",
		L"Resource/Textures/Swirling_Mask.dds",
		L"Resource/Textures/WireFence.dds",
		L"Resource/Textures/Bricks2.dds",
		L"Resource/Textures/Checkboard.dds",
		L"Resource/Textures/Ice.dds",
		L"Resource/Textures/Help.dds",
		L"Resource/Textures/Treearray2.dds",
	};

	for (UINT i = 0; i < mSkinnedMats.size(); i++)
	{
		std::string diffuseName = mSkinnedMats[i].DiffuseMapName;
		std::string normalName = mSkinnedMats[i].NormalMapName;

		std::wstring diffuseFilename = L"Resource/Textures/" + AnsiToWString(diffuseName);
		std::wstring normalFilename = L"Resource/Textures/" + AnsiToWString(normalName);

		//확장자 제거.
		diffuseName = diffuseName.substr(0, diffuseName.find_last_of("."));
		normalName = normalName.substr(0, normalName.find_last_of("."));

		mSkinnedTexturePaths.push_back(diffuseFilename);
		mSkinnedNormalTexturePaths.push_back(normalFilename);
		paths.push_back(diffuseFilename);
		//paths.push_back(normalFilename);
	}

	//묶음 로딩 : 텍스처 15개 기준 3ms 단축.
	ThrowIfFailed(TextureManager::GetInstance().LoadDDS(context, paths));

	double elapsedMs = (mTimer.TotalTime() - start) * 1000.0;
	std::wstring s = L"Texture Load elapsed : "
		+ std::to_wstring(elapsedMs)
		+ L" ms\n";
	Logger::Info(s);
}

void SceneRenderer::BuildDescriptorHeaps(D3D12Context& context)
{
	/*
		백버퍼의 SRV SwapChainBufferCount개.
		기존 텍스처
		ImGui Font
		ImGui용 추가 슬롯(optional)
		mWaves의 DiscriptorCount개수 6개.
		mBlurFilter의 DescriptorCount 개수 4개.
		mSobelFilter의 DescriptorCount 개수 4개.
	*/

	mWaves->BuildDescriptors([&context](
		D3D12_CPU_DESCRIPTOR_HANDLE* outCpuHandle,
		D3D12_GPU_DESCRIPTOR_HANDLE* outGpuHandle)
		{
			context.AllocateSrvUavDescriptor(outCpuHandle, outGpuHandle);
		},
		[&context](D3D12_GPU_DESCRIPTOR_HANDLE gpuHandle)
		{
			context.FreeSrvUavDescriptor(gpuHandle);
		});

	mBlurFilter->BuildDescriptors([&context](
			D3D12_CPU_DESCRIPTOR_HANDLE* outCpuHandle,
			D3D12_GPU_DESCRIPTOR_HANDLE* outGpuHandle)
		{
			context.AllocateSrvUavDescriptor(outCpuHandle, outGpuHandle);
		});

	mSobelFilter->BuildDescriptors([&context](
		D3D12_CPU_DESCRIPTOR_HANDLE* outCpuHandle,
		D3D12_GPU_DESCRIPTOR_HANDLE* outGpuHandle)
		{
			context.AllocateSrvUavDescriptor(outCpuHandle, outGpuHandle);
		});
}

void SceneRenderer::BuildMaterials(D3D12Context& context)
{
	std::map<std::string, std::wstring> textures =
	{
		{"defaultTex", L"Resource/Textures/White1x1.dds"},
		{"woodCrateTex", L"Resource/Textures/MipmapTest.dds"},
		{"bricksTex0", L"Resource/Textures/Bricks.dds"},
		{"stoneTex", L"Resource/Textures/Stone.dds"},
		{"tileTex", L"Resource/Textures/Tile.dds"},
		{"grassTex", L"Resource/Textures/Grass.dds"},
		{"waterTex", L"Resource/Textures/Water1.dds"},
		{"swirlingTex", L"Resource/Textures/Swirling.dds"},
		{"swirlingMaskTex", L"Resource/Textures/Swirling_Mask.dds"},
		{"fenceTex", L"Resource/Textures/WireFence.dds"},
		{"bricksTex1", L"Resource/Textures/Bricks2.dds"},
		{"checkboardTex", L"Resource/Textures/Checkboard.dds"},
		{"iceTex", L"Resource/Textures/Ice.dds"},
		{"helpTex", L"Resource/Textures/Help.dds"},
		{"treeArrayTex", L"Resource/Textures/Treearray2.dds"}
	};

	UINT index = 0;

	auto defaultMat = std::make_unique<Material>();
	defaultMat->Name = "defaultMat";
	defaultMat->MatBufferIndex = index++;
	defaultMat->DiffuseTexturePath = textures["defaultTex"];
	defaultMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	defaultMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	defaultMat->Roughness = 0.3f;

	auto tileMat = std::make_unique<Material>();
	tileMat->Name = "tile0";
	tileMat->MatBufferIndex = index++;
	tileMat->DiffuseTexturePath = textures["tileTex"];
	tileMat->DiffuseAlbedo = XMFLOAT4(Colors::LightGray);
	tileMat->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	tileMat->Roughness = 0.2f;

	auto bricksMat0 = std::make_unique<Material>();
	bricksMat0->Name = "bricks0";
	bricksMat0->MatBufferIndex = index++;
	bricksMat0->DiffuseTexturePath = textures["bricksTex0"];
	bricksMat0->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	bricksMat0->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	bricksMat0->Roughness = 0.1f;

	auto stoneMat = std::make_unique<Material>();
	stoneMat->Name = "stone0";
	stoneMat->MatBufferIndex = index++;
	stoneMat->DiffuseTexturePath = textures["stoneTex"];
	stoneMat->DiffuseAlbedo = XMFLOAT4(Colors::LightSteelBlue);
	stoneMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	stoneMat->Roughness = 0.3f;

	auto grassMat = std::make_unique<Material>();
	grassMat->Name = "grass0";
	grassMat->MatBufferIndex = index++;
	grassMat->DiffuseTexturePath = textures["grassTex"];
	grassMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	grassMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	grassMat->Roughness = 0.125f;

	auto waterMat = std::make_unique<Material>();
	waterMat->Name = "water0";
	waterMat->MatBufferIndex = index++;
	waterMat->DiffuseTexturePath = textures["waterTex"];
	waterMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.5f);
	waterMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	waterMat->Roughness = 0.0f;

	auto woodCrateMat = std::make_unique<Material>();
	woodCrateMat->Name = "woodCrate";
	woodCrateMat->MatBufferIndex = index++;
	woodCrateMat->DiffuseTexturePath = textures["woodCrateTex"];
	woodCrateMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	woodCrateMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	woodCrateMat->Roughness = 0.0f;

	auto swirlingMat = std::make_unique<Material>();
	swirlingMat->Name = "swirling";
	swirlingMat->MatBufferIndex = index++;
	swirlingMat->DiffuseTexturePath = textures["swirlingTex"];
	swirlingMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMat->Roughness = 0.0f;

	auto swirlingMaskMat = std::make_unique<Material>();
	swirlingMaskMat->Name = "swirlingMask";
	swirlingMaskMat->MatBufferIndex = index++;
	swirlingMaskMat->DiffuseTexturePath = textures["swirlingMaskTex"];
	swirlingMaskMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMaskMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMaskMat->Roughness = 0.0f;

	auto wireFence = std::make_unique<Material>();
	wireFence->Name = "wireFence";
	wireFence->MatBufferIndex = index++;
	wireFence->DiffuseTexturePath = textures["fenceTex"];
	wireFence->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	wireFence->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	wireFence->Roughness = 0.25f;

	auto bricksMat1 = std::make_unique<Material>();
	bricksMat1->Name = "bricks1";
	bricksMat1->MatBufferIndex = index++;
	bricksMat1->DiffuseTexturePath = textures["bricksTex1"];
	bricksMat1->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	bricksMat1->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	bricksMat1->Roughness = 0.25f;

	auto checkerTileMat = std::make_unique<Material>();
	checkerTileMat->Name = "checkerTileMat";
	checkerTileMat->MatBufferIndex = index++;
	checkerTileMat->DiffuseTexturePath = textures["checkboardTex"];
	checkerTileMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	checkerTileMat->FresnelR0 = XMFLOAT3(0.07f, 0.07f, 0.07f);
	checkerTileMat->Roughness = 0.3f;

	auto iceMirrorMat = std::make_unique<Material>();
	iceMirrorMat->Name = "iceMirrorMat";
	iceMirrorMat->MatBufferIndex = index++;
	iceMirrorMat->DiffuseTexturePath = textures["iceTex"];
	iceMirrorMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.3f);
	iceMirrorMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	iceMirrorMat->Roughness = 0.5f;

	auto shadowMat_skull = std::make_unique<Material>();
	shadowMat_skull->Name = "shadowMat_skull";
	shadowMat_skull->MatBufferIndex = index++;
	shadowMat_skull->DiffuseTexturePath = textures["defaultTex"];
	shadowMat_skull->DiffuseAlbedo = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.5f);
	shadowMat_skull->FresnelR0 = XMFLOAT3(0.001f, 0.001f, 0.001f);
	shadowMat_skull->Roughness = 0.0f;

	auto treeBillboardMat = std::make_unique<Material>();
	treeBillboardMat->Name = "treeBillboardMat";
	treeBillboardMat->MatBufferIndex = index++;
	treeBillboardMat->DiffuseTexturePath = textures["treeArrayTex"];
	treeBillboardMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	treeBillboardMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	treeBillboardMat->Roughness = 0.125f;

	auto mirrorBaseMat = std::make_unique<Material>();
	mirrorBaseMat->Name = "mirrorBaseMat";
	mirrorBaseMat->MatBufferIndex = index++;
	mirrorBaseMat->DiffuseTexturePath = textures["defaultTex"];
	mirrorBaseMat->DiffuseAlbedo = mMainPassCB.gFogColor;
	mirrorBaseMat->FresnelR0 = XMFLOAT3(0.0f, 0.0f, 0.0f);
	mirrorBaseMat->Roughness = 1.0f;

	auto highlightMat = std::make_unique<Material>();
	highlightMat->Name = "highlightMat";
	highlightMat->MatBufferIndex = index++;
	highlightMat->DiffuseTexturePath = textures["defaultTex"];
	highlightMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 0.0f, 0.6f);
	highlightMat->FresnelR0 = XMFLOAT3(0.06f, 0.06f, 0.06f);
	highlightMat->Roughness = 0.0f;

	auto gizmoX = std::make_unique<Material>();
	gizmoX->Name = "gizmoX";
	gizmoX->MatBufferIndex = index++;
	gizmoX->DiffuseTexturePath = textures["defaultTex"];
	gizmoX->DiffuseAlbedo = XMFLOAT4(1.0f, 0.05f, 0.05f, 0.5f);
	gizmoX->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	gizmoX->Roughness = 0.4f;

	auto gizmoY = std::make_unique<Material>();
	gizmoY->Name = "gizmoY";
	gizmoY->MatBufferIndex = index++;
	gizmoY->DiffuseTexturePath = textures["defaultTex"];
	gizmoY->DiffuseAlbedo = XMFLOAT4(0.05f, 1.0f, 0.05f, 0.5f);
	gizmoY->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	gizmoY->Roughness = 0.4f;

	auto gizmoZ = std::make_unique<Material>();
	gizmoZ->Name = "gizmoZ";
	gizmoZ->MatBufferIndex = index++;
	gizmoZ->DiffuseTexturePath = textures["defaultTex"];
	gizmoZ->DiffuseAlbedo = XMFLOAT4(0.05f, 0.25f, 1.0f, 0.5f);
	gizmoZ->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	gizmoZ->Roughness = 0.4f;

	mMaterials[defaultMat->Name] = std::move(defaultMat);
	mMaterials[tileMat->Name] = std::move(tileMat);
	mMaterials[bricksMat0->Name] = std::move(bricksMat0);
	mMaterials[stoneMat->Name] = std::move(stoneMat);
	mMaterials[grassMat->Name] = std::move(grassMat);
	mMaterials[waterMat->Name] = std::move(waterMat);
	mMaterials[woodCrateMat->Name] = std::move(woodCrateMat);
	mMaterials[swirlingMat->Name] = std::move(swirlingMat);
	mMaterials[swirlingMaskMat->Name] = std::move(swirlingMaskMat);
	mMaterials[wireFence->Name] = std::move(wireFence);
	mMaterials[bricksMat1->Name] = std::move(bricksMat1);
	mMaterials[checkerTileMat->Name] = std::move(checkerTileMat);
	mMaterials[iceMirrorMat->Name] = std::move(iceMirrorMat);
	mMaterials[shadowMat_skull->Name] = std::move(shadowMat_skull);
	mMaterials[treeBillboardMat->Name] = std::move(treeBillboardMat);
	mMaterials[mirrorBaseMat->Name] = std::move(mirrorBaseMat);
	mMaterials[highlightMat->Name] = std::move(highlightMat);
	mMaterials[gizmoX->Name] = std::move(gizmoX);
	mMaterials[gizmoY->Name] = std::move(gizmoY);
	mMaterials[gizmoZ->Name] = std::move(gizmoZ);

	for (UINT i = 0; i < mSkinnedMats.size(); ++i)
	{
		auto mat = std::make_unique<Material>();
		mat->Name = mSkinnedMats[i].Name;
		mat->MatBufferIndex = index++;
		mat->DiffuseTexturePath = mSkinnedTexturePaths[i];
		//mat->NormalTexturePath = mSkinnedNormalTexturePaths[i];
		mat->DiffuseAlbedo = mSkinnedMats[i].DiffuseAlbedo;
		mat->FresnelR0 = mSkinnedMats[i].FresnelR0;
		mat->Roughness = mSkinnedMats[i].Roughness;

		mMaterials[mat->Name] = std::move(mat);
	}
}

void SceneRenderer::BuildRootSignature(D3D12Context& context)
{
	BuildRootSignature_Default(context);
	BuildRootSignature_DepthComplexity(context);
	BuildRootSignature_PostProcess(context);
	BuildRootSignature_Waves(context);
}

void SceneRenderer::BuildRootSignature_Default(D3D12Context& context)
{
	CD3DX12_DESCRIPTOR_RANGE diffuseMapTable;
	diffuseMapTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, context.GetDesc().CbvSrvUavHeapCapacity, 0); //t0
	CD3DX12_DESCRIPTOR_RANGE displacementMapTable;
	displacementMapTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0, 2); //t0, space2
	CD3DX12_DESCRIPTOR_RANGE treeArrayTable;
	treeArrayTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0, 3); //t0, space3

	// Perfomance TIP:
	// 루트 파라미터를 갱신 빈도(커맨드 리스트에서 Set되는 빈도) 순으로 배치 (자주 바뀌는 것 → 덜 바뀌는 것)
	// 드라이버 구현에 따라 효과는 다르지만 일반적으로 권장되는 패턴
	std::array<CD3DX12_ROOT_PARAMETER, 8> slotRootParameter{};
	slotRootParameter[0].InitAsConstantBufferView(0);	// (b0) pass CB
	slotRootParameter[1].InitAsConstants(1, 1, 0, D3D12_SHADER_VISIBILITY_VERTEX);			// (b1) Start Instance Location
	slotRootParameter[2].InitAsConstantBufferView(2);										// (b2) skinned CB
	slotRootParameter[3].InitAsDescriptorTable(1, &diffuseMapTable, D3D12_SHADER_VISIBILITY_PIXEL);	// (t0) textures
	slotRootParameter[4].InitAsShaderResourceView(0, 1);							// (t0, space1) materials + tex index
	slotRootParameter[5].InitAsShaderResourceView(1, 1);							// (t1, space1) instances + mat index
	slotRootParameter[6].InitAsDescriptorTable(1, &displacementMapTable);			// (t0, space2) wave height map
	slotRootParameter[7].InitAsDescriptorTable(1, &treeArrayTable, D3D12_SHADER_VISIBILITY_PIXEL);	// (t0, space3) tree billboard

	auto staticSamplers = GetStaticSamplers();

	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(
		(UINT)slotRootParameter.size(),
		slotRootParameter.data(),
		(UINT)staticSamplers.size(),
		staticSamplers.data(),
		D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

	//루트 시그니처는 보통 DESC -> Serialize(Blob) ->Create
	//직렬화 단계에서 문법/제약/버전 관점에서 유효성 검사
	//캐싱/저장에 활용.
	ComPtr<ID3DBlob> serializedRootsig = nullptr;
	ComPtr<ID3DBlob> errorBlob = nullptr;
	ThrowIfFailed(D3D12SerializeRootSignature(
		&rootSigDesc,
		D3D_ROOT_SIGNATURE_VERSION_1,
		serializedRootsig.GetAddressOf(),
		errorBlob.GetAddressOf()));

	if (errorBlob != nullptr)
		Logger::Error((char*)errorBlob->GetBufferPointer());

	ThrowIfFailed(context.GetDevice()->CreateRootSignature(
		0,
		serializedRootsig->GetBufferPointer(),
		serializedRootsig->GetBufferSize(),
		IID_PPV_ARGS(mRootSignature.GetAddressOf())));
}

void SceneRenderer::BuildRootSignature_DepthComplexity(D3D12Context& context)
{
	std::array<CD3DX12_ROOT_PARAMETER, 1> slotRootParameter;
	slotRootParameter[0].InitAsConstants(4, 0); //debugColor

	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(
		(UINT)slotRootParameter.size(),
		slotRootParameter.data(),
		0, nullptr,
		D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

	ComPtr<ID3DBlob> serializedRootsig = nullptr;
	ComPtr<ID3DBlob> errorBlob = nullptr;
	ThrowIfFailed(D3D12SerializeRootSignature(
		&rootSigDesc,
		D3D_ROOT_SIGNATURE_VERSION_1,
		serializedRootsig.GetAddressOf(),
		errorBlob.GetAddressOf()));

	if (errorBlob != nullptr)
		Logger::Error((char*)errorBlob->GetBufferPointer());

	ThrowIfFailed(context.GetDevice()->CreateRootSignature(
		0,
		serializedRootsig->GetBufferPointer(),
		serializedRootsig->GetBufferSize(),
		IID_PPV_ARGS(mRootSignature_debug.GetAddressOf())));
}

void SceneRenderer::BuildRootSignature_PostProcess(D3D12Context& context)
{
	CD3DX12_DESCRIPTOR_RANGE srvTable;
	srvTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0);

	CD3DX12_DESCRIPTOR_RANGE srvTable1;
	srvTable1.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 1);

	CD3DX12_DESCRIPTOR_RANGE uavTable;
	uavTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 0);

	std::array<CD3DX12_ROOT_PARAMETER, 4> slotRootParameter;
	slotRootParameter[0].InitAsConstants(12, 0);
	slotRootParameter[1].InitAsDescriptorTable(1, &srvTable);
	slotRootParameter[2].InitAsDescriptorTable(1, &srvTable1);
	slotRootParameter[3].InitAsDescriptorTable(1, &uavTable);

	auto staticSamplers = GetStaticSamplers();

	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(
		(UINT)slotRootParameter.size(),
		slotRootParameter.data(),
		(UINT)staticSamplers.size(),
		staticSamplers.data(),
		D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

	ComPtr<ID3DBlob> serializedRootSig = nullptr;
	ComPtr<ID3DBlob> errorBlob = nullptr;

	ThrowIfFailed(D3D12SerializeRootSignature(&rootSigDesc, D3D_ROOT_SIGNATURE_VERSION_1,
		serializedRootSig.GetAddressOf(), errorBlob.GetAddressOf()));

	if (errorBlob != nullptr)
		Logger::Error((char*)errorBlob->GetBufferPointer());

	ThrowIfFailed(context.GetDevice()->CreateRootSignature(
		0,
		serializedRootSig->GetBufferPointer(),
		serializedRootSig->GetBufferSize(),
		IID_PPV_ARGS(mPostProcessRootSignature.GetAddressOf())));
}

void SceneRenderer::BuildRootSignature_Waves(D3D12Context& context)
{
	CD3DX12_DESCRIPTOR_RANGE prevSolInputUAV;
	prevSolInputUAV.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 0);	//u0
	CD3DX12_DESCRIPTOR_RANGE CurrSolInputUAV;
	CurrSolInputUAV.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 1);	//u1
	CD3DX12_DESCRIPTOR_RANGE outputUAV;
	outputUAV.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 2);			//u2

	// Perfomance TIP:
	// 루트 파라미터를 갱신 빈도(커맨드 리스트에서 Set되는 빈도) 순으로 배치 (자주 바뀌는 것 → 덜 바뀌는 것)
	// 드라이버 구현에 따라 효과는 다르지만 일반적으로 권장되는 패턴
	std::array<CD3DX12_ROOT_PARAMETER, 4> slotRootParameter;
	slotRootParameter[0].InitAsConstants(6, 0);
	slotRootParameter[1].InitAsDescriptorTable(1, &prevSolInputUAV);
	slotRootParameter[2].InitAsDescriptorTable(1, &CurrSolInputUAV);
	slotRootParameter[3].InitAsDescriptorTable(1, &outputUAV);

	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc((UINT)slotRootParameter.size(), slotRootParameter.data());

	ComPtr<ID3DBlob> serializedRootSig = nullptr;
	ComPtr<ID3DBlob> errorBlob = nullptr;
	ThrowIfFailed(D3D12SerializeRootSignature(&rootSigDesc, D3D_ROOT_SIGNATURE_VERSION_1, serializedRootSig.GetAddressOf(), errorBlob.GetAddressOf()));

	if (errorBlob != nullptr)
		Logger::Error((char*)errorBlob->GetBufferPointer());

	ThrowIfFailed(context.GetDevice()->CreateRootSignature(
		0,
		serializedRootSig->GetBufferPointer(),
		serializedRootSig->GetBufferSize(),
		IID_PPV_ARGS(mWavesRootSignature.GetAddressOf())));
}

void SceneRenderer::BuildShadersAndInputLayout()
{
	const D3D_SHADER_MACRO fogDefines[] =
	{
		"FOG", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO wavesDefines[] =
	{
		"DISPLACEMENT_MAP", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO textureBlendDefines[] =
	{
		fogDefines[0],
		"TEXTURE_BLEND", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO alphaTestDefines[] =
	{
		fogDefines[0],
		"ALPHA_TEST", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO tessWallDefines[] =
	{
		"WALL", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO skinnedDefines[] =
	{
		"SKINNED", "1",
		NULL, NULL
	};

	double start = mTimer.TotalTime();

#define USE_COMPILED_SHADER
#ifndef USE_COMPILED_SHADER
	mShaders["standardVS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Default.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["opaquePS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Default.hlsl", fogDefines, "PS", "ps_5_1");
	mShaders["mirrorBaseFillPS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Default.hlsl", nullptr, "PS_MirrorBaseFill", "ps_5_1");
	mShaders["multiTextureBlendPS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Default.hlsl", textureBlendDefines, "PS", "ps_5_1");
	mShaders["alphaTestPS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Default.hlsl", alphaTestDefines, "PS", "ps_5_1");
	mShaders["wavesVS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Default.hlsl", wavesDefines, "VS", "vs_5_1");
	mShaders["wavesSimUpdate"] = D3D12Util::CompileShader(L"Resource\\Shaders\\WaveSim.hlsl", nullptr, "UpdateWavesCS", "cs_5_1");
	mShaders["wavesSimDisturb"] = D3D12Util::CompileShader(L"Resource\\Shaders\\WaveSim.hlsl", nullptr, "DisturbWavesCS", "cs_5_1");

	mShaders["depthDebugVS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\DepthComplexity.hlsl", nullptr, "FullscreenVS", "vs_5_1");
	mShaders["depthDebugPS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\DepthComplexity.hlsl", nullptr, "FullscreenPS", "ps_5_1");

	mShaders["treeBillboardVS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\TreeBillboard.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["treeBillboardGS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\TreeBillboard.hlsl", nullptr, "GS", "gs_5_1");
	mShaders["treeBillboardPS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\TreeBillboard.hlsl", alphaTestDefines, "PS", "ps_5_1");
	mShaders["treeBillboardPS_Wireframe"] = D3D12Util::CompileShader(L"Resource\\Shaders\\TreeBillboard.hlsl", nullptr, "PS_Wireframe", "ps_5_1");

	mShaders["lineToCylinderVS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["lineToCylinderGS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", nullptr, "GS", "gs_5_1");
	mShaders["lineToCylinderPS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", alphaTestDefines, "PS", "ps_5_1");

	mShaders["explodeGS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", alphaTestDefines, "GS_Explode", "gs_5_1");

	mShaders["LOD_GS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", nullptr, "GS_LOD", "gs_5_1");

	mShaders["vertexDebugGS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", nullptr, "GS_Debugging", "gs_5_1");
	mShaders["vertexDebugPS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", nullptr, "PS_VertexNormal", "ps_5_1");

	mShaders["blurH"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Blur.hlsl", nullptr, "HorzBlurCS", "cs_5_1");
	mShaders["blurV"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Blur.hlsl", nullptr, "VertBlurCS", "cs_5_1");

	mShaders["sobelCS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Sobel.hlsl", nullptr, "SobelCS", "cs_5_1");
	mShaders["sobelCompositeCS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Sobel.hlsl", nullptr, "CompositeCS", "cs_5_1");

	mShaders["tessVS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Tessellation.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["tessHS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Tessellation.hlsl", nullptr, "HS", "hs_5_1");
	mShaders["tessDS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Tessellation.hlsl", nullptr, "DS", "ds_5_1");
	mShaders["tessDS_Wall"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Tessellation.hlsl", tessWallDefines, "DS", "ds_5_1");
	mShaders["tessPS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Tessellation.hlsl", fogDefines, "PS", "ps_5_1");

	mShaders["highlightVS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Outline.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["highlightVS_Mask"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Outline.hlsl", nullptr, "VS_Mask", "vs_5_1");
	mShaders["highlightPS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Outline.hlsl", nullptr, "PS", "ps_5_1");

	mShaders["skinnedVS"] = D3D12Util::CompileShader(L"Resource\\Shaders\\Default.hlsl", skinnedDefines, "VS", "vs_5_1");

#else
	mShaders["standardVS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\Default_vs.cso");
	mShaders["opaquePS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\Default_ps.cso");
	mShaders["mirrorBaseFillPS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\MirrorBaseFill.cso");
	mShaders["multiTextureBlendPS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\Default_ps_TextureBlend.cso");
	mShaders["alphaTestPS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\Default_ps_AlphaTest.cso");
	mShaders["wavesVS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\Default_vs_Waves.cso");
	mShaders["wavesSimUpdate"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\WaveSim_cs_Update.cso");
	mShaders["wavesSimDisturb"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\WaveSim_cs_Disturb.cso");

	mShaders["depthDebugVS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\DepthComplexity_vs.cso");
	mShaders["depthDebugPS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\DepthComplexity_ps.cso");

	mShaders["treeBillboardVS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\TreeBillboardVS.cso");
	mShaders["treeBillboardGS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\TreeBillboardGS.cso");
	mShaders["treeBillboardPS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\TreeBillboardPS.cso");
	mShaders["treeBillboardPS_Wireframe"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\TreeBillboardPS_Wireframe.cso");

	mShaders["lineToCylinderVS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\LineToCylinderVS.cso");
	mShaders["lineToCylinderGS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\LineToCylinderGS.cso");
	mShaders["lineToCylinderPS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\LineToCylinderPS.cso");

	mShaders["explodeGS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\ExplodeGS.cso");

	mShaders["LOD_GS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\LOD_GS.cso");

	mShaders["vertexDebugGS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\VertexDebugGS.cso");
	mShaders["vertexDebugPS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\VertexDebugPS.cso");

	mShaders["blurH"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\HorzBlurCS.cso");
	mShaders["blurV"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\VertBlurCS.cso");

	mShaders["sobelCS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\SobelCS.cso");
	mShaders["sobelCompositeCS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\CompositeCS.cso");

	mShaders["tessVS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\tessVS.cso");
	mShaders["tessHS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\tessHS.cso");
	mShaders["tessDS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\tessDS.cso");
	mShaders["tessDS_Wall"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\tessDS_Wall.cso");
	mShaders["tessPS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\tessPS.cso");

	mShaders["highlightVS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\highlightVS.cso");
	mShaders["highlightVS_Mask"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\highlightVS_Mask.cso");
	mShaders["highlightPS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\highlightPS.cso");

	mShaders["skinnedVS"] = D3D12Util::LoadBinary(L"Resource\\Shaders\\Compiled\\skinnedVS.cso");

#endif

	double elapsedMs = (mTimer.TotalTime() - start) * 1000.0;

#ifdef USE_COMPILED_SHADER
	std::wstring s = L"Shader Load elapsed : ";
#else
	std::wstring s = L"Shader Compile elapsed : ";
#endif
	s += std::to_wstring(elapsedMs) + L" ms\n";

	Logger::Info(s);

	mInputLayout =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0,  D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
		{ "NORMAL",   0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
		{ "TANGENT",  0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 24, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
		{ "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT,    0, 36, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
	};

	mTreeBillboardInputLayout =
	{
		{"POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
		{"SIZE", 0, DXGI_FORMAT_R32G32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
	};

	mSkinnedInputLayout =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0,
			offsetof(SkinnedVertex, Position),
			D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },

		{ "NORMAL", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0,
			offsetof(SkinnedVertex, Normal),
			D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },

		{ "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT, 0,
			offsetof(SkinnedVertex, TexCoord),
			D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },

		{ "TANGENT", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0,
			offsetof(SkinnedVertex, Tangent),
			D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },

		{ "WEIGHTS", 0, DXGI_FORMAT_R32G32B32A32_FLOAT, 0,
			offsetof(SkinnedVertex, JointWeights),
			D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },

		{ "BONEINDICES", 0, DXGI_FORMAT_R16G16B16A16_UINT, 0,
			offsetof(SkinnedVertex, PaletteJointIndices),
			D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 }
	};
}


void SceneRenderer::BuildGeometry(D3D12Context& context)
{
	BuildShapeGeometry(context);
	BuildLandGeometry(context);
	BuildWavesGeometry(context);
	BuildTreeBillboardGeometry(context);
	BuildCylinderWithoutTopGeometry(context);
	BuildBrickWallGeometry(context);
	BuildFBXGeometry(context);
}

void SceneRenderer::BuildShapeGeometry(D3D12Context& context)
{
	MeshData skull = LoadModelFromFile_dx12ex(L"Resource/Models/skull.txt");

	GeometryGenerator geoGen;
	MeshData box = geoGen.CreateBox(1.5, 1.5, 1.5, 3);
	MeshData grid = geoGen.CreateGrid(20, 30, 60, 40);
	MeshData sphere = geoGen.CreateSphere(0.5, 20, 20);
	MeshData geoSphere = geoGen.CreateGeosphere(0.5, 2);
	MeshData cylinder = geoGen.CreateCylinder(0.5f, 0.3f, 3.f, 20, 20);

	UINT boxVertexCount = (UINT)box.Vertices.size();
	UINT gridVertexCount = (UINT)grid.Vertices.size();
	UINT sphereVertexCount = (UINT)sphere.Vertices.size();
	UINT geoSphereVertexCount = (UINT)geoSphere.Vertices.size();
	UINT cylinderVertexCount = (UINT)cylinder.Vertices.size();
	UINT skullVertexCount = (UINT)skull.Vertices.size();

	UINT boxVertexOffset = 0;
	UINT gridVertexOffset = (UINT)box.Vertices.size();
	UINT sphereVertexOffset = gridVertexOffset + (UINT)grid.Vertices.size();
	UINT geoSphereVertexOffset = sphereVertexOffset + (UINT)sphere.Vertices.size();
	UINT cylinderVertexOffset = geoSphereVertexOffset + (UINT)geoSphere.Vertices.size();
	UINT skullVertexOffset = cylinderVertexOffset + (UINT)cylinder.Vertices.size();

	UINT boxIndexOffset = 0;
	UINT gridIndexOffset = (UINT)box.Indices32.size();
	UINT sphereIndexOffset = gridIndexOffset + (UINT)grid.Indices32.size();
	UINT geoSphereIndexOffset = sphereIndexOffset + (UINT)sphere.Indices32.size();
	UINT cylinderIndexOffset = geoSphereIndexOffset + (UINT)geoSphere.Indices32.size();
	UINT skullIndexOffset = cylinderIndexOffset + (UINT)cylinder.Indices32.size();

	SubmeshGeometry boxSubmesh;
	boxSubmesh.IndexCount = (UINT)box.Indices32.size();
	boxSubmesh.StartIndexLocation = boxIndexOffset;
	boxSubmesh.BaseVertexLocation = boxVertexOffset;
	boxSubmesh.VertexCount = boxVertexCount;
	BoundingBox::CreateFromPoints(boxSubmesh.Bounds, box.Vertices.size(), &box.Vertices[0].Position, sizeof(Vertex));

	SubmeshGeometry gridSubmesh;
	gridSubmesh.IndexCount = (UINT)grid.Indices32.size();
	gridSubmesh.StartIndexLocation = gridIndexOffset;
	gridSubmesh.BaseVertexLocation = gridVertexOffset;
	gridSubmesh.VertexCount = gridVertexCount;
	BoundingBox::CreateFromPoints(gridSubmesh.Bounds, grid.Vertices.size(), &grid.Vertices[0].Position, sizeof(Vertex));

	SubmeshGeometry sphereSubmesh;
	sphereSubmesh.IndexCount = (UINT)sphere.Indices32.size();
	sphereSubmesh.StartIndexLocation = sphereIndexOffset;
	sphereSubmesh.BaseVertexLocation = sphereVertexOffset;
	sphereSubmesh.VertexCount = sphereVertexCount;
	BoundingBox::CreateFromPoints(sphereSubmesh.Bounds, sphere.Vertices.size(), &sphere.Vertices[0].Position, sizeof(Vertex));

	SubmeshGeometry geoSphereSubmesh;
	geoSphereSubmesh.IndexCount = (UINT)geoSphere.Indices32.size();
	geoSphereSubmesh.StartIndexLocation = geoSphereIndexOffset;
	geoSphereSubmesh.BaseVertexLocation = geoSphereVertexOffset;
	geoSphereSubmesh.VertexCount = geoSphereVertexCount;
	BoundingBox::CreateFromPoints(geoSphereSubmesh.Bounds, geoSphere.Vertices.size(), &geoSphere.Vertices[0].Position, sizeof(Vertex));

	SubmeshGeometry cylinderSubmesh;
	cylinderSubmesh.IndexCount = (UINT)cylinder.Indices32.size();
	cylinderSubmesh.StartIndexLocation = cylinderIndexOffset;
	cylinderSubmesh.BaseVertexLocation = cylinderVertexOffset;
	cylinderSubmesh.VertexCount = cylinderVertexCount;
	BoundingBox::CreateFromPoints(cylinderSubmesh.Bounds, cylinder.Vertices.size(), &cylinder.Vertices[0].Position, sizeof(Vertex));

	SubmeshGeometry skullSubmesh;
	skullSubmesh.IndexCount = (UINT)skull.Indices32.size();
	skullSubmesh.StartIndexLocation = skullIndexOffset;
	skullSubmesh.BaseVertexLocation = skullVertexOffset;
	skullSubmesh.VertexCount = skullVertexCount;
	BoundingBox::CreateFromPoints(skullSubmesh.Bounds, skull.Vertices.size(), &skull.Vertices[0].Position, sizeof(Vertex));

	//여러 메시들을 한 버퍼에 관리.
	auto totalVertexCount =
		box.Vertices.size() +
		grid.Vertices.size() +
		sphere.Vertices.size() +
		geoSphere.Vertices.size() +
		cylinder.Vertices.size() +
		skull.Vertices.size();

	std::vector<Vertex> vertices(totalVertexCount);

	UINT k = 0;
	for (size_t i = 0; i < box.Vertices.size(); i++, k++)
	{
		vertices[k].Position = box.Vertices[i].Position;
		vertices[k].Normal = box.Vertices[i].Normal;
		vertices[k].TangentU = box.Vertices[i].TangentU;
		vertices[k].TexC = box.Vertices[i].TexC;
	}
	for (size_t i = 0; i < grid.Vertices.size(); i++, k++)
	{
		vertices[k].Position = grid.Vertices[i].Position;
		vertices[k].Normal = grid.Vertices[i].Normal;
		vertices[k].TangentU = grid.Vertices[i].TangentU;
		vertices[k].TexC = grid.Vertices[i].TexC;
	}
	for (size_t i = 0; i < sphere.Vertices.size(); i++, k++)
	{
		vertices[k].Position = sphere.Vertices[i].Position;
		vertices[k].Normal = sphere.Vertices[i].Normal;
		vertices[k].TangentU = sphere.Vertices[i].TangentU;
		vertices[k].TexC = sphere.Vertices[i].TexC;
	}
	for (size_t i = 0; i < geoSphere.Vertices.size(); i++, k++)
	{
		vertices[k].Position = geoSphere.Vertices[i].Position;
		vertices[k].Normal = geoSphere.Vertices[i].Normal;
		vertices[k].TangentU = geoSphere.Vertices[i].TangentU;
		vertices[k].TexC = geoSphere.Vertices[i].TexC;
	}
	for (size_t i = 0; i < cylinder.Vertices.size(); i++, k++)
	{
		vertices[k].Position = cylinder.Vertices[i].Position;
		vertices[k].Normal = cylinder.Vertices[i].Normal;
		vertices[k].TangentU = cylinder.Vertices[i].TangentU;
		vertices[k].TexC = cylinder.Vertices[i].TexC;
	}
	for (size_t i = 0; i < skull.Vertices.size(); i++, k++)
	{
		vertices[k].Position = skull.Vertices[i].Position;
		vertices[k].Normal = skull.Vertices[i].Normal;
		vertices[k].TangentU = skull.Vertices[i].TangentU;
		vertices[k].TexC = skull.Vertices[i].TexC;
	}

	std::vector<std::uint32_t> indices;
	indices.insert(indices.end(), box.Indices32.begin(), box.Indices32.end());
	indices.insert(indices.end(), grid.Indices32.begin(), grid.Indices32.end());
	indices.insert(indices.end(), sphere.Indices32.begin(), sphere.Indices32.end());
	indices.insert(indices.end(), geoSphere.Indices32.begin(), geoSphere.Indices32.end());
	indices.insert(indices.end(), cylinder.Indices32.begin(), cylinder.Indices32.end());
	indices.insert(indices.end(), skull.Indices32.begin(), skull.Indices32.end());

	const UINT vbByteSize = (UINT)vertices.size() * sizeof(Vertex);
	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint32_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "shapeGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, geo->VertexBufferCPU.GetAddressOf()));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, geo->IndexBufferCPU.GetAddressOf()));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = D3D12Util::CreateDefaultBuffer(context.GetDevice(), context.GetCommandList(), vertices.data(), vbByteSize, geo->VertexBufferUploader);

	geo->IndexBufferGPU = D3D12Util::CreateDefaultBuffer(context.GetDevice(), context.GetCommandList(), indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R32_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	geo->DrawArgs["box"] = boxSubmesh;
	geo->DrawArgs["grid"] = gridSubmesh;
	geo->DrawArgs["sphere"] = sphereSubmesh;
	geo->DrawArgs["geoSphere"] = geoSphereSubmesh;
	geo->DrawArgs["cylinder"] = cylinderSubmesh;
	geo->DrawArgs["skull"] = skullSubmesh;

	mGeometries[geo->Name] = std::move(geo);
}

void SceneRenderer::BuildLandGeometry(D3D12Context& context)
{
	auto md3dDevice = context.GetDevice();
	auto mCommandList = context.GetCommandList();

	GeometryGenerator geoGen;
	//MeshData grid = geoGen.CreateGrid(160, 160, 17, 17);
	const int rows = 2;
	const int cols = 2;
	MeshData grid = geoGen.CreateGrid(160, 160, rows, cols);

	std::vector<Vertex> vertices(grid.Vertices.size());
	for (int i = 0; i < grid.Vertices.size(); i++)
	{
		DirectX::XMFLOAT3& p = grid.Vertices[i].Position;
		vertices[i].Position = p;
		vertices[i].Normal = XMFLOAT3(0.0f, 1.0f, 0.0f);//실제 높이 등은 DS에서 계산
		vertices[i].TangentU = grid.Vertices[i].TangentU;
		vertices[i].TexC = grid.Vertices[i].TexC;
	}

	const UINT vbByteSize = (UINT)vertices.size() * sizeof(Vertex);

	std::vector<std::uint16_t> indices;
	indices.reserve((rows - 1) * (cols - 1) * 4);
	for (int i = 0; i < rows - 1; ++i)
	{
		for (int j = 0; j < cols - 1; ++j)
		{
			indices.push_back(i * cols + j);
			indices.push_back(i * cols + j + 1);
			indices.push_back((i + 1) * cols + j);
			indices.push_back((i + 1) * cols + j + 1);
		}
	}

	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint16_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "landGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, geo->VertexBufferCPU.GetAddressOf()));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);
	ThrowIfFailed(D3DCreateBlob(ibByteSize, geo->IndexBufferCPU.GetAddressOf()));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = D3D12Util::CreateDefaultBuffer(md3dDevice, mCommandList, vertices.data(), vbByteSize, geo->VertexBufferUploader);
	geo->IndexBufferGPU = D3D12Util::CreateDefaultBuffer(md3dDevice, mCommandList, indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R16_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;
	sm.VertexCount = (UINT)vertices.size();
	BoundingBox::CreateFromPoints(sm.Bounds, grid.Vertices.size(), &grid.Vertices[0].Position, sizeof(Vertex));

	geo->DrawArgs["grid"] = sm;
	mGeometries[geo->Name] = std::move(geo);
}

void SceneRenderer::BuildWavesGeometry(D3D12Context& context)
{
	auto md3dDevice = context.GetDevice();
	auto mCommandList = context.GetCommandList();

	GeometryGenerator geoGen;
	MeshData grid = geoGen.CreateGrid(160.0f, 160.0f, mWaves->RowCount(), mWaves->ColumnCount());

	const std::vector<Vertex>& vertices = grid.Vertices;
	const std::vector<std::uint32_t>& indices = grid.Indices32;	//인덱스 사이즈가 16비트(65535)를 넘을 가능성.

	UINT vbByteSize = mWaves->VertexCount() * sizeof(Vertex);
	UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint32_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "waterGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, &geo->VertexBufferCPU));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);
	ThrowIfFailed(D3DCreateBlob(ibByteSize, &geo->IndexBufferCPU));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = D3D12Util::CreateDefaultBuffer(md3dDevice, mCommandList, vertices.data(), vbByteSize, geo->VertexBufferUploader);
	geo->IndexBufferGPU = D3D12Util::CreateDefaultBuffer(md3dDevice, mCommandList, indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R32_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;
	BoundingBox::CreateFromPoints(sm.Bounds, grid.Vertices.size(), &grid.Vertices[0].Position, sizeof(Vertex));

	geo->DrawArgs["grid"] = sm;

	mGeometries[geo->Name] = std::move(geo);
}

void SceneRenderer::BuildTreeBillboardGeometry(D3D12Context& context)
{
	auto md3dDevice = context.GetDevice();
	auto mCommandList = context.GetCommandList();

	struct TreeVertex
	{
		XMFLOAT3 pos;
		XMFLOAT2 size;
	};

	static const int treeCount = 48;
	std::array<TreeVertex, treeCount> vertices;
	for (UINT i = 0; i < treeCount; i++)
	{
		float x = 0, y = 0, z = 0;
		while (true)
		{
			float range = 70.0f;
			x = MathHelper::RandF(-range, range);
			z = MathHelper::RandF(-range, range);
			if ((x > -15.f && x < 15.f) || (z > -15.f && z < 15.f))
				continue;

			y = GetHillsHeight(x, z);
			if (y > 2) break;
		}
		y += 2.0f;
		vertices[i].pos = XMFLOAT3(x, y, z);
		vertices[i].size = XMFLOAT2(11.0f, 15.0f);
	}

	std::array<std::uint16_t, treeCount> indices;
	for (int i = 0; i < treeCount; i++) indices[i] = i;

	const UINT vbByteSize = (UINT)vertices.size() * sizeof(TreeVertex);
	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint16_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "treeBillboard";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, &geo->VertexBufferCPU));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, &geo->IndexBufferCPU));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = D3D12Util::CreateDefaultBuffer(md3dDevice, mCommandList, vertices.data(), vbByteSize, geo->VertexBufferUploader);

	geo->IndexBufferGPU = D3D12Util::CreateDefaultBuffer(md3dDevice, mCommandList, indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(TreeVertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R16_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;
	sm.VertexCount = (UINT)vertices.size();
	BoundingBox::CreateFromPoints(sm.Bounds, vertices.size(), &vertices[0].pos, sizeof(TreeVertex));

	geo->DrawArgs["tree"] = sm;
	mGeometries[geo->Name] = std::move(geo);
}

void SceneRenderer::BuildCylinderWithoutTopGeometry(D3D12Context& context)
{
	auto md3dDevice = context.GetDevice();
	auto mCommandList = context.GetCommandList();

	GeometryGenerator geoGen;
	MeshData cylinder = geoGen.CreateCircleLine(2, 10);

	SubmeshGeometry cylinderSubmesh;
	cylinderSubmesh.IndexCount = (UINT)cylinder.Indices32.size();
	cylinderSubmesh.StartIndexLocation = 0;
	cylinderSubmesh.BaseVertexLocation = 0;
	cylinderSubmesh.VertexCount = (UINT)cylinder.Vertices.size();
	BoundingBox::CreateFromPoints(cylinderSubmesh.Bounds, cylinder.Vertices.size(), &cylinder.Vertices[0].Position, sizeof(Vertex));

	std::vector<Vertex> vertices(cylinder.Vertices.size());

	for (size_t i = 0; i < cylinder.Vertices.size(); i++)
	{
		vertices[i].Position = cylinder.Vertices[i].Position;
		vertices[i].Normal = cylinder.Vertices[i].Normal;
		vertices[i].TangentU = cylinder.Vertices[i].TangentU;
		vertices[i].TexC = cylinder.Vertices[i].TexC;
	}

	const UINT vbByteSize = (UINT)cylinder.Vertices.size() * sizeof(Vertex);
	const UINT ibByteSize = (UINT)cylinder.Indices32.size() * sizeof(std::uint32_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "cylinderWithoutTop";
	ThrowIfFailed(D3DCreateBlob(vbByteSize, geo->VertexBufferCPU.GetAddressOf()));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, geo->IndexBufferCPU.GetAddressOf()));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), cylinder.Indices32.data(), ibByteSize);

	geo->VertexBufferGPU = D3D12Util::CreateDefaultBuffer(md3dDevice, mCommandList, vertices.data(), vbByteSize, geo->VertexBufferUploader);
	geo->IndexBufferGPU = D3D12Util::CreateDefaultBuffer(md3dDevice, mCommandList, cylinder.Indices32.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R32_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	geo->DrawArgs["cylinderWithoutTop"] = cylinderSubmesh;
	mGeometries[geo->Name] = std::move(geo);
}

void SceneRenderer::BuildBrickWallGeometry(D3D12Context& context)
{
	auto md3dDevice = context.GetDevice();
	auto mCommandList = context.GetCommandList();

	std::array<Vertex, 4> vertices{};

	float w = 20.0f;
	float d = 30.0f;

	vertices[0].Position = XMFLOAT3(-w * 0.5f, 0.0f, -d * 0.5f);
	vertices[1].Position = XMFLOAT3(w * 0.5f, 0.0f, -d * 0.5f);
	vertices[2].Position = XMFLOAT3(-w * 0.5f, 0.0f, d * 0.5f);
	vertices[3].Position = XMFLOAT3(w * 0.5f, 0.0f, d * 0.5f);

	for (auto& v : vertices)
	{
		v.Normal = XMFLOAT3(0.0f, 1.0f, 0.0f);
		v.TangentU = XMFLOAT3(1.0f, 0.0f, 0.0f);
	}

	vertices[0].TexC = XMFLOAT2(0.0f, 1.0f);
	vertices[1].TexC = XMFLOAT2(1.0f, 1.0f);
	vertices[2].TexC = XMFLOAT2(0.0f, 0.0f);
	vertices[3].TexC = XMFLOAT2(1.0f, 0.0f);

	std::array<std::uint16_t, 4> indices = { 0, 1, 2, 3 };

	const UINT vbByteSize = (UINT)vertices.size() * sizeof(Vertex);
	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint16_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "brickWallGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, geo->VertexBufferCPU.GetAddressOf()));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, geo->IndexBufferCPU.GetAddressOf()));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = D3D12Util::CreateDefaultBuffer(md3dDevice, mCommandList, vertices.data(), vbByteSize, geo->VertexBufferUploader);

	geo->IndexBufferGPU = D3D12Util::CreateDefaultBuffer(md3dDevice, mCommandList, indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R16_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;
	sm.VertexCount = (UINT)vertices.size();
	BoundingBox::CreateFromPoints(sm.Bounds, vertices.size(), &vertices[0].Position, sizeof(Vertex));

	geo->DrawArgs["brickWall"] = sm;

	mGeometries[geo->Name] = std::move(geo);
}

void SceneRenderer::BuildFBXGeometry(D3D12Context& context)
{
	SkeletalMesh skelMesh = FbxImporter::ImportSkeletalMesh("Resource/Models/Dismissing Gesture.fbx");
	for (std::size_t submeshIndex = 0; submeshIndex < skelMesh.Submeshes.size(); submeshIndex++)
	{
		const SkeletalSubmesh& submesh = skelMesh.Submeshes[submeshIndex];

		const std::size_t paletteSize = submesh.Skin.PaletteToSkeletonJoint.size();

		for (const SkinnedVertex& vertex : submesh.Vertices)
		{
			float weightSum = 0.0f;

			for (int i = 0; i < 4; ++i)
			{
				assert(std::isfinite(vertex.JointWeights[i]));
				assert(vertex.JointWeights[i] >= 0.0f);

				weightSum += vertex.JointWeights[i];
				if (vertex.JointWeights[i] > 0.0f)
				{
					assert(vertex.PaletteJointIndices[i] < paletteSize);
				}
			}

			assert(weightSum > 0.99f);
			assert(weightSum < 1.01f);
		}
	}

	std::vector<SkinnedVertex> vertices;
	std::vector<std::uint32_t> indices;

	for (auto& sm : skelMesh.Submeshes)
	{
		vertices.insert(vertices.end(), sm.Vertices.begin(), sm.Vertices.end());
		indices.insert(indices.end(), sm.Indices.begin(), sm.Indices.end());
	}

	const UINT vbByteSize = static_cast<UINT>(vertices.size() * sizeof(SkinnedVertex));
	const UINT ibByteSize = static_cast<UINT>(indices.size() * sizeof(std::uint32_t));

	auto geometry = std::make_unique<MeshGeometry>();
	geometry->Name = "fbxPreviewGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, geometry->VertexBufferCPU.GetAddressOf()));
	CopyMemory(geometry->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);
	ThrowIfFailed(D3DCreateBlob(ibByteSize, geometry->IndexBufferCPU.GetAddressOf()));
	CopyMemory(geometry->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geometry->VertexBufferGPU =	D3D12Util::CreateDefaultBuffer(
		context.GetDevice(),
		context.GetCommandList(),
		vertices.data(),
		vbByteSize,
		geometry->VertexBufferUploader);

	geometry->IndexBufferGPU = D3D12Util::CreateDefaultBuffer(
		context.GetDevice(),
		context.GetCommandList(),
		indices.data(),
		ibByteSize,
		geometry->IndexBufferUploader);

	geometry->VertexByteStride = sizeof(SkinnedVertex);
	geometry->VertexBufferByteSize = vbByteSize;
	geometry->IndexFormat = DXGI_FORMAT_R32_UINT;
	geometry->IndexBufferByteSize = ibByteSize;

	int baseVertexLocation = 0;
	UINT startIndexLocation = 0;
	for (UINT i = 0; i < (UINT)skelMesh.Submeshes.size(); i++)
	{
		const auto& sourceSubmesh = skelMesh.Submeshes[i];

		SubmeshGeometry submesh;

		submesh.IndexCount = static_cast<UINT>(sourceSubmesh.Indices.size());
		submesh.StartIndexLocation = startIndexLocation;
		submesh.BaseVertexLocation = baseVertexLocation;
		submesh.VertexCount = static_cast<UINT>(sourceSubmesh.Vertices.size());

		if (!sourceSubmesh.Vertices.empty())
		{
			DirectX::BoundingBox::CreateFromPoints(submesh.Bounds, sourceSubmesh.Vertices.size(),
				&sourceSubmesh.Vertices.front().Position, sizeof(SkinnedVertex));
		}

		geometry->DrawArgs[sourceSubmesh.Name] = submesh;

		baseVertexLocation += submesh.VertexCount;
		startIndexLocation += submesh.IndexCount;
	}

	const std::string geometryName = geometry->Name;
	mGeometries[geometryName] = std::move(geometry);
	mSkeletalMeshes[geometryName] = std::move(skelMesh);
	SkeletalMesh& storedAsset = mSkeletalMeshes.at(geometryName);
	mSkinnedModelInstance = std::make_unique<SkinnedModelInstance>();
	auto clipName = "mixamo.com";
	//auto clipName = "Take 001";
	for (const auto& [name, clip] : storedAsset.Animations)
	{
		Logger::Info(
			L"Animation Clip: " +
			AnsiToWString(name) +
			L"\n");
	}
	mSkinnedModelInstance->Initialize(storedAsset, clipName);
}

void SceneRenderer::BuildRenderItems()
{
	UINT StartInstanceLocation = 0;
	BuildRenderItems_Common(StartInstanceLocation);
	BuildRenderItems_InMirror(StartInstanceLocation);
	BuildRenderItems_Gizmo(StartInstanceLocation);
	BuildRenderItems_SkinnedModel(StartInstanceLocation);
	BuildRenderItems_FBX(StartInstanceLocation);

	mInstanceCount = StartInstanceLocation;

#if defined(DEBUG) || defined(_DEBUG)
	UINT expectedStartLocation = 0;
	for (const auto& renderItem : mAllRenderItems)
	{
		assert(renderItem != nullptr);
		assert(renderItem->StartInstanceLocation == expectedStartLocation);

		expectedStartLocation += static_cast<UINT>(renderItem->Instances.size());
	}

	assert(expectedStartLocation == mInstanceCount);
#endif
}

void SceneRenderer::BuildRenderItems_Common(UINT& InstanceBufferIndex)
{
	RenderItem* boxRI = CreateRenderItem("shapeGeo", "box",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::Opaque }, true);
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 0.5f, 2.0f };
		transform.Rotation = { 0.0f, 0.0f, 0.0f };
		transform.Scale = { 2.0f, 2.0f / 3.0f, 2.0f };

		AddInstance(boxRI, "woodCrate", L"나무 상자", transform);
	}
	FinalizeRenderItem(boxRI, InstanceBufferIndex);

	RenderItem* blendBoxRI = CreateRenderItem("shapeGeo", "box",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::MultiTextureBlend }, true);
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 2.0f, 15.0f };
		transform.Scale = { 2.0f, 2.0f, 2.0f };

		AddInstance(blendBoxRI, "swirling", L"회전 블랜딩 상자", transform);
	}
	FinalizeRenderItem(blendBoxRI, InstanceBufferIndex);

	RenderItem* netBoxRI = CreateRenderItem("shapeGeo", "box",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::AlphaTestOpaque }, true);
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 1.0f, -3.0f };

		AddInstance(netBoxRI, "wireFence", L"철망 상자", transform);
	}
	FinalizeRenderItem(netBoxRI, InstanceBufferIndex);

	RenderItem* gridRI = CreateRenderItem("shapeGeo", "grid",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::Opaque }, true);
	{
		TransformComponent transform;
		transform.Position = { -3.0f, 0.0f, 7.0f };
		transform.Scale = { 1.5f, 1.0f, 1.4f };

		auto& data = AddInstance(gridRI, "checkerTileMat", L"바닥", transform);
		XMStoreFloat4x4(&data.TexTransform, XMMatrixScaling(8.0f, 8.0f, 1.0f));
	}
	FinalizeRenderItem(gridRI, InstanceBufferIndex);

	RenderItem* CylinderRI = CreateRenderItem("shapeGeo", "cylinder",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::Opaque }, true);

	RenderItem* SphereRI = CreateRenderItem("shapeGeo", "sphere",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::Opaque }, true);

	RenderItem* GeoSphereRI = CreateRenderItem("shapeGeo", "geoSphere",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::GeoSphereLOD }, true);

	for (int i = 0; i < 8; ++i)
	{
		TransformComponent leftCylTransform;
		leftCylTransform.Position = { -12.0f, 1.5f, -10.0f + i * 5.0f };

		TransformComponent rightCylTransform;
		rightCylTransform.Position = { -2.0f, 1.5f, -10.0f + i * 5.0f };

		TransformComponent leftSphereTransform;
		leftSphereTransform.Position = { -12.0f, 3.5f, -10.0f + i * 5.0f };

		TransformComponent rightSphereTransform;
		rightSphereTransform.Position = { -2.0f, 3.5f, -10.0f + i * 5.0f };
		rightSphereTransform.Scale = { 2.0f, 2.0f, 2.0f };

		std::wstring objectName1 = L"기둥" + std::to_wstring(i);
		std::wstring objectName2 = L"돌" + std::to_wstring(i);
		AddInstance(CylinderRI, "bricks0", objectName1.c_str(), leftCylTransform);
		AddInstance(CylinderRI, "bricks0", objectName1.c_str(), rightCylTransform);
		AddInstance(SphereRI, "stone0", objectName2.c_str(), leftSphereTransform);
		AddInstance(GeoSphereRI, "stone0", objectName2.c_str(), rightSphereTransform);
	}
	FinalizeRenderItem(CylinderRI, InstanceBufferIndex);
	FinalizeRenderItem(SphereRI, InstanceBufferIndex);
	FinalizeRenderItem(GeoSphereRI, InstanceBufferIndex);

	//skull
	mSkull = CreateRenderItem("shapeGeo", "skull",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::Opaque }, true);
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 1.0f, 7.0f };
		transform.Scale = { 0.2f, 0.2f, 0.2f };

		AddInstance(mSkull, "defaultMat", L"해골", transform);
	}
	FinalizeRenderItem(mSkull, InstanceBufferIndex);

	//land
	RenderItem* landRI = CreateRenderItem("landGeo", "grid",
		D3D_PRIMITIVE_TOPOLOGY_4_CONTROL_POINT_PATCHLIST,
		{ RenderLayer::TessLand });
	{
		TransformComponent transform;
		transform.Position = { 0.0f, -5.0f, 0.0f };

		auto& data = AddInstance(landRI, "grass0", L"해골", transform);
		XMStoreFloat4x4(&data.TexTransform, XMMatrixScaling(5.0f, 5.0f, 1.0f));
	}
	FinalizeRenderItem(landRI, InstanceBufferIndex);

	//wave
	RenderItem* waveRI = CreateRenderItem("waterGeo", "grid",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::Waves });
	{
		TransformComponent transform;
		transform.Position = { 0.0f, -1.0f, 0.0f };

		auto& data = AddInstance(waveRI, "water0", L"파도", transform);
		XMStoreFloat4x4(&data.TexTransform, XMMatrixScaling(5.0f, 5.0f, 1.0f));
		data.DisplacementMapTexelSize = { 1.0f / mWaves->ColumnCount(), 1.0f / mWaves->RowCount() };
	}
	FinalizeRenderItem(waveRI, InstanceBufferIndex);

	//mirror
	mMirror = CreateRenderItem("shapeGeo", "grid",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::MirrorStencil, RenderLayer::Transparent });
	{
		TransformComponent transform;
		transform.Position = { -18.0f, 2.0f, 7.0f };
		transform.Rotation = { 0.0f, 0.0f, -90.0f };
		transform.Scale = { 0.2f, 1.0f, 0.5f };

		auto& data = AddInstance(mMirror, "iceMirrorMat", L"거울", transform);
		XMStoreFloat4x4(&data.TexTransform, XMMatrixScaling(1.0f, 2.0f, 1.0f) * XMMatrixRotationZ(XM_PIDIV2));
	}
	FinalizeRenderItem(mMirror, InstanceBufferIndex);

	RenderItem* mirrorWallTessRI = CreateRenderItem("brickWallGeo", "brickWall",
		D3D_PRIMITIVE_TOPOLOGY_4_CONTROL_POINT_PATCHLIST,
		{ RenderLayer::TessWall });
	{
		TransformComponent transform;
		transform.Position = { -18.001f, 3.0f, 7.0f };
		transform.Rotation = { 0.0f, 0.0f, -90.0f };
		transform.Scale = { 0.3f, 1.0f, 1.4f };

		auto& data = AddInstance(mirrorWallTessRI, "bricks1", L"거울 벽", transform);
		XMStoreFloat4x4(&data.TexTransform, XMMatrixScaling(2.5f, 11.0f, 1.0f) * XMMatrixRotationZ(XM_PIDIV2));
	}
	FinalizeRenderItem(mirrorWallTessRI, InstanceBufferIndex);

	//거울 백플레이트
	RenderItem* mirrorBackRI = CreateRenderItem("shapeGeo", "grid",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::MirrorBaseFill });
	{
		TransformComponent transform;
		transform.Position = { -18.0f, 2.0f, 7.0f };
		transform.Rotation = { 0.0f, 0.0f, -90.0f };
		transform.Scale = { 0.2f, 1.0f, 0.5f };

		auto& data = AddInstance(mirrorBackRI, "mirrorBaseMat", L"거울 백플레이트", transform);
	}
	FinalizeRenderItem(mirrorBackRI, InstanceBufferIndex);

	//skull shadow
	mSkullShadow = CreateRenderItem("shapeGeo", "skull",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::Shadow });
	{
		TransformComponent transform;
		transform.Position = { 3.0f, 3.0f, 0.0f };

		auto& data = AddInstance(mSkullShadow, "shadowMat_skull", L"해골 그림자", transform);
	}
	FinalizeRenderItem(mSkullShadow, InstanceBufferIndex);

	//tree billboard
	RenderItem* treeBillboardRI = CreateRenderItem("treeBillboard", "tree",
		D3D_PRIMITIVE_TOPOLOGY_POINTLIST,
		{ RenderLayer::A2C_TreeBillboard });
	{
		TransformComponent transform;

		auto& data = AddInstance(treeBillboardRI, "treeBillboardMat", L"나무 빌보드", transform);
	}
	FinalizeRenderItem(treeBillboardRI, InstanceBufferIndex);

	//extended Cylinder
	RenderItem* cylRI = CreateRenderItem("cylinderWithoutTop", "cylinderWithoutTop",
		D3D_PRIMITIVE_TOPOLOGY_LINESTRIP,
		{ RenderLayer::LineToCylinder });
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 0.0f, 20.0f };

		auto& data = AddInstance(cylRI, "bricks0", L"GS확장 원통", transform);
	}
	FinalizeRenderItem(cylRI, InstanceBufferIndex);

	//explode
	RenderItem* explodeRI = CreateRenderItem("shapeGeo", "geoSphere",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::GeoExplode });
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 6.0f, 7.0f };

		auto& data = AddInstance(explodeRI, "bricks0", L"폭발하는 돌", transform);
	}
	FinalizeRenderItem(explodeRI, InstanceBufferIndex);
}

void SceneRenderer::BuildRenderItems_InMirror(UINT& InstanceBufferIndex)
{
	XMVECTOR mirrorPlane = GetMirrorPlane(); // x = -10 plane
	XMMATRIX R = XMMatrixReflect(mirrorPlane);

	std::vector<std::unique_ptr<RenderItem>> renderItems;
	for (auto& ri : mAllRenderItems)
	{
		if (ri->InMirror == false) continue;

		auto reflectedRI = std::make_unique<RenderItem>();
		*reflectedRI = *ri;	// 값 복사
		for (auto& instance : reflectedRI->Instances)
		{
			auto world = XMLoadFloat4x4(&instance.World) * R;
			auto invTransposeWorld = MathHelper::InverseTranspose(world);
			XMStoreFloat4x4(&instance.World, world);
			XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
		}
		FinalizeRenderItem(reflectedRI.get(), InstanceBufferIndex);

		if (ri.get() == mSkullShadow) mSkullShadowMirror = reflectedRI.get();
		if (ri.get() == mSkull) mSkullMirror = reflectedRI.get();

		mRenderItemLayer[(int)RenderLayer::Reflected].push_back(reflectedRI.get());
		renderItems.push_back(std::move(reflectedRI));
	}

	mAllRenderItems.insert(
		mAllRenderItems.end(),
		std::make_move_iterator(renderItems.begin()),
		std::make_move_iterator(renderItems.end()));
}

void SceneRenderer::BuildRenderItems_Gizmo(UINT& InstanceBufferIndex)
{
	RenderItem* gizmoRI = CreateRenderItem("shapeGeo", "box",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
		{ RenderLayer::Gizmo });
	gizmoRI->Visible = false;
	{
		TransformComponent transform;

		AddInstance(gizmoRI, "gizmoX", L"기즈모 X", transform, false);
		AddInstance(gizmoRI, "gizmoY", L"기즈모 Y", transform, false);
		AddInstance(gizmoRI, "gizmoZ", L"기즈모 Z", transform, false);
	}
	mGizmo.SetGigmoRenderItem(gizmoRI);
	FinalizeRenderItem(gizmoRI, InstanceBufferIndex);
}

void SceneRenderer::BuildRenderItems_SkinnedModel(UINT& InstanceBufferIndex)
{
	// 데이터가 내보내진 좌표계(RHS)를 변경하기 위해 반전(reflect)을 수행.
	//TransformComponent transform;
	//transform.Position = { 8.0f, 0.0f, -2.0f };
	//transform.Rotation = { 0.0f, 180.0f, 0.0f };
	//transform.Scale = { 0.05f, 0.05f, -0.05f };

	//for (UINT i = 0; i < mSkinnedMats.size(); ++i)
	//{
	//	std::string submeshName = "sm_" + std::to_string(i);

	//	RenderItem* ri = CreateRenderItem("soldier", submeshName.c_str(),
	//		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
	//		{ RenderLayer::SkinnedOpaque }, false);

	//	AddInstance(ri, mSkinnedMats[i].Name.c_str(), AnsiToWString(submeshName).c_str(), transform);

	//	// 이 soldier.m3d 인스턴스의 모든 렌더링 항목은 동일한 스킨드 모델 인스턴스를 공유.
	//	ri->SkinnedCBIndex = 0;
	//	ri->SkinnedModelInstance = mSkinnedModelInstance.get();
	//	FinalizeRenderItem(ri, InstanceBufferIndex);
	//}
}

void SceneRenderer::BuildRenderItems_FBX(UINT& InstanceBufferIndex)
{
	const std::string assetName = "fbxPreviewGeo";
	const auto skeletalMeshIt = mSkeletalMeshes.find(assetName);

	SkeletalMesh& skeletalMesh = skeletalMeshIt->second;
	TransformComponent transform;
	transform.Position = { 5.0f, 0.0f, 0.0f };
	transform.Rotation = { 0.0f, 180.0f, 0.0f };
	transform.Scale = { 0.03f, 0.03f, 0.03f };

	for (int submeshIndex = 0; submeshIndex < (int)skeletalMesh.Submeshes.size(); submeshIndex++)
	{
		const SkeletalSubmesh& submesh = skeletalMesh.Submeshes[submeshIndex];

		RenderItem* renderItem = CreateRenderItem(assetName.c_str(), submesh.Name.c_str(),
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST,
			{ RenderLayer::SkinnedOpaque }, false);

		AddInstance(renderItem, "defaultMat", L"FBX 미리보기", transform);

		// 서브메시마다 서로 다른 CB 사용
		renderItem->SkinnedCBIndex = submeshIndex;
		renderItem->SkinnedModelInstance = mSkinnedModelInstance.get();
		FinalizeRenderItem(renderItem, InstanceBufferIndex);
	}
}

RenderItem* SceneRenderer::CreateRenderItem(const char* GeoName, const char* submeshName, D3D12_PRIMITIVE_TOPOLOGY topology, std::vector<RenderLayer> layer, bool InMirror)
{
	auto* geometry = mGeometries.at(GeoName).get();
	const auto& submesh = geometry->DrawArgs.at(submeshName);

	auto renderItem = std::make_unique<RenderItem>();

	renderItem->Geo = geometry;
	renderItem->IndexCount = submesh.IndexCount;
	renderItem->StartIndexLocation = submesh.StartIndexLocation;
	renderItem->BaseVertexLocation = submesh.BaseVertexLocation;
	renderItem->PrimitiveType = topology;
	renderItem->LocalBounds = submesh.Bounds;
	renderItem->InMirror = InMirror;

	RenderItem* result = renderItem.get();

	for(auto l : layer)
		mRenderItemLayer[(int)l].push_back(result);
	mAllRenderItems.push_back(std::move(renderItem));

	return result;
}

InstanceData& SceneRenderer::AddInstance(RenderItem* renderItem, const char* matName, const wchar_t* objectName, const TransformComponent& transform, bool RegisterSceneObject)
{
	assert(renderItem != nullptr);

	Material* material = mMaterials.at(matName).get();

	const UINT localInstanceIndex = static_cast<UINT>(renderItem->Instances.size());
	const XMMATRIX world = transform.GetWorldMatrix();
	const XMMATRIX worldInvTranspose = MathHelper::InverseTranspose(world);

	InstanceData instance{};
	XMStoreFloat4x4(&instance.World, world);
	XMStoreFloat4x4(&instance.WorldInvTranspose, worldInvTranspose);
	instance.MaterialIndex = material->MatBufferIndex;
	renderItem->Instances.push_back(instance);

	if (RegisterSceneObject)
	{
		SceneObject& sceneObject = mScene.CreateObject(objectName);
		sceneObject.Transform = transform;
		sceneObject.RenderBindings.push_back(
			{
				renderItem,
				localInstanceIndex,
				material
			});
	}

	return renderItem->Instances.back();
}

void SceneRenderer::FinalizeRenderItem(RenderItem* renderItem, UINT& nextInstanceBufferIndex)
{
	assert(renderItem != nullptr);
	assert(!renderItem->Instances.empty());

	renderItem->StartInstanceLocation = nextInstanceBufferIndex;
	nextInstanceBufferIndex += static_cast<UINT>(renderItem->Instances.size());
}

void SceneRenderer::BuildFrameResources(D3D12Context& context)
{
	UINT skinnedCBCount = 1;

	if (mSkinnedModelInstance != nullptr)
	{
		skinnedCBCount = mSkinnedModelInstance->SubmeshFinalTransforms.size();
		skinnedCBCount = std::max(1u, skinnedCBCount);
	}

	for (int i = 0; i < RenderConfig::NumFrameResources; i++)
	{
		mFrameResources.push_back(
			std::make_unique<FrameResource>(
				context.GetDevice(),
				2,
				mInstanceCount,
				(UINT)mWaves->VertexCount(),
				(UINT)mMaterials.size(),
				skinnedCBCount));
	}
}

void SceneRenderer::BuildPSOs(const D3D12Context& context)
{
	ComPtr<ID3D12Device> device = context.GetDevice();

	PsoBuildContext ctx{};
	ctx.Device = device.Get();
	ctx.InputLayout = &mInputLayout;
	ctx.RootSignature = mRootSignature.Get();
	ctx.RenderTargetFormat = mColorFormat;
	ctx.DepthStencilFormat = mDepthFormat;
	ctx.SampleCount = context.mMsaaOption.SampleCount();
	ctx.SampleQuality = context.mMsaaOption.Quality();
	ctx.IsWireframe = false;
	ctx.CullMode = D3D12_CULL_MODE_BACK;
	ctx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;

	//mLayerPSOs
	{
		PsoBuildContext opaqueCtx = ctx;
		PipelineStateFactory factory(opaqueCtx);
		mLayerPSOs[(int)RenderLayer::Opaque][(int)SceneRenderMode::Lit] =
			factory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
		mLayerPSOs[(int)RenderLayer::Transparent][(int)SceneRenderMode::Lit] =
			factory.CreateTransparentPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
		mLayerPSOs[(int)RenderLayer::Waves][(int)SceneRenderMode::Lit] =
			factory.CreateTransparentPSO(mShaders["wavesVS"].Get(), mShaders["opaquePS"].Get());
		mLayerPSOs[(int)RenderLayer::MultiTextureBlend][(int)SceneRenderMode::Lit] =
			factory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["multiTextureBlendPS"].Get());

		PsoBuildContext alphaTestCtx = ctx;
		alphaTestCtx.CullMode = D3D12_CULL_MODE_NONE;
		PipelineStateFactory alphaTestFactory(alphaTestCtx);
		mLayerPSOs[(int)RenderLayer::AlphaTestOpaque][(int)SceneRenderMode::Lit] =
			alphaTestFactory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["alphaTestPS"].Get());
	}

	{
		PsoBuildContext opaqueWireframeCtx = ctx;
		opaqueWireframeCtx.IsWireframe = true;
		PipelineStateFactory factory(opaqueWireframeCtx);
		mLayerPSOs[(int)RenderLayer::Opaque][(int)SceneRenderMode::Wireframe] =
			factory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
	}

	{
		PsoBuildContext depthCtx = ctx;
		PipelineStateFactory depthFactory(depthCtx);
		mLayerPSOs[(int)RenderLayer::Opaque][(int)SceneRenderMode::DepthComplexity] =
			depthFactory.CreateDepthCountPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
	}

	{
		PsoBuildContext mirrorCtx = ctx;
		PipelineStateFactory mirrorFactory(mirrorCtx);
		mLayerPSOs[(int)RenderLayer::MirrorStencil][(int)SceneRenderMode::Lit] =
			mirrorFactory.CreateMirrorStencilPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());

		PsoBuildContext mirrorCtx2 = ctx;
		mirrorCtx2.Clockwise = true;
		mirrorCtx2.CullMode = D3D12_CULL_MODE_NONE;
		PipelineStateFactory mirrorFactory2(mirrorCtx2);
		mLayerPSOs[(int)RenderLayer::Reflected][(int)SceneRenderMode::Lit] =
			mirrorFactory2.CreateMirrorReflectedPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());

		PsoBuildContext mirrorCtx3 = ctx;
		PipelineStateFactory mirrorFactory3(mirrorCtx3);
		mLayerPSOs[(int)RenderLayer::MirrorBaseFill][(int)SceneRenderMode::Lit] =
			mirrorFactory3.CreateMirrorBaseFillPSO(mShaders["standardVS"].Get(), mShaders["mirrorBaseFillPS"].Get());
	}


	{
		PsoBuildContext shadowCtx = ctx;
		PipelineStateFactory shadowFactory(shadowCtx);
		mLayerPSOs[(int)RenderLayer::Shadow][(int)SceneRenderMode::Lit] = 
			shadowFactory.CreateShadowPSO(mShaders["standardVS"].Get(), mShaders["alphaTestPS"].Get());
	}

	{
		PsoBuildContext treeCtx = ctx;
		treeCtx.InputLayout = &mTreeBillboardInputLayout;
		treeCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_POINT;
		PipelineStateFactory treeFactory(treeCtx);
		mLayerPSOs[(int)RenderLayer::A2C_TreeBillboard][(int)SceneRenderMode::Lit] =
			treeFactory.CreateTreeBillboardPSO(mShaders["treeBillboardVS"].Get(), mShaders["treeBillboardGS"].Get(), mShaders["treeBillboardPS"].Get(), true);
		mLayerPSOs[(int)RenderLayer::A2C_TreeBillboard][(int)SceneRenderMode::DepthComplexity] =
			treeFactory.CreateDepthCountPSO(mShaders["treeBillboardVS"].Get(), mShaders["treeBillboardGS"].Get(), mShaders["treeBillboardPS"].Get());

		PsoBuildContext treeCtx2 = treeCtx;
		treeCtx2.IsWireframe = true;
		PipelineStateFactory treeFactory2(treeCtx2);
		mLayerPSOs[(int)RenderLayer::A2C_TreeBillboard][(int)SceneRenderMode::Wireframe] =
			treeFactory2.CreateTreeBillboardPSO(mShaders["treeBillboardVS"].Get(), mShaders["treeBillboardGS"].Get(), mShaders["treeBillboardPS_Wireframe"].Get(), true);
	}

	{
		PsoBuildContext exCylCtx = ctx;
		exCylCtx.InputLayout = &mInputLayout;
		exCylCtx.CullMode = D3D12_CULL_MODE_NONE;
		exCylCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_LINE;
		PipelineStateFactory exCylFactory(exCylCtx);
		mLayerPSOs[(int)RenderLayer::LineToCylinder][(int)SceneRenderMode::Lit] =
			exCylFactory.CreateLineToCylinderPSO(mShaders["lineToCylinderVS"].Get(), mShaders["lineToCylinderGS"].Get(), mShaders["lineToCylinderPS"].Get());
		mLayerPSOs[(int)RenderLayer::LineToCylinder][(int)SceneRenderMode::DepthComplexity] =
			exCylFactory.CreateDepthCountPSO(mShaders["lineToCylinderVS"].Get(), mShaders["lineToCylinderGS"].Get(), mShaders["lineToCylinderPS"].Get());

		PsoBuildContext exCylCtx2 = exCylCtx;
		exCylCtx2.IsWireframe = true;
		PipelineStateFactory exCylFactory2(exCylCtx2);
		mLayerPSOs[(int)RenderLayer::LineToCylinder][(int)SceneRenderMode::Wireframe] =
			exCylFactory2.CreateLineToCylinderPSO(mShaders["lineToCylinderVS"].Get(), mShaders["lineToCylinderGS"].Get(), mShaders["lineToCylinderPS"].Get());
	}

	{
		PsoBuildContext explodeCtx = ctx;
		explodeCtx.CullMode = D3D12_CULL_MODE_NONE;
		PipelineStateFactory explodeFactory(explodeCtx);
		mLayerPSOs[(int)RenderLayer::GeoExplode][(int)SceneRenderMode::Lit] =
			explodeFactory.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["explodeGS"].Get(), mShaders["lineToCylinderPS"].Get());
		mLayerPSOs[(int)RenderLayer::GeoExplode][(int)SceneRenderMode::DepthComplexity] =
			explodeFactory.CreateDepthCountPSO(mShaders["lineToCylinderVS"].Get(), mShaders["explodeGS"].Get(), mShaders["lineToCylinderPS"].Get());

		PsoBuildContext explodeCtx2 = explodeCtx;
		explodeCtx2.IsWireframe = true;
		PipelineStateFactory explodeFactory2(explodeCtx2);
		mLayerPSOs[(int)RenderLayer::GeoExplode][(int)SceneRenderMode::Wireframe] =
			explodeFactory2.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["explodeGS"].Get(), mShaders["lineToCylinderPS"].Get());
	}

	{
		PsoBuildContext lodCtx = ctx;
		PipelineStateFactory lodFactory(lodCtx);
		mLayerPSOs[(int)RenderLayer::GeoSphereLOD][(int)SceneRenderMode::Lit] =
			lodFactory.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["LOD_GS"].Get(), mShaders["lineToCylinderPS"].Get());
		mLayerPSOs[(int)RenderLayer::GeoSphereLOD][(int)SceneRenderMode::DepthComplexity] =
			lodFactory.CreateDepthCountPSO(mShaders["lineToCylinderVS"].Get(), mShaders["LOD_GS"].Get(), mShaders["lineToCylinderPS"].Get());
	
		PsoBuildContext lodCtx2 = lodCtx;
		lodCtx2.IsWireframe = true;
		PipelineStateFactory lodFactory2(lodCtx2);
		mLayerPSOs[(int)RenderLayer::GeoSphereLOD][(int)SceneRenderMode::Wireframe] =
			lodFactory2.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["LOD_GS"].Get(), mShaders["lineToCylinderPS"].Get());
	}
	
	{
		PsoBuildContext tessCtx = ctx;
		tessCtx.CullMode = D3D12_CULL_MODE_NONE;
		tessCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_PATCH;
		PipelineStateFactory tessFactory(tessCtx);
		mLayerPSOs[(int)RenderLayer::TessLand][(int)SceneRenderMode::Lit] =
			tessFactory.CreateTessellationPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS"].Get(), mShaders["tessPS"].Get());
		mLayerPSOs[(int)RenderLayer::TessLand][(int)SceneRenderMode::DepthComplexity] =
			tessFactory.CreateDepthCountPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS"].Get(), mShaders["tessPS"].Get());
		mLayerPSOs[(int)RenderLayer::TessWall][(int)SceneRenderMode::Lit] =
			tessFactory.CreateTessellateMirrorWallPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS_Wall"].Get(), mShaders["tessPS"].Get());
		mLayerPSOs[(int)RenderLayer::TessWall][(int)SceneRenderMode::DepthComplexity] =
			tessFactory.CreateDepthCountPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS_Wall"].Get(), mShaders["tessPS"].Get());

		PsoBuildContext tessCtx2 = tessCtx;
		tessCtx2.IsWireframe = true;
		PipelineStateFactory tessFactory2(tessCtx2);
		mLayerPSOs[(int)RenderLayer::TessLand][(int)SceneRenderMode::Wireframe] =
			tessFactory2.CreateTessellationPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS"].Get(), mShaders["tessPS"].Get());
		mLayerPSOs[(int)RenderLayer::TessWall][(int)SceneRenderMode::Wireframe] =
			tessFactory2.CreateTessellateMirrorWallPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS_Wall"].Get(), mShaders["tessPS"].Get());
	}

	{
		PsoBuildContext gizmoCtx = ctx;
		PipelineStateFactory gizmoFactory(gizmoCtx);
		mLayerPSOs[(int)RenderLayer::Gizmo][(int)SceneRenderMode::Lit] =
			gizmoFactory.CreateGizmoPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
	}

	{
		PsoBuildContext skinnedCtx = ctx;
		skinnedCtx.InputLayout = &mSkinnedInputLayout;
		skinnedCtx.CullMode = D3D12_CULL_MODE_NONE;
		PipelineStateFactory skinnedFactory(skinnedCtx);
		mLayerPSOs[(int)RenderLayer::SkinnedOpaque][(int)SceneRenderMode::Lit] =
			skinnedFactory.CreateOpaquePSO(mShaders["skinnedVS"].Get(), mShaders["opaquePS"].Get());

		PsoBuildContext skinnedCtx2 = skinnedCtx;
		skinnedCtx2.IsWireframe = true;
		PipelineStateFactory skinnedFactory2(skinnedCtx2);
		mLayerPSOs[(int)RenderLayer::SkinnedOpaque][(int)SceneRenderMode::Wireframe] =
			skinnedFactory2.CreateOpaquePSO(mShaders["skinnedVS"].Get(), mShaders["opaquePS"].Get());
	}

	//mGraphicsPSOs
	{
		PsoBuildContext depthVisualizeCtx = ctx;
		depthVisualizeCtx.RootSignature = mRootSignature_debug.Get();
		PipelineStateFactory depthVisualizeFactory(depthVisualizeCtx);
		mGraphicsPSOs[(int)GraphicsPass::DepthComplexityVisualize] =
			depthVisualizeFactory.CreateDepthComplexityDebugPSO(mShaders["depthDebugVS"].Get(), mShaders["depthDebugPS"].Get());

		PsoBuildContext normalDebugCtx = ctx;
		normalDebugCtx.CullMode = D3D12_CULL_MODE_NONE;
		normalDebugCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_POINT;
		PipelineStateFactory normalDebugFactory(normalDebugCtx);
		mGraphicsPSOs[(int)GraphicsPass::VertexNormalVisualize] =
			normalDebugFactory.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["vertexDebugGS"].Get(), mShaders["vertexDebugPS"].Get());

		PsoBuildContext selectedCtx = ctx;
		PipelineStateFactory selectedFactory(selectedCtx);
		mGraphicsPSOs[(int)GraphicsPass::SelectedMask] =
			selectedFactory.CreateSelectedStencilMaskPSO(mShaders["highlightVS_Mask"].Get(), mShaders["highlightPS"].Get());
		mGraphicsPSOs[(int)GraphicsPass::SelectedOutline] =
			selectedFactory.CreateSelectedPSO(mShaders["highlightVS"].Get(), mShaders["highlightPS"].Get());
	}

	//mComputePSOs
	{
		PsoBuildContext waveCtx = ctx;
		waveCtx.RootSignature = mWavesRootSignature.Get();
		PipelineStateFactory waveFactory(waveCtx);
		mComputePSOs[(int)ComputePass::WavesDisturb] = waveFactory.CreateComputePSO(mShaders["wavesSimDisturb"].Get());
		mComputePSOs[(int)ComputePass::WavesUpdate] = waveFactory.CreateComputePSO(mShaders["wavesSimUpdate"].Get());

		PsoBuildContext blurCtx = ctx;
		blurCtx.RootSignature = mPostProcessRootSignature.Get();
		PipelineStateFactory blurFactory(blurCtx);
		mComputePSOs[(int)ComputePass::BlurHorizontal] = blurFactory.CreateComputePSO(mShaders["blurH"].Get());
		mComputePSOs[(int)ComputePass::BlurVertical] = blurFactory.CreateComputePSO(mShaders["blurV"].Get());

		PsoBuildContext sobelCtx = ctx;
		sobelCtx.RootSignature = mPostProcessRootSignature.Get();
		PipelineStateFactory sobelFactory(sobelCtx);
		mComputePSOs[(int)ComputePass::SobelExcute] = sobelFactory.CreateComputePSO(mShaders["sobelCS"].Get());
		mComputePSOs[(int)ComputePass::SobelComposite] = sobelFactory.CreateComputePSO(mShaders["sobelCompositeCS"].Get());
	}
}

std::array<const CD3DX12_STATIC_SAMPLER_DESC, 7> SceneRenderer::GetStaticSamplers()
{
	static const CD3DX12_STATIC_SAMPLER_DESC pointWrap(
		0, // shaderRegister
		D3D12_FILTER_MIN_MAG_MIP_POINT, // filter
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,  // addressU
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,  // addressV
		D3D12_TEXTURE_ADDRESS_MODE_WRAP); // addressW

	static const CD3DX12_STATIC_SAMPLER_DESC pointClamp(
		1,
		D3D12_FILTER_MIN_MAG_MIP_POINT,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP);

	static const CD3DX12_STATIC_SAMPLER_DESC linearWrap(
		2,
		D3D12_FILTER_MIN_MAG_MIP_LINEAR,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP);

	static const CD3DX12_STATIC_SAMPLER_DESC linearClamp(
		3,
		D3D12_FILTER_MIN_MAG_MIP_LINEAR,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP);

	static const CD3DX12_STATIC_SAMPLER_DESC anisotropicWrap(
		4,
		D3D12_FILTER_ANISOTROPIC,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		0,
		8);

	static const CD3DX12_STATIC_SAMPLER_DESC anisotropicClamp(
		5,
		D3D12_FILTER_ANISOTROPIC,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		0.0f,
		8);

	static const CD3DX12_STATIC_SAMPLER_DESC testSampler(
		6,
		D3D12_FILTER_ANISOTROPIC,
		D3D12_TEXTURE_ADDRESS_MODE_MIRROR_ONCE,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		0.0f,
		8);

	static std::array<const CD3DX12_STATIC_SAMPLER_DESC, 7> array =
	{
			pointWrap, pointClamp, linearWrap, linearClamp, anisotropicWrap, anisotropicClamp, testSampler 
	};

	return array;
}

DirectX::XMVECTOR SceneRenderer::GetMirrorPlane()
{
	XMMATRIX W = XMLoadFloat4x4(&mMirror->Instances[0].World);

	XMVECTOR pLocal = XMVectorSet(0.0f, 0.0f, 0.0f, 1.0f);	// 점 벡터
	XMVECTOR nLocal = XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f);	// grid가 XZ Plane일 때

	XMVECTOR pWorld = XMVector3TransformCoord(pLocal, W);

	XMMATRIX invTransW = MathHelper::InverseTranspose(W);
	XMVECTOR nWorld = XMVector3TransformNormal(nLocal, invTransW);
	nWorld = XMVector3Normalize(nWorld);

	float d = -XMVectorGetX(XMVector3Dot(nWorld, pWorld));

	return XMVectorSetW(nWorld, d);
}

float SceneRenderer::GetHillsHeight(float x, float z) const
{
	return 0.3f * (z * sinf(0.05f * x) + x * cosf(0.1f * z));
}

MeshData SceneRenderer::LoadModelFromFile_dx12ex(const std::wstring& path)
{
	std::ifstream file(path);
	if (!file)
	{
		std::wstring wfn = AnsiToWString(__FILE__);
		throw DxException(1, path, wfn, __LINE__);
	}

	int vertexCount = 0;
	int indexCount = 0;
	std::string ignore;

	file >> ignore >> vertexCount;
	file >> ignore >> indexCount;
	file >> ignore >> ignore >> ignore >> ignore;

	//메시 생성
	MeshData md;
	std::vector<Vertex> vertices(vertexCount);
	for (int i = 0; i < vertexCount; i++)
	{
		file >> vertices[i].Position.x >> vertices[i].Position.y >> vertices[i].Position.z;
		file >> vertices[i].Normal.x >> vertices[i].Normal.y >> vertices[i].Normal.z;
		vertices[i].TangentU = { 1.0f, 0.0f, 0.0f };

		XMVECTOR P = XMLoadFloat3(&vertices[i].Position);
		XMFLOAT3 spherePos;
		XMStoreFloat3(&spherePos, XMVector3Normalize(P));

		float theta = atan2f(spherePos.z, spherePos.x);

		// Put in [0, 2pi].
		if (theta < 0.0f)
			theta += XM_2PI;

		float phi = acosf(spherePos.y);

		float u = theta / (2.0f * XM_PI);
		float v = phi / XM_PI;
		vertices[i].TexC = { u,v };
	}
	md.Vertices = vertices;

	file >> ignore >> ignore >> ignore;

	std::vector<uint32_t> indices(indexCount * 3);
	for (int i = 0; i < indexCount; i++)
	{
		file >> indices[i * 3 + 0] >> indices[i * 3 + 1] >> indices[i * 3 + 2];
	}
	md.Indices32 = indices;

	file.close();

	return md;
}

//void SceneRenderer::LoadSkinnedModel_dx12ex(D3D12Context& context)
//{
//	std::vector<M3DLoader::SkinnedVertex> vertices;
//	std::vector<std::uint16_t> indices;
//
//	mSkinnedModelInstance = std::make_unique<SkinnedModelInstance>();
//	M3DLoader m3dLoader;
//	std::vector<M3DLoader::Subset> skinnedSubsets;
//	m3dLoader.LoadM3d("Resource\\Models\\soldier.m3d", vertices, indices,
//		skinnedSubsets, mSkinnedMats, mSkinnedModelInstance->skinnedInfo);
//
//	mSkinnedModelInstance->finalTransforms.resize(mSkinnedModelInstance->skinnedInfo.BoneCount());
//	mSkinnedModelInstance->clipName = "Take1";
//	mSkinnedModelInstance->timePos = 0.0f;
//
//	const UINT vbByteSize = (UINT)vertices.size() * sizeof(M3DLoader::SkinnedVertex);
//	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint16_t);
//
//	auto geo = std::make_unique<MeshGeometry>();
//	geo->Name = "soldier";
//
//	ThrowIfFailed(D3DCreateBlob(vbByteSize, &geo->VertexBufferCPU));
//	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);
//
//	ThrowIfFailed(D3DCreateBlob(ibByteSize, &geo->IndexBufferCPU));
//	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);
//
//	geo->VertexBufferGPU = D3D12Util::CreateDefaultBuffer(context.GetDevice(),
//		context.GetCommandList(), vertices.data(), vbByteSize, geo->VertexBufferUploader);
//
//	geo->IndexBufferGPU = D3D12Util::CreateDefaultBuffer(context.GetDevice(),
//		context.GetCommandList(), indices.data(), ibByteSize, geo->IndexBufferUploader);
//
//	geo->VertexByteStride = sizeof(M3DLoader::SkinnedVertex);
//	geo->VertexBufferByteSize = vbByteSize;
//	geo->IndexFormat = DXGI_FORMAT_R16_UINT;
//	geo->IndexBufferByteSize = ibByteSize;
//
//	for (UINT i = 0; i < (UINT)skinnedSubsets.size(); i++)
//	{
//		SubmeshGeometry submesh;
//		std::string name = "sm_" + std::to_string(i);
//
//		submesh.IndexCount = (UINT)skinnedSubsets[i].FaceCount * 3;
//		submesh.StartIndexLocation = skinnedSubsets[i].FaceStart * 3;
//		submesh.BaseVertexLocation = 0;
//		BoundingBox::CreateFromPoints(submesh.Bounds, vertices.size(), &vertices[0].Pos, sizeof(M3DLoader::SkinnedVertex));
//
//		geo->DrawArgs[name] = submesh;
//	}
//
//	mGeometries[geo->Name] = std::move(geo);
//}

void SceneRenderer::UpdateSkinnedCBs()
{
	auto currSkinnedCB = mCurrFrameResource->SkinnedCB.get();

	// 캐릭터 인스턴스당 한 번만 애니메이션 평가
	mSkinnedModelInstance->UpdateAnimation(mTimer.DeltaTime());

	const auto& submeshPalettes = mSkinnedModelInstance->SubmeshFinalTransforms;

	for (UINT submeshIndex = 0; submeshIndex < (UINT)submeshPalettes.size(); submeshIndex++)
	{
		const std::vector<XMFLOAT4X4>& finalTransforms = submeshPalettes[submeshIndex];

		SkinnedConstants skinnedConstants{};
		constexpr std::size_t maxPaletteSize = std::size(skinnedConstants.BoneTransforms);

		if (finalTransforms.size() > maxPaletteSize)
		{
			throw DxException(
				E_FAIL,
				L"Skin palette exceeds SkinnedConstants capacity.",
				AnsiToWString(__FILE__),
				__LINE__);
		}

		std::copy(finalTransforms.begin(), finalTransforms.end(), std::begin(skinnedConstants.BoneTransforms));

		// submeshIndex == RenderItem::SkinnedCBIndex
		currSkinnedCB->CopyData(submeshIndex, skinnedConstants);
	}
}

void SceneRenderer::UpdateMainPassCB()
{
	XMMATRIX view = mCamera.GetView();
	XMMATRIX proj = mCamera.GetProj();
	XMMATRIX viewProj = XMMatrixMultiply(view, proj);

	XMVECTOR viewDet = XMMatrixDeterminant(view);
	XMVECTOR projDet = XMMatrixDeterminant(proj);
	XMVECTOR viewProjDet = XMMatrixDeterminant(viewProj);

	XMMATRIX invView = XMMatrixInverse(&viewDet, view);
	XMMATRIX invProj = XMMatrixInverse(&projDet, proj);
	XMMATRIX invViewProj = XMMatrixInverse(&viewProjDet, viewProj);

	XMStoreFloat4x4(&mMainPassCB.View, XMMatrixTranspose(view));
	XMStoreFloat4x4(&mMainPassCB.InvView, XMMatrixTranspose(invView));
	XMStoreFloat4x4(&mMainPassCB.Proj, XMMatrixTranspose(proj));
	XMStoreFloat4x4(&mMainPassCB.InvProj, XMMatrixTranspose(invProj));
	XMStoreFloat4x4(&mMainPassCB.ViewProj, XMMatrixTranspose(viewProj));
	XMStoreFloat4x4(&mMainPassCB.InvViewProj, XMMatrixTranspose(invViewProj));

	mMainPassCB.EyePosW = mCamera.GetPosition3f();
	mMainPassCB.RenderTargetSize = XMFLOAT2((float)mViewportWidth, (float)mViewportHeight);
	mMainPassCB.InvRenderTargetSize = XMFLOAT2(1.0f / mViewportHeight, 1.0f / mViewportHeight);
	mMainPassCB.NearZ = 1.0f;
	mMainPassCB.FarZ = 1000.0f;
	mMainPassCB.TotalTime = (float)mTimer.TotalTime();
	mMainPassCB.DeltaTime = (float)mTimer.DeltaTime();
	mMainPassCB.AmbientLight = { 0.25f, 0.25f, 0.35f, 1.0f };
	mMainPassCB.Lights[0].Direction = { 0.57735f, -0.57735f, 0.57735f };
	mMainPassCB.Lights[0].Strength = { 0.6f, 0.6f, 0.6f };
	mMainPassCB.Lights[1].Direction = { -0.57735f, -0.57735f, 0.57735f };
	mMainPassCB.Lights[1].Strength = { 0.3f, 0.3f, 0.3f };
	mMainPassCB.Lights[2].Direction = { 0.0f, -0.707f, -0.707f };
	mMainPassCB.Lights[2].Strength = { 0.15f, 0.15f, 0.15f };

	mMainPassCB.gFogColor = { 0.7f, 0.7f, 0.7f, 1.0f };
	mMainPassCB.gFogStart = 5.f;
	mMainPassCB.gFogRange = 200.f;

	XMVECTOR lightDir = -MathHelper::SphericalToCatesian(1.0f, mSunTheta, mSunPhi);
	XMStoreFloat3(&mMainPassCB.Lights[0].Direction, lightDir);

	mCurrFrameResource->PassCB->CopyData(0, mMainPassCB);
}

void SceneRenderer::UpdateReflectedPassCB()
{
	mReflectedPassCB = mMainPassCB;

	XMVECTOR mirrorPlane = GetMirrorPlane(); // x = -10 plane
	XMMATRIX R = XMMatrixReflect(mirrorPlane);

	for (int i = 0; i < MaxLights; i++)
	{
		XMVECTOR lightDir = XMLoadFloat3(&mMainPassCB.Lights[i].Direction);
		XMVECTOR reflectedLightDir = XMVector3TransformNormal(lightDir, R);
		XMStoreFloat3(&mReflectedPassCB.Lights[i].Direction, reflectedLightDir);
	}

	mCurrFrameResource->PassCB->CopyData(1, mReflectedPassCB);
}

void SceneRenderer::UpdateInstanceBuffer()
{
	XMMATRIX invView = mCamera.GetInvView();

	// 카메라 프러스텀을 뷰 공간에서 월드 공간으로 변환한다.
	BoundingFrustum worldFrustum;
	mCamFrustum.Transform(worldFrustum, invView);

	auto currInstanceBuffer = mCurrFrameResource->InstanceBuffer.get();

	mVisibleInstanceCount = 0;
	for (auto& ri : mAllRenderItems)
	{
		ri->VisibleInstanceCount = 0;

		for (auto& instance : ri->Instances)
			instance.GpuInstanceIndex = UINT_MAX;

		if (!ri->Visible) continue;

		UINT visibleInstanceCount = 0;

		for (UINT i = 0; i < ri->Instances.size(); ++i)
		{
			InstanceData& instance = ri->Instances[i];

			instance.GpuInstanceIndex = UINT_MAX;
			if (instance.visible == false) continue;
			instance.FrustumVisible = false;

			XMMATRIX world = XMLoadFloat4x4(&instance.World);
			XMMATRIX worldInvTranspose = XMLoadFloat4x4(&instance.WorldInvTranspose);
			XMMATRIX texTransform = XMLoadFloat4x4(&instance.TexTransform);

			BoundingBox worldBounds;
			ri->LocalBounds.Transform(worldBounds, world);

			// 월드 공간에서 박스/프러스텀 교차 테스트를 수행한다.
			if ((worldFrustum.Contains(worldBounds) != DirectX::DISJOINT) || !mFrustumCullingEnabled)
			{
				instance.FrustumVisible = true;

				InstanceData_GPU gpuData;
				XMStoreFloat4x4(&gpuData.World, XMMatrixTranspose(world));
				XMStoreFloat4x4(&gpuData.WorldInvTranspose, XMMatrixTranspose(worldInvTranspose));
				XMStoreFloat4x4(&gpuData.TexTransform, XMMatrixTranspose(texTransform));
				gpuData.MaterialIndex = instance.MaterialIndex;
				gpuData.DisplacementMapTexelSize = instance.DisplacementMapTexelSize;
				gpuData.GridSpatialStep = instance.GridSpatialStep;

				UINT gpuIndex = ri->StartInstanceLocation + visibleInstanceCount;
				currInstanceBuffer->CopyData(gpuIndex, gpuData);
				instance.GpuInstanceIndex = gpuIndex;
				visibleInstanceCount++;
			}
		}

		ri->VisibleInstanceCount = visibleInstanceCount;
		mVisibleInstanceCount += visibleInstanceCount;
	}
}

void SceneRenderer::UpdateMaterialBuffer()
{
	auto currMaterialCB = mCurrFrameResource->MaterialBuffer.get();
	
	for (auto& e : mMaterials)
	{
		Material* mat = e.second.get();
		if (mat->NumFramesDirty > 0)
		{
			XMMATRIX matTransform = XMLoadFloat4x4(&mat->MatTransform);

			MaterialData matConstants;
			matConstants.DiffuseAlbedo = mat->DiffuseAlbedo;
			matConstants.FresnelR0 = mat->FresnelR0;
			matConstants.Roughness = mat->Roughness;
			XMStoreFloat4x4(&matConstants.MatTransform, XMMatrixTranspose(matTransform));
			matConstants.DiffuseMapIndex =
				TextureManager::GetInstance().Find(mat->DiffuseTexturePath)->Srv.Index;

			currMaterialCB->CopyData(mat->MatBufferIndex, matConstants);
			mat->NumFramesDirty--;
		}
	}
}

void SceneRenderer::UpdateWavesGPU(ID3D12GraphicsCommandList* cmdList)
{
	static float t_base = 0.0f;
	if ((mTimer.TotalTime() - t_base) >= 0.25f)
	{
		t_base += 0.25f;

		int i = MathHelper::Rand(4, mWaves->RowCount() - 5);
		int j = MathHelper::Rand(4, mWaves->ColumnCount() - 5);
		float r = MathHelper::RandF(0.5f, 1.0f);

		mWaves->Disturb(cmdList, mWavesRootSignature.Get(), mComputePSOs[(int)ComputePass::WavesDisturb].Get(), i, j, r);
	}

	mWaves->Update(mTimer, cmdList, mWavesRootSignature.Get(), mComputePSOs[(int)ComputePass::WavesUpdate].Get());
	mWaves->PrepareDraw(cmdList);
}

void SceneRenderer::UpdateShadowTransform()
{
	if (mSkullShadow == nullptr) return;

	//빛 전환에 따른 해골 그림자 변환.
	XMVECTOR shadowPlane = XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f); //xz plane
	XMVECTOR toMainLight = -XMLoadFloat3(&mMainPassCB.Lights[0].Direction);
	XMVECTOR toReflectedLight = -XMLoadFloat3(&mReflectedPassCB.Lights[0].Direction);
	XMMATRIX s = XMMatrixShadow(shadowPlane, toMainLight);
	XMMATRIX s2 = XMMatrixShadow(shadowPlane, toReflectedLight);
	XMMATRIX shadowOffsetY = XMMatrixTranslation(0.0f, 0.001f, 0.0f);
	XMMATRIX skullWorld = XMLoadFloat4x4(&mSkull->Instances[0].World);
	XMStoreFloat4x4(&mSkullShadow->Instances[0].World, skullWorld * s * shadowOffsetY);

	if (mSkullShadowMirror != nullptr)
	{
		XMMATRIX mirrorSkullWorld = XMLoadFloat4x4(&mSkullMirror->Instances[0].World);
		XMStoreFloat4x4(&mSkullShadowMirror->Instances[0].World, mirrorSkullWorld * s2 * shadowOffsetY);
	}
}

void SceneRenderer::AnimateMaterials()
{
	auto waterMat = mMaterials["water0"].get();

	float& tu = waterMat->MatTransform(3, 0);
	float& tv = waterMat->MatTransform(3, 1);

	tu += 0.1f * mTimer.DeltaTime();
	tv += 0.02f * mTimer.DeltaTime();

	if (tu >= 1.0f) tu -= 1.0f;
	if (tv >= 1.0f) tv -= 1.0f;

	waterMat->NumFramesDirty = RenderConfig::NumFrameResources;


	//Blend Texture Box Animation
	//uv 중심에서 회전하기 위해 이동행렬 필요.
	auto swirlingMat = mMaterials["swirling"].get();
	XMMATRIX R = XMMatrixRotationZ(1.5f * (float)mTimer.TotalTime());
	XMMATRIX T0 = XMMatrixTranslation(-0.5f, -0.5f, 0.0f);
	XMMATRIX T1 = XMMatrixTranslation(0.5f, 0.5f, 0.0f);
	XMMATRIX M = T0 * R * T1;
	XMStoreFloat4x4(&swirlingMat->MatTransform, M);
	swirlingMat->NumFramesDirty = RenderConfig::NumFrameResources;
}

void SceneRenderer::DrawRenderItems(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers)
{
	UINT skinnedCBByteSize = D3D12Util::CalcConstantBufferByteSize(sizeof(SkinnedConstants));
	auto skinnedCB = mCurrFrameResource->SkinnedCB->Resource();

	for (auto& ri : renderLayers)
	{
		if (ri->VisibleInstanceCount == 0) continue;

		auto vbv = ri->Geo->VertexBufferView();
		auto ibv = ri->Geo->IndexBufferView();

		cmdList->IASetVertexBuffers(0, 1, &vbv);
		cmdList->IASetIndexBuffer(&ibv);
		cmdList->IASetPrimitiveTopology(ri->PrimitiveType);

		cmdList->SetGraphicsRoot32BitConstant(1, ri->StartInstanceLocation, 0);

		if (ri->SkinnedModelInstance != nullptr)
		{
			D3D12_GPU_VIRTUAL_ADDRESS skinnedCBAddress = skinnedCB->GetGPUVirtualAddress() + ri->SkinnedCBIndex * skinnedCBByteSize;
			cmdList->SetGraphicsRootConstantBufferView(2, skinnedCBAddress);
		}
		else
		{
			cmdList->SetGraphicsRootConstantBufferView(2, 0);
		}

		cmdList->DrawIndexedInstanced(ri->IndexCount, ri->VisibleInstanceCount, ri->StartIndexLocation, ri->BaseVertexLocation, 0);
	}
}

void SceneRenderer::DrawSelectedInstance(ID3D12GraphicsCommandList* cmdList)
{
	auto selectedInstances = mGizmo.GetSelectedInstances();

	if (selectedInstances.empty()) return;

	for (auto& selected : selectedInstances)
	{
		if (selected.renderItem == nullptr ||
			selected.instanceIndex == UINT_MAX)
		{
			continue;
		}

		RenderItem* ri = selected.renderItem;
		UINT instanceIndex = selected.instanceIndex;
		UINT instanceIndexGPU = ri->Instances[instanceIndex].GpuInstanceIndex;
		if (instanceIndexGPU == UINT_MAX) continue;

		auto vbv = ri->Geo->VertexBufferView();
		auto ibv = ri->Geo->IndexBufferView();
		cmdList->IASetVertexBuffers(0, 1, &vbv);
		cmdList->IASetIndexBuffer(&ibv);
		cmdList->IASetPrimitiveTopology(ri->PrimitiveType);

		cmdList->SetGraphicsRoot32BitConstant(1, instanceIndexGPU, 0);

		cmdList->DrawIndexedInstanced(ri->IndexCount, 1, ri->StartIndexLocation, ri->BaseVertexLocation, 0);
	}
}

void SceneRenderer::DrawRenderItems_VertexNormalDebug(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers)
{
	for (auto& ri : renderLayers)
	{
		if (ri->VisibleInstanceCount == 0) continue;

		auto vbv = ri->Geo->VertexBufferView();
		auto ibv = ri->Geo->IndexBufferView();

		cmdList->IASetVertexBuffers(0, 1, &vbv);
		cmdList->IASetIndexBuffer(&ibv);
		cmdList->IASetPrimitiveTopology(D3D10_PRIMITIVE_TOPOLOGY_POINTLIST);

		cmdList->SetGraphicsRoot32BitConstant(1, ri->StartInstanceLocation, 0);

		cmdList->DrawIndexedInstanced(ri->IndexCount, ri->VisibleInstanceCount, ri->StartIndexLocation, ri->BaseVertexLocation, 0);
	}
}

void SceneRenderer::DrawDebugColorTriangle(ID3D12GraphicsCommandList* cmdList)
{
	static constexpr std::array<DebugColorConstants, 10> colors =
	{
		XMFLOAT4{1.0f, 0.0f, 0.0f, 1.0f},   // 1 빨강
		XMFLOAT4{1.0f, 0.5f, 0.0f, 1.0f},   // 2 주황
		XMFLOAT4{1.0f, 1.0f, 0.0f, 1.0f},   // 3 노랑
		XMFLOAT4{0.0f, 1.0f, 0.0f, 1.0f},   // 4 초록
		XMFLOAT4{0.0f, 0.0f, 1.0f, 1.0f},   // 5 파랑
		XMFLOAT4{0.0f, 1.0f, 1.0f, 1.0f},   // 6 청록
		XMFLOAT4{1.0f, 0.0f, 1.0f, 1.0f},   // 7 자홍
		XMFLOAT4{0.5f, 0.0f, 1.0f, 1.0f},   // 8 보라
		XMFLOAT4{1.0f, 1.0f, 1.0f, 1.0f},   // 9 흰색
		XMFLOAT4{0.4f, 0.4f, 0.4f, 1.0f}    // 10 회색
	};

	UINT debugColorCBByteSize = D3D12Util::CalcConstantBufferByteSize(sizeof(DebugColorConstants));

	cmdList->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

	for (UINT i = 0; i < colors.size(); i++)
	{
		cmdList->OMSetStencilRef(i + 1);
		cmdList->SetGraphicsRoot32BitConstants(0, 4, &colors[i], 0);
		cmdList->DrawInstanced(3, 1, 0, 0);
	}
}

void SceneRenderer::CreateQueryHeap(D3D12Context& context)
{
	D3D12_QUERY_HEAP_DESC queryHeapDesc = {};
	queryHeapDesc.Count = 4 * RenderConfig::NumFrameResources;
	queryHeapDesc.Type = D3D12_QUERY_HEAP_TYPE_TIMESTAMP;

	ThrowIfFailed(context.GetDevice()->CreateQueryHeap(
		&queryHeapDesc,
		IID_PPV_ARGS(&mTimestampQueryHeap)));

	const UINT64 bufferSize = sizeof(UINT64) * 4 * RenderConfig::NumFrameResources;

	auto heapProps = CD3DX12_HEAP_PROPERTIES(D3D12_HEAP_TYPE_READBACK);
	auto bufferDesc = CD3DX12_RESOURCE_DESC::Buffer(bufferSize);

	ThrowIfFailed(context.GetDevice()->CreateCommittedResource(
		&heapProps,
		D3D12_HEAP_FLAG_NONE,
		&bufferDesc,
		D3D12_RESOURCE_STATE_COPY_DEST,
		nullptr,
		IID_PPV_ARGS(&mTimestampReadbackBuffer)));

	context.GetCommandQueue()->GetTimestampFrequency(&mGpuTimestampFrequency);
}

ID3D12PipelineState* SceneRenderer::ResolvePSO(RenderLayer layer, SceneRenderMode mode) const
{
	if(mode == SceneRenderMode::VertexNormal)
		return mLayerPSOs[(int)layer][(int)SceneRenderMode::Lit].Get();

	const auto& modePso = mLayerPSOs[(int)layer][(int)mode];
	if (modePso) return modePso.Get();

	const auto& litPso = mLayerPSOs[(int)RenderLayer::Opaque][(int)mode];
	return litPso.Get();
}

void SceneRenderer::SyncSceneObjectTransforms()
{
	for (const auto& object : mScene.GetObjects())
	{
		if (!object) continue;

		if (!object->TransformDirty) continue;

		const XMMATRIX world = object->Transform.GetWorldMatrix();

		const XMMATRIX worldInvTranspose = MathHelper::InverseTranspose(world);

		for (const RenderInstanceBinding& binding : object->RenderBindings)
		{
			RenderItem* renderItem = binding.RenderData;

			if (!renderItem) continue;

			if (binding.InstanceIndex >= renderItem->Instances.size())
			{
				assert(false && "SceneObject RenderBinding index is invalid.");
				continue;
			}

			InstanceData& instance = renderItem->Instances[binding.InstanceIndex];

			XMStoreFloat4x4(&instance.World, world);
			XMStoreFloat4x4(&instance.WorldInvTranspose, worldInvTranspose);
		}

		object->TransformDirty = false;
	}
}