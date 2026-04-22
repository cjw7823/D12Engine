#include "pch.h"
#include "AppD3D.h"

using namespace DirectX;
using namespace Microsoft::WRL;

AppD3D::~AppD3D()
{
	if (md3dDevice != nullptr)
		FlushCommandQueue();

	if (mImGuiInitialized)
	{
		ImGui_ImplDX12_Shutdown();
		ImGui_ImplWin32_Shutdown();
		ImGui::DestroyContext();

		mImGuiInitialized = false;
	}
}

bool AppD3D::Initialize()
{
	if (!InitAppD3D::Initialize())
		return false;

	ThrowIfFailed(mCommandAlloc->Reset());
	ThrowIfFailed(mCommandList->Reset(mCommandAlloc.Get(), nullptr));

	mWaves = std::make_unique<GpuWaves>(
		md3dDevice.Get(),
		mCommandList.Get(),
		256, 256, 0.25f, 0.03f, 2.0f, 0.2f);

	LoadTextures();
	BuildDescriptorHeaps();
	BuildRootsignature();
	BuildWavesRootSignature();
	BuildShadersAndInputLayout();
	BuildShapeGeometry();
	BuildLandGeometry();
	BuildWavesGeometry();
	BuildTreeBillboardGeometry();
	BuildCylinderWithoutTop();
	BuildMaterials();
	BuildRenderItems();
	BuildFrameResources();
	BuildPSO();

	SetDebugColorCB();
	InitImGui();

	ThrowIfFailed(mCommandList->Close());
	ID3D12CommandList* cmdLists[] = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(_countof(cmdLists), cmdLists);

	FlushCommandQueue();

	return true;
}

void AppD3D::Set4xMsaaState(bool value)
{
	__super::Set4xMsaaState(value);
	BuildPSO();
}

void AppD3D::OnResize()
{
	__super::OnResize();

	//종횡비가 변할 때 변경해야 하므로.
	XMMATRIX P = XMMatrixPerspectiveFovLH(0.25f * MathHelper::Pi, AspectRatio(), 1.0f, 200.0f);
	XMStoreFloat4x4(&mProj, P);
}

void AppD3D::Update(const GameTimer& gt)
{
	OnKeyboardInput(gt);
	UpdateCamera(gt);

	mCurrFrameResourceIndex = (mCurrFrameResourceIndex + 1) % gNumFrameResources;
	mCurrFrameResource = mFrameResources[mCurrFrameResourceIndex].get();

	if (mCurrFrameResource->Fence != 0 && mFence->GetCompletedValue() < mCurrFrameResource->Fence)
	{
		ThrowIfFailed(mFence->SetEventOnCompletion(mCurrFrameResource->Fence, mFenceEvent.Get()));
		WaitForSingleObject(mFenceEvent.Get(), INFINITE);
	}

	AnimateMaterials(gt);
	UpdateObjectCBs(gt);
	UpdateMainPassCB(gt);
	UpdateReflectedPassCB(gt);
	UpdateMaterialCBs(gt);
	UpdateShadowTransform();

	//이동 로직. 회전과 연동 안됨.
	float dt = gt.DeltaTime();
	if (isMoving)
	{
		float speed = 10.f; // units/sec
		float forward = 0;
		float right = 0;
		float up = 0;
		if (md == 1) forward = +1;      // W
		else if (md == 2) forward = -1; // S
		else if (md == 3) right = -1; // A
		else if (md == 4) right = +1; // D
		else if (md == 5) up = -1; // Q
		else if (md == 6) up = +1; // E

		float moveZ = forward * speed * dt;
		float moveX = right * speed * dt;
		float moveY = up * speed * dt;

		XMMATRIX cam = XMLoadFloat4x4(&mCamPos);
		XMMATRIX delta = XMMatrixTranslation(-moveX, -moveY, -moveZ);
		cam *= delta;
		XMStoreFloat4x4(&mCamPos, cam);
	}
}

void AppD3D::Draw(const GameTimer& gt)
{
	auto cmdListAlloc = mCurrFrameResource->cmdListAlloc;
	ThrowIfFailed(cmdListAlloc->Reset());
	ThrowIfFailed(mCommandList->Reset(cmdListAlloc.Get(), nullptr));

	mCommandList->RSSetViewports(1, &mScreenViewport);
	mCommandList->RSSetScissorRects(1, &mScissorRect);

	auto barrier1 = CD3DX12_RESOURCE_BARRIER::Transition(
		CurrentBackBuffer(),
		D3D12_RESOURCE_STATE_PRESENT,
		m4xMsaaState? D3D12_RESOURCE_STATE_RESOLVE_DEST : D3D12_RESOURCE_STATE_RENDER_TARGET);
	mCommandList->ResourceBarrier(1, &barrier1);
	
	auto sceneRtv = m4xMsaaState ? MsaaRenderTargetView() : CurrentBackBufferView();
	auto dsvHandle = DepthStencilView();
	mCommandList->ClearRenderTargetView(
		sceneRtv,
		(float*)&mMainPassCB.gFogColor,
		0, nullptr);
	mCommandList->ClearDepthStencilView(
		dsvHandle,
		D3D12_CLEAR_FLAG_DEPTH | D3D12_CLEAR_FLAG_STENCIL,
		1.0f,
		0,
		0,
		nullptr);
	mCommandList->OMSetRenderTargets(1, &sceneRtv, true, &dsvHandle);

	ID3D12DescriptorHeap* descriptorHeap[] = { mSrvHeap.Get() };
	mCommandList->SetDescriptorHeaps(_countof(descriptorHeap), descriptorHeap);
	UpdateWavesGPU(gt);
	mCommandList->SetGraphicsRootSignature(mRootSignature.Get());	

	auto passCB = mCurrFrameResource->PassCB->Resource();
	UINT passCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(PassConstants));
	mCommandList->SetGraphicsRootDescriptorTable(5, mWaves->DisplacementMap());
	for (int layer = 0; layer < (int)RenderLayer::Count; layer++)
	{
		mCommandList->OMSetStencilRef(0);
		mCommandList->SetGraphicsRootConstantBufferView(4, passCB->GetGPUVirtualAddress());
		switch (layer)
		{
		case (int)RenderLayer::Opaque :
			mCommandList->SetPipelineState(mPSOs["opaque"].Get());
			break;
		case (int)RenderLayer::Multi:
			mCommandList->SetPipelineState(mPSOs["multiPSO"].Get());
			break;
		case (int)RenderLayer::MirrorStencil:
			mCommandList->OMSetStencilRef(1);
			mCommandList->SetPipelineState(mPSOs["mirrorStencil"].Get());
			break;
		case (int)RenderLayer::MirrorWall:
			mCommandList->OMSetStencilRef(1);
			mCommandList->SetPipelineState(mPSOs["mirrorWall"].Get());
			break;
		case (int)RenderLayer::Reflected:
			//거울에 비친 반사 물체만 그림(스텐실 버퍼가 1인 픽셀에만 해당).
			//반전된 광원을 포함한 별도의 매 패스 상수 버퍼를 제공.
			mCommandList->OMSetStencilRef(1);
			mCommandList->SetGraphicsRootConstantBufferView(4, passCB->GetGPUVirtualAddress() + 1 * passCBByteSize);
			mCommandList->SetPipelineState(mPSOs["drawStencilReflections"].Get());
			break;
		case (int)RenderLayer::AlphaTestedTreeSprites:
			mCommandList->SetPipelineState(mPSOs["treeBillboard"].Get());
			break;
		case (int)RenderLayer::LineStrip:
			mCommandList->SetPipelineState(mPSOs["circleEx"].Get());
			break;
		case (int)RenderLayer::TriangleList:
			mCommandList->SetPipelineState(mPSOs["geoSphereLOD"].Get());
			break;
		case (int)RenderLayer::Explode:
			mCommandList->SetPipelineState(mPSOs["explode"].Get());
			break;
		case (int)RenderLayer::Transparent:
			mCommandList->SetPipelineState(mPSOs["transparent"].Get());
			break;
		case (int)RenderLayer::Waves:
			mCommandList->SetPipelineState(mPSOs["wavesRender"].Get());
			break;
		case (int)RenderLayer::AlphaTest:
			mCommandList->SetPipelineState(mPSOs["alphaTested"].Get());
			break;
		case (int)RenderLayer::Shadow:
			mCommandList->SetPipelineState(mPSOs["shadow"].Get());
			break;
		default:
			mCommandList->SetPipelineState(mPSOs["opaque"].Get());
			break;
		}

		if (mIsWireframe)
		{
			switch (layer)
			{
			case (int)RenderLayer::AlphaTestedTreeSprites:
				mCommandList->SetPipelineState(mPSOs["treeBillboard_wireframe"].Get());
				break;
			case (int)RenderLayer::LineStrip:
				mCommandList->SetPipelineState(mPSOs["circleEx_wireframe"].Get());
				break;
			case (int)RenderLayer::TriangleList:
				mCommandList->SetPipelineState(mPSOs["geoSphereLOD_wireframe"].Get());
				break;
			default:
				mCommandList->SetPipelineState(mPSOs["opaque_wireframe"].Get());
				break;
			}
		}
		else if (mIsDepthComplexityDebug)
		{
			switch (layer)
			{
			case (int)RenderLayer::AlphaTestedTreeSprites:
				mCommandList->SetPipelineState(mPSOs["treeBillboard_depthCount"].Get());
				break;
			case (int)RenderLayer::LineStrip:
				mCommandList->SetPipelineState(mPSOs["circleEx_depthCount"].Get());
				break;
			case (int)RenderLayer::TriangleList:
				mCommandList->SetPipelineState(mPSOs["geoSphereLOD_depthCount"].Get());
				break;
			default:
				mCommandList->SetPipelineState(mPSOs["depthCount"].Get());
				break;
			}
		}

		DrawRenderItems(mCommandList.Get(), mRenderItemLayer[layer]);
	}

	if (mIsDepthComplexityDebug)
	{
		mCommandList->SetGraphicsRootSignature(mRootSignature_debug.Get());
		mCommandList->SetPipelineState(mPSOs["debugComplexity"].Get());
		DrawFullscreenTriangle(mCommandList.Get());
	}

	if (mIsVertexNormalDebug)
		DrawAllVertexNormals(mCommandList.Get());

	if (m4xMsaaState)
		ResolveMsaaToBackBuffer();

	RenderImGui();

	auto barrier2 = CD3DX12_RESOURCE_BARRIER::Transition(
		CurrentBackBuffer(),
		D3D12_RESOURCE_STATE_RENDER_TARGET,
		D3D12_RESOURCE_STATE_PRESENT);
	mCommandList->ResourceBarrier(1, &barrier2);

	ThrowIfFailed(mCommandList->Close());

	ID3D12CommandList* cmdLists[] = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(_countof(cmdLists), cmdLists);

	ThrowIfFailed(mSwapChain->Present(0, 0));
	mCurrBackBuffer = (mCurrBackBuffer + 1) % SwapChainBufferCount;

	mCurrFrameResource->Fence = ++mCurrentFence;
	mCommandQueue->Signal(mFence.Get(), mCurrentFence);
}

void AppD3D::OnMouseDown(WPARAM btnState, int x, int y)
{
	mLastMousePos = { x,y };

	//마우스 커서가 창 밖으로 나가도 마우스 메시지가 계속 이 창으로 들어옴.
	SetCapture(mhMainWnd);
}

void AppD3D::OnMouseUp(WPARAM btnState, int x, int y)
{
	ReleaseCapture();
}

void AppD3D::OnMouseMove(WPARAM btnState, int x, int y)
{
	ImGuiIO& io = ImGui::GetIO();
	
	if (io.WantCaptureMouse)
		return;

	if ((btnState & MK_LBUTTON) != 0)
	{
		float dx = DirectX::XMConvertToRadians(0.5f * static_cast<float>(x - mLastMousePos.x));
		float dy = DirectX::XMConvertToRadians(0.5f * static_cast<float>(y - mLastMousePos.y));

		mTheta += dx;
		mPhi += dy;

		//LookAt 행렬 생성 시 up 벡터와 시선 벡터가 평행해져서 직교 기저를 만들 수 없는 수학적 퇴화 현상 방지.
		mPhi = MathHelper::Clamp(mPhi, 0.1f, MathHelper::Pi - 0.1f);
	}

	mLastMousePos.x = x;
	mLastMousePos.y = y;
}

void AppD3D::OnMouseWheel(short zDelta, int x, int y)
{
	mRadius -= static_cast<long long>(zDelta) * 0.01f;
	mRadius = MathHelper::Clamp(mRadius, 0.1f, 150.0f);

	OutputDebugStringA(("Mouse wheel: " + std::to_string(mRadius) + "\n").c_str());
}

void AppD3D::OnKeyUp(WPARAM key)
{
	std::wstring s(1, static_cast<wchar_t>(key));
	s += L" ";
	OutputDebugStringW((std::wstring(L"UP : ") + s).c_str());

	isMoving = false;
}

void AppD3D::OnKeyDown(WPARAM key)
{
	std::wstring s(1, static_cast<wchar_t>(key));
	s += L" ";
	OutputDebugStringW((std::wstring(L"DOWN : ") + s).c_str());

	isMoving = true;
	if (key == 'W') md = 1;
	else if (key == 'S') md = 2;
	else if (key == 'A') md = 3;
	else if (key == 'D') md = 4;
	else if (key == 'Q') md = 5;
	else if (key == 'E') md = 6;
	else isMoving = false;
}

