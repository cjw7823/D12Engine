#include "pch.h"
#include "SceneRenderer.h"

#include "EngineCore/GameTimer.h"
#include "EngineCore/Logging/Logger.h"

#include "Renderer/Resources/RenderData.h"
#include "Renderer/DirectX12/D3D12Context.h"
#include "Renderer/DirectX12/Scene/Scene.h"
#include "Renderer/DirectX12/Scene/SceneSerializer.h"
#include "Renderer/DirectX12/MACRO.h"
#include "Renderer/DirectX12/GeometryGenerator.h"
#include "Renderer/DirectX12/PipelineStateFactory.h"
#include "Renderer/DirectX12/Components/StaticMeshComponent.h"
#include "Renderer/DirectX12/Components/SkeletalMeshComponent.h"

#include "AssetPipeline/Importers/FbxImporter.h"

#include <filesystem>
#include <cassert>
#include <cmath>

using namespace Microsoft::WRL;
using namespace DirectX;

namespace
{
	struct RuntimeSceneObjects
	{
		SceneObject* Mirror = nullptr;
		SceneObject* Skull = nullptr;
		SceneObject* SkullShadow = nullptr;
		SceneObject* Waves = nullptr;
	};

	bool FindRuntimeSceneObjects(Scene& scene, RuntimeSceneObjects& result)
	{
		for (const auto& objectPtr : scene.GetObjects())
		{
			if (!objectPtr) continue;

			SceneObject* object = objectPtr.get();
			MeshComponent* mesh = object->GetComponent<MeshComponent>();
			if (!mesh) continue;

			for (const SubmeshSlot& slot : mesh->SubmeshSlots)
			{
				for (RenderPass pass : slot.Layers)
				{
					if (pass == RenderPass::MirrorStencil)
						result.Mirror = object;

					if (pass == RenderPass::Waves)
						result.Waves = object;

					if (slot.SubmeshName == "skull" && pass == RenderPass::Opaque)
						result.Skull = object;

					if (slot.SubmeshName == "skull" && pass == RenderPass::Shadow)
						result.SkullShadow = object;
				}
			}
		}

		if (!result.Mirror) return false;
		if (result.SkullShadow && !result.Skull) return false;

		return true;
	}
}

SceneRenderer::SceneRenderer(Scene& scene) : mScene(scene), mGizmo(scene)
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

	LoadBuiltInTextures(context);
	BuildMaterials(context);

	BuildDescriptorHeaps(context);
	BuildRootSignature(context);
	BuildShadersAndInputLayout();
	BuildGeometry(context);

	const std::filesystem::path modelDirectory = "Resource/Models";
	std::vector<std::filesystem::path> fbxPaths;
	for (const auto& entry : std::filesystem::directory_iterator(modelDirectory))
	{
		if (!entry.is_regular_file()) continue;

		std::filesystem::path path = entry.path();

		std::wstring extension = path.extension().wstring();
		std::transform(extension.begin(), extension.end(), extension.begin(), ::towlower);

		if (extension == L".fbx")
			fbxPaths.push_back(std::move(path));
	}

#ifdef BUILD_SCENE
	for (const auto& path : fbxPaths)
		AddFbxToScene(context, path);
	BuildScene();

#else
	for (const auto& path : fbxPaths)
		LoadFbxResource(context, path);
	LoadScene();

#endif

	RebuildRenderBatches();
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
	mGizmo.Pick(vx, vy);
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

SceneRenderStatistics SceneRenderer::GetStatistics() const noexcept
{
	SceneRenderStatistics result{};

	result.GpuTimestampValid = mGpuTimestampValid;
	result.RendererGpuMs = mFullGpuMs;
	result.ScenePassGpuMs = mSceneGpuMs;

	result.FrustumCullingEnabled = mFrustumCullingEnabled;
	result.BatchedInstanceCount = mInstanceCount;
	result.CullCandidateCount = mCullCandidateCount;
	result.VisibleInstanceCount = mVisibleInstanceCount;
	result.FrustumCulledInstanceCount = mFrustumCulledInstanceCount;

	return result;
}

void SceneRenderer::Update(const Scene& scene, float deltaTime)
{
	if (!mInitialized) return;

	mCamera.UpdateViewMatrix();

	mGizmo.Update(&mCamera, mViewportWidth, mViewportHeight);

	// 이 시점이면 이 FrameResource slot의 이전 GPU 작업은 완료됨.
	ReadbackTimestampData(mCurrFrameResourceIndex);

	AnimateMaterials();
	UpdateSkinnedBuffer();
	UpdateMainPassCB();
	UpdateReflectedPassCB();
	UpdateShadowTransform();
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

	TextureHandle h = TextureManager::GetInstance().FindHandle("treeArrayTex");
	UINT treeArrayTexIndex = TextureManager::GetInstance().Get(h)->Srv.Index;
	CD3DX12_GPU_DESCRIPTOR_HANDLE hTable(context.GetSrvUavHeap()->GetGPUDescriptorHandleForHeapStart());
	mCommandList->SetGraphicsRootDescriptorTable(2, hTable);
	hTable.Offset(treeArrayTexIndex, context.GetCbvSrvUavDescriptorSize());
	mCommandList->SetGraphicsRootDescriptorTable(7, hTable);

	auto instanceBufferAddress = mCurrFrameResource->InstanceBuffer->Resource()->GetGPUVirtualAddress();
	mCommandList->SetGraphicsRootShaderResourceView(4, instanceBufferAddress);

	auto matBuffer = mCurrFrameResource->MaterialBuffer->Resource();
	mCommandList->SetGraphicsRootShaderResourceView(3, matBuffer->GetGPUVirtualAddress());

	auto skinnedBuffer = mCurrFrameResource->SkinnedDataBuffer->Resource();
	mCommandList->SetGraphicsRootShaderResourceView(5, skinnedBuffer->GetGPUVirtualAddress());

	mCommandList->EndQuery(mTimestampQueryHeap.Get(), queryType, SceneStart);

	for (int layer = 0; layer < (int)RenderPass::Count; layer++)
	{
		RenderPass renderLayer = (RenderPass)layer;
		assert(mLayerPSOs[layer][(int)SceneRenderMode::Lit] && "모든 RenderLayer에는 Lit PSO가 필요합니다.");

		mCommandList->SetGraphicsRootConstantBufferView(0, passCB->GetGPUVirtualAddress());
		if (renderLayer == RenderPass::Reflected)
			mCommandList->SetGraphicsRootConstantBufferView(0, passCB->GetGPUVirtualAddress() + passCBByteSize);

		mCommandList->OMSetStencilRef(0);
		if(renderLayer == RenderPass::MirrorStencil || renderLayer == RenderPass::TessWall ||
			renderLayer == RenderPass::MirrorBaseFill || renderLayer == RenderPass::Reflected)
			mCommandList->OMSetStencilRef(1);

		ID3D12PipelineState* pso = ResolvePSO(renderLayer, mRenderSettings.Mode);
		mCommandList->SetPipelineState(pso);

		DrawLayer(mCommandList, (RenderPass)layer);

		if (mRenderSettings.Mode == SceneRenderMode::VertexNormal)
		{
			mCommandList->SetPipelineState(mGraphicsPSOs[(int)GraphicsPass::VertexNormalVisualize].Get());
			DrawLayer_VertexNormalDebug(mCommandList, (RenderPass)layer);
		}
	}

	// 깊이 복잡도 렌더링할 때는 외곽선 표시 X
	if (mRenderSettings.Mode != SceneRenderMode::DepthComplexity && !mScene.GetSelectedObjectIds().empty())
	{
		mCommandList->OMSetStencilRef(0x80);

		// 선택 원본 메시를 stencil에 기록
		mCommandList->SetPipelineState(mGraphicsPSOs[(int)GraphicsPass::SelectedMask].Get());
		DrawSelectedSceneObject(mCommandList);

		// stencil != 1 인 부분에만 부풀린 외곽선 출력
		mCommandList->SetPipelineState(mGraphicsPSOs[(int)GraphicsPass::SelectedOutline].Get());
		DrawSelectedSceneObject(mCommandList);
	}

	if (mRenderSettings.Mode == SceneRenderMode::DepthComplexity)
	{
		mCommandList->SetGraphicsRootSignature(mRootSignature_debug.Get());
		mCommandList->SetPipelineState(mGraphicsPSOs[(int)GraphicsPass::DepthComplexityVisualize].Get());
		DrawDebugColorTriangle(mCommandList);
	}

	mCommandList->EndQuery(mTimestampQueryHeap.Get(), queryType, SceneEnd);

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
			mComputePSOs[(int)ComputePass::SobelExecute].Get(),
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
	const bool fullValid = fullEnd > fullStart;
	const bool sceneValid = sceneEnd > sceneStart;

	if (fullValid)
	{
		mFullGpuMs = double(fullEnd - fullStart) * 1000.0 /
			double(mGpuTimestampFrequency);
	}

	if (sceneValid)
	{
		mSceneGpuMs = double(sceneEnd - sceneStart) * 1000.0 / 
			double(mGpuTimestampFrequency);
	}

	mGpuTimestampValid = fullValid && sceneValid;
}

void SceneRenderer::LoadBuiltInTextures(D3D12Context& context)
{
	double start = mTimer.TotalTime();

	std::vector<TextureManager::TextureFileRequest> requests =
	{
		{ "defaultTex",      L"Resource/Textures/White1x1.dds" },
		{ "woodCrateTex",    L"Resource/Textures/MipmapTest.dds" },
		{ "bricksTex0",      L"Resource/Textures/Bricks.dds" },
		{ "bricksTex1",      L"Resource/Textures/Bricks2.dds" },
		{ "stoneTex",        L"Resource/Textures/Stone.dds" },
		{ "tileTex",         L"Resource/Textures/Tile.dds" },
		{ "grassTex",        L"Resource/Textures/Grass.dds" },
		{ "waterTex",        L"Resource/Textures/Water1.dds" },
		{ "swirlingTex",     L"Resource/Textures/Swirling.dds" },
		{ "swirlingMaskTex", L"Resource/Textures/Swirling_Mask.dds" },
		{ "fenceTex",        L"Resource/Textures/WireFence.dds" },
		{ "checkboardTex",   L"Resource/Textures/Checkboard.dds" },
		{ "iceTex",          L"Resource/Textures/Ice.dds" },
		{ "helpTex",         L"Resource/Textures/Help.dds" },
		{ "treeArrayTex",    L"Resource/Textures/Treearray2.dds" },
	};

	std::vector<TextureHandle> handles;
	//묶음 로딩 : 텍스처 15개 기준 3ms 단축.
	ThrowIfFailed(TextureManager::GetInstance().LoadFromFile(requests, handles));

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
	UINT index = 0;

	auto defaultMat = std::make_unique<Material>();
	defaultMat->Name = "defaultMat";
	defaultMat->MatBufferIndex = index++;
	defaultMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("defaultTex");
	defaultMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	defaultMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	defaultMat->Roughness = 0.3f;

	auto tileMat = std::make_unique<Material>();
	tileMat->Name = "tile0";
	tileMat->MatBufferIndex = index++;
	tileMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("tileTex");
	tileMat->DiffuseAlbedo = XMFLOAT4(Colors::LightGray);
	tileMat->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	tileMat->Roughness = 0.2f;

	auto bricksMat0 = std::make_unique<Material>();
	bricksMat0->Name = "bricks0";
	bricksMat0->MatBufferIndex = index++;
	bricksMat0->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("bricksTex0");
	bricksMat0->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	bricksMat0->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	bricksMat0->Roughness = 0.1f;

	auto stoneMat = std::make_unique<Material>();
	stoneMat->Name = "stone0";
	stoneMat->MatBufferIndex = index++;
	stoneMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("stoneTex");
	stoneMat->DiffuseAlbedo = XMFLOAT4(Colors::LightSteelBlue);
	stoneMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	stoneMat->Roughness = 0.3f;

	auto grassMat = std::make_unique<Material>();
	grassMat->Name = "grass0";
	grassMat->MatBufferIndex = index++;
	grassMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("grassTex");
	grassMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	grassMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	grassMat->Roughness = 0.125f;

	auto waterMat = std::make_unique<Material>();
	waterMat->Name = "water0";
	waterMat->MatBufferIndex = index++;
	waterMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("waterTex");
	waterMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.5f);
	waterMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	waterMat->Roughness = 0.0f;

	auto woodCrateMat = std::make_unique<Material>();
	woodCrateMat->Name = "woodCrate";
	woodCrateMat->MatBufferIndex = index++;
	woodCrateMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("woodCrateTex");
	woodCrateMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	woodCrateMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	woodCrateMat->Roughness = 0.0f;

	auto swirlingMat = std::make_unique<Material>();
	swirlingMat->Name = "swirling";
	swirlingMat->MatBufferIndex = index++;
	swirlingMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("swirlingTex");
	swirlingMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMat->Roughness = 0.0f;

	auto swirlingMaskMat = std::make_unique<Material>();
	swirlingMaskMat->Name = "swirlingMask";
	swirlingMaskMat->MatBufferIndex = index++;
	swirlingMaskMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("swirlingMaskTex");
	swirlingMaskMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMaskMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMaskMat->Roughness = 0.0f;

	auto wireFence = std::make_unique<Material>();
	wireFence->Name = "wireFence";
	wireFence->MatBufferIndex = index++;
	wireFence->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("fenceTex");
	wireFence->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	wireFence->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	wireFence->Roughness = 0.25f;

	auto bricksMat1 = std::make_unique<Material>();
	bricksMat1->Name = "bricks1";
	bricksMat1->MatBufferIndex = index++;
	bricksMat1->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("bricksTex1");
	bricksMat1->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	bricksMat1->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	bricksMat1->Roughness = 0.25f;

	auto checkerTileMat = std::make_unique<Material>();
	checkerTileMat->Name = "checkerTileMat";
	checkerTileMat->MatBufferIndex = index++;
	checkerTileMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("checkboardTex");
	checkerTileMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	checkerTileMat->FresnelR0 = XMFLOAT3(0.07f, 0.07f, 0.07f);
	checkerTileMat->Roughness = 0.3f;

	auto iceMirrorMat = std::make_unique<Material>();
	iceMirrorMat->Name = "iceMirrorMat";
	iceMirrorMat->MatBufferIndex = index++;
	iceMirrorMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("iceTex");
	iceMirrorMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.3f);
	iceMirrorMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	iceMirrorMat->Roughness = 0.5f;

	auto shadowMat_skull = std::make_unique<Material>();
	shadowMat_skull->Name = "shadowMat_skull";
	shadowMat_skull->MatBufferIndex = index++;
	shadowMat_skull->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("defaultTex");
	shadowMat_skull->DiffuseAlbedo = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.5f);
	shadowMat_skull->FresnelR0 = XMFLOAT3(0.001f, 0.001f, 0.001f);
	shadowMat_skull->Roughness = 0.0f;

	auto treeBillboardMat = std::make_unique<Material>();
	treeBillboardMat->Name = "treeBillboardMat";
	treeBillboardMat->MatBufferIndex = index++;
	treeBillboardMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("treeArrayTex");
	treeBillboardMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	treeBillboardMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	treeBillboardMat->Roughness = 0.125f;

	auto mirrorBaseMat = std::make_unique<Material>();
	mirrorBaseMat->Name = "mirrorBaseMat";
	mirrorBaseMat->MatBufferIndex = index++;
	mirrorBaseMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("defaultTex");
	mirrorBaseMat->DiffuseAlbedo = mMainPassCB.gFogColor;
	mirrorBaseMat->FresnelR0 = XMFLOAT3(0.0f, 0.0f, 0.0f);
	mirrorBaseMat->Roughness = 1.0f;

	auto highlightMat = std::make_unique<Material>();
	highlightMat->Name = "highlightMat";
	highlightMat->MatBufferIndex = index++;
	highlightMat->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("defaultTex");
	highlightMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 0.0f, 0.6f);
	highlightMat->FresnelR0 = XMFLOAT3(0.06f, 0.06f, 0.06f);
	highlightMat->Roughness = 0.0f;

	auto gizmoX = std::make_unique<Material>();
	gizmoX->Name = "gizmoX";
	gizmoX->MatBufferIndex = index++;
	gizmoX->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("defaultTex");
	gizmoX->DiffuseAlbedo = XMFLOAT4(1.0f, 0.05f, 0.05f, 0.5f);
	gizmoX->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	gizmoX->Roughness = 0.4f;

	auto gizmoY = std::make_unique<Material>();
	gizmoY->Name = "gizmoY";
	gizmoY->MatBufferIndex = index++;
	gizmoY->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("defaultTex");
	gizmoY->DiffuseAlbedo = XMFLOAT4(0.05f, 1.0f, 0.05f, 0.5f);
	gizmoY->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	gizmoY->Roughness = 0.4f;

	auto gizmoZ = std::make_unique<Material>();
	gizmoZ->Name = "gizmoZ";
	gizmoZ->MatBufferIndex = index++;
	gizmoZ->DiffuseTextureHandle = TextureManager::GetInstance().FindHandle("defaultTex");
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
	slotRootParameter[2].InitAsDescriptorTable(1, &diffuseMapTable, D3D12_SHADER_VISIBILITY_PIXEL);	// (t0) textures
	slotRootParameter[3].InitAsShaderResourceView(0, 1);							// (t0, space1) materials + tex index
	slotRootParameter[4].InitAsShaderResourceView(1, 1);							// (t1, space1) instances + mat index
	slotRootParameter[5].InitAsShaderResourceView(2, 1);							// (t2, space1) skinned CB
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

void SceneRenderer::LoadScene()
{
	Scene loadedScene;

	if (!SceneSerializer::Load(loadedScene, L"Resource/Scenes/Main.d12scene"))
		throw DxException(E_FAIL, L"Scene file load failed.", AnsiToWide(__FILE__), __LINE__);

	if (!ResolveSceneResources(loadedScene))
		throw DxException(E_FAIL, L"Scene resource resolution failed.", AnsiToWide(__FILE__), __LINE__);

	mScene.Swap(loadedScene);
	BuildSceneRuntimeObjects();
}