void AppD3D::LoadTextures()
{
	if (!mTexLoader)
		mTexLoader = std::make_unique<TextureLoader_Blocking>(
			md3dDevice.Get(), mCommandQueue.Get(), mFence.Get());

	auto defaultTex = std::make_unique<Texture>();
	defaultTex->Name = "defaultTex";
	defaultTex->Filename = L"Resource/Textures/white1x1.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*defaultTex, mCurrentFence));

	auto woodCrateTex = std::make_unique<Texture>();
	woodCrateTex->Name = "woodCrateTex";
	woodCrateTex->Filename = L"Resource/Textures/MipmapTest.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*woodCrateTex, mCurrentFence));

	auto bricksTex0 = std::make_unique<Texture>();
	bricksTex0->Name = "bricksTex0";
	bricksTex0->Filename = L"Resource/Textures/bricks.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*bricksTex0, mCurrentFence));

	auto stoneTex = std::make_unique<Texture>();
	stoneTex->Name = "stoneTex";
	stoneTex->Filename = L"Resource/Textures/stone.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*stoneTex, mCurrentFence));

	auto tileTex = std::make_unique<Texture>();
	tileTex->Name = "tileTex";
	tileTex->Filename = L"Resource/Textures/tile.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*tileTex, mCurrentFence));

	auto grassTex = std::make_unique<Texture>();
	grassTex->Name = "grassTex";
	grassTex->Filename = L"Resource/Textures/grass.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*grassTex, mCurrentFence));

	auto waterTex = std::make_unique<Texture>();
	waterTex->Name = "waterTex";
	waterTex->Filename = L"Resource/Textures/water1.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*waterTex, mCurrentFence));

	auto swirlingTex = std::make_unique<Texture>();
	swirlingTex->Name = "swirlingTex";
	swirlingTex->Filename = L"Resource/Textures/swirling.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*swirlingTex, mCurrentFence));

	auto swirlingMaskTex = std::make_unique<Texture>();
	swirlingMaskTex->Name = "swirlingMaskTex";
	swirlingMaskTex->Filename = L"Resource/Textures/swirling_Mask.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*swirlingMaskTex, mCurrentFence));

	auto fenceTex = std::make_unique<Texture>();
	fenceTex->Name = "fenceTex";
	fenceTex->Filename = L"Resource/Textures/WireFence.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*fenceTex, mCurrentFence));

	auto bricksTex1 = std::make_unique<Texture>();
	bricksTex1->Name = "bricksTex1";
	bricksTex1->Filename = L"Resource/Textures/bricks3.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*bricksTex1, mCurrentFence));

	auto checkboardTex = std::make_unique<Texture>();
	checkboardTex->Name = "checkboardTex";
	checkboardTex->Filename = L"Resource/Textures/checkboard.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*checkboardTex, mCurrentFence));

	auto iceTex = std::make_unique<Texture>();
	iceTex->Name = "iceTex";
	iceTex->Filename = L"Resource/Textures/ice.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*iceTex, mCurrentFence));

	auto helpTex = std::make_unique<Texture>();
	helpTex->Name = "helpTex";
	helpTex->Filename = L"Resource/Textures/help.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*helpTex, mCurrentFence));

	auto treeArrayTex = std::make_unique<Texture>();
	treeArrayTex->Name = "treeArrayTex";
	treeArrayTex->Filename = L"Resource/Textures/treearray2.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*treeArrayTex, mCurrentFence));

	mTextures[defaultTex->Name] = std::move(defaultTex);
	mTextures[woodCrateTex->Name] = std::move(woodCrateTex);
	mTextures[bricksTex0->Name] = std::move(bricksTex0);
	mTextures[stoneTex->Name] = std::move(stoneTex);
	mTextures[tileTex->Name] = std::move(tileTex);
	mTextures[grassTex->Name] = std::move(grassTex);
	mTextures[waterTex->Name] = std::move(waterTex);
	mTextures[swirlingTex->Name] = std::move(swirlingTex);
	mTextures[swirlingMaskTex->Name] = std::move(swirlingMaskTex);
	mTextures[fenceTex->Name] = std::move(fenceTex);
	mTextures[bricksTex1->Name] = std::move(bricksTex1);
	mTextures[checkboardTex->Name] = std::move(checkboardTex);
	mTextures[iceTex->Name] = std::move(iceTex);
	mTextures[helpTex->Name] = std::move(helpTex);
	mTextures[treeArrayTex->Name] = std::move(treeArrayTex);
}

void AppD3D::BuildDescriptorHeaps()
{
	/*
		0 ~ N-1   : 기존 텍스처
		N         : ImGui font
		N+1 ~ Resource. : ImGui용 추가 슬롯 (optional)
	*/
	D3D12_DESCRIPTOR_HEAP_DESC srvHeapDesc = {};
	const UINT textureCount = (UINT)mTextures.size();
	const UINT imguiReservedCount = 1; // 폰트만
	srvHeapDesc.NumDescriptors = textureCount + imguiReservedCount + mWaves->DescriptorCount();
	srvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
	srvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&srvHeapDesc, IID_PPV_ARGS(mSrvHeap.GetAddressOf())));

	CD3DX12_CPU_DESCRIPTOR_HANDLE hDescriptor(mSrvHeap->GetCPUDescriptorHandleForHeapStart());

	int i = 0;
	for (auto& tex : mTextures)
	{
		auto resource = tex.second->Resource;
		D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc = {};
		srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
		srvDesc.Format = resource->GetDesc().Format;
		srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
		srvDesc.Texture2D.MostDetailedMip = 0;
		srvDesc.Texture2D.MipLevels = resource->GetDesc().MipLevels;
		srvDesc.Texture2D.ResourceMinLODClamp = 0.f;

		md3dDevice->CreateShaderResourceView(resource.Get(), &srvDesc, hDescriptor);
		hDescriptor.Offset(1, mCbvSrvUavDescriptorSize);

		tex.second->DiffuseSrvHeapIndex = i;
		i++;
	}

	const UINT wavesBaseIndex = textureCount + imguiReservedCount;

	mWaves->BuildDescriptors(
		CD3DX12_CPU_DESCRIPTOR_HANDLE(
			mSrvHeap->GetCPUDescriptorHandleForHeapStart(),
			wavesBaseIndex,
			mCbvSrvUavDescriptorSize),
		CD3DX12_GPU_DESCRIPTOR_HANDLE(
			mSrvHeap->GetGPUDescriptorHandleForHeapStart(),
			wavesBaseIndex,
			mCbvSrvUavDescriptorSize),
		mCbvSrvUavDescriptorSize);
}

void AppD3D::BuildMaterials()
{
	UINT index = 0;

	auto skullMat = std::make_unique<Material>();
	skullMat->Name = "skullMat";
	skullMat->MatCBIndex = index++;
	skullMat->DiffuseSrvHeapIndex = mTextures["defaultTex"]->DiffuseSrvHeapIndex; //텍스처 없음.
	skullMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	skullMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	skullMat->Roughness = 0.3f;

	auto tileMat = std::make_unique<Material>();
	tileMat->Name = "tile0";
	tileMat->MatCBIndex = index++;
	tileMat->DiffuseSrvHeapIndex = mTextures["tileTex"]->DiffuseSrvHeapIndex;
	tileMat->DiffuseAlbedo = XMFLOAT4(Colors::LightGray);
	tileMat->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	tileMat->Roughness = 0.2f;

	auto bricksMat0 = std::make_unique<Material>();
	bricksMat0->Name = "bricks0";
	bricksMat0->MatCBIndex = index++;
	bricksMat0->DiffuseSrvHeapIndex = mTextures["bricksTex0"]->DiffuseSrvHeapIndex;
	bricksMat0->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	bricksMat0->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	bricksMat0->Roughness = 0.1f;

	auto stoneMat = std::make_unique<Material>();
	stoneMat->Name = "stone0";
	stoneMat->MatCBIndex = index++;
	stoneMat->DiffuseSrvHeapIndex = mTextures["stoneTex"]->DiffuseSrvHeapIndex;
	stoneMat->DiffuseAlbedo = XMFLOAT4(Colors::LightSteelBlue);
	stoneMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	stoneMat->Roughness = 0.3f;

	auto grassMat = std::make_unique<Material>();
	grassMat->Name = "grass0";
	grassMat->MatCBIndex = index++;
	grassMat->DiffuseSrvHeapIndex = mTextures["grassTex"]->DiffuseSrvHeapIndex;
	grassMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	grassMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	grassMat->Roughness = 0.125f;

	auto waterMat = std::make_unique<Material>();
	waterMat->Name = "water0";
	waterMat->MatCBIndex = index++;
	waterMat->DiffuseSrvHeapIndex = mTextures["waterTex"]->DiffuseSrvHeapIndex;
	waterMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.5f);
	waterMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	waterMat->Roughness = 0.0f;

	auto woodCrateMat = std::make_unique<Material>();
	woodCrateMat->Name = "woodCrate";
	woodCrateMat->MatCBIndex = index++;
	woodCrateMat->DiffuseSrvHeapIndex = mTextures["woodCrateTex"]->DiffuseSrvHeapIndex;
	woodCrateMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	woodCrateMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	woodCrateMat->Roughness = 0.0f;

	auto swirlingMat = std::make_unique<Material>();
	swirlingMat->Name = "swirling";
	swirlingMat->MatCBIndex = index++;
	swirlingMat->DiffuseSrvHeapIndex = mTextures["swirlingTex"]->DiffuseSrvHeapIndex;
	swirlingMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMat->Roughness = 0.0f;

	auto swirlingMaskMat = std::make_unique<Material>();
	swirlingMaskMat->Name = "swirlingMask";
	swirlingMaskMat->MatCBIndex = index++;
	swirlingMaskMat->DiffuseSrvHeapIndex = mTextures["swirlingMaskTex"]->DiffuseSrvHeapIndex;
	swirlingMaskMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMaskMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMaskMat->Roughness = 0.0f;

	auto wireFence = std::make_unique<Material>();
	wireFence->Name = "wireFence";
	wireFence->MatCBIndex = index++;
	wireFence->DiffuseSrvHeapIndex = mTextures["fenceTex"]->DiffuseSrvHeapIndex;
	wireFence->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	wireFence->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	wireFence->Roughness = 0.25f;

	auto bricksMat1 = std::make_unique<Material>();
	bricksMat1->Name = "bricks1";
	bricksMat1->MatCBIndex = index++;
	bricksMat1->DiffuseSrvHeapIndex = mTextures["bricksTex1"]->DiffuseSrvHeapIndex;
	bricksMat1->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	bricksMat1->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	bricksMat1->Roughness = 0.25f;

	auto checkerTileMat = std::make_unique<Material>();
	checkerTileMat->Name = "checkerTileMat";
	checkerTileMat->MatCBIndex = index++;
	checkerTileMat->DiffuseSrvHeapIndex = mTextures["checkboardTex"]->DiffuseSrvHeapIndex;
	checkerTileMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	checkerTileMat->FresnelR0 = XMFLOAT3(0.07f, 0.07f, 0.07f);
	checkerTileMat->Roughness = 0.3f;

	auto iceMirrorMat = std::make_unique<Material>();
	iceMirrorMat->Name = "iceMirrorMat";
	iceMirrorMat->MatCBIndex = index++;
	iceMirrorMat->DiffuseSrvHeapIndex = mTextures["iceTex"]->DiffuseSrvHeapIndex;
	iceMirrorMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.3f);
	iceMirrorMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	iceMirrorMat->Roughness = 0.5f;

	auto shadowMat_skull = std::make_unique<Material>();
	shadowMat_skull->Name = "shadowMat_skull";
	shadowMat_skull->MatCBIndex = index++;
	shadowMat_skull->DiffuseSrvHeapIndex = mTextures["defaultTex"]->DiffuseSrvHeapIndex;
	shadowMat_skull->DiffuseAlbedo = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.5f);
	shadowMat_skull->FresnelR0 = XMFLOAT3(0.001f, 0.001f, 0.001f);
	shadowMat_skull->Roughness = 0.0f;

	auto treeBillboardMat = std::make_unique<Material>();
	treeBillboardMat->Name = "treeBillboardMat";
	treeBillboardMat->MatCBIndex = index++;
	treeBillboardMat->DiffuseSrvHeapIndex = mTextures["treeArrayTex"]->DiffuseSrvHeapIndex;
	treeBillboardMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	treeBillboardMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	treeBillboardMat->Roughness = 0.125f;

	mMaterials[skullMat->Name] = std::move(skullMat);
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
}

void AppD3D::BuildRootsignature()
{
	CD3DX12_DESCRIPTOR_RANGE texTable1;
	texTable1.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0); //t0
	CD3DX12_DESCRIPTOR_RANGE texTable2;
	texTable2.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 1); //t1

	CD3DX12_DESCRIPTOR_RANGE displacementMapTable;
	displacementMapTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 2);

	std::array<CD3DX12_ROOT_PARAMETER, 6> slotRootParameter;
	slotRootParameter[0].InitAsDescriptorTable(1, &texTable1, D3D12_SHADER_VISIBILITY_PIXEL);
	slotRootParameter[1].InitAsDescriptorTable(1, &texTable2, D3D12_SHADER_VISIBILITY_PIXEL);
	slotRootParameter[2].InitAsConstantBufferView(0); //obj CB
	slotRootParameter[3].InitAsConstantBufferView(1); //material CB
	slotRootParameter[4].InitAsConstantBufferView(2); //pass CB
	slotRootParameter[5].InitAsDescriptorTable(1, &displacementMapTable, D3D12_SHADER_VISIBILITY_ALL);

	auto staticSamplers = GetStaticSamplers();

	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(
		(UINT)slotRootParameter.size(),
		slotRootParameter.data(),
		(UINT)staticSamplers.size(),
		staticSamplers.data(),
		D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

	//루트 시그니처는 보통 DESC -> Serialize(Blob) -> Create
	//직렬화 단계에서 문법/제약/버전 관점에서 유효성 검사.
	//캐싱/저장에 활용.
	ComPtr<ID3DBlob> serializedRootsig = nullptr;
	ComPtr<ID3DBlob> errorBlob = nullptr;
	HRESULT hr = D3D12SerializeRootSignature(
		&rootSigDesc,
		D3D_ROOT_SIGNATURE_VERSION_1,
		serializedRootsig.GetAddressOf(),
		errorBlob.GetAddressOf());

	if (errorBlob != nullptr)
		OutputDebugStringA((char*)errorBlob->GetBufferPointer());
	ThrowIfFailed(hr);

	ThrowIfFailed(md3dDevice->CreateRootSignature(
		0,
		serializedRootsig->GetBufferPointer(),
		serializedRootsig->GetBufferSize(),
		IID_PPV_ARGS(mRootSignature.GetAddressOf())));

	//DepthComplexity.hlsl 용
	{
		std::array<CD3DX12_ROOT_PARAMETER, 1> slotRootParameter;
		slotRootParameter[0].InitAsConstantBufferView(0); //debugColor

		CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(
			(UINT)slotRootParameter.size(),
			slotRootParameter.data(),
			0, nullptr,
			D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

		ComPtr<ID3DBlob> serializedRootsig = nullptr;
		ComPtr<ID3DBlob> errorBlob = nullptr;
		HRESULT hr = D3D12SerializeRootSignature(
			&rootSigDesc,
			D3D_ROOT_SIGNATURE_VERSION_1,
			serializedRootsig.GetAddressOf(),
			errorBlob.GetAddressOf());

		if (errorBlob != nullptr)
			OutputDebugString((wchar_t*)errorBlob->GetBufferPointer());
		ThrowIfFailed(hr);

		ThrowIfFailed(md3dDevice->CreateRootSignature(
			0,
			serializedRootsig->GetBufferPointer(),
			serializedRootsig->GetBufferSize(),
			IID_PPV_ARGS(mRootSignature_debug.GetAddressOf())));
	}
}

void AppD3D::BuildWavesRootSignature()
{
	CD3DX12_DESCRIPTOR_RANGE uavTable0;
	uavTable0.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 0);

	CD3DX12_DESCRIPTOR_RANGE uavTable1;
	uavTable1.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 1);

	CD3DX12_DESCRIPTOR_RANGE uavTable2;
	uavTable2.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 2);

	std::array<CD3DX12_ROOT_PARAMETER, 4> slotRootParameter;

	// Perfomance TIP:
	// 루트 파라미터를 갱신 빈도(커맨드 리스트에서 Set되는 빈도) 순으로 배치 (자주 바뀌는 것 → 덜 바뀌는 것)
	// 드라이버 구현에 따라 효과는 다르지만 일반적으로 권장되는 패턴
	slotRootParameter[0].InitAsConstants(6, 0);
	slotRootParameter[1].InitAsDescriptorTable(1, &uavTable0);
	slotRootParameter[2].InitAsDescriptorTable(1, &uavTable1);
	slotRootParameter[3].InitAsDescriptorTable(1, &uavTable2);

	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc((UINT)slotRootParameter.size(), slotRootParameter.data(),
		0, nullptr,
		D3D12_ROOT_SIGNATURE_FLAG_NONE);

	ComPtr<ID3DBlob> serializedRootSig = nullptr;
	ComPtr<ID3DBlob> errorBlob = nullptr;
	HRESULT hr = D3D12SerializeRootSignature(&rootSigDesc, D3D_ROOT_SIGNATURE_VERSION_1,
		serializedRootSig.GetAddressOf(), errorBlob.GetAddressOf());

	if (errorBlob != nullptr)
	{
		::OutputDebugStringA((char*)errorBlob->GetBufferPointer());
	}
	ThrowIfFailed(hr);

	ThrowIfFailed(md3dDevice->CreateRootSignature(
		0,
		serializedRootSig->GetBufferPointer(),
		serializedRootSig->GetBufferSize(),
		IID_PPV_ARGS(mWavesRootSignature.GetAddressOf())));
}