bool SceneRenderer::ResolveSceneResources(Scene& scene)
{
	for (const auto& objectPtr : scene.GetObjects())
	{
		if (!objectPtr) continue;

		SceneObject& object = *objectPtr;
		MeshComponent* mesh = object.GetComponent<MeshComponent>();
		if (!mesh) continue;

		const auto geometryIt = mGeometries.find(mesh->GeometryName);
		if (geometryIt == mGeometries.end())
			return false;

		mesh->Geometry = geometryIt->second.get();

		if (mesh->SubmeshSlots.empty())
			return false;

		for (SubmeshSlot& slot : mesh->SubmeshSlots)
		{
			const auto submeshIt = mesh->Geometry->Submeshes.find(slot.SubmeshName);
			if (submeshIt == mesh->Geometry->Submeshes.end())
				return false;

			if (slot.Layers.empty())
				return false;

			for (RenderPass pass : slot.Layers)
			{
				const int passIndex = static_cast<int>(pass);
				if (passIndex < 0 || passIndex >= static_cast<int>(RenderPass::Count))
					return false;
			}

			const auto materialIt = mMaterials.find(slot.MaterialName);
			if (materialIt == mMaterials.end())
				return false;

			Material* material = materialIt->second.get();
			material->MatTransform = slot.MatTransform;
			material->NumFramesDirty = GlobalConfig::NumFrameResources;

			slot.Submesh = &submeshIt->second;
			slot.MaterialData = materialIt->second.get();
		}

		SkeletalMeshComponent* skeletalMesh = object.GetComponent<SkeletalMeshComponent>();
		if (!skeletalMesh) continue;

		const auto assetIt = mSkeletalMesheAssets.find(skeletalMesh->SkeletalAssetName);
		if (assetIt == mSkeletalMesheAssets.end())
			return false;

		SkeletalMeshAsset& asset = assetIt->second;

		if (asset.Animations.empty())
			return false;

		const UINT submeshCount = asset.GetSubmeshCount();
		if (skeletalMesh->SubmeshSlots.size() != submeshCount)
			return false;

		skeletalMesh->Asset = &asset;
		skeletalMesh->SkinnedBufferIndices.assign(submeshCount, UINT_MAX);
		skeletalMesh->mSkinnedModelInstance = std::make_unique<SkinnedModelInstance>();

		const std::string clipName = SelectDefaultAnimation(asset);
		skeletalMesh->mSkinnedModelInstance->Initialize(asset, clipName);
	}
	return true;
}

void SceneRenderer::BuildSceneRuntimeObjects()
{
	if (!BindSpecialSceneObjects())
		throw DxException(E_FAIL, L"Required runtime scene objects were not found.", AnsiToWide(__FILE__), __LINE__);

	BuildSceneObject_InMirror();
	BuildSceneObject_Gizmo();
	RebuildRenderBatches();
}

void SceneRenderer::RebuildSceneRuntime(D3D12Context& context)
{
	mScene.ClearSelection();

	BuildSceneRuntimeObjects();

	mFrameResources.clear();
	mCurrFrameResource = nullptr;
	mCurrFrameResourceIndex = 0;

	BuildFrameResources(context);
}

bool SceneRenderer::BindSpecialSceneObjects()
{
	mMirror = nullptr;
	mSkull = nullptr;
	mSkullMirror = nullptr;
	mSkullShadow = nullptr;
	mSkullShadowMirror = nullptr;
	mWavesRenderItem = nullptr;

	RuntimeSceneObjects objects;
	if (!FindRuntimeSceneObjects(mScene, objects))
		return false;

	mMirror = objects.Mirror;
	mSkull = objects.Skull;
	mSkullShadow = objects.SkullShadow;
	mWavesRenderItem = objects.Waves;

	return true;
}


void SceneRenderer::BuildGeometry(D3D12Context& context)
{
	BuildShapeGeometry(context);
	BuildLandGeometry(context);
	BuildWavesGeometry(context);
	BuildTreeBillboardGeometry(context);
	BuildCylinderWithoutTopGeometry(context);
	BuildBrickWallGeometry(context);
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

	geo->Submeshes["box"] = boxSubmesh;
	geo->Submeshes["grid"] = gridSubmesh;
	geo->Submeshes["sphere"] = sphereSubmesh;
	geo->Submeshes["geoSphere"] = geoSphereSubmesh;
	geo->Submeshes["cylinder"] = cylinderSubmesh;
	geo->Submeshes["skull"] = skullSubmesh;

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

	//테셀레이션 제어점 패치 용도.
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

	geo->Submeshes["grid"] = sm;
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

	geo->Submeshes["grid"] = sm;

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

	geo->Submeshes["tree"] = sm;
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

	geo->Submeshes["cylinderWithoutTop"] = cylinderSubmesh;
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

	geo->Submeshes["brickWall"] = sm;

	mGeometries[geo->Name] = std::move(geo);
}