void AppD3D::BuildShadersAndInputLayout()
{
	//매크로 테스트. HLSL에서 #ifdef ALPHA_TEST으로 분기 가능.
	const D3D_SHADER_MACRO alphaTestDefines[] =
	{
		"FOG", "1",
		"ALPHA_TEST", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO defines[] =
	{
		"FOG", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO waveDefines[] =
	{
		"DISPLACEMENT_MAP", "1",
		NULL, NULL
	};

	mShaders["standardVS"] = d3dUtil::CompileShader(L"Shaders\\Default.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["wavesVS"] = d3dUtil::CompileShader(L"Shaders\\Default.hlsl", waveDefines, "VS", "vs_5_1");
	mShaders["opaquePS"] = d3dUtil::CompileShader(L"Shaders\\Default.hlsl", defines, "PS", "ps_5_1");
	mShaders["multiPS"] = d3dUtil::CompileShader(L"Shaders\\Default.hlsl", defines, "PS_multiTexture", "ps_5_1");
	mShaders["alphaTestedPS"] = d3dUtil::CompileShader(L"Shaders\\Default.hlsl", alphaTestDefines, "PS", "ps_5_1");

	mShaders["debugVS"] = d3dUtil::CompileShader(L"Shaders\\DepthComplexity.hlsl", nullptr, "FullscreenVS", "vs_5_1");
	mShaders["debugPS"] = d3dUtil::CompileShader(L"Shaders\\DepthComplexity.hlsl", nullptr, "FullscreenPS", "ps_5_1");

	mShaders["treeBillboardVS"] = d3dUtil::CompileShader(L"Shaders\\TreeBillboard.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["treeBillboardGS"] = d3dUtil::CompileShader(L"Shaders\\TreeBillboard.hlsl", nullptr, "GS", "gs_5_1");
	mShaders["treeBillboardPS"] = d3dUtil::CompileShader(L"Shaders\\TreeBillboard.hlsl", alphaTestDefines, "PS", "ps_5_1");

	mShaders["circleExVS"] = d3dUtil::CompileShader(L"Shaders\\Task_GS.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["circleExGS"] = d3dUtil::CompileShader(L"Shaders\\Task_GS.hlsl", nullptr, "GS", "gs_5_1");
	mShaders["circleExPS"] = d3dUtil::CompileShader(L"Shaders\\Task_GS.hlsl", defines, "PS", "ps_5_1");

	mShaders["LOD_GS"] = d3dUtil::CompileShader(L"Shaders\\Task_GS.hlsl", nullptr, "GS_LOD", "gs_5_1");
	mShaders["explodeGS"] = d3dUtil::CompileShader(L"Shaders\\Task_GS.hlsl", nullptr, "GS_Explode", "gs_5_1");

	mShaders["vertexDebugGS"] = d3dUtil::CompileShader(L"Shaders\\Task_GS.hlsl", nullptr, "GS_Debugging", "gs_5_1");
	mShaders["vertexDebugPS"] = d3dUtil::CompileShader(L"Shaders\\Task_GS.hlsl", nullptr, "PS_VertexNormal", "ps_5_1");

	mShaders["wavesUpdateCS"] = d3dUtil::CompileShader(L"Shaders\\WaveSim.hlsl", nullptr, "UpdateWavesCS", "cs_5_1");
	mShaders["wavesDisturbCS"] = d3dUtil::CompileShader(L"Shaders\\WaveSim.hlsl", nullptr, "DisturbWavesCS", "cs_5_1");

	mInputLayout =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
		{ "NORMAL", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
		{ "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT, 0, 24, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
	};

	mTreeBillboardInputLayout =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
		{ "SIZE", 0, DXGI_FORMAT_R32G32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
	};
}

void AppD3D::BuildShapeGeometry()
{
	GeometryGenerator::MeshData skull = LoadModelFile(L"Resource/skull.txt");

	GeometryGenerator geoGen;
	GeometryGenerator::MeshData box = geoGen.CreateBox(1.5, 1.5, 1.5, 3);
	GeometryGenerator::MeshData grid = geoGen.CreateGrid(20, 30, 60, 40);
	GeometryGenerator::MeshData sphere = geoGen.CreateSphere(0.5, 20, 20);
	GeometryGenerator::MeshData geoSphere = geoGen.CreateGeosphere(0.5, 2);
	GeometryGenerator::MeshData cylinder = geoGen.CreateCylinder(0.5f, 0.3f, 3.f, 20, 20);

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

	SubmeshGeometry gridSubmesh;
	gridSubmesh.IndexCount = (UINT)grid.Indices32.size();
	gridSubmesh.StartIndexLocation = gridIndexOffset;
	gridSubmesh.BaseVertexLocation = gridVertexOffset;
	gridSubmesh.VertexCount = gridVertexCount;

	SubmeshGeometry sphereSubmesh;
	sphereSubmesh.IndexCount = (UINT)sphere.Indices32.size();
	sphereSubmesh.StartIndexLocation = sphereIndexOffset;
	sphereSubmesh.BaseVertexLocation = sphereVertexOffset;
	sphereSubmesh.VertexCount = sphereVertexCount;

	SubmeshGeometry geoSphereSubmesh;
	geoSphereSubmesh.IndexCount = (UINT)geoSphere.Indices32.size();
	geoSphereSubmesh.StartIndexLocation = geoSphereIndexOffset;
	geoSphereSubmesh.BaseVertexLocation = geoSphereVertexOffset;
	geoSphereSubmesh.VertexCount = geoSphereVertexCount;

	SubmeshGeometry cylinderSubmesh;
	cylinderSubmesh.IndexCount = (UINT)cylinder.Indices32.size();
	cylinderSubmesh.StartIndexLocation = cylinderIndexOffset;
	cylinderSubmesh.BaseVertexLocation = cylinderVertexOffset;
	cylinderSubmesh.VertexCount = cylinderVertexCount;

	SubmeshGeometry skullSubmesh;
	skullSubmesh.IndexCount = (UINT)skull.Indices32.size();
	skullSubmesh.StartIndexLocation = skullIndexOffset;
	skullSubmesh.BaseVertexLocation = skullVertexOffset;
	skullSubmesh.VertexCount = skullVertexCount;

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
		vertices[k].Pos = box.Vertices[i].Position;
		vertices[k].Normal = box.Vertices[i].Normal;
		vertices[k].TexC = box.Vertices[i].TexC;
	}
	for (size_t i = 0; i < grid.Vertices.size(); i++, k++)
	{
		vertices[k].Pos = grid.Vertices[i].Position;
		vertices[k].Normal = grid.Vertices[i].Normal;
		vertices[k].TexC = grid.Vertices[i].TexC;
	}
	for (size_t i = 0; i < sphere.Vertices.size(); i++, k++)
	{
		vertices[k].Pos = sphere.Vertices[i].Position;
		vertices[k].Normal = sphere.Vertices[i].Normal;
		vertices[k].TexC = sphere.Vertices[i].TexC;
	}
	for (size_t i = 0; i < geoSphere.Vertices.size(); i++, k++)
	{
		vertices[k].Pos = geoSphere.Vertices[i].Position;
		vertices[k].Normal = geoSphere.Vertices[i].Normal;
		vertices[k].TexC = geoSphere.Vertices[i].TexC;
	}
	for (size_t i = 0; i < cylinder.Vertices.size(); i++, k++)
	{
		vertices[k].Pos = cylinder.Vertices[i].Position;
		vertices[k].Normal = cylinder.Vertices[i].Normal;
		vertices[k].TexC = cylinder.Vertices[i].TexC;
	}
	for (size_t i = 0; i < skull.Vertices.size(); i++, k++)
	{
		vertices[k].Pos = skull.Vertices[i].Position;
		vertices[k].Normal = skull.Vertices[i].Normal;
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

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), vertices.data(), vbByteSize, geo->VertexBufferUploader);

	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), indices.data(), ibByteSize, geo->IndexBufferUploader);

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

void AppD3D::BuildLandGeometry()
{
	GeometryGenerator geoGen;
	GeometryGenerator::MeshData grid = geoGen.CreateGrid(160, 160, 50, 50);

	//일부 정점의 높이를 조절하고 높이에 따른 색상 설정.

	std::vector<Vertex> vertices(grid.Vertices.size());
	for (size_t i = 0; i < grid.Vertices.size(); i++)
	{
		auto& p = grid.Vertices[i].Position;
		vertices[i].Pos = p;
		vertices[i].Pos.y = GetHillsHeight(p.x, p.z);
		vertices[i].Normal = GetHillsNormal(p.x, p.z);
		vertices[i].TexC = grid.Vertices[i].TexC;
	}

	const UINT vbByteSize = (UINT)vertices.size() * sizeof(Vertex);

	std::vector<std::uint16_t> indices = grid.GetIndices16();
	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint16_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "landGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, &geo->VertexBufferCPU));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, &geo->IndexBufferCPU));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), vertices.data(), vbByteSize, geo->VertexBufferUploader);
	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R16_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;
	sm.VertexCount = (UINT)vertices.size();

	geo->DrawArgs["grid"] = sm;
	mGeometries["landGeo"] = std::move(geo);
}

void AppD3D::BuildWavesGeometry()
{
	GeometryGenerator geoGen;
	GeometryGenerator::MeshData grid = geoGen.CreateGrid(160.0f, 160.0f, mWaves->RowCount(), mWaves->ColumnCount());

	std::vector<Vertex> vertices(grid.Vertices.size());
	for (size_t i = 0; i < grid.Vertices.size(); ++i)
	{
		vertices[i].Pos = grid.Vertices[i].Position;
		vertices[i].Normal = grid.Vertices[i].Normal;
		vertices[i].TexC = grid.Vertices[i].TexC;
	}

	std::vector<std::uint32_t> indices = grid.Indices32;

	UINT vbByteSize = mWaves->VertexCount() * sizeof(Vertex);
	UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint32_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "waterGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, &geo->VertexBufferCPU));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, &geo->IndexBufferCPU));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(),
		mCommandList.Get(), vertices.data(), vbByteSize, geo->VertexBufferUploader);

	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(),
		mCommandList.Get(), indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R32_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry submesh;
	submesh.IndexCount = (UINT)indices.size();
	submesh.StartIndexLocation = 0;
	submesh.BaseVertexLocation = 0;

	geo->DrawArgs["grid"] = submesh;

	mGeometries["waterGeo"] = std::move(geo);
}

void AppD3D::BuildTreeBillboardGeometry()
{
	struct TreeVertex
	{
		XMFLOAT3 Pos;
		XMFLOAT2 Size;
	};

	static const int treeCount = 16;
	std::array<TreeVertex, treeCount> vertices;
	for (UINT i = 0; i < treeCount; i++)
	{
		float x = 0, z = 0;
		while (true)
		{
			if(x > -15.0f && x < 15.0f)
				x = MathHelper::RandF(-45.0f, 45.0f);
			else if(z > -15.0f && z < 15.0f)
				z = MathHelper::RandF(-45.0f, 45.0f);
			else
				break;
		}
		float y = GetHillsHeight(x, z); // 땅 위에 나무가 있도록.

		y += 8.0f;

		vertices[i].Pos = XMFLOAT3(x, y, z);
		vertices[i].Size = XMFLOAT2(11.0f, 15.0f);
	}

	std::array<std::uint16_t, 16> indices =
	{
		0, 1, 2, 3, 4, 5, 6, 7,
		8, 9, 10, 11, 12, 13, 14, 15
	};

	const UINT vbByteSize = (UINT)vertices.size() * sizeof(TreeVertex);
	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint16_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "treeBillboard";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, &geo->VertexBufferCPU));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(vbByteSize, &geo->IndexBufferCPU));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), vertices.data(), vbByteSize, geo->VertexBufferUploader);

	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(TreeVertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R16_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;
	sm.VertexCount = (UINT)vertices.size();

	geo->DrawArgs["tree"] = sm;
	mGeometries[geo->Name] = std::move(geo);
}

void AppD3D::BuildCylinderWithoutTop()
{
	GeometryGenerator geoGen;
	GeometryGenerator::MeshData cylinder = geoGen.CreateCircleLine(2, 10);

	SubmeshGeometry cylinderSubmesh;
	cylinderSubmesh.IndexCount = (UINT)cylinder.Indices32.size();
	cylinderSubmesh.StartIndexLocation = 0;
	cylinderSubmesh.BaseVertexLocation = 0;
	cylinderSubmesh.VertexCount = (UINT)cylinder.Vertices.size();

	std::vector<Vertex> vertices(cylinder.Vertices.size());

	for (size_t i = 0; i < cylinder.Vertices.size(); i++)
	{
		vertices[i].Pos = cylinder.Vertices[i].Position;
		vertices[i].Normal = cylinder.Vertices[i].Normal;
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

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), vertices.data(), vbByteSize, geo->VertexBufferUploader);
	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), cylinder.Indices32.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R32_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	geo->DrawArgs["cylinderWithoutTop"] = cylinderSubmesh;
	mGeometries[geo->Name] = std::move(geo);
}