std::string SceneRenderer::BuildFBXGeometry(D3D12Context& context, const std::filesystem::path& path)
{
	SkeletalMeshAsset skelMesh = FbxImporter::ImportSkeletalMesh(path);

	//단순 가중치 검증
	for (const SkeletalMeshPart& meshPart : skelMesh.MeshParts)
	{
		const std::size_t paletteSize = meshPart.Skin.PaletteToSkeletonJoint.size();

		for (const SkinnedVertex& vertex : meshPart.Vertices)
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

	for (auto& part : skelMesh.MeshParts)
	{
		vertices.insert(vertices.end(), part.Vertices.begin(), part.Vertices.end());
		indices.insert(indices.end(), part.Indices.begin(), part.Indices.end());
	}

	const UINT vbByteSize = static_cast<UINT>(vertices.size() * sizeof(SkinnedVertex));
	const UINT ibByteSize = static_cast<UINT>(indices.size() * sizeof(std::uint32_t));

	const std::string geoName = path.stem().string();
	auto geometry = std::make_unique<MeshGeometry>();
	geometry->Name = geoName;
	Logger::Info("FBX Geometry Name : " + geometry->Name);

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
	UINT partStartIndexLocation = 0;
	for (int partIndex = 0; partIndex < skelMesh.MeshParts.size(); partIndex++)
	{
		const SkeletalMeshPart& part = skelMesh.MeshParts[partIndex];
		for (int submeshIndex = 0; submeshIndex < part.Submeshes.size(); submeshIndex++)
		{
			const SkeletalSubmesh& source = part.Submeshes[submeshIndex];
			SubmeshGeometry submesh{};

			submesh.IndexCount = source.IndexCount;
			submesh.StartIndexLocation = partStartIndexLocation + source.StartIndexLocation;
			submesh.BaseVertexLocation = baseVertexLocation;
			submesh.VertexCount = static_cast<UINT>(part.Vertices.size());

			if (!part.Vertices.empty())
			{
				BoundingBox::CreateFromPoints(
					submesh.Bounds,
					part.Vertices.size(),
					&part.Vertices.front().Position,
					sizeof(SkinnedVertex));
			}

			const std::string submeshKey = geometry->MakeSubmeshKey(partIndex, submeshIndex);
			geometry->Submeshes[submeshKey] = submesh;
		}

		baseVertexLocation += static_cast<int>(part.Vertices.size());
		partStartIndexLocation += static_cast<UINT>(part.Indices.size());
	}

	mGeometries[geoName] = std::move(geometry);
	mSkeletalMesheAssets[geoName] = std::move(skelMesh);

	return geoName;
}

SceneObject* SceneRenderer::CreateStaticMeshObject(
	const wchar_t* objName,
	const char* GeoName,
	const char* subMeshName,
	const char* matName,
	D3D12_PRIMITIVE_TOPOLOGY topology,
	const TransformComponent& transform,
	std::vector<RenderPass> layer,
	bool InMirror,
	DirectX::XMMATRIX matTransform)
{
	auto* geometry = mGeometries.at(GeoName).get();
	SceneObject& obj = mScene.CreateObject(objName);
	obj.Transform = transform;

	auto& component = obj.AddComponent<StaticMeshComponent>();
	component.GeometryName = GeoName;
	component.Geometry = geometry;
	component.Topology = topology;
	component.InMirror = InMirror;

	Material* material = mMaterials.at(matName).get();
	XMStoreFloat4x4(&material->MatTransform, matTransform);
	SubmeshGeometry& sm = component.Geometry->Submeshes[subMeshName];

	SubmeshSlot smSlot{};
	smSlot.SubmeshName = subMeshName;
	smSlot.MaterialName = matName;
	smSlot.MatTransform = material->MatTransform;
	smSlot.Submesh = &sm;
	smSlot.MaterialData = material;
	smSlot.Layers = layer;
	component.SubmeshSlots.push_back(smSlot);

	mRenderBatchesDirty = true;

	return &obj;
}

SceneObject* SceneRenderer::CreateSkeletalMeshObject(const wchar_t* objName, const char* GeoName, const SkeletalMeshAsset& asset, const TransformComponent& transform)
{
	auto* geometry = mGeometries.at(GeoName).get();
	SceneObject& object = mScene.CreateObject(objName);
	object.Transform = transform;

	UINT submeshCount = asset.GetSubmeshCount();

	auto& component = object.AddComponent<SkeletalMeshComponent>();
	component.GeometryName = GeoName;
	component.SkeletalAssetName = GeoName;
	component.Asset = &asset;
	component.Geometry = geometry;
	component.Topology = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	component.SubmeshSlots.reserve(submeshCount);
	component.SkinnedBufferIndices.resize(submeshCount, UINT_MAX);
	component.mSkinnedModelInstance = std::make_unique<SkinnedModelInstance>();

	SkeletalMeshAsset& storedAsset = mSkeletalMesheAssets.at(GeoName);
	if (!storedAsset.Animations.empty())
	{
		for (const auto& [name, clip] : storedAsset.Animations)
			Logger::Info(L"Animation Clip: " + AnsiToWide(name) + L"\n");

		//믹사모 모델 사용으로 인한 임시 구현.
		const std::string clipName = SelectDefaultAnimation(asset);
		component.mSkinnedModelInstance->Initialize(storedAsset, clipName);
	}
	
	int partIndex = 0;
	for (const auto& part : asset.MeshParts)
	{
		for (int i = 0; i < part.Submeshes.size(); i++)
		{
			const SkeletalSubmesh source = part.Submeshes[i];
			std::string key = geometry->MakeSubmeshKey(partIndex, i);
			auto geometryIt = geometry->Submeshes.find(key);
			if (geometryIt == geometry->Submeshes.end())
			{
				std::wstring wfn = AnsiToWide(__FILE__);
				throw DxException(1, L"Skeletal submesh geometry not found: ", wfn, __LINE__);
			}

			const ImportedMaterialIndex materialIndex = source.MaterialIndex;

			Material* material = mMaterials.at("defaultMat").get();
			if (materialIndex != InvalidMaterialIndex)
				material = mMaterials.at(asset.MaterialNames[materialIndex]).get();

			SubmeshSlot slot{};
			slot.SubmeshName = key;
			slot.MaterialName = material->Name;
			slot.MatTransform = material->MatTransform;
			slot.Submesh = &geometryIt->second;
			slot.MaterialData = material;
			slot.Layers = { RenderPass::SkinnedOpaque };

			component.SubmeshSlots.push_back(slot);
		}
		partIndex++;
	}

	mRenderBatchesDirty = true;

	return &object;
}

std::string SceneRenderer::SelectDefaultAnimation(const SkeletalMeshAsset& asset)
{
	if (asset.Animations.count("mixamo.com"))
		return "mixamo.com";

	if (asset.Animations.empty())
		return {};

	return asset.Animations.begin()->first;
}

void SceneRenderer::BuildFrameResources(D3D12Context& context)
{
	UINT skinnedCBCount = 0u;

	for (auto& object : mScene.GetObjects())
	{
		auto* skinnedMesh = object->GetComponent<SkeletalMeshComponent>();
		if (!skinnedMesh) continue;

		const auto& palettes = skinnedMesh->mSkinnedModelInstance->SubmeshFinalTransforms;
		for (const auto& palette : palettes)
		{
			skinnedCBCount += static_cast<UINT>(palette.size());
		}
	}
	skinnedCBCount = std::max(1u, skinnedCBCount);

	mFrameResources.clear();
	for (int i = 0; i < GlobalConfig::NumFrameResources; i++)
	{
		mFrameResources.push_back(
			std::make_unique<FrameResource>(
				context.GetDevice(),
				2,
				(UINT)std::max(1u, mInstanceCount),
				(UINT)mWaves->VertexCount(),
				(UINT)mMaterials.size(),
				skinnedCBCount));
	}

	// 새 MaterialBuffer가 생성되었으므로 모든 Material을 다시 업로드해야 한다.
	for (auto& [name, material] : mMaterials)
	{
		if (material)
			material->NumFramesDirty = GlobalConfig::NumFrameResources;
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
		mLayerPSOs[(int)RenderPass::Opaque][(int)SceneRenderMode::Lit] =
			factory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
		mLayerPSOs[(int)RenderPass::Transparent][(int)SceneRenderMode::Lit] =
			factory.CreateTransparentPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
		mLayerPSOs[(int)RenderPass::Waves][(int)SceneRenderMode::Lit] =
			factory.CreateTransparentPSO(mShaders["wavesVS"].Get(), mShaders["opaquePS"].Get());
		mLayerPSOs[(int)RenderPass::MultiTextureBlend][(int)SceneRenderMode::Lit] =
			factory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["multiTextureBlendPS"].Get());

		PsoBuildContext alphaTestCtx = ctx;
		alphaTestCtx.CullMode = D3D12_CULL_MODE_NONE;
		PipelineStateFactory alphaTestFactory(alphaTestCtx);
		mLayerPSOs[(int)RenderPass::AlphaTestOpaque][(int)SceneRenderMode::Lit] =
			alphaTestFactory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["alphaTestPS"].Get());
	}

	{
		PsoBuildContext opaqueWireframeCtx = ctx;
		opaqueWireframeCtx.IsWireframe = true;
		PipelineStateFactory factory(opaqueWireframeCtx);
		mLayerPSOs[(int)RenderPass::Opaque][(int)SceneRenderMode::Wireframe] =
			factory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
		mLayerPSOs[(int)RenderPass::Waves][(int)SceneRenderMode::Wireframe] =
			factory.CreateOpaquePSO(mShaders["wavesVS"].Get(), mShaders["opaquePS"].Get());
	}

	{
		PsoBuildContext depthCtx = ctx;
		PipelineStateFactory depthFactory(depthCtx);
		mLayerPSOs[(int)RenderPass::Opaque][(int)SceneRenderMode::DepthComplexity] =
			depthFactory.CreateDepthCountPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
	}

	{
		PsoBuildContext mirrorCtx = ctx;
		PipelineStateFactory mirrorFactory(mirrorCtx);
		mLayerPSOs[(int)RenderPass::MirrorStencil][(int)SceneRenderMode::Lit] =
			mirrorFactory.CreateMirrorStencilPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());

		PsoBuildContext mirrorCtx2 = ctx;
		mirrorCtx2.Clockwise = true;
		mirrorCtx2.CullMode = D3D12_CULL_MODE_NONE;
		PipelineStateFactory mirrorFactory2(mirrorCtx2);
		mLayerPSOs[(int)RenderPass::Reflected][(int)SceneRenderMode::Lit] =
			mirrorFactory2.CreateMirrorReflectedPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());

		PsoBuildContext mirrorCtx3 = ctx;
		PipelineStateFactory mirrorFactory3(mirrorCtx3);
		mLayerPSOs[(int)RenderPass::MirrorBaseFill][(int)SceneRenderMode::Lit] =
			mirrorFactory3.CreateMirrorBaseFillPSO(mShaders["standardVS"].Get(), mShaders["mirrorBaseFillPS"].Get());
	}


	{
		PsoBuildContext shadowCtx = ctx;
		PipelineStateFactory shadowFactory(shadowCtx);
		mLayerPSOs[(int)RenderPass::Shadow][(int)SceneRenderMode::Lit] = 
			shadowFactory.CreateShadowPSO(mShaders["standardVS"].Get(), mShaders["alphaTestPS"].Get());
	}

	{
		PsoBuildContext treeCtx = ctx;
		treeCtx.InputLayout = &mTreeBillboardInputLayout;
		treeCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_POINT;
		PipelineStateFactory treeFactory(treeCtx);
		mLayerPSOs[(int)RenderPass::A2C_TreeBillboard][(int)SceneRenderMode::Lit] =
			treeFactory.CreateTreeBillboardPSO(mShaders["treeBillboardVS"].Get(), mShaders["treeBillboardGS"].Get(), mShaders["treeBillboardPS"].Get(), true);
		mLayerPSOs[(int)RenderPass::A2C_TreeBillboard][(int)SceneRenderMode::DepthComplexity] =
			treeFactory.CreateDepthCountPSO(mShaders["treeBillboardVS"].Get(), mShaders["treeBillboardGS"].Get(), mShaders["treeBillboardPS"].Get());

		PsoBuildContext treeCtx2 = treeCtx;
		treeCtx2.IsWireframe = true;
		PipelineStateFactory treeFactory2(treeCtx2);
		mLayerPSOs[(int)RenderPass::A2C_TreeBillboard][(int)SceneRenderMode::Wireframe] =
			treeFactory2.CreateTreeBillboardPSO(mShaders["treeBillboardVS"].Get(), mShaders["treeBillboardGS"].Get(), mShaders["treeBillboardPS_Wireframe"].Get(), true);
	}

	{
		PsoBuildContext exCylCtx = ctx;
		exCylCtx.InputLayout = &mInputLayout;
		exCylCtx.CullMode = D3D12_CULL_MODE_NONE;
		exCylCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_LINE;
		PipelineStateFactory exCylFactory(exCylCtx);
		mLayerPSOs[(int)RenderPass::LineToCylinder][(int)SceneRenderMode::Lit] =
			exCylFactory.CreateLineToCylinderPSO(mShaders["lineToCylinderVS"].Get(), mShaders["lineToCylinderGS"].Get(), mShaders["lineToCylinderPS"].Get());
		mLayerPSOs[(int)RenderPass::LineToCylinder][(int)SceneRenderMode::DepthComplexity] =
			exCylFactory.CreateDepthCountPSO(mShaders["lineToCylinderVS"].Get(), mShaders["lineToCylinderGS"].Get(), mShaders["lineToCylinderPS"].Get());

		PsoBuildContext exCylCtx2 = exCylCtx;
		exCylCtx2.IsWireframe = true;
		PipelineStateFactory exCylFactory2(exCylCtx2);
		mLayerPSOs[(int)RenderPass::LineToCylinder][(int)SceneRenderMode::Wireframe] =
			exCylFactory2.CreateLineToCylinderPSO(mShaders["lineToCylinderVS"].Get(), mShaders["lineToCylinderGS"].Get(), mShaders["lineToCylinderPS"].Get());
	}

	{
		PsoBuildContext explodeCtx = ctx;
		explodeCtx.CullMode = D3D12_CULL_MODE_NONE;
		PipelineStateFactory explodeFactory(explodeCtx);
		mLayerPSOs[(int)RenderPass::GeoExplode][(int)SceneRenderMode::Lit] =
			explodeFactory.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["explodeGS"].Get(), mShaders["lineToCylinderPS"].Get());
		mLayerPSOs[(int)RenderPass::GeoExplode][(int)SceneRenderMode::DepthComplexity] =
			explodeFactory.CreateDepthCountPSO(mShaders["lineToCylinderVS"].Get(), mShaders["explodeGS"].Get(), mShaders["lineToCylinderPS"].Get());

		PsoBuildContext explodeCtx2 = explodeCtx;
		explodeCtx2.IsWireframe = true;
		PipelineStateFactory explodeFactory2(explodeCtx2);
		mLayerPSOs[(int)RenderPass::GeoExplode][(int)SceneRenderMode::Wireframe] =
			explodeFactory2.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["explodeGS"].Get(), mShaders["lineToCylinderPS"].Get());
	}

	{
		PsoBuildContext lodCtx = ctx;
		PipelineStateFactory lodFactory(lodCtx);
		mLayerPSOs[(int)RenderPass::GeoSphereLOD][(int)SceneRenderMode::Lit] =
			lodFactory.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["LOD_GS"].Get(), mShaders["lineToCylinderPS"].Get());
		mLayerPSOs[(int)RenderPass::GeoSphereLOD][(int)SceneRenderMode::DepthComplexity] =
			lodFactory.CreateDepthCountPSO(mShaders["lineToCylinderVS"].Get(), mShaders["LOD_GS"].Get(), mShaders["lineToCylinderPS"].Get());
	
		PsoBuildContext lodCtx2 = lodCtx;
		lodCtx2.IsWireframe = true;
		PipelineStateFactory lodFactory2(lodCtx2);
		mLayerPSOs[(int)RenderPass::GeoSphereLOD][(int)SceneRenderMode::Wireframe] =
			lodFactory2.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["LOD_GS"].Get(), mShaders["lineToCylinderPS"].Get());
	}
	
	{
		PsoBuildContext tessCtx = ctx;
		tessCtx.CullMode = D3D12_CULL_MODE_NONE;
		tessCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_PATCH;
		PipelineStateFactory tessFactory(tessCtx);
		mLayerPSOs[(int)RenderPass::TessLand][(int)SceneRenderMode::Lit] =
			tessFactory.CreateTessellationPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS"].Get(), mShaders["tessPS"].Get());
		mLayerPSOs[(int)RenderPass::TessLand][(int)SceneRenderMode::DepthComplexity] =
			tessFactory.CreateDepthCountPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS"].Get(), mShaders["tessPS"].Get());
		mLayerPSOs[(int)RenderPass::TessWall][(int)SceneRenderMode::Lit] =
			tessFactory.CreateTessellateMirrorWallPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS_Wall"].Get(), mShaders["tessPS"].Get());
		mLayerPSOs[(int)RenderPass::TessWall][(int)SceneRenderMode::DepthComplexity] =
			tessFactory.CreateDepthCountPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS_Wall"].Get(), mShaders["tessPS"].Get());

		PsoBuildContext tessCtx2 = tessCtx;
		tessCtx2.IsWireframe = true;
		PipelineStateFactory tessFactory2(tessCtx2);
		mLayerPSOs[(int)RenderPass::TessLand][(int)SceneRenderMode::Wireframe] =
			tessFactory2.CreateTessellationPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS"].Get(), mShaders["tessPS"].Get());
		mLayerPSOs[(int)RenderPass::TessWall][(int)SceneRenderMode::Wireframe] =
			tessFactory2.CreateTessellateMirrorWallPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS_Wall"].Get(), mShaders["tessPS"].Get());
	}

	{
		PsoBuildContext gizmoCtx = ctx;
		PipelineStateFactory gizmoFactory(gizmoCtx);
		mLayerPSOs[(int)RenderPass::Gizmo][(int)SceneRenderMode::Lit] =
			gizmoFactory.CreateGizmoPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
	}

	{
		PsoBuildContext skinnedCtx = ctx;
		skinnedCtx.InputLayout = &mSkinnedInputLayout;
		skinnedCtx.CullMode = D3D12_CULL_MODE_NONE;
		PipelineStateFactory skinnedFactory(skinnedCtx);
		mLayerPSOs[(int)RenderPass::SkinnedOpaque][(int)SceneRenderMode::Lit] =
			skinnedFactory.CreateOpaquePSO(mShaders["skinnedVS"].Get(), mShaders["opaquePS"].Get());

		PsoBuildContext skinnedCtx2 = skinnedCtx;
		skinnedCtx2.IsWireframe = true;
		PipelineStateFactory skinnedFactory2(skinnedCtx2);
		mLayerPSOs[(int)RenderPass::SkinnedOpaque][(int)SceneRenderMode::Wireframe] =
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
		mComputePSOs[(int)ComputePass::SobelExecute] = sobelFactory.CreateComputePSO(mShaders["sobelCS"].Get());
		mComputePSOs[(int)ComputePass::SobelComposite] = sobelFactory.CreateComputePSO(mShaders["sobelCompositeCS"].Get());
	}
}