void AppD3D::BuildRenderItems()
{
	UINT objCBIndex = 0;
	{
		auto boxRI = std::make_unique<RenderItem>();
		XMStoreFloat4x4(&boxRI->World, XMMatrixScaling(2.f, 2.f / 3.f, 2.f) * XMMatrixTranslation(0.f, 0.5f, -5.f));
		boxRI->ObjCBIndex = objCBIndex++;
		boxRI->Geo = mGeometries["shapeGeo"].get();
		boxRI->Mat = mMaterials["woodCrate"].get();
		boxRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		boxRI->IndexCount = boxRI->Geo->DrawArgs["box"].IndexCount;
		boxRI->StartIndexLocation = boxRI->Geo->DrawArgs["box"].StartIndexLocation;
		boxRI->BaseVertexLocation = boxRI->Geo->DrawArgs["box"].BaseVertexLocation;
		boxRI->VertexCount = boxRI->Geo->DrawArgs["box"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(boxRI.get());
		mAllRenderItems.push_back(std::move(boxRI));

		auto gridRI = std::make_unique<RenderItem>();
		gridRI->World = MathHelper::Identity4x4();
		XMStoreFloat4x4(&gridRI->TexTransform, XMMatrixScaling(8.0f, 8.0f, 1.0f));
		gridRI->ObjCBIndex = objCBIndex++;
		gridRI->Geo = mGeometries["shapeGeo"].get();
		gridRI->Mat = mMaterials["tile0"].get();
		gridRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		gridRI->IndexCount = gridRI->Geo->DrawArgs["grid"].IndexCount;
		gridRI->StartIndexLocation = gridRI->Geo->DrawArgs["grid"].StartIndexLocation;
		gridRI->BaseVertexLocation = gridRI->Geo->DrawArgs["grid"].BaseVertexLocation;
		gridRI->VertexCount = gridRI->Geo->DrawArgs["grid"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(gridRI.get());
		mAllRenderItems.push_back(std::move(gridRI));

		for (int i = 0; i < 5; ++i)
		{
			auto leftCylRitem = std::make_unique<RenderItem>();
			auto rightCylRitem = std::make_unique<RenderItem>();
			auto leftSphereRitem = std::make_unique<RenderItem>();
			auto rightGeoSphereRitem = std::make_unique<RenderItem>();

			XMMATRIX leftCylWorld = XMMatrixTranslation(-5.0f, 1.5f, -10.0f + i * 5.0f);
			XMMATRIX rightCylWorld = XMMatrixTranslation(+5.0f, 1.5f, -10.0f + i * 5.0f);

			XMMATRIX leftSphereWorld = XMMatrixTranslation(-5.0f, 3.5f, -10.0f + i * 5.0f);
			XMMATRIX rightSphereWorld = XMMatrixScaling(2.0f, 2.0f, 2.0f) * XMMatrixTranslation(+5.0f, 3.5f, -10.0f + i * 5.0f);

			XMStoreFloat4x4(&leftCylRitem->World, leftCylWorld);
			leftCylRitem->ObjCBIndex = objCBIndex++;
			leftCylRitem->Geo = mGeometries["shapeGeo"].get();
			leftCylRitem->Mat = mMaterials["bricks0"].get();
			leftCylRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
			leftCylRitem->IndexCount = leftCylRitem->Geo->DrawArgs["cylinder"].IndexCount;
			leftCylRitem->StartIndexLocation = leftCylRitem->Geo->DrawArgs["cylinder"].StartIndexLocation;
			leftCylRitem->BaseVertexLocation = leftCylRitem->Geo->DrawArgs["cylinder"].BaseVertexLocation;
			leftCylRitem->VertexCount = leftCylRitem->Geo->DrawArgs["cylinder"].VertexCount;
			mRenderItemLayer[(int)RenderLayer::Opaque].push_back(leftCylRitem.get());

			XMStoreFloat4x4(&rightCylRitem->World, rightCylWorld);
			rightCylRitem->ObjCBIndex = objCBIndex++;
			rightCylRitem->Geo = mGeometries["shapeGeo"].get();
			rightCylRitem->Mat = mMaterials["bricks0"].get();
			rightCylRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
			rightCylRitem->IndexCount = rightCylRitem->Geo->DrawArgs["cylinder"].IndexCount;
			rightCylRitem->StartIndexLocation = rightCylRitem->Geo->DrawArgs["cylinder"].StartIndexLocation;
			rightCylRitem->BaseVertexLocation = rightCylRitem->Geo->DrawArgs["cylinder"].BaseVertexLocation;
			rightCylRitem->VertexCount = rightCylRitem->Geo->DrawArgs["cylinder"].VertexCount;
			mRenderItemLayer[(int)RenderLayer::Opaque].push_back(rightCylRitem.get());

			XMStoreFloat4x4(&leftSphereRitem->World, leftSphereWorld);
			leftSphereRitem->ObjCBIndex = objCBIndex++;
			leftSphereRitem->Geo = mGeometries["shapeGeo"].get();
			leftSphereRitem->Mat = mMaterials["stone0"].get();
			leftSphereRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
			leftSphereRitem->IndexCount = leftSphereRitem->Geo->DrawArgs["sphere"].IndexCount;
			leftSphereRitem->StartIndexLocation = leftSphereRitem->Geo->DrawArgs["sphere"].StartIndexLocation;
			leftSphereRitem->BaseVertexLocation = leftSphereRitem->Geo->DrawArgs["sphere"].BaseVertexLocation;
			leftSphereRitem->VertexCount = leftSphereRitem->Geo->DrawArgs["sphere"].VertexCount;
			mRenderItemLayer[(int)RenderLayer::Opaque].push_back(leftSphereRitem.get());

			XMStoreFloat4x4(&rightGeoSphereRitem->World, rightSphereWorld);
			rightGeoSphereRitem->ObjCBIndex = objCBIndex++;
			rightGeoSphereRitem->Geo = mGeometries["shapeGeo"].get();
			rightGeoSphereRitem->Mat = mMaterials["stone0"].get();
			rightGeoSphereRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
			rightGeoSphereRitem->IndexCount = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].IndexCount;
			rightGeoSphereRitem->StartIndexLocation = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].StartIndexLocation;
			rightGeoSphereRitem->BaseVertexLocation = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].BaseVertexLocation;
			rightGeoSphereRitem->VertexCount = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].VertexCount;
			mRenderItemLayer[(int)RenderLayer::TriangleList].push_back(rightGeoSphereRitem.get());

			mAllRenderItems.push_back(std::move(leftCylRitem));
			mAllRenderItems.push_back(std::move(rightCylRitem));
			mAllRenderItems.push_back(std::move(leftSphereRitem));
			mAllRenderItems.push_back(std::move(rightGeoSphereRitem));
		}

		//land용
		auto landRI = std::make_unique<RenderItem>();
		XMStoreFloat4x4(&landRI->World, XMMatrixScaling(1, 1, 1) * XMMatrixTranslation(0, -5, 0));
		XMStoreFloat4x4(&landRI->TexTransform, XMMatrixScaling(5.0f, 5.0f, 1.0f));
		landRI->ObjCBIndex = objCBIndex++;
		landRI->Geo = mGeometries["landGeo"].get();
		landRI->Mat = mMaterials["grass0"].get();
		landRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		landRI->IndexCount = landRI->Geo->DrawArgs["grid"].IndexCount;
		landRI->StartIndexLocation = landRI->Geo->DrawArgs["grid"].StartIndexLocation;
		landRI->BaseVertexLocation = landRI->Geo->DrawArgs["grid"].BaseVertexLocation;
		landRI->VertexCount = landRI->Geo->DrawArgs["grid"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(landRI.get());
		mAllRenderItems.push_back(std::move(landRI));

		//waves용
		auto waveRI = std::make_unique<RenderItem>();
		XMStoreFloat4x4(&waveRI->World, XMMatrixScaling(1, 1, 1) * XMMatrixTranslation(0, -1, 0));
		XMStoreFloat4x4(&waveRI->TexTransform, XMMatrixScaling(5.0f, 5.0f, 1.0f));
		waveRI->DisplacementMapTexelSize.x = 1.0f / mWaves->ColumnCount();
		waveRI->DisplacementMapTexelSize.y = 1.0f / mWaves->RowCount();
		waveRI->ObjCBIndex = objCBIndex++;
		waveRI->Geo = mGeometries["waterGeo"].get();
		waveRI->Mat = mMaterials["water0"].get();
		waveRI->PrimitiveType = D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		waveRI->IndexCount = waveRI->Geo->DrawArgs["grid"].IndexCount;
		waveRI->StartIndexLocation = waveRI->Geo->DrawArgs["grid"].StartIndexLocation;
		waveRI->BaseVertexLocation = waveRI->Geo->DrawArgs["grid"].BaseVertexLocation;
		waveRI->VertexCount = waveRI->Geo->DrawArgs["grid"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Waves].push_back(waveRI.get());
		mWavesRenderItem = waveRI.get();
		mAllRenderItems.push_back(std::move(waveRI));

		//회전 텍스쳐 박스
		auto boxRI2 = std::make_unique<RenderItem>();
		XMStoreFloat4x4(&boxRI2->World, XMMatrixScaling(2.f, 2.f, 2.f) * XMMatrixTranslation(0.f, 2.f, 8.f));
		boxRI2->ObjCBIndex = objCBIndex++;
		boxRI2->Geo = mGeometries["shapeGeo"].get();
		boxRI2->Mat = mMaterials["swirling"].get();
		boxRI2->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		boxRI2->IndexCount = boxRI2->Geo->DrawArgs["box"].IndexCount;
		boxRI2->StartIndexLocation = boxRI2->Geo->DrawArgs["box"].StartIndexLocation;
		boxRI2->BaseVertexLocation = boxRI2->Geo->DrawArgs["box"].BaseVertexLocation;
		boxRI2->VertexCount = boxRI2->Geo->DrawArgs["box"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Multi].push_back(boxRI2.get());
		mAllRenderItems.push_back(std::move(boxRI2));

		//철망 박스
		auto boxRI3 = std::make_unique<RenderItem>();
		XMStoreFloat4x4(&boxRI3->World, XMMatrixScaling(1.f, 1.f, 1.f) * XMMatrixTranslation(0.f, 1.f, -10.f));
		boxRI3->ObjCBIndex = objCBIndex++;
		boxRI3->Geo = mGeometries["shapeGeo"].get();
		boxRI3->Mat = mMaterials["wireFence"].get();
		boxRI3->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		boxRI3->IndexCount = boxRI3->Geo->DrawArgs["box"].IndexCount;
		boxRI3->StartIndexLocation = boxRI3->Geo->DrawArgs["box"].StartIndexLocation;
		boxRI3->BaseVertexLocation = boxRI3->Geo->DrawArgs["box"].BaseVertexLocation;
		boxRI3->VertexCount = boxRI3->Geo->DrawArgs["box"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::AlphaTest].push_back(boxRI3.get());
		mAllRenderItems.push_back(std::move(boxRI3));
	}
	
	//거울 벽
	auto mirrorWallRI = std::make_unique<RenderItem>();
	XMMATRIX wM1 = XMMatrixScaling(0.3f, 1.0f, 1.0f) * XMMatrixRotationRollPitchYaw(0, 0, -XM_PIDIV2) * XMMatrixTranslation(-10.001, 3, 0);
	XMStoreFloat4x4(&mirrorWallRI->World, wM1);
	XMMATRIX wM2 = XMMatrixScaling(2.5f, 11.0f, 1.0f) * XMMatrixRotationZ(XM_PIDIV2);
	XMStoreFloat4x4(&mirrorWallRI->TexTransform, wM2);
	mirrorWallRI->ObjCBIndex = objCBIndex++;
	mirrorWallRI->Geo = mGeometries["shapeGeo"].get();
	mirrorWallRI->Mat = mMaterials["bricks1"].get();
	mirrorWallRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	mirrorWallRI->IndexCount = mirrorWallRI->Geo->DrawArgs["grid"].IndexCount;
	mirrorWallRI->StartIndexLocation = mirrorWallRI->Geo->DrawArgs["grid"].StartIndexLocation;
	mirrorWallRI->BaseVertexLocation = mirrorWallRI->Geo->DrawArgs["grid"].BaseVertexLocation;
	mirrorWallRI->VertexCount = mirrorWallRI->Geo->DrawArgs["grid"].VertexCount;
	mRenderItemLayer[(int)RenderLayer::MirrorWall].push_back(mirrorWallRI.get());
	mAllRenderItems.push_back(std::move(mirrorWallRI));

	//거울
	auto mirrorRI = std::make_unique<RenderItem>();
	XMMATRIX mirrorM1 = XMMatrixScaling(0.2f, 1.0f, 0.5f) * XMMatrixRotationRollPitchYaw(0, 0, -XM_PIDIV2) * XMMatrixTranslation(-10, 2, 0);
	XMStoreFloat4x4(&mirrorRI->World, mirrorM1);
	XMMATRIX mirrorM2 = XMMatrixScaling(1.0f, 2.0f, 1.0f) * XMMatrixRotationZ(XM_PIDIV2);
	XMStoreFloat4x4(&mirrorRI->TexTransform, mirrorM2);
	mirrorRI->ObjCBIndex = objCBIndex++;
	mirrorRI->Geo = mGeometries["shapeGeo"].get();
	mirrorRI->Mat = mMaterials["iceMirrorMat"].get();
	mirrorRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	mirrorRI->IndexCount = mirrorRI->Geo->DrawArgs["grid"].IndexCount;
	mirrorRI->StartIndexLocation = mirrorRI->Geo->DrawArgs["grid"].StartIndexLocation;
	mirrorRI->BaseVertexLocation = mirrorRI->Geo->DrawArgs["grid"].BaseVertexLocation;
	mirrorRI->VertexCount = mirrorRI->Geo->DrawArgs["grid"].VertexCount;
	mMirror = mirrorRI.get();
	mRenderItemLayer[(int)RenderLayer::MirrorStencil].push_back(mirrorRI.get());
	mRenderItemLayer[(int)RenderLayer::Transparent].push_back(mirrorRI.get());
	mAllRenderItems.push_back(std::move(mirrorRI));

	//skull용
	auto skullRI = std::make_unique<RenderItem>();
	XMMATRIX skullWorld = XMMatrixScaling(0.2f, 0.2f, 0.2f) * XMMatrixTranslation(0.f, 1.f, 0.f);
	XMStoreFloat4x4(&skullRI->World, skullWorld);
	skullRI->ObjCBIndex = objCBIndex++;
	skullRI->Geo = mGeometries["shapeGeo"].get();
	skullRI->Mat = mMaterials["skullMat"].get();
	skullRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	skullRI->IndexCount = skullRI->Geo->DrawArgs["skull"].IndexCount;
	skullRI->StartIndexLocation = skullRI->Geo->DrawArgs["skull"].StartIndexLocation;
	skullRI->BaseVertexLocation = skullRI->Geo->DrawArgs["skull"].BaseVertexLocation;
	skullRI->VertexCount = skullRI->Geo->DrawArgs["skull"].VertexCount;
	mSkull = skullRI.get();
	mRenderItemLayer[(int)RenderLayer::Opaque].push_back(skullRI.get());
	mAllRenderItems.push_back(std::move(skullRI));

	//거울 속 해골
	XMVECTOR mirrorPlane = GetMirrorPlane(); // x = -10 plane
	XMMATRIX R = XMMatrixReflect(mirrorPlane);
	XMMATRIX skullWorldM = XMLoadFloat4x4(&mSkull->World);
	auto reflectedSkullRitem = std::make_unique<RenderItem>();
	*reflectedSkullRitem = *mSkull;	//멤버 단위 복사
	reflectedSkullRitem->ObjCBIndex = objCBIndex++;
	XMStoreFloat4x4(&reflectedSkullRitem->World, skullWorldM * R);
	mRenderItemLayer[(int)RenderLayer::Reflected].push_back(reflectedSkullRitem.get());
	mAllRenderItems.push_back(std::move(reflectedSkullRitem));

	{
		//거울 백플레이트 - 바닥
		auto mirrorBackRI1 = std::make_unique<RenderItem>();
		XMMATRIX bM1 = XMMatrixScaling(1.0f, 1.0f, 1.0f) * XMMatrixRotationRollPitchYaw(0, 0, 0) * XMMatrixTranslation(-15, 0.1f, 0);
		XMStoreFloat4x4(&mirrorBackRI1->World, bM1);
		mirrorBackRI1->ObjCBIndex = objCBIndex++;
		mirrorBackRI1->Geo = mGeometries["shapeGeo"].get();
		mirrorBackRI1->Mat = mMaterials["shadowMat_skull"].get();
		mirrorBackRI1->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		mirrorBackRI1->IndexCount = mirrorBackRI1->Geo->DrawArgs["grid"].IndexCount;
		mirrorBackRI1->StartIndexLocation = mirrorBackRI1->Geo->DrawArgs["grid"].StartIndexLocation;
		mirrorBackRI1->BaseVertexLocation = mirrorBackRI1->Geo->DrawArgs["grid"].BaseVertexLocation;
		mirrorBackRI1->VertexCount = mirrorBackRI1->Geo->DrawArgs["grid"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Reflected].push_back(mirrorBackRI1.get());
		mAllRenderItems.push_back(std::move(mirrorBackRI1));

		//거울 백플레이트 - 뒤
		auto mirrorBackRI2 = std::make_unique<RenderItem>();
		XMMATRIX bM2 = XMMatrixScaling(1.0f, 1.0f, 1.0f) * XMMatrixRotationRollPitchYaw(0, 0, -XM_PIDIV2) * XMMatrixTranslation(-30, 3, 0);
		XMStoreFloat4x4(&mirrorBackRI2->World, bM2);
		mirrorBackRI2->ObjCBIndex = objCBIndex++;
		mirrorBackRI2->Geo = mGeometries["shapeGeo"].get();
		mirrorBackRI2->Mat = mMaterials["shadowMat_skull"].get();
		mirrorBackRI2->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		mirrorBackRI2->IndexCount = mirrorBackRI2->Geo->DrawArgs["grid"].IndexCount;
		mirrorBackRI2->StartIndexLocation = mirrorBackRI2->Geo->DrawArgs["grid"].StartIndexLocation;
		mirrorBackRI2->BaseVertexLocation = mirrorBackRI2->Geo->DrawArgs["grid"].BaseVertexLocation;
		mirrorBackRI2->VertexCount = mirrorBackRI2->Geo->DrawArgs["grid"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Reflected].push_back(mirrorBackRI2.get());
		mAllRenderItems.push_back(std::move(mirrorBackRI2));

		//거울 백플레이트 - 왼
		auto mirrorBackRI3 = std::make_unique<RenderItem>();
		XMMATRIX bM3 = XMMatrixScaling(1.0f, 1.0f, 1.0f) * XMMatrixRotationRollPitchYaw(XM_PIDIV2, 0, 0) * XMMatrixTranslation(-20, 0, -15);
		XMStoreFloat4x4(&mirrorBackRI3->World, bM3);
		mirrorBackRI3->ObjCBIndex = objCBIndex++;
		mirrorBackRI3->Geo = mGeometries["shapeGeo"].get();
		mirrorBackRI3->Mat = mMaterials["shadowMat_skull"].get();
		mirrorBackRI3->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		mirrorBackRI3->IndexCount = mirrorBackRI3->Geo->DrawArgs["grid"].IndexCount;
		mirrorBackRI3->StartIndexLocation = mirrorBackRI3->Geo->DrawArgs["grid"].StartIndexLocation;
		mirrorBackRI3->BaseVertexLocation = mirrorBackRI3->Geo->DrawArgs["grid"].BaseVertexLocation;
		mirrorBackRI3->VertexCount = mirrorBackRI3->Geo->DrawArgs["grid"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Reflected].push_back(mirrorBackRI3.get());
		mAllRenderItems.push_back(std::move(mirrorBackRI3));

		//거울 백플레이트 - 오
		auto mirrorBackRI4 = std::make_unique<RenderItem>();
		XMMATRIX bM4 = XMMatrixScaling(1.0f, 1.0f, 1.0f) * XMMatrixRotationRollPitchYaw(-XM_PIDIV2, 0, 0) * XMMatrixTranslation(-20, 0, 15);
		XMStoreFloat4x4(&mirrorBackRI4->World, bM4);
		mirrorBackRI4->ObjCBIndex = objCBIndex++;
		mirrorBackRI4->Geo = mGeometries["shapeGeo"].get();
		mirrorBackRI4->Mat = mMaterials["shadowMat_skull"].get();
		mirrorBackRI4->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		mirrorBackRI4->IndexCount = mirrorBackRI4->Geo->DrawArgs["grid"].IndexCount;
		mirrorBackRI4->StartIndexLocation = mirrorBackRI4->Geo->DrawArgs["grid"].StartIndexLocation;
		mirrorBackRI4->BaseVertexLocation = mirrorBackRI4->Geo->DrawArgs["grid"].BaseVertexLocation;
		mirrorBackRI4->VertexCount = mirrorBackRI4->Geo->DrawArgs["grid"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Reflected].push_back(mirrorBackRI4.get());
		mAllRenderItems.push_back(std::move(mirrorBackRI4));
	}
	
	//해골 그림자
	auto skullShadowRI = std::make_unique<RenderItem>();
	*skullShadowRI = *mSkull;
	skullShadowRI->ObjCBIndex = objCBIndex++;
	skullShadowRI->Mat = mMaterials["shadowMat_skull"].get();
	mSkullShadow = skullShadowRI.get();
	mRenderItemLayer[(int)RenderLayer::Shadow].push_back(skullShadowRI.get());
	mAllRenderItems.push_back(std::move(skullShadowRI));

	//트리 빌보드
	auto treeBillboardRI = std::make_unique<RenderItem>();
	treeBillboardRI->World = MathHelper::Identity4x4();
	treeBillboardRI->ObjCBIndex = objCBIndex++;
	treeBillboardRI->Mat = mMaterials["treeBillboardMat"].get();
	treeBillboardRI->Geo = mGeometries["treeBillboard"].get();
	treeBillboardRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_POINTLIST;
	treeBillboardRI->IndexCount = treeBillboardRI->Geo->DrawArgs["tree"].IndexCount;
	treeBillboardRI->StartIndexLocation = treeBillboardRI->Geo->DrawArgs["tree"].StartIndexLocation;
	treeBillboardRI->BaseVertexLocation = treeBillboardRI->Geo->DrawArgs["tree"].BaseVertexLocation;
	treeBillboardRI->VertexCount = treeBillboardRI->Geo->DrawArgs["tree"].VertexCount;
	mRenderItemLayer[(int)RenderLayer::AlphaTestedTreeSprites].push_back(treeBillboardRI.get());
	mAllRenderItems.push_back(std::move(treeBillboardRI));

	//마개 없는 원통
	auto cylRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&cylRI->World, XMMatrixScaling(1.f, 1.f, 1.f)* XMMatrixTranslation(0.f, 0.f, 13.f));
	cylRI->ObjCBIndex = objCBIndex++;
	cylRI->Mat = mMaterials["bricks0"].get();
	cylRI->Geo = mGeometries["cylinderWithoutTop"].get();
	cylRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_LINESTRIP;
	cylRI->IndexCount = cylRI->Geo->DrawArgs["cylinderWithoutTop"].IndexCount;
	cylRI->StartIndexLocation = cylRI->Geo->DrawArgs["cylinderWithoutTop"].StartIndexLocation;
	cylRI->BaseVertexLocation = cylRI->Geo->DrawArgs["cylinderWithoutTop"].BaseVertexLocation;
	cylRI->VertexCount = cylRI->Geo->DrawArgs["cylinderWithoutTop"].VertexCount;
	mRenderItemLayer[(int)RenderLayer::LineStrip].push_back(cylRI.get());
	mAllRenderItems.push_back(std::move(cylRI));

	//폭탄
	auto bombRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&bombRI->World, XMMatrixScaling(1.f, 1.f, 1.f)* XMMatrixTranslation(0.f, 6.0f, 0.0f));
	bombRI->ObjCBIndex = objCBIndex++;
	bombRI->Mat = mMaterials["bricks0"].get();
	bombRI->Geo = mGeometries["shapeGeo"].get();
	bombRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	bombRI->IndexCount = bombRI->Geo->DrawArgs["geoSphere"].IndexCount;
	bombRI->StartIndexLocation = bombRI->Geo->DrawArgs["geoSphere"].StartIndexLocation;
	bombRI->BaseVertexLocation = bombRI->Geo->DrawArgs["geoSphere"].BaseVertexLocation;
	bombRI->VertexCount = bombRI->Geo->DrawArgs["geoSphere"].VertexCount;
	mRenderItemLayer[(int)RenderLayer::Explode].push_back(bombRI.get());
	mAllRenderItems.push_back(std::move(bombRI));
}

void AppD3D::BuildFrameResources()
{
	for (int i = 0; i < gNumFrameResources; i++)
	{
		mFrameResources.push_back(
			std::make_unique<FrameResource>(
				md3dDevice.Get(),
				2,
				(UINT)mAllRenderItems.size(),
				(UINT)mWaves->VertexCount(),
				(UINT)mMaterials.size()));
	}
}

void AppD3D::BuildPSO()
{
	D3D12_GRAPHICS_PIPELINE_STATE_DESC opaquePsoDesc;
	ZeroMemory(&opaquePsoDesc, sizeof(D3D12_GRAPHICS_PIPELINE_STATE_DESC));
	opaquePsoDesc.InputLayout = { mInputLayout.data(), (UINT)mInputLayout.size() };
	opaquePsoDesc.pRootSignature = mRootSignature.Get();
	opaquePsoDesc.VS =
	{
		reinterpret_cast<BYTE*>(mShaders["standardVS"]->GetBufferPointer()),
		mShaders["standardVS"]->GetBufferSize()
	};
	opaquePsoDesc.PS =
	{
		reinterpret_cast<BYTE*>(mShaders["opaquePS"]->GetBufferPointer()),
		mShaders["opaquePS"]->GetBufferSize()
	};
	opaquePsoDesc.RasterizerState = CD3DX12_RASTERIZER_DESC(D3D12_DEFAULT);
	opaquePsoDesc.BlendState = CD3DX12_BLEND_DESC(D3D12_DEFAULT);
	opaquePsoDesc.DepthStencilState = CD3DX12_DEPTH_STENCIL_DESC(D3D12_DEFAULT);
	opaquePsoDesc.SampleMask = UINT_MAX; //모든 샘플 사용.
	opaquePsoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
	opaquePsoDesc.NumRenderTargets = 1;
	opaquePsoDesc.RTVFormats[0] = mBackBufferFormat;
	opaquePsoDesc.SampleDesc.Count = m4xMsaaState ? 4 : 1;
	opaquePsoDesc.SampleDesc.Quality = m4xMsaaState ? (m4xMsaaQuality - 1) : 0;
	opaquePsoDesc.DSVFormat = mdepthStencilFormat;
	ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&opaquePsoDesc, IID_PPV_ARGS(mPSOs["opaque"].GetAddressOf())));

	D3D12_GRAPHICS_PIPELINE_STATE_DESC opaqueWireframePsoDesc = opaquePsoDesc;
	opaqueWireframePsoDesc.RasterizerState.FillMode = D3D12_FILL_MODE_WIREFRAME;
	ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&opaqueWireframePsoDesc, IID_PPV_ARGS(&mPSOs["opaque_wireframe"])));

	D3D12_GRAPHICS_PIPELINE_STATE_DESC multiPsoDesc = opaquePsoDesc;
	multiPsoDesc.PS =
	{
		reinterpret_cast<BYTE*>(mShaders["multiPS"]->GetBufferPointer()),
		mShaders["multiPS"]->GetBufferSize()
	};
	ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&multiPsoDesc, IID_PPV_ARGS(&mPSOs["multiPSO"])));

	D3D12_GRAPHICS_PIPELINE_STATE_DESC transparentPsoDesc = opaquePsoDesc;

	D3D12_RENDER_TARGET_BLEND_DESC transparencyBlendDesc;
	transparencyBlendDesc.BlendEnable = true;
	transparencyBlendDesc.LogicOpEnable = false;
	transparencyBlendDesc.SrcBlend = D3D12_BLEND_SRC_ALPHA;
	transparencyBlendDesc.DestBlend = D3D12_BLEND_INV_SRC_ALPHA;
	transparencyBlendDesc.BlendOp = D3D12_BLEND_OP_ADD;
	transparencyBlendDesc.SrcBlendAlpha = D3D12_BLEND_ONE;
	transparencyBlendDesc.DestBlendAlpha = D3D12_BLEND_ZERO;
	transparencyBlendDesc.BlendOpAlpha = D3D12_BLEND_OP_ADD;
	transparencyBlendDesc.LogicOp = D3D12_LOGIC_OP_NOOP;
	transparencyBlendDesc.RenderTargetWriteMask = D3D12_COLOR_WRITE_ENABLE_ALL;

	//transparentPsoDesc.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
	transparentPsoDesc.BlendState.RenderTarget[0] = transparencyBlendDesc;
	ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&transparentPsoDesc, IID_PPV_ARGS(&mPSOs["transparent"])));

	D3D12_GRAPHICS_PIPELINE_STATE_DESC alphaTestedPsoDesc = opaquePsoDesc;
	alphaTestedPsoDesc.PS =
	{
		reinterpret_cast<BYTE*>(mShaders["alphaTestedPS"]->GetBufferPointer()),
		mShaders["alphaTestedPS"]->GetBufferSize()
	};
	alphaTestedPsoDesc.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
	ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&alphaTestedPsoDesc, IID_PPV_ARGS(&mPSOs["alphaTested"])));

	//스텐실 거울 용
	{
		CD3DX12_BLEND_DESC mirrorBlendState(D3D12_DEFAULT);
		mirrorBlendState.RenderTarget[0].RenderTargetWriteMask = 0;

		D3D12_DEPTH_STENCIL_DESC mirrorDSD;
		mirrorDSD.DepthEnable = true;
		mirrorDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
		mirrorDSD.DepthFunc = D3D12_COMPARISON_FUNC_LESS;
		mirrorDSD.StencilEnable = true;
		mirrorDSD.StencilReadMask = 0xff;
		mirrorDSD.StencilWriteMask = 0xff;

		mirrorDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_REPLACE;
		mirrorDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
		mirrorDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;
		mirrorDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_ALWAYS;

		//뒷면을 향하는 폴리곤은 렌더링하지 않으므로 설정 중요도 없음.
		mirrorDSD.BackFace = mirrorDSD.FrontFace;

		D3D12_GRAPHICS_PIPELINE_STATE_DESC mirrorStencilPsoDesc = opaquePsoDesc;
		mirrorStencilPsoDesc.BlendState = mirrorBlendState;
		mirrorStencilPsoDesc.DepthStencilState = mirrorDSD;
		mirrorStencilPsoDesc.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&mirrorStencilPsoDesc, IID_PPV_ARGS(mPSOs["mirrorStencil"].GetAddressOf())));

		D3D12_DEPTH_STENCIL_DESC reflectionsDSD;
		reflectionsDSD.DepthEnable = true;
		reflectionsDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ALL;
		reflectionsDSD.DepthFunc = D3D12_COMPARISON_FUNC_LESS;
		reflectionsDSD.StencilEnable = true;
		reflectionsDSD.StencilReadMask = 0xff;
		reflectionsDSD.StencilWriteMask = 0x00;

		reflectionsDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
		reflectionsDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;
		reflectionsDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_KEEP;
		reflectionsDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_EQUAL;

		//뒷면을 향하는 폴리곤은 렌더링하지 않으므로 설정 중요도 없음.
		reflectionsDSD.BackFace = reflectionsDSD.FrontFace;

		D3D12_GRAPHICS_PIPELINE_STATE_DESC drawReflectionsPsoDesc = opaquePsoDesc;
		drawReflectionsPsoDesc.DepthStencilState = reflectionsDSD;
		drawReflectionsPsoDesc.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
		drawReflectionsPsoDesc.RasterizerState.FrontCounterClockwise = true;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&drawReflectionsPsoDesc, IID_PPV_ARGS(&mPSOs["drawStencilReflections"])));

		//거울 벽용
		D3D12_DEPTH_STENCIL_DESC mirrorWallDSD;
		mirrorWallDSD.DepthEnable = true;
		mirrorWallDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ALL;
		mirrorWallDSD.DepthFunc = D3D12_COMPARISON_FUNC_LESS;
		mirrorWallDSD.StencilEnable = true;
		mirrorWallDSD.StencilReadMask = 0xff;
		mirrorWallDSD.StencilWriteMask = 0xff;

		mirrorWallDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
		mirrorWallDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;
		mirrorWallDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_KEEP;
		mirrorWallDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_NOT_EQUAL;

		mirrorWallDSD.BackFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
		mirrorWallDSD.BackFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;
		mirrorWallDSD.BackFace.StencilPassOp = D3D12_STENCIL_OP_ZERO;
		mirrorWallDSD.BackFace.StencilFunc = D3D12_COMPARISON_FUNC_ALWAYS;

		D3D12_GRAPHICS_PIPELINE_STATE_DESC mirrorWallPsoDesc = opaquePsoDesc;
		mirrorWallPsoDesc.DepthStencilState = mirrorWallDSD;
		mirrorWallPsoDesc.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&mirrorWallPsoDesc, IID_PPV_ARGS(mPSOs["mirrorWall"].GetAddressOf())));
	}	

	//투명도를 가진 그림자를 그릴 것이므로 투명도 설명을 기반으로 함.
	D3D12_DEPTH_STENCIL_DESC shadowDSD;
	shadowDSD.DepthEnable = true;
	shadowDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ALL;
	shadowDSD.DepthFunc = D3D12_COMPARISON_FUNC_LESS;
	shadowDSD.StencilEnable = true;
	shadowDSD.StencilReadMask = 0xff;
	shadowDSD.StencilWriteMask = 0xff;

	shadowDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	shadowDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;
	shadowDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_INCR;	//주의
	shadowDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_EQUAL;

	//뒷면을 향하는 폴리곤은 렌더링하지 않으므로 설정 중요도 없음.
	shadowDSD.BackFace = shadowDSD.FrontFace;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC shadowPsoDesc = transparentPsoDesc;
	shadowPsoDesc.DepthStencilState = shadowDSD;
	ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&shadowPsoDesc, IID_PPV_ARGS(&mPSOs["shadow"])));

	//깊이 복잡도 렌더링 용
	D3D12_DEPTH_STENCIL_DESC depthCountDSD;
	{
		depthCountDSD.DepthEnable = false;
		depthCountDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
		depthCountDSD.DepthFunc = D3D12_COMPARISON_FUNC_ALWAYS;
		depthCountDSD.StencilEnable = true;
		depthCountDSD.StencilReadMask = 0xff;
		depthCountDSD.StencilWriteMask = 0xff;

		depthCountDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
		depthCountDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_INCR_SAT;
		depthCountDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_INCR_SAT;
		depthCountDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_ALWAYS;

		//뒷면을 향하는 폴리곤은 렌더링하지 않으므로 설정 중요도 없음.
		depthCountDSD.BackFace = depthCountDSD.FrontFace;

		D3D12_GRAPHICS_PIPELINE_STATE_DESC depthCountPsoDesc = opaquePsoDesc;
		depthCountPsoDesc.BlendState.RenderTarget[0].RenderTargetWriteMask = 0;
		depthCountPsoDesc.DepthStencilState = depthCountDSD;

		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&depthCountPsoDesc, IID_PPV_ARGS(mPSOs["depthCount"].GetAddressOf())));

		D3D12_DEPTH_STENCIL_DESC depthComplexityDSD;
		depthComplexityDSD.DepthEnable = false;
		depthComplexityDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
		depthComplexityDSD.DepthFunc = D3D12_COMPARISON_FUNC_ALWAYS;
		depthComplexityDSD.StencilEnable = true;
		depthComplexityDSD.StencilReadMask = 0xff;
		depthComplexityDSD.StencilWriteMask = 0x00;

		depthComplexityDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
		depthComplexityDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;
		depthComplexityDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_KEEP;
		depthComplexityDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_EQUAL;

		//뒷면을 향하는 폴리곤은 렌더링하지 않으므로 설정 중요도 없음.
		depthComplexityDSD.BackFace = depthComplexityDSD.FrontFace;

		D3D12_GRAPHICS_PIPELINE_STATE_DESC depthComplexityPsoDesc = depthCountPsoDesc;
		depthComplexityPsoDesc.BlendState.RenderTarget[0].RenderTargetWriteMask = D3D12_COLOR_WRITE_ENABLE_ALL;
		depthComplexityPsoDesc.DepthStencilState = depthComplexityDSD;
		depthComplexityPsoDesc.InputLayout = { nullptr, 0 };
		depthComplexityPsoDesc.pRootSignature = mRootSignature_debug.Get();
		depthComplexityPsoDesc.VS =
		{
			reinterpret_cast<BYTE*>(mShaders["debugVS"]->GetBufferPointer()),
			mShaders["debugVS"]->GetBufferSize()
		};
		depthComplexityPsoDesc.PS =
		{
			reinterpret_cast<BYTE*>(mShaders["debugPS"]->GetBufferPointer()),
			mShaders["debugPS"]->GetBufferSize()
		};

		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&depthComplexityPsoDesc, IID_PPV_ARGS(mPSOs["debugComplexity"].GetAddressOf())));
	}

	//트리 빌보드 용
	{
		D3D12_GRAPHICS_PIPELINE_STATE_DESC treeBillboardPsoDesc = opaquePsoDesc;
		treeBillboardPsoDesc.VS = 
		{
			reinterpret_cast<BYTE*>(mShaders["treeBillboardVS"]->GetBufferPointer()),
			mShaders["treeBillboardVS"]->GetBufferSize()
		};
		treeBillboardPsoDesc.GS =
		{
			reinterpret_cast<BYTE*>(mShaders["treeBillboardGS"]->GetBufferPointer()),
			mShaders["treeBillboardGS"]->GetBufferSize()
		};
		treeBillboardPsoDesc.PS =
		{
			reinterpret_cast<BYTE*>(mShaders["treeBillboardPS"]->GetBufferPointer()),
			mShaders["treeBillboardPS"]->GetBufferSize()
		};
		treeBillboardPsoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_POINT;
		treeBillboardPsoDesc.InputLayout = { mTreeBillboardInputLayout.data(), (UINT)mTreeBillboardInputLayout.size() };
		treeBillboardPsoDesc.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
		treeBillboardPsoDesc.BlendState.AlphaToCoverageEnable = true;	//멀티샘플링이 활성화된 경우, 픽셀의 coverage에 따라 알파 블렌딩이 자동으로 적용됨.

		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&treeBillboardPsoDesc, IID_PPV_ARGS(&mPSOs["treeBillboard"])));

		D3D12_GRAPHICS_PIPELINE_STATE_DESC treeBillboard_wireframePsoDesc = treeBillboardPsoDesc;
		treeBillboard_wireframePsoDesc.RasterizerState.FillMode = D3D12_FILL_MODE_WIREFRAME;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&treeBillboard_wireframePsoDesc, IID_PPV_ARGS(&mPSOs["treeBillboard_wireframe"])));

		D3D12_GRAPHICS_PIPELINE_STATE_DESC treeBillboard_depthCountPsoDesc = treeBillboardPsoDesc;
		treeBillboard_depthCountPsoDesc.BlendState.RenderTarget[0].RenderTargetWriteMask = 0;
		treeBillboard_depthCountPsoDesc.DepthStencilState = depthCountDSD;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&treeBillboard_depthCountPsoDesc, IID_PPV_ARGS(&mPSOs["treeBillboard_depthCount"])));
	}

	{
		//circle extent shader용
		D3D12_GRAPHICS_PIPELINE_STATE_DESC circleExPsoDesc = opaquePsoDesc;
		circleExPsoDesc.VS =
		{
			reinterpret_cast<BYTE*>(mShaders["circleExVS"]->GetBufferPointer()),
			mShaders["circleExVS"]->GetBufferSize()
		};
		circleExPsoDesc.GS =
		{
			reinterpret_cast<BYTE*>(mShaders["circleExGS"]->GetBufferPointer()),
			mShaders["circleExGS"]->GetBufferSize()
		};
		circleExPsoDesc.PS =
		{
			reinterpret_cast<BYTE*>(mShaders["circleExPS"]->GetBufferPointer()),
			mShaders["circleExPS"]->GetBufferSize()
		};
		circleExPsoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_LINE;
		circleExPsoDesc.InputLayout = { mInputLayout.data(), (UINT)mInputLayout.size() };
		circleExPsoDesc.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&circleExPsoDesc, IID_PPV_ARGS(&mPSOs["circleEx"])));

		D3D12_GRAPHICS_PIPELINE_STATE_DESC circleEx_wireframePsoDesc = circleExPsoDesc;
		circleEx_wireframePsoDesc.RasterizerState.FillMode = D3D12_FILL_MODE_WIREFRAME;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&circleEx_wireframePsoDesc, IID_PPV_ARGS(&mPSOs["circleEx_wireframe"])));

		D3D12_GRAPHICS_PIPELINE_STATE_DESC circleEx_depthCountPsoDesc = circleExPsoDesc;
		circleEx_depthCountPsoDesc.BlendState.RenderTarget[0].RenderTargetWriteMask = 0;
		circleEx_depthCountPsoDesc.DepthStencilState = depthCountDSD;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&circleEx_depthCountPsoDesc, IID_PPV_ARGS(&mPSOs["circleEx_depthCount"])));

		//LOD GeoSphere 용
		D3D12_GRAPHICS_PIPELINE_STATE_DESC geoSpherePsoDesc = circleExPsoDesc;
		geoSpherePsoDesc.GS =
		{
			reinterpret_cast<BYTE*>(mShaders["LOD_GS"]->GetBufferPointer()),
			mShaders["LOD_GS"]->GetBufferSize()
		};
		geoSpherePsoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&geoSpherePsoDesc, IID_PPV_ARGS(&mPSOs["geoSphereLOD"])));

		D3D12_GRAPHICS_PIPELINE_STATE_DESC geoSphere_wireframePsoDesc = geoSpherePsoDesc;
		geoSphere_wireframePsoDesc.RasterizerState.FillMode = D3D12_FILL_MODE_WIREFRAME;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&geoSphere_wireframePsoDesc, IID_PPV_ARGS(&mPSOs["geoSphereLOD_wireframe"])));

		D3D12_GRAPHICS_PIPELINE_STATE_DESC geoSphere_depthCountPsoDesc = geoSpherePsoDesc;
		geoSphere_depthCountPsoDesc.BlendState.RenderTarget[0].RenderTargetWriteMask = 0;
		geoSphere_depthCountPsoDesc.DepthStencilState = depthCountDSD;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&geoSphere_depthCountPsoDesc, IID_PPV_ARGS(&mPSOs["geoSphereLOD_depthCount"])));


		//Explode shader 용
		D3D12_GRAPHICS_PIPELINE_STATE_DESC explodePsoDesc = circleExPsoDesc;
		explodePsoDesc.GS =
		{
			reinterpret_cast<BYTE*>(mShaders["explodeGS"]->GetBufferPointer()),
			mShaders["explodeGS"]->GetBufferSize()
		};
		explodePsoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
		explodePsoDesc.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&explodePsoDesc, IID_PPV_ARGS(&mPSOs["explode"])));
	}

	//정점 법선 디버깅 용
	{
		D3D12_GRAPHICS_PIPELINE_STATE_DESC vertexNormalDebugPsoDesc = opaquePsoDesc;
		vertexNormalDebugPsoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_POINT;
		vertexNormalDebugPsoDesc.VS =
		{
			reinterpret_cast<BYTE*>(mShaders["circleExVS"]->GetBufferPointer()),
			mShaders["circleExVS"]->GetBufferSize()
		};
		vertexNormalDebugPsoDesc.GS =
		{
			reinterpret_cast<BYTE*>(mShaders["vertexDebugGS"]->GetBufferPointer()),
			mShaders["vertexDebugGS"]->GetBufferSize()
		};
		vertexNormalDebugPsoDesc.PS =
		{
			reinterpret_cast<BYTE*>(mShaders["vertexDebugPS"]->GetBufferPointer()),
			mShaders["vertexDebugPS"]->GetBufferSize()
		};
		vertexNormalDebugPsoDesc.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
		vertexNormalDebugPsoDesc.BlendState.RenderTarget[0].RenderTargetWriteMask = D3D12_COLOR_WRITE_ENABLE_ALL;
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&vertexNormalDebugPsoDesc, IID_PPV_ARGS(&mPSOs["vertexNormalDebug"])));
	}

	//GPU Wave용
	{
		D3D12_GRAPHICS_PIPELINE_STATE_DESC wavesRenderPSO = transparentPsoDesc;
		wavesRenderPSO.VS =
		{
			reinterpret_cast<BYTE*>(mShaders["wavesVS"]->GetBufferPointer()),
			mShaders["wavesVS"]->GetBufferSize()
		};
		ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&wavesRenderPSO, IID_PPV_ARGS(&mPSOs["wavesRender"])));

		D3D12_COMPUTE_PIPELINE_STATE_DESC wavesDisturbPSO = {};
		wavesDisturbPSO.pRootSignature = mWavesRootSignature.Get();
		wavesDisturbPSO.CS =
		{
			reinterpret_cast<BYTE*>(mShaders["wavesDisturbCS"]->GetBufferPointer()),
			mShaders["wavesDisturbCS"]->GetBufferSize()
		};
		wavesDisturbPSO.Flags = D3D12_PIPELINE_STATE_FLAG_NONE;
		ThrowIfFailed(md3dDevice->CreateComputePipelineState(&wavesDisturbPSO, IID_PPV_ARGS(&mPSOs["wavesDisturb"])));

		D3D12_COMPUTE_PIPELINE_STATE_DESC wavesUpdatePSO = {};
		wavesUpdatePSO.pRootSignature = mWavesRootSignature.Get();
		wavesUpdatePSO.CS =
		{
			reinterpret_cast<BYTE*>(mShaders["wavesUpdateCS"]->GetBufferPointer()),
			mShaders["wavesUpdateCS"]->GetBufferSize()
		};
		wavesUpdatePSO.Flags = D3D12_PIPELINE_STATE_FLAG_NONE;
		ThrowIfFailed(md3dDevice->CreateComputePipelineState(&wavesUpdatePSO, IID_PPV_ARGS(&mPSOs["wavesUpdate"])));
	}
}