void SceneRenderer::BuildImportedTextures()
{
	TextureManager& textureManager = TextureManager::GetInstance();

	for (auto& [assetName, asset] : mSkeletalMesheAssets)
	{
		// ImportedTextureIndex와 동일한 인덱스 구조를 유지한다.
		asset.TextureHandles.assign(asset.Textures.size(), InvalidTextureHandle);

		std::vector<TextureManager::TextureFileRequest> fileRequests;
		std::vector<std::size_t> fileTextureIndices;
		std::vector<TextureManager::TextureMemoryRequest> memoryRequests;
		std::vector<std::size_t> memoryTextureIndices;

		fileRequests.reserve(asset.Textures.size());
		fileTextureIndices.reserve(asset.Textures.size());
		memoryRequests.reserve(asset.Textures.size());
		memoryTextureIndices.reserve(asset.Textures.size());

		for (int textureIndex = 0; textureIndex < asset.Textures.size(); textureIndex++)
		{
			const ImportedTexture& importedTexture = asset.Textures[textureIndex];
			
			const std::string textureKey = assetName + "::Texture_" + std::to_string(textureIndex);

			TextureLoadDesc loadDesc{};
			loadDesc.ColorSpace = TextureColorSpace::SRGB;
			loadDesc.Lifetime = TextureLifetime::Scene;
			loadDesc.GenerateMips = false;

			switch (importedTexture.Source)
			{
			case ImportedTextureSource::ExternalFile:
			{
				if (importedTexture.FilePath.empty())
				{
					throw DxException(
						E_FAIL,
						L"Imported external texture has no file path.",
						AnsiToWide(__FILE__),
						__LINE__);
				}

				TextureManager::TextureFileRequest request{};
				request.Key = textureKey;
				request.FilePath = importedTexture.FilePath;
				request.Desc = loadDesc;

				fileRequests.push_back(std::move(request));
				fileTextureIndices.push_back(textureIndex);

				break;
			}

			case ImportedTextureSource::Embedded:
			{
				if (importedTexture.EncodedData.empty())
				{
					throw DxException(
						E_FAIL,
						L"Imported embedded texture has no encoded data.",
						AnsiToWide(__FILE__),
						__LINE__);
				}

				TextureManager::TextureMemoryRequest request{};
				request.Key = textureKey;
				request.Data = importedTexture.EncodedData.data();
				request.Size = importedTexture.EncodedData.size();
				request.Desc = loadDesc;

				memoryRequests.push_back(std::move(request));
				memoryTextureIndices.push_back(textureIndex);

				break;
			}

			case ImportedTextureSource::NotTextureFile:
				// Shader/Layer wrapper이므로 GPU 텍스처를 생성하지 않는다.
				break;
			}
		}

		if (!fileRequests.empty())
		{
			std::vector<TextureHandle> loadedHandles;

			ThrowIfFailed(textureManager.LoadFromFile(fileRequests, loadedHandles));

			if (loadedHandles.size() != fileTextureIndices.size())
			{
				throw DxException(
					E_FAIL,
					L"Loaded file texture count does not match the request count.",
					AnsiToWide(__FILE__),
					__LINE__);
			}

			for (int i = 0; i < loadedHandles.size(); i++)
			{
				asset.TextureHandles[fileTextureIndices[i]] = loadedHandles[i];
			}
		}

		if (!memoryRequests.empty())
		{
			std::vector<TextureHandle> loadedHandles;

			ThrowIfFailed(textureManager.LoadFromMemory(memoryRequests, loadedHandles));

			if (loadedHandles.size() != memoryTextureIndices.size())
			{
				throw DxException(
					E_FAIL,
					L"Loaded memory texture count does not match the request count.",
					AnsiToWide(__FILE__),
					__LINE__);
			}

			for (int i = 0; i < loadedHandles.size(); i++)
			{
				asset.TextureHandles[memoryTextureIndices[i]] = loadedHandles[i];
			}
		}
	}
}