void AppD3D::SetDebugColorCB()
{
	std::vector<DebugColorConstants> colors =
	{
		{ XMFLOAT4{1.0f, 0.0f, 0.0f, 1.0f} },   // 빨강
		{ XMFLOAT4{1.0f, 0.5f, 0.0f, 1.0f} },   // 주황
		{ XMFLOAT4{1.0f, 1.0f, 0.0f, 1.0f} },   // 노랑
		{ XMFLOAT4{0.0f, 1.0f, 0.0f, 1.0f} },   // 초록
		{ XMFLOAT4{0.0f, 0.0f, 1.0f, 1.0f} }    // 파랑
	};

	for (auto& f : mFrameResources)
	{
		for (int i = 0; i < f->debugColorNum; i++)
			f->debugColorCB->CopyData(i, colors[i]);
	}
}

bool AppD3D::InitImGui()
{
	ImGui::CreateContext();
	ImGui_ImplWin32_Init(mhMainWnd);

	UINT textureCount = (UINT)mTextures.size();
	UINT imguiFontIndex = textureCount;

	CD3DX12_CPU_DESCRIPTOR_HANDLE cpuHandle(
		mSrvHeap->GetCPUDescriptorHandleForHeapStart());
	cpuHandle.Offset(imguiFontIndex, mCbvSrvUavDescriptorSize);

	CD3DX12_GPU_DESCRIPTOR_HANDLE gpuHandle(
		mSrvHeap->GetGPUDescriptorHandleForHeapStart());
	gpuHandle.Offset(imguiFontIndex, mCbvSrvUavDescriptorSize);

	ImGui_ImplDX12_InitInfo init_info = {};
	init_info.Device = md3dDevice.Get();
	init_info.CommandQueue = mCommandQueue.Get();
	init_info.NumFramesInFlight = gNumFrameResources;
	init_info.RTVFormat = mBackBufferFormat;
	init_info.DSVFormat = mdepthStencilFormat;
	init_info.SrvDescriptorHeap = mSrvHeap.Get();
	init_info.LegacySingleSrvCpuDescriptor = cpuHandle;
	init_info.LegacySingleSrvGpuDescriptor = gpuHandle;

	ImGui_ImplDX12_Init(&init_info);

	ImGuiIO& io = ImGui::GetIO();

	io.Fonts->AddFontFromFileTTF(
		"C:\\Windows\\Fonts\\malgun.ttf",  // 맑은 고딕
		18.0f,
		nullptr,
		io.Fonts->GetGlyphRangesKorean()
	);
	ImGui_ImplDX12_InvalidateDeviceObjects();
	ImGui_ImplDX12_CreateDeviceObjects();

	return mImGuiInitialized = true;
}

void AppD3D::RenderImGui()
{
	ImGui_ImplDX12_NewFrame();
	ImGui_ImplWin32_NewFrame();
	ImGui::NewFrame();

	//ImGui::ShowDemoWindow(&mIsShowHelper);

	if (mIsShowHelper)
	{
		ImGui::SetNextWindowPos(ImVec2(5, 5), ImGuiCond_Appearing);
		ImGui::SetNextWindowSize(ImVec2(240, 230), ImGuiCond_Appearing);

		ImGui::Begin(u8"조작 안내", &mIsShowHelper, ImGuiWindowFlags_NoResize);

		ImGui::TextUnformatted(u8"화면 드래그 : 화면 회전");
		ImGui::TextUnformatted(u8"마우스 휠   : 확대 / 축소");
		ImGui::Separator();
		ImGui::TextUnformatted(u8"W A S D     : 이동");
		ImGui::TextUnformatted(u8"Q / E       : 위 / 아래 이동");
		ImGui::Separator();
		ImGui::TextUnformatted(u8"방향키      : 주광원 이동");
		ImGui::Separator();
		ImGui::TextUnformatted(u8"숫자 1		: 와이어 프레임 모드");
		ImGui::TextUnformatted(u8"숫자 2		: 깊이 복잡도 렌더 모드");
		ImGui::TextUnformatted(u8"숫자 3		: 정점 법선 렌더 모드");

		ImGui::TextUnformatted(u8"F2		: MSAA 4x 모드 토글");

		ImGui::End();
	}
	else
	{
		ImGui::SetNextWindowPos(ImVec2(0, 0), ImGuiCond_Once);
		ImGui::SetNextWindowBgAlpha(0.0f);

		UINT index = mTextures["helpTex"]->DiffuseSrvHeapIndex;

		CD3DX12_GPU_DESCRIPTOR_HANDLE handle(
			mSrvHeap->GetGPUDescriptorHandleForHeapStart());
		handle.Offset(index, mCbvSrvUavDescriptorSize);

		ImGui::Begin("overlay",
			nullptr,
			ImGuiWindowFlags_NoDecoration	|
			ImGuiWindowFlags_NoBackground	|
			ImGuiWindowFlags_NoMove);

		ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.7, 0.7, 0.7, 0.5));
		ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.7, 0.7, 0.7, 0.7));
		ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImVec4(0.8, 0.8, 0.8, 0.7));

		if (ImGui::ImageButton("btn", (ImTextureID)handle.ptr, ImVec2(40, 40)))
		{
			mIsShowHelper = true;
		}
		ImGui::PopStyleColor(3);
		ImGui::End();
	}

	ImGui::Render();

	ImGui_ImplDX12_RenderDrawData(
		ImGui::GetDrawData(),
		mCommandList.Get());
}

void AppD3D::ResolveMsaaToBackBuffer()
{
	auto msaaBarrier = CD3DX12_RESOURCE_BARRIER::Transition(
		mMsaaRenderTarget.Get(),
		D3D12_RESOURCE_STATE_RENDER_TARGET,
		D3D12_RESOURCE_STATE_RESOLVE_SOURCE);
	mCommandList->ResourceBarrier(1, &msaaBarrier);

	mCommandList->ResolveSubresource(
		CurrentBackBuffer(),
		0,
		mMsaaRenderTarget.Get(),
		0,
		mBackBufferFormat);

	msaaBarrier = CD3DX12_RESOURCE_BARRIER::Transition(
		mMsaaRenderTarget.Get(),
		D3D12_RESOURCE_STATE_RESOLVE_SOURCE,
		D3D12_RESOURCE_STATE_RENDER_TARGET);
	mCommandList->ResourceBarrier(1, &msaaBarrier);

	msaaBarrier = CD3DX12_RESOURCE_BARRIER::Transition(
		CurrentBackBuffer(),
		D3D12_RESOURCE_STATE_RESOLVE_DEST,
		D3D12_RESOURCE_STATE_RENDER_TARGET);
	mCommandList->ResourceBarrier(1, &msaaBarrier);

	auto uiRtv = CurrentBackBufferView();
	mCommandList->OMSetRenderTargets(1, &uiRtv, true, nullptr);
}

void AppD3D::DrawFullscreenTriangle(ID3D12GraphicsCommandList* cmdList)
{
	int num = mCurrFrameResource->debugColorNum;
	UINT debugColorCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(DebugColorConstants));

	cmdList->IASetVertexBuffers(0, 0, nullptr);
	cmdList->IASetIndexBuffer(nullptr);
	cmdList->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

	for (int i = 0; i < num; i++)
	{
		cmdList->OMSetStencilRef(i + 1);
		cmdList->SetGraphicsRootConstantBufferView(
			0,
			mCurrFrameResource->debugColorCB->Resource()->GetGPUVirtualAddress() + i * debugColorCBByteSize);
		cmdList->DrawInstanced(3, 1, 0, 0);
	}
}

XMVECTOR AppD3D::GetMirrorPlane()
{
	XMMATRIX W = XMLoadFloat4x4(&mMirror->World);

	XMVECTOR pLocal = XMVectorSet(0.0f, 0.0f, 0.0f, 1.0f);
	XMVECTOR nLocal = XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f); // grid가 XZ plane일 때

	XMVECTOR pWorld = XMVector3TransformCoord(pLocal, W);

	XMMATRIX invTransW = XMMatrixTranspose(XMMatrixInverse(nullptr, W));
	XMVECTOR nWorld = XMVector3TransformNormal(nLocal, invTransW);
	nWorld = XMVector3Normalize(nWorld);

	float d = -XMVectorGetX(XMVector3Dot(nWorld, pWorld));

	return XMVectorSet(
		XMVectorGetX(nWorld),
		XMVectorGetY(nWorld),
		XMVectorGetZ(nWorld),
		d);
}

void AppD3D::OnKeyboardInput(const GameTimer& gt)
{
	static bool prevKeyDown1 = false;
	static bool prevKeyDown2 = false;
	static bool prevKeyDown3 = false;

	bool KeyDown1 = (GetAsyncKeyState('1') & 0x8000) != 0;
	bool KeyDown2 = (GetAsyncKeyState('2') & 0x8000) != 0;
	bool KeyDown3 = (GetAsyncKeyState('3') & 0x8000) != 0;

	// 키가 "눌린 순간"만 감지
	if (KeyDown1 && !prevKeyDown1)
	{
		mIsWireframe = !mIsWireframe;
		mIsDepthComplexityDebug = false;
		mIsVertexNormalDebug = false;
	}
	if (KeyDown2 && !prevKeyDown2)
	{
		mIsDepthComplexityDebug = !mIsDepthComplexityDebug;
		mIsWireframe = false;
		mIsVertexNormalDebug = false;
	}
	if (KeyDown3 && !prevKeyDown3)
	{
		mIsVertexNormalDebug = !mIsVertexNormalDebug;
		mIsWireframe = false;
		mIsDepthComplexityDebug = false;
	}

	prevKeyDown1 = KeyDown1;
	prevKeyDown2 = KeyDown2;
	prevKeyDown3 = KeyDown3;

	const float dt = gt.DeltaTime();

	if (GetAsyncKeyState(VK_LEFT) & 0x8000)
		mSunTheta -= 1.0f * dt;

	if (GetAsyncKeyState(VK_RIGHT) & 0x8000)
		mSunTheta += 1.0f * dt;

	if (GetAsyncKeyState(VK_UP) & 0x8000)
		mSunPhi -= 1.0f * dt;

	if (GetAsyncKeyState(VK_DOWN) & 0x8000)
		mSunPhi += 1.0f * dt;

	mSunPhi = MathHelper::Clamp(mSunPhi, 0.1f, XM_PIDIV2);
}

void AppD3D::UpdateCamera(const GameTimer& gt)
{
	mEyePos.x = mRadius * sinf(mPhi) * cosf(mTheta);
	mEyePos.y = mRadius * cosf(mPhi);
	mEyePos.z = mRadius * sinf(mPhi) * sinf(mTheta);
	auto eye = XMLoadFloat3(&mEyePos);

	XMVECTOR pos = XMVectorSetW(eye, 1.f);
	XMVECTOR target = XMVectorZero();
	XMVECTOR up = XMVectorSet(0.f, 1.f, 0.f, 0.f);

	//좌수 좌표계 행렬 생성.
	XMMATRIX view = XMMatrixLookAtLH(pos, target, up);
	XMStoreFloat4x4(&mView, view);
}

void AppD3D::UpdateObjectCBs(const GameTimer& gt)
{
	auto currObjectCB = mCurrFrameResource->ObjectCB.get();
	for (auto& e : mAllRenderItems)
	{
		if (e->NumFramesDirty > 0)
		{
			XMMATRIX world = XMLoadFloat4x4(&e->World);
			XMMATRIX texTransform = XMLoadFloat4x4(&e->TexTransform);

			ObjectConstants objConstants;
			XMStoreFloat4x4(&objConstants.World, XMMatrixTranspose(world));
			XMStoreFloat4x4(&objConstants.TexTransform, XMMatrixTranspose(texTransform));
			objConstants.DisplacementMapTexelSize = e->DisplacementMapTexelSize;
			objConstants.GridSpatialStep = e->GridSpatialStep;

			currObjectCB->CopyData(e->ObjCBIndex, objConstants);
			e->NumFramesDirty--;
		}
	}
}