void SceneRenderer::BuildImportedTextures(const std::string& assetName, SkeletalMeshAsset& asset)
{
	TextureManager& textureManager = TextureManager::GetInstance();

	// ImportedTextureIndex와 동일한 인덱스 구조를 유지한다.
	asset.TextureHandles.assign(asset.Textures.size(), InvalidTextureHandle);

	std::vector<TextureManager::TextureFileRequest> fileRequests;
	std::vector<std::size_t> fileTextureIndices;
	std::vector<TextureManager::TextureMemoryRequest> memoryRequests;
	std::vector<std::size_t> memoryTextureIndices;

	fileRequests.reserve(asset.Textures.size());
	fileTextureIndices.reserve(asset.Textures.size());
	memoryRequests.reserve(asset.Textures.size());
	memoryTextureIndices.reserve(asset.Textures.size());

	for (int textureIndex = 0; textureIndex < asset.Textures.size(); textureIndex++)
	{
		const ImportedTexture& importedTexture = asset.Textures[textureIndex];

		const std::string textureKey = assetName + "::Texture_" + std::to_string(textureIndex);

		TextureLoadDesc loadDesc{};
		loadDesc.ColorSpace = TextureColorSpace::SRGB;
		loadDesc.Lifetime = TextureLifetime::Scene;
		loadDesc.GenerateMips = false;

		switch (importedTexture.Source)
		{
		case ImportedTextureSource::ExternalFile:
		{
			if (importedTexture.FilePath.empty())
			{
				throw DxException(
					E_FAIL,
					L"Imported external texture has no file path.",
					AnsiToWide(__FILE__),
					__LINE__);
			}

			TextureManager::TextureFileRequest request{};
			request.Key = textureKey;
			request.FilePath = importedTexture.FilePath;
			request.Desc = loadDesc;

			fileRequests.push_back(std::move(request));
			fileTextureIndices.push_back(textureIndex);

			break;
		}

		case ImportedTextureSource::Embedded:
		{
			if (importedTexture.EncodedData.empty())
			{
				throw DxException(
					E_FAIL,
					L"Imported embedded texture has no encoded data.",
					AnsiToWide(__FILE__),
					__LINE__);
			}

			TextureManager::TextureMemoryRequest request{};
			request.Key = textureKey;
			request.Data = importedTexture.EncodedData.data();
			request.Size = importedTexture.EncodedData.size();
			request.Desc = loadDesc;

			memoryRequests.push_back(std::move(request));
			memoryTextureIndices.push_back(textureIndex);

			break;
		}

		case ImportedTextureSource::NotTextureFile:
			// Shader/Layer wrapper이므로 GPU 텍스처를 생성하지 않는다.
			break;
		}
	}

	if (!fileRequests.empty())
	{
		std::vector<TextureHandle> loadedHandles;

		ThrowIfFailed(textureManager.LoadFromFile(fileRequests, loadedHandles));

		if (loadedHandles.size() != fileTextureIndices.size())
		{
			throw DxException(
				E_FAIL,
				L"Loaded file texture count does not match the request count.",
				AnsiToWide(__FILE__),
				__LINE__);
		}

		for (int i = 0; i < loadedHandles.size(); i++)
		{
			asset.TextureHandles[fileTextureIndices[i]] = loadedHandles[i];
		}
	}

	if (!memoryRequests.empty())
	{
		std::vector<TextureHandle> loadedHandles;

		ThrowIfFailed(textureManager.LoadFromMemory(memoryRequests, loadedHandles));

		if (loadedHandles.size() != memoryTextureIndices.size())
		{
			throw DxException(
				E_FAIL,
				L"Loaded memory texture count does not match the request count.",
				AnsiToWide(__FILE__),
				__LINE__);
		}

		for (int i = 0; i < loadedHandles.size(); i++)
		{
			asset.TextureHandles[memoryTextureIndices[i]] = loadedHandles[i];
		}
	}
}

void SceneRenderer::BuildImportedMaterials()
{
	auto MakeMaterialName = [](const std::string& assetName, const ImportedMaterialIndex materialIndex) -> std::string
		{
			return assetName + "::Material_" + std::to_string(materialIndex);
		};

	TextureManager& textureManager = TextureManager::GetInstance();
	const TextureHandle defaultTextureHandle = textureManager.FindHandle("defaultTex");

	for (auto& [assetName, asset] : mSkeletalMesheAssets)
	{
		asset.MaterialNames.assign(asset.Materials.size(), std::string{});

		for (ImportedMaterialIndex materialIndex = 0; materialIndex < asset.Materials.size(); materialIndex++)
		{
			const ImportedMaterial& importedMaterial = asset.Materials[materialIndex];

			auto material = std::make_unique<Material>();
			material->Name = MakeMaterialName(assetName, materialIndex);
			material->MatBufferIndex = (UINT)mMaterials.size();
			material->DiffuseAlbedo = importedMaterial.BaseColor;
			material->Roughness = importedMaterial.Roughness;

			const float metallic = importedMaterial.Metallic;
			material->FresnelR0 =
			{
				0.04f + (importedMaterial.BaseColor.x - 0.04f) * metallic,
				0.04f + (importedMaterial.BaseColor.y - 0.04f) * metallic,
				0.04f + (importedMaterial.BaseColor.z - 0.04f) * metallic
			};

			material->DiffuseTextureHandle = defaultTextureHandle;
			if (importedMaterial.BaseColorTexture != InvalidTextureIndex && importedMaterial.BaseColorTexture < asset.TextureHandles.size())
			{
				const TextureHandle textureHandle = asset.TextureHandles[importedMaterial.BaseColorTexture];

				if (textureHandle.IsValid())
					material->DiffuseTextureHandle = textureHandle;
			}

			if (importedMaterial.NormalTexture != InvalidTextureIndex && importedMaterial.NormalTexture < asset.TextureHandles.size())
				material->NormalTextureHandle = asset.TextureHandles[importedMaterial.NormalTexture];

			asset.MaterialNames[materialIndex] = material->Name;
			mMaterials[material->Name] = std::move(material);
		}
	}
}

void SceneRenderer::BuildImportedMaterials(const std::string& assetName, SkeletalMeshAsset& asset)
{
	for (auto& [name, mat] : mMaterials)
	{
		if (name.find(assetName) != std::string::npos) return;
	}

	auto MakeMaterialName = [](const std::string& assetName, const ImportedMaterialIndex materialIndex) -> std::string
		{
			return assetName + "::Material_" + std::to_string(materialIndex);
		};

	TextureManager& textureManager = TextureManager::GetInstance();
	const TextureHandle defaultTextureHandle = textureManager.FindHandle("defaultTex");

	asset.MaterialNames.assign(asset.Materials.size(), std::string{});

	for (ImportedMaterialIndex materialIndex = 0; materialIndex < asset.Materials.size(); materialIndex++)
	{
		const ImportedMaterial& importedMaterial = asset.Materials[materialIndex];

		auto material = std::make_unique<Material>();
		material->Name = MakeMaterialName(assetName, materialIndex);
		material->MatBufferIndex = (UINT)mMaterials.size();
		material->DiffuseAlbedo = importedMaterial.BaseColor;
		material->Roughness = importedMaterial.Roughness;

		const float metallic = importedMaterial.Metallic;
		material->FresnelR0 =
		{
			0.04f + (importedMaterial.BaseColor.x - 0.04f) * metallic,
			0.04f + (importedMaterial.BaseColor.y - 0.04f) * metallic,
			0.04f + (importedMaterial.BaseColor.z - 0.04f) * metallic
		};

		material->DiffuseTextureHandle = defaultTextureHandle;
		if (importedMaterial.BaseColorTexture != InvalidTextureIndex && importedMaterial.BaseColorTexture < asset.TextureHandles.size())
		{
			const TextureHandle textureHandle = asset.TextureHandles[importedMaterial.BaseColorTexture];

			if (textureHandle.IsValid())
				material->DiffuseTextureHandle = textureHandle;
		}

		if (importedMaterial.NormalTexture != InvalidTextureIndex && importedMaterial.NormalTexture < asset.TextureHandles.size())
			material->NormalTextureHandle = asset.TextureHandles[importedMaterial.NormalTexture];

		asset.MaterialNames[materialIndex] = material->Name;
		mMaterials[material->Name] = std::move(material);
	}
}