void AppD3D::UpdateMainPassCB(const GameTimer& gt)
{
	XMMATRIX cam = XMLoadFloat4x4(&mCamPos);

	XMMATRIX view = XMLoadFloat4x4(&mView) * cam;
	XMMATRIX proj = XMLoadFloat4x4(&mProj);

	XMMATRIX viewProj = XMMatrixMultiply(view, proj);
	XMVECTOR viewDet = XMMatrixDeterminant(view);
	auto projDet = XMMatrixDeterminant(proj);
	auto viewProjDet = XMMatrixDeterminant(viewProj);
	auto invView = XMMatrixInverse(&viewDet, view);
	XMMATRIX invProj = XMMatrixInverse(&projDet, proj);
	XMMATRIX invViewProj = XMMatrixInverse(&viewProjDet, viewProj);

	XMStoreFloat4x4(&mMainPassCB.View, XMMatrixTranspose(view));
	XMStoreFloat4x4(&mMainPassCB.InvView, XMMatrixTranspose(invView));
	XMStoreFloat4x4(&mMainPassCB.Proj, XMMatrixTranspose(proj));
	XMStoreFloat4x4(&mMainPassCB.InvProj, XMMatrixTranspose(invProj));
	XMStoreFloat4x4(&mMainPassCB.ViewProj, XMMatrixTranspose(viewProj));
	XMStoreFloat4x4(&mMainPassCB.InvViewProj, XMMatrixTranspose(invViewProj));

	mMainPassCB.EyePosW = mEyePos;
	mMainPassCB.RenderTargetSize = XMFLOAT2((float)mClientWidth, (float)mClientHeight);
	mMainPassCB.InvRenderTargetSize = XMFLOAT2(1.0f / mClientWidth, 1.0f / mClientHeight);
	mMainPassCB.NearZ = 1.0f;
	mMainPassCB.FarZ = 1000.0f;
	mMainPassCB.TotalTime = gt.TotalTime();
	mMainPassCB.DeltaTime = gt.DeltaTime();
	mMainPassCB.AmbientLight = { 0.25f, 0.25f, 0.35f, 1.0f };

	mMainPassCB.Lights[0].Direction = { 0.57735f, -0.57735f, 0.57735f };
	mMainPassCB.Lights[0].Strength = { 0.6f, 0.6f, 0.6f };
	mMainPassCB.Lights[1].Direction = { -0.57735f, -0.57735f, 0.57735f };
	mMainPassCB.Lights[1].Strength = { 0.3f, 0.3f, 0.3f };
	mMainPassCB.Lights[2].Direction = { 0.0f, -0.707f, -0.707f };
	mMainPassCB.Lights[2].Strength = { 0.15f, 0.15f, 0.15f };

	mMainPassCB.gFogColor = { 0.7f, 0.7f, 0.7f, 1.0f };
	mMainPassCB.gFogStart = 5.f;
	mMainPassCB.gFogRange = 150.f;

	XMVECTOR lightDir = -MathHelper::SphericalToCatesian(1.0, mSunTheta, mSunPhi);
	XMStoreFloat3(&mMainPassCB.Lights[0].Direction, lightDir);

	auto currPassCB = mCurrFrameResource->PassCB.get();
	currPassCB->CopyData(0, mMainPassCB);
}

void AppD3D::UpdateReflectedPassCB(const GameTimer& gt)
{
	mReflectedPassCB = mMainPassCB;

	XMVECTOR mirrorPlane = GetMirrorPlane(); // x = -10 plane
	XMMATRIX R = XMMatrixReflect(mirrorPlane);

	for (int i = 0; i < 3; i++)
	{
		XMVECTOR lightDir = XMLoadFloat3(&mMainPassCB.Lights[i].Direction);
		XMVECTOR reflectedLightDir = XMVector3TransformNormal(lightDir, R);
		XMStoreFloat3(&mReflectedPassCB.Lights[i].Direction, reflectedLightDir);
	}

	auto currPassCB = mCurrFrameResource->PassCB.get();
	currPassCB->CopyData(1, mReflectedPassCB);
}

void AppD3D::UpdateMaterialCBs(const GameTimer& gt)
{
	auto currMaterialCB = mCurrFrameResource->MaterialCB.get();
	for (auto& e : mMaterials)
	{
		Material* mat = e.second.get();
		if (mat->NumFramesDirty > 0)
		{
			XMMATRIX matTransform = XMLoadFloat4x4(&mat->MatTransform);

			MaterialConstants matConstants;
			matConstants.DiffuseAlbedo = mat->DiffuseAlbedo;
			matConstants.FresnelR0 = mat->FresnelR0;
			matConstants.Roughness = mat->Roughness;
			XMStoreFloat4x4(&matConstants.MatTransform, XMMatrixTranspose(matTransform));

			currMaterialCB->CopyData(mat->MatCBIndex, matConstants);
			mat->NumFramesDirty--;
		}
	}
}

void AppD3D::UpdateWavesGPU(const GameTimer& gt)
{
	static float t_base = 0.0f;
	if ((mTimer.TotalTime() - t_base) >= 0.25f)
	{
		t_base += 0.25f;

		int i = MathHelper::Rand(4, mWaves->RowCount() - 5);
		int j = MathHelper::Rand(4, mWaves->ColumnCount() - 5);

		float r = MathHelper::RandF(0.5f, 1.0f);

		mWaves->Disturb(mCommandList.Get(), mWavesRootSignature.Get(), mPSOs["wavesDisturb"].Get(), i, j, r);
	}

	// Update the wave simulation.
	mWaves->Update(gt, mCommandList.Get(), mWavesRootSignature.Get(), mPSOs["wavesUpdate"].Get());
}

void AppD3D::UpdateShadowTransform()
{
	//빛 전환에 따른 해골 그림자 변환.
	XMVECTOR shadowPlane = XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f); // xz plane
	XMVECTOR toMainLight = -XMLoadFloat3(&mMainPassCB.Lights[0].Direction);
	XMMATRIX S = XMMatrixShadow(shadowPlane, toMainLight);
	XMMATRIX shadowOffsetY = XMMatrixTranslation(0.0f, 0.001f, 0.0f);
	XMMATRIX skullWorld = XMLoadFloat4x4(&mSkull->World);
	XMStoreFloat4x4(&mSkullShadow->World, skullWorld * S * shadowOffsetY);
	mSkullShadow->NumFramesDirty = gNumFrameResources;
}

void AppD3D::AnimateMaterials(const GameTimer& gt)
{
	auto waterMat = mMaterials["water0"].get();

	//변환행렬의 x,y 이동 부분
	float& tu = waterMat->MatTransform(3, 0);
	float& tv = waterMat->MatTransform(3, 1);

	tu += 0.1f * gt.DeltaTime();
	tv += 0.02f * gt.DeltaTime();

	if (tu >= 1.0f) tu -= 1.0f;
	if (tv >= 1.0f) tv -= 1.0f;

	waterMat->NumFramesDirty = gNumFrameResources;


	//파이어볼 회전 애니메이션
	auto swirlingMat = mMaterials["swirling"].get();
	XMMATRIX R = XMMatrixRotationZ(1.5f * gt.TotalTime());
	XMMATRIX T0 = XMMatrixTranslation(-0.5f, -0.5f, 0.0f);
	XMMATRIX T1 = XMMatrixTranslation(0.5f, 0.5f, 0.0f);
	XMMATRIX M = T0 * R * T1;
	XMStoreFloat4x4(&swirlingMat->MatTransform, M);
	swirlingMat->NumFramesDirty = gNumFrameResources;
}

void AppD3D::DrawRenderItems(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayer)
{
	UINT objCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(ObjectConstants));
	UINT matCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(MaterialConstants));

	auto objectCB = mCurrFrameResource->ObjectCB->Resource();
	auto matCB = mCurrFrameResource->MaterialCB->Resource();

	//멀티 텍스쳐에 사용되는 특수 텍스쳐
	CD3DX12_GPU_DESCRIPTOR_HANDLE hTable(mSrvHeap->GetGPUDescriptorHandleForHeapStart());
	hTable.Offset(mTextures["swirlingMaskTex"]->DiffuseSrvHeapIndex, mCbvSrvUavDescriptorSize);
	cmdList->SetGraphicsRootDescriptorTable(1, hTable);

	for (auto& ri : renderLayer)
	{
		auto vbv = ri->Geo->VertexBufferView();
		auto ibv = ri->Geo->IndexBufferView();

		cmdList->IASetVertexBuffers(0, 1, &vbv);
		cmdList->IASetIndexBuffer(&ibv);
		cmdList->IASetPrimitiveTopology(ri->PrimitiveType);

		CD3DX12_GPU_DESCRIPTOR_HANDLE tex(mSrvHeap->GetGPUDescriptorHandleForHeapStart());
		tex.Offset(ri->Mat->DiffuseSrvHeapIndex, mCbvSrvUavDescriptorSize);
		D3D12_GPU_VIRTUAL_ADDRESS objCBAddress = objectCB->GetGPUVirtualAddress();
		objCBAddress += ri->ObjCBIndex * objCBByteSize;
		D3D12_GPU_VIRTUAL_ADDRESS matCBAddress = matCB->GetGPUVirtualAddress();
		matCBAddress += ri->Mat->MatCBIndex * matCBByteSize;

		cmdList->SetGraphicsRootDescriptorTable(0, tex);
		cmdList->SetGraphicsRootConstantBufferView(2, objCBAddress);
		cmdList->SetGraphicsRootConstantBufferView(3, matCBAddress);

		cmdList->DrawIndexedInstanced(ri->IndexCount, 1, ri->StartIndexLocation, ri->BaseVertexLocation, 0);
	}
}

void AppD3D::DrawRenderItems_VertexNormal(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayer)
{
	UINT objCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(ObjectConstants));
	UINT matCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(MaterialConstants));

	auto objectCB = mCurrFrameResource->ObjectCB->Resource();
	auto matCB = mCurrFrameResource->MaterialCB->Resource();

	for (auto& ri : renderLayer)
	{
		auto vbv = ri->Geo->VertexBufferView();
		auto ibv = ri->Geo->IndexBufferView();

		cmdList->IASetVertexBuffers(0, 1, &vbv);
		cmdList->IASetIndexBuffer(&ibv);
		cmdList->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_POINTLIST);

		CD3DX12_GPU_DESCRIPTOR_HANDLE tex(mSrvHeap->GetGPUDescriptorHandleForHeapStart());
		tex.Offset(ri->Mat->DiffuseSrvHeapIndex, mCbvSrvUavDescriptorSize);
		D3D12_GPU_VIRTUAL_ADDRESS objCBAddress = objectCB->GetGPUVirtualAddress();
		objCBAddress += ri->ObjCBIndex * objCBByteSize;
		D3D12_GPU_VIRTUAL_ADDRESS matCBAddress = matCB->GetGPUVirtualAddress();
		matCBAddress += ri->Mat->MatCBIndex * matCBByteSize;

		cmdList->SetGraphicsRootDescriptorTable(0, tex);
		cmdList->SetGraphicsRootConstantBufferView(2, objCBAddress);
		cmdList->SetGraphicsRootConstantBufferView(3, matCBAddress);

		cmdList->DrawInstanced(ri->VertexCount, 1, ri->BaseVertexLocation, 0);
	}
}

void AppD3D::DrawAllVertexNormals(ID3D12GraphicsCommandList* cmdList)
{
	cmdList->SetPipelineState(mPSOs["vertexNormalDebug"].Get());

	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::Opaque]);
	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::Multi]);
	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::Transparent]);
	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::AlphaTest]);
	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::MirrorWall]);
	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::MirrorStencil]);
	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::Reflected]);
	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::LineStrip]);
	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::Shadow]);
	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::TriangleList]);
	DrawRenderItems_VertexNormal(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::Explode]);
}

std::array<const CD3DX12_STATIC_SAMPLER_DESC, 7> AppD3D::GetStaticSamplers()
{
	const CD3DX12_STATIC_SAMPLER_DESC pointWrap(
		0, // shaderRegister
		D3D12_FILTER_MIN_MAG_MIP_POINT, // filter
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,  // addressU
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,  // addressV
		D3D12_TEXTURE_ADDRESS_MODE_WRAP); // addressW

	const CD3DX12_STATIC_SAMPLER_DESC pointClamp(
		1,
		D3D12_FILTER_MIN_MAG_MIP_POINT,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP);

	const CD3DX12_STATIC_SAMPLER_DESC linearWrap(
		2,
		D3D12_FILTER_MIN_MAG_MIP_LINEAR,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP);

	const CD3DX12_STATIC_SAMPLER_DESC linearClamp(
		3,
		D3D12_FILTER_MIN_MAG_MIP_LINEAR,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP);

	const CD3DX12_STATIC_SAMPLER_DESC anisotropicWrap(
		4,
		D3D12_FILTER_ANISOTROPIC,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		0,
		8);

	const CD3DX12_STATIC_SAMPLER_DESC anisotropicClamp(
		5,
		D3D12_FILTER_ANISOTROPIC,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		0.0f,
		8);

	const CD3DX12_STATIC_SAMPLER_DESC testSampler(
		6,
		D3D12_FILTER_ANISOTROPIC,
		D3D12_TEXTURE_ADDRESS_MODE_MIRROR_ONCE,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		0.0f,
		8);

	return {
		pointWrap, pointClamp,
		linearWrap, linearClamp,
		anisotropicWrap, anisotropicClamp, testSampler };
}

GeometryGenerator::MeshData AppD3D::LoadModelFile(const std::wstring& path)
{
	std::ifstream file(path);
	if (!file)
	{
		std::wstring wfn = AnsiToWString(__FILE__);
		throw DxException(1, path, wfn, __LINE__);
	}

	std::vector<std::string> lines;
	std::string line;

	while (std::getline(file, line))
	{
		lines.push_back(line);
	}
	file.close();

	std::string label;
	int vertexCount = 0;
	int indexCount = 0;

	std::istringstream iss(lines[0]);
	iss >> label >> vertexCount;
	iss.str(lines[1]); iss.clear();
	iss >> label >> indexCount;

	// 메시 생성
	GeometryGenerator::MeshData meshData;

	for (int i = 4; i < 4 + vertexCount; i++)
	{
		iss.str(lines[i]); iss.clear();
		float v1, v2, v3, n1, n2, n3;
		iss >> v1 >> v2 >> v3 >> n1 >> n2 >> n3;

		GeometryGenerator::Vertex v;
		v.Position = { v1,v2,v3 };
		v.Normal = { n1,n2,n3 };
		meshData.Vertices.push_back(v);
	}
	for (int i = 31083; i < 31083 + indexCount; i++)
	{
		iss.str(lines[i]); iss.clear();
		int i1, i2, i3;
		iss >> i1 >> i2 >> i3;

		meshData.Indices32.push_back(i1);
		meshData.Indices32.push_back(i2);
		meshData.Indices32.push_back(i3);
	}

	return meshData;
}