SceneObject* SceneRenderer::AddFbxToScene(D3D12Context& context, const std::filesystem::path& path)
{
	LoadFbxResource(context, path);

	const std::string geometryName = path.stem().string();
	SkeletalMeshAsset& asset = mSkeletalMesheAssets.at(geometryName);

	TransformComponent transform{};
	transform.Position = { 5.0f, 0.0f, 0.0f };
	transform.Rotation = { 0.0f, 180.0f, 0.0f };
	transform.Scale = { 0.03f, 0.03f, 0.03f };

	auto sceneObj = CreateSkeletalMeshObject(
		path.stem().c_str(),
		geometryName.c_str(),
		asset,
		transform);

	RebuildRenderBatches();
	BuildFrameResources(context);

	return sceneObj;
}

void SceneRenderer::LoadFbxResource(D3D12Context& context, const std::filesystem::path& path)
{
	const std::string name = path.stem().string();

	if (mGeometries.count(name))
		return;

	BuildFBXGeometry(context, path);
	SkeletalMeshAsset& asset = mSkeletalMesheAssets.at(name);
	BuildImportedTextures(name, asset);
	BuildImportedMaterials(name, asset);
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
	if (mMirror == nullptr) return XMVectorSet(1.0f, 1.0f, 1.0f, 1.0f);

	XMMATRIX W = mMirror->Transform.GetWorldMatrix();

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
		std::wstring wfn = AnsiToWide(__FILE__);
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

void SceneRenderer::UpdateSkinnedBuffer()
{
	auto currSkinnedBuffer = mCurrFrameResource->SkinnedDataBuffer.get();

	// gBoneTransforms 전체에서 다음으로 기록할 행렬 인덱스
	UINT skinnedMatrixIndex = 0;
	for (auto& object : mScene.GetObjects())
	{
		auto* skinnedMesh = object->GetComponent<SkeletalMeshComponent>();
		if (!skinnedMesh) continue;

		// 캐릭터 인스턴스당 한 번만 애니메이션 평가
		skinnedMesh->mSkinnedModelInstance->UpdateAnimation(mTimer.DeltaTime());

		const auto& partPalettes = skinnedMesh->mSkinnedModelInstance->SubmeshFinalTransforms;
		const SkeletalMeshAsset& asset = *skinnedMesh->Asset;
		assert(partPalettes.size() == asset.MeshParts.size());

		UINT flatSubmeshIndex = 0;
		for (UINT partIndex = 0; partIndex < (UINT)partPalettes.size(); partIndex++)
		{
			const std::vector<XMFLOAT4X4>& finalTransforms = partPalettes[partIndex];
			const UINT paletteStart = skinnedMatrixIndex;

			// 이 MeshPart의 palette를 GPU에 한 번만 기록
			for (const XMFLOAT4X4& transform : finalTransforms)
			{
				SkinnedData_GPU gpuData{};
				gpuData.BoneTransforms = transform;

				currSkinnedBuffer->CopyData(skinnedMatrixIndex, gpuData);

				skinnedMatrixIndex++;
			}

			// 이 Part의 모든 material submesh는 같은 Skin Palette 사용
			for (UINT i = 0; i < asset.MeshParts[partIndex].Submeshes.size(); i++)
			{
				skinnedMesh->SkinnedBufferIndices[flatSubmeshIndex++] = paletteStart;
			}
		}
		assert(flatSubmeshIndex == skinnedMesh->SkinnedBufferIndices.size());
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
	if (mRenderBatchesDirty)
		RebuildRenderBatches();

	// 동일한 SceneObject가 여러 서브메시 배치에 포함될 수 있으므로
	// 객체 단위 결과는 프레임 시작 시 한 번만 초기화한다.
	for (const auto& objectPtr : mScene.GetObjects())
	{
		if (objectPtr) objectPtr->FrustumVisible = false;
	}

	XMMATRIX invView = mCamera.GetInvView();

	// 카메라 프러스텀을 뷰 공간에서 월드 공간으로 변환한다.
	BoundingFrustum worldFrustum;
	mCamFrustum.Transform(worldFrustum, invView);

	auto currInstanceBuffer = mCurrFrameResource->InstanceBuffer.get();

	mVisibleInstanceCount = 0;
	mCullCandidateCount = 0;
	mFrustumCulledInstanceCount = 0;
	UINT instanceRegionStart = 0;
	for (std::vector<RenderBatch>& batches : mRenderBatches)
	{
		for (RenderBatch& batch : batches)
		{
			batch.StartInstanceLocation = instanceRegionStart;
			instanceRegionStart += (UINT)batch.Instances.size();
			batch.VisibleInstanceCount = 0;

			for (int i = 0; i < batch.Instances.size(); i++)
			{
				RenderInstanceRef& ref = batch.Instances[i];
				ref.GpuInstanceIndex = UINT_MAX;
				SceneObject* object = ref.Object;

				if (!object || !object->Visible) continue;
				MeshComponent* mesh = object->GetComponent<MeshComponent>();
				if (!mesh || !mesh->Visible || !mesh->Geometry) continue;
				SubmeshSlot& slot = mesh->SubmeshSlots[ref.SubMeshSlotIndex];
				if (!slot.Visible || !slot.Submesh || !slot.MaterialData) continue;

				XMMATRIX world = object->Transform.GetWorldMatrix();
				XMMATRIX worldInvTranspose = MathHelper::InverseTranspose(world);

				BoundingBox worldBounds;
				slot.Submesh->Bounds.Transform(worldBounds, world);

				// 실제로 렌더링 가능한 인스턴스만 컬링 후보로 계산한다.
				mCullCandidateCount++;

				// 월드 공간에서 박스/프러스텀 교차 테스트를 수행한다.
				if ((worldFrustum.Contains(worldBounds) != DirectX::DISJOINT) || !mFrustumCullingEnabled)
				{
					object->FrustumVisible = true;

					InstanceData_GPU gpuData{};
					XMStoreFloat4x4(&gpuData.World, XMMatrixTranspose(world));
					XMStoreFloat4x4(&gpuData.WorldInvTranspose, XMMatrixTranspose(worldInvTranspose));
					gpuData.GridSpatialStep = mWaves->SpatialStep();
					gpuData.MaterialIndex = slot.MaterialData->MatBufferIndex;

					if (SkeletalMeshComponent* skinnedMesh = object->GetComponent<SkeletalMeshComponent>())
					{
						const UINT submeshIndex = ref.SubMeshSlotIndex;

						gpuData.SkinnedBufferIndex = skinnedMesh->SkinnedBufferIndices[submeshIndex];
					}

					// 컬링을 통과한 인스턴스를 배치 영역 앞쪽부터 압축한다.
					const UINT gpuInstanceIndex = batch.StartInstanceLocation + batch.VisibleInstanceCount;
					currInstanceBuffer->CopyData(gpuInstanceIndex, gpuData);
					ref.GpuInstanceIndex = gpuInstanceIndex;
					object->FrustumVisible = true;
					batch.VisibleInstanceCount++;
					mVisibleInstanceCount++;
				}
				else
					mFrustumCulledInstanceCount++;
			}
		}
	}
}

void SceneRenderer::RebuildRenderBatches()
{
	mInstanceCount = 0;

	for (auto& layerBatches : mRenderBatches)
		layerBatches.clear();

	for (const std::unique_ptr<SceneObject>& ptr : mScene.GetObjects())
	{
		SceneObject* object = ptr.get();
		if (!object) continue;

		MeshComponent* mesh = object->GetComponent<MeshComponent>();
		if (!mesh || !mesh->Geometry || !mesh->Visible) continue;

		SkeletalMeshComponent* skeletalMesh = object->GetComponent<SkeletalMeshComponent>();

		for (int i = 0; i < mesh->SubmeshSlots.size(); i++)
		{
			SubmeshSlot& slot = mesh->SubmeshSlots[i];
			if (!slot.Submesh) continue;

			for (RenderPass layer : slot.Layers)
			{
				RenderBatchKey key{};
				key.Geometry = mesh->Geometry;
				key.Submesh = slot.Submesh;
				key.Topology = mesh->Topology;

				RenderBatch& batch = FindOrCreateBatch(layer, key);

				RenderInstanceRef ref{};
				ref.Object = object;
				ref.SubMeshSlotIndex = i;
				ref.GpuInstanceIndex = UINT_MAX;

				batch.Instances.push_back(ref);

				mInstanceCount++;
			}
		}
	}

	mRenderBatchesDirty = false;
}

RenderBatch& SceneRenderer::FindOrCreateBatch(RenderPass layer, const RenderBatchKey& key)
{
	std::vector<RenderBatch>& batches = mRenderBatches[(int)layer];

	const auto result = std::find_if(batches.begin(), batches.end(),
		[&key](const RenderBatch& batch)
		{
			return batch.Key == key;
		});

	if (result != batches.end()) return *result;

	RenderBatch& newBatch =	batches.emplace_back();
	newBatch.Key = key;

	return newBatch;
}

void SceneRenderer::DrawLayer(ID3D12GraphicsCommandList* cmdList, RenderPass layer)
{
	for (const RenderBatch& batch : mRenderBatches[(int)layer])
	{
		if (batch.VisibleInstanceCount == 0) continue;

		MeshGeometry& geometry = *batch.Key.Geometry;
		const SubmeshGeometry& submesh = *batch.Key.Submesh;

		const auto vbv = geometry.VertexBufferView();
		const auto ibv = geometry.IndexBufferView();

		cmdList->IASetVertexBuffers(0, 1, &vbv);
		cmdList->IASetIndexBuffer(&ibv);
		cmdList->IASetPrimitiveTopology(batch.Key.Topology);
		cmdList->SetGraphicsRoot32BitConstant(1, batch.StartInstanceLocation, 0); //instance

		cmdList->DrawIndexedInstanced(
			submesh.IndexCount,
			batch.VisibleInstanceCount,
			submesh.StartIndexLocation,
			submesh.BaseVertexLocation,
			0);
	}
}

void SceneRenderer::DrawLayer_VertexNormalDebug(ID3D12GraphicsCommandList* cmdList, RenderPass layer)
{
	for (const RenderBatch& batch : mRenderBatches[(int)layer])
	{
		if (batch.VisibleInstanceCount == 0) continue;

		auto vbv = batch.Key.Geometry->VertexBufferView();
		auto ibv = batch.Key.Geometry->IndexBufferView();
		const SubmeshGeometry& submesh = *batch.Key.Submesh;

		cmdList->IASetVertexBuffers(0, 1, &vbv);
		cmdList->IASetIndexBuffer(&ibv);
		cmdList->IASetPrimitiveTopology(D3D10_PRIMITIVE_TOPOLOGY_POINTLIST);

		cmdList->SetGraphicsRoot32BitConstant(1, batch.StartInstanceLocation, 0);

		cmdList->DrawIndexedInstanced(submesh.IndexCount, batch.VisibleInstanceCount, submesh.StartIndexLocation, submesh.BaseVertexLocation, 0);
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

			MaterialData_GPU matConstants;
			matConstants.DiffuseAlbedo = mat->DiffuseAlbedo;
			matConstants.FresnelR0 = mat->FresnelR0;
			matConstants.Roughness = mat->Roughness;
			XMStoreFloat4x4(&matConstants.MatTransform, XMMatrixTranspose(matTransform));
			matConstants.DiffuseMapIndex = TextureManager::GetInstance().Get(mat->DiffuseTextureHandle)->Srv.Index;

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
	XMMATRIX skullWorld = mSkull->Transform.GetWorldMatrix();
	XMStoreFloat4x4(&mSkullShadow->Transform.WorldOverride, skullWorld * s * shadowOffsetY);
	mSkullShadow->Transform.UseWorldOverride = true;

	if (mSkullShadowMirror != nullptr)
	{ 
		XMMATRIX mirrorSkullWorld = mSkullMirror->Transform.GetWorldMatrix();
		XMStoreFloat4x4(&mSkullShadowMirror->Transform.WorldOverride, mirrorSkullWorld * s2 * shadowOffsetY);
		mSkullShadowMirror->Transform.UseWorldOverride = true;
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

	waterMat->NumFramesDirty = GlobalConfig::NumFrameResources;


	//Blend Texture Box Animation
	//uv 중심에서 회전하기 위해 이동행렬 필요.
	auto swirlingMat = mMaterials["swirling"].get();
	XMMATRIX R = XMMatrixRotationZ(1.5f * (float)mTimer.TotalTime());
	XMMATRIX T0 = XMMatrixTranslation(-0.5f, -0.5f, 0.0f);
	XMMATRIX T1 = XMMatrixTranslation(0.5f, 0.5f, 0.0f);
	XMMATRIX M = T0 * R * T1;
	XMStoreFloat4x4(&swirlingMat->MatTransform, M);
	swirlingMat->NumFramesDirty = GlobalConfig::NumFrameResources;
}

void SceneRenderer::DrawSelectedSceneObject(ID3D12GraphicsCommandList* cmdList)
{
	auto selectedIds = mScene.GetSelectedObjectIds();

	for (auto selectedId : selectedIds)
	{
		SceneObject* selectedObj = mScene.FindObject(selectedId);
		if (!selectedObj) continue;

		auto mesh = selectedObj->GetComponent<MeshComponent>();
		if (!mesh || !mesh->Geometry) continue;

		for (UINT i = 0; i < mesh->SubmeshSlots.size(); i++)
		{
			const SubmeshSlot& slot = mesh->SubmeshSlots[i];
			RenderBatchKey key{};
			key.Geometry = mesh->Geometry;
			key.Submesh = slot.Submesh;
			key.Topology = mesh->Topology;
			const auto& batches = mRenderBatches[static_cast<int>(slot.Layers[0])];

			const auto batchIt = std::find_if(batches.begin(), batches.end(),
				[&key](const RenderBatch& batch)
				{
					return batch.Key == key;
				});
			if (batchIt == batches.end()) continue;

			const RenderBatch& batch = *batchIt;
			const auto instanceIt = std::find_if(batch.Instances.begin(), batch.Instances.end(),
				[&](const RenderInstanceRef& instance)
				{
					return instance.Object == selectedObj &&
						instance.SubMeshSlotIndex == i;
				});

			if (instanceIt == batch.Instances.end() || instanceIt->GpuInstanceIndex == UINT_MAX)
				continue;

			auto vbv = mesh->Geometry->VertexBufferView();
			auto ibv = mesh->Geometry->IndexBufferView();
			cmdList->IASetVertexBuffers(0, 1, &vbv);
			cmdList->IASetIndexBuffer(&ibv);
			cmdList->IASetPrimitiveTopology(mesh->Topology);

			cmdList->SetGraphicsRoot32BitConstant(1, instanceIt->GpuInstanceIndex, 0);

			cmdList->DrawIndexedInstanced(slot.Submesh->IndexCount, 1, slot.Submesh->StartIndexLocation, slot.Submesh->BaseVertexLocation, 0);
		}
	}
}

void SceneRenderer::DrawDebugColorTriangle(ID3D12GraphicsCommandList* cmdList)
{
	static constexpr std::array<DirectX::XMFLOAT4, 20> colors =
	{
		XMFLOAT4{1.0f, 0.0f, 0.0f, 1.0f},   //  1 빨강
		XMFLOAT4{1.0f, 0.5f, 0.0f, 1.0f},   //  2 주황
		XMFLOAT4{1.0f, 1.0f, 0.0f, 1.0f},   //  3 노랑
		XMFLOAT4{0.0f, 1.0f, 0.0f, 1.0f},   //  4 초록
		XMFLOAT4{0.0f, 0.0f, 1.0f, 1.0f},   //  5 파랑
		XMFLOAT4{0.0f, 1.0f, 1.0f, 1.0f},   //  6 청록
		XMFLOAT4{1.0f, 0.0f, 1.0f, 1.0f},   //  7 자홍
		XMFLOAT4{0.5f, 0.0f, 1.0f, 1.0f},   //  8 보라
		XMFLOAT4{1.0f, 1.0f, 1.0f, 1.0f},   //  9 흰색
		XMFLOAT4{0.5f, 1.0f, 0.0f, 1.0f},   // 10 라임

		XMFLOAT4{1.0f, 0.4f, 0.4f, 1.0f},   // 11 연한 빨강
		XMFLOAT4{1.0f, 0.7f, 0.4f, 1.0f},   // 12 연한 주황
		XMFLOAT4{0.8f, 0.8f, 0.0f, 1.0f},   // 13 황록
		XMFLOAT4{0.4f, 1.0f, 0.4f, 1.0f},   // 14 연한 초록
		XMFLOAT4{0.4f, 0.4f, 1.0f, 1.0f},   // 15 연한 파랑
		XMFLOAT4{0.0f, 0.6f, 0.6f, 1.0f},   // 16 짙은 청록
		XMFLOAT4{1.0f, 0.4f, 0.7f, 1.0f},   // 17 분홍
		XMFLOAT4{0.6f, 0.3f, 0.1f, 1.0f},   // 18 갈색
		XMFLOAT4{1.0f, 0.75f, 0.0f, 1.0f},  // 19 금색
		XMFLOAT4{0.1f, 0.1f, 0.1f, 1.0f}    // 20 검정
	};

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
	queryHeapDesc.Count = 4 * GlobalConfig::NumFrameResources;
	queryHeapDesc.Type = D3D12_QUERY_HEAP_TYPE_TIMESTAMP;

	ThrowIfFailed(context.GetDevice()->CreateQueryHeap(
		&queryHeapDesc,
		IID_PPV_ARGS(&mTimestampQueryHeap)));

	const UINT64 bufferSize = sizeof(UINT64) * 4 * GlobalConfig::NumFrameResources;

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

ID3D12PipelineState* SceneRenderer::ResolvePSO(RenderPass layer, SceneRenderMode mode) const
{
	if(mode == SceneRenderMode::VertexNormal)
		return mLayerPSOs[(int)layer][(int)SceneRenderMode::Lit].Get();

	const auto& modePso = mLayerPSOs[(int)layer][(int)mode];
	if (modePso) return modePso.Get();

	const auto& litPso = mLayerPSOs[(int)RenderPass::Opaque][(int)mode];
	return litPso.Get();
}
