#include "AppD3D.h"

using namespace DirectX;
using namespace Microsoft::WRL;

AppD3D::~AppD3D()
{
	if (md3dDevice != nullptr)
		FlushCommandQueue();
}

bool AppD3D::Initialize()
{
	if (!InitAppD3D::Initialize())
		return false;

	ThrowIfFailed(mCommandAlloc->Reset());
	ThrowIfFailed(mCommandList->Reset(mCommandAlloc.Get(), nullptr));

	LoadTexture();
	BuildDescriptorHeaps();
	BuildRootsignature();
	BuildShadersAndInputLayout();
	BuildShapeGeometry();
	BuildLandGeometry();
	BuildWavesGeometryBuffers();
	BuildMaterials();
	BuildRenderItems();
	BuildFrameResources();
	BuildPSO();

	ThrowIfFailed(mCommandList->Close());
	ID3D12CommandList* cmdLists[] = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(_countof(cmdLists), cmdLists);

	FlushCommandQueue();

	return true;
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
	UpdateWaves(gt);
	UpdateMaterialCBs(gt);

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
		D3D12_RESOURCE_STATE_RENDER_TARGET);
	mCommandList->ResourceBarrier(1, &barrier1);
	auto rtvHandle = CurrentBackBufferView();
	auto dsvHandle = DepthStencilView();
	mCommandList->ClearRenderTargetView(
		rtvHandle,
		Colors::LightSteelBlue,
		0, nullptr);
	mCommandList->ClearDepthStencilView(
		dsvHandle,
		D3D12_CLEAR_FLAG_DEPTH | D3D12_CLEAR_FLAG_STENCIL,
		1.0f,
		0,
		0,
		nullptr);
	mCommandList->OMSetRenderTargets(1, &rtvHandle, true, &dsvHandle);

	ID3D12DescriptorHeap* descriptorHeap[] = { mSrvHeap.Get() };
	mCommandList->SetDescriptorHeaps(_countof(descriptorHeap), descriptorHeap);
	mCommandList->SetGraphicsRootSignature(mRootSignature.Get());

	auto passCB = mCurrFrameResource->PassCB->Resource();
	mCommandList->SetGraphicsRootConstantBufferView(4, passCB->GetGPUVirtualAddress());

	for (int layer = 0; layer < (int)RenderLayer::Count; layer++)
	{
		if (mIsWireframe)
			mCommandList->SetPipelineState(mPSOs["opaque_wireframe"].Get());
		else
		{
			switch (layer)
			{
			case (int)RenderLayer::Opaque :
				mCommandList->SetPipelineState(mPSOs["opaque"].Get());
				break;
			case (int)RenderLayer::Multi:
				mCommandList->SetPipelineState(mPSOs["multiPSO"].Get());
				break;
			case (int)RenderLayer::Transparent:
				mCommandList->SetPipelineState(mPSOs["transparent"].Get());
				break;
			case (int)RenderLayer::AlphaTest:
				mCommandList->SetPipelineState(mPSOs["alphaTested"].Get());
				break;
			default:
				break;
			}
		}
		DrawRenderItems(mCommandList.Get(), mRenderItemLayer[layer]);
	}

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
	mRadius -= static_cast<long long>(zDelta) * 0.05f;
	mRadius = MathHelper::Clamp(mRadius, 0.1f, 150.0f);
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

void AppD3D::LoadTexture()
{
	if (!mTexLoader)
		mTexLoader = std::make_unique<TextureLoader_Blocking>(
			md3dDevice.Get(), mCommandQueue.Get(), mFence.Get());

	auto defaultTex = std::make_unique<Texture>();
	defaultTex->Name = "defaultTex";
	defaultTex->Filename = L"../Textures/white1x1.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*defaultTex, mCurrentFence));

	auto woodCrateTex = std::make_unique<Texture>();
	woodCrateTex->Name = "woodCrateTex";
	woodCrateTex->Filename = L"../Textures/MipmapTest.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*woodCrateTex, mCurrentFence));

	auto brickTex = std::make_unique<Texture>();
	brickTex->Name = "brickTex";
	brickTex->Filename = L"../Textures/bricks.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*brickTex, mCurrentFence));

	auto stoneTex = std::make_unique<Texture>();
	stoneTex->Name = "stoneTex";
	stoneTex->Filename = L"../Textures/stone.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*stoneTex, mCurrentFence));

	auto tileTex = std::make_unique<Texture>();
	tileTex->Name = "tileTex";
	tileTex->Filename = L"../Textures/tile.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*tileTex, mCurrentFence));

	auto grassTex = std::make_unique<Texture>();
	grassTex->Name = "grassTex";
	grassTex->Filename = L"../Textures/grass.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*grassTex, mCurrentFence));

	auto waterTex = std::make_unique<Texture>();
	waterTex->Name = "waterTex";
	waterTex->Filename = L"../Textures/water1.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*waterTex, mCurrentFence));

	auto swirlingTex = std::make_unique<Texture>();
	swirlingTex->Name = "swirlingTex";
	swirlingTex->Filename = L"../Textures/swirling.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*swirlingTex, mCurrentFence));

	auto swirlingMaskTex = std::make_unique<Texture>();
	swirlingMaskTex->Name = "swirlingMaskTex";
	swirlingMaskTex->Filename = L"../Textures/swirling_Mask.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*swirlingMaskTex, mCurrentFence));

	auto fenceTex = std::make_unique<Texture>();
	fenceTex->Name = "fenceTex";
	fenceTex->Filename = L"../Textures/WireFence.dds";
	ThrowIfFailed(mTexLoader->LoadDDS(*fenceTex, mCurrentFence));

	mTextures[defaultTex->Name] = std::move(defaultTex);
	mTextures[woodCrateTex->Name] = std::move(woodCrateTex);
	mTextures[brickTex->Name] = std::move(brickTex);
	mTextures[stoneTex->Name] = std::move(stoneTex);
	mTextures[tileTex->Name] = std::move(tileTex);
	mTextures[grassTex->Name] = std::move(grassTex);
	mTextures[waterTex->Name] = std::move(waterTex);
	mTextures[swirlingTex->Name] = std::move(swirlingTex);
	mTextures[swirlingMaskTex->Name] = std::move(swirlingMaskTex);
	mTextures[fenceTex->Name] = std::move(fenceTex);
}

void AppD3D::BuildDescriptorHeaps()
{
	//추후 텍스처를 위한 srvHeap만 생성 예정.
	D3D12_DESCRIPTOR_HEAP_DESC srvHeapDesc = {};
	srvHeapDesc.NumDescriptors = (UINT)mTextures.size();
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
}

void AppD3D::BuildMaterials()
{
	auto skullMat = std::make_unique<Material>();
	skullMat->Name = "skullMat";
	skullMat->MatCBIndex = 0;
	skullMat->DiffuseSrvHeapIndex = mTextures["defaultTex"]->DiffuseSrvHeapIndex; //텍스처 없음.
	skullMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	skullMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	skullMat->Roughness = 0.3f;

	auto tileMat = std::make_unique<Material>();
	tileMat->Name = "tile0";
	tileMat->MatCBIndex = 1;
	tileMat->DiffuseSrvHeapIndex = mTextures["tileTex"]->DiffuseSrvHeapIndex;
	tileMat->DiffuseAlbedo = XMFLOAT4(Colors::LightGray);
	tileMat->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	tileMat->Roughness = 0.2f;

	auto brickMat = std::make_unique<Material>();
	brickMat->Name = "bricks0";
	brickMat->MatCBIndex = 2;
	brickMat->DiffuseSrvHeapIndex = mTextures["brickTex"]->DiffuseSrvHeapIndex;
	brickMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	brickMat->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	brickMat->Roughness = 0.1f;

	auto stoneMat = std::make_unique<Material>();
	stoneMat->Name = "stone0";
	stoneMat->MatCBIndex = 3;
	stoneMat->DiffuseSrvHeapIndex = mTextures["stoneTex"]->DiffuseSrvHeapIndex;
	stoneMat->DiffuseAlbedo = XMFLOAT4(Colors::LightSteelBlue);
	stoneMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	stoneMat->Roughness = 0.3f;

	auto grassMat = std::make_unique<Material>();
	grassMat->Name = "grass0";
	grassMat->MatCBIndex = 4;
	grassMat->DiffuseSrvHeapIndex = mTextures["grassTex"]->DiffuseSrvHeapIndex;
	grassMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	grassMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	grassMat->Roughness = 0.125f;

	auto waterMat = std::make_unique<Material>();
	waterMat->Name = "water0";
	waterMat->MatCBIndex = 5;
	waterMat->DiffuseSrvHeapIndex = mTextures["waterTex"]->DiffuseSrvHeapIndex;
	waterMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.5f);
	waterMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	waterMat->Roughness = 0.0f;

	auto woodCrateMat = std::make_unique<Material>();
	woodCrateMat->Name = "woodCrate";
	woodCrateMat->MatCBIndex = 6;
	woodCrateMat->DiffuseSrvHeapIndex = mTextures["woodCrateTex"]->DiffuseSrvHeapIndex;
	woodCrateMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	woodCrateMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	woodCrateMat->Roughness = 0.0f;

	auto swirlingMat = std::make_unique<Material>();
	swirlingMat->Name = "swirling";
	swirlingMat->MatCBIndex = 7;
	swirlingMat->DiffuseSrvHeapIndex = mTextures["swirlingTex"]->DiffuseSrvHeapIndex;
	swirlingMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMat->Roughness = 0.0f;

	auto swirlingMaskMat = std::make_unique<Material>();
	swirlingMaskMat->Name = "swirlingMask";
	swirlingMaskMat->MatCBIndex = 8;
	swirlingMaskMat->DiffuseSrvHeapIndex = mTextures["swirlingMaskTex"]->DiffuseSrvHeapIndex;
	swirlingMaskMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMaskMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMaskMat->Roughness = 0.0f;

	auto wireFence = std::make_unique<Material>();
	wireFence->Name = "wireFence";
	wireFence->MatCBIndex = 9;
	wireFence->DiffuseSrvHeapIndex = mTextures["fenceTex"]->DiffuseSrvHeapIndex;
	wireFence->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	wireFence->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	wireFence->Roughness = 0.25f;

	mMaterials[skullMat->Name] = std::move(skullMat);
	mMaterials[tileMat->Name] = std::move(tileMat);
	mMaterials[brickMat->Name] = std::move(brickMat);
	mMaterials[stoneMat->Name] = std::move(stoneMat);
	mMaterials[grassMat->Name] = std::move(grassMat);
	mMaterials[waterMat->Name] = std::move(waterMat);
	mMaterials[woodCrateMat->Name] = std::move(woodCrateMat);
	mMaterials[swirlingMat->Name] = std::move(swirlingMat);
	mMaterials[swirlingMaskMat->Name] = std::move(swirlingMaskMat);
	mMaterials[wireFence->Name] = std::move(wireFence);
}

void AppD3D::BuildRootsignature()
{
	CD3DX12_DESCRIPTOR_RANGE texTable1;
	texTable1.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0); //t0
	CD3DX12_DESCRIPTOR_RANGE texTable2;
	texTable2.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 1); //t1

	std::array<CD3DX12_ROOT_PARAMETER, 5> slotRootParameter;
	slotRootParameter[0].InitAsDescriptorTable(1, &texTable1, D3D12_SHADER_VISIBILITY_PIXEL);
	slotRootParameter[1].InitAsDescriptorTable(1, &texTable2, D3D12_SHADER_VISIBILITY_PIXEL);
	slotRootParameter[2].InitAsConstantBufferView(0); //obj CB
	slotRootParameter[3].InitAsConstantBufferView(1); //material CB
	slotRootParameter[4].InitAsConstantBufferView(2); //pass CB

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
		OutputDebugString((wchar_t*)errorBlob->GetBufferPointer());
	ThrowIfFailed(hr);

	ThrowIfFailed(md3dDevice->CreateRootSignature(
		0,
		serializedRootsig->GetBufferPointer(),
		serializedRootsig->GetBufferSize(),
		IID_PPV_ARGS(mRootSignature.GetAddressOf())));
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

	mShaders["standardVS"] = d3dUtil::CompileShader(L"Shaders\\Default.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["opaquePS"] = d3dUtil::CompileShader(L"Shaders\\Default.hlsl", defines, "PS", "ps_5_1");
	mShaders["multiPS"] = d3dUtil::CompileShader(L"Shaders\\Default.hlsl", defines, "PS_multiTexture", "ps_5_1");
	mShaders["alphaTestedPS"] = d3dUtil::CompileShader(L"Shaders\\Default.hlsl", alphaTestDefines, "PS", "ps_5_1");

	mInputLayout =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
		{ "NORMAL", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
		{ "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT, 0, 24, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
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

	SubmeshGeometry gridSubmesh;
	gridSubmesh.IndexCount = (UINT)grid.Indices32.size();
	gridSubmesh.StartIndexLocation = gridIndexOffset;
	gridSubmesh.BaseVertexLocation = gridVertexOffset;

	SubmeshGeometry sphereSubmesh;
	sphereSubmesh.IndexCount = (UINT)sphere.Indices32.size();
	sphereSubmesh.StartIndexLocation = sphereIndexOffset;
	sphereSubmesh.BaseVertexLocation = sphereVertexOffset;

	SubmeshGeometry geoSphereSubmesh;
	geoSphereSubmesh.IndexCount = (UINT)geoSphere.Indices32.size();
	geoSphereSubmesh.StartIndexLocation = geoSphereIndexOffset;
	geoSphereSubmesh.BaseVertexLocation = geoSphereVertexOffset;

	SubmeshGeometry cylinderSubmesh;
	cylinderSubmesh.IndexCount = (UINT)cylinder.Indices32.size();
	cylinderSubmesh.StartIndexLocation = cylinderIndexOffset;
	cylinderSubmesh.BaseVertexLocation = cylinderVertexOffset;

	SubmeshGeometry skullSubmesh;
	skullSubmesh.IndexCount = (UINT)skull.Indices32.size();
	skullSubmesh.StartIndexLocation = skullIndexOffset;
	skullSubmesh.BaseVertexLocation = skullVertexOffset;

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

	geo->DrawArgs["grid"] = sm;
	mGeometries["landGeo"] = std::move(geo);
}

void AppD3D::BuildWavesGeometryBuffers()
{
	mWaves = std::make_unique<Waves>(128, 128, 1.0f, 0.03f, 4.0f, 0.2f);

	std::vector<std::uint16_t> indices(3 * mWaves->TriangleCount());
	assert(mWaves->VertexCount() < 0x0000ffff);

	int m = mWaves->RowCount();
	int n = mWaves->ColumnCount();
	int k = 0;
	for (int i = 0; i < m - 1; i++)
	{
		for (int j = 0; j < n - 1; j++)
		{
			indices[k] = i * n + j;
			indices[k + 1] = i * n + j + 1;
			indices[k + 2] = (i + 1) * n + j;

			indices[k + 3] = (i + 1) * n + j;
			indices[k + 4] = i * n + j + 1;
			indices[k + 5] = (i + 1) * n + j + 1;

			k += 6;
		}
	}

	UINT vbByteSize = mWaves->VertexCount() * sizeof(Vertex);
	UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint16_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "waterGeo";
	//다이나믹 버퍼이므로 동적으로 설정.
	geo->VertexBufferCPU = nullptr;	//따로 설정x. Waves안에 이미 존재.
	geo->VertexBufferGPU = nullptr; //UpdateWaves()에서 설정.

	ThrowIfFailed(D3DCreateBlob(ibByteSize, &geo->IndexBufferCPU));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), indices.data(), ibByteSize, geo->IndexBufferUploader);
	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R16_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;

	geo->DrawArgs["grid"] = sm;

	mGeometries["waterGeo"] = std::move(geo);
}

void AppD3D::BuildRenderItems()
{
	auto boxRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&boxRI->World, XMMatrixScaling(2.f, 2.f/3.f, 2.f) * XMMatrixTranslation(0.f, 0.5f, 0.f));
	//XMStoreFloat4x4(&boxRI->TexTransform, XMMatrixScaling(5.f, 5.f, 1.0f) * XMMatrixTranslation(-1, -1, 0.f));
	boxRI->ObjCBIndex = 0;
	boxRI->Geo = mGeometries["shapeGeo"].get();
	boxRI->Mat = mMaterials["woodCrate"].get();
	boxRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	boxRI->IndexCount = boxRI->Geo->DrawArgs["box"].IndexCount;
	boxRI->StartIndexLocation = boxRI->Geo->DrawArgs["box"].StartIndexLocation;
	boxRI->BaseVertexLocation = boxRI->Geo->DrawArgs["box"].BaseVertexLocation;
	mRenderItemLayer[(int)RenderLayer::Opaque].push_back(boxRI.get());
	mAllRenderItems.push_back(std::move(boxRI));

	auto gridRI = std::make_unique<RenderItem>();
	gridRI->World = MathHelper::Identity4x4();
	XMStoreFloat4x4(&gridRI->TexTransform, XMMatrixScaling(8.0f, 8.0f, 1.0f));
	gridRI->ObjCBIndex = 1;
	gridRI->Geo = mGeometries["shapeGeo"].get();
	gridRI->Mat = mMaterials["tile0"].get();
	gridRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	gridRI->IndexCount = gridRI->Geo->DrawArgs["grid"].IndexCount;
	gridRI->StartIndexLocation = gridRI->Geo->DrawArgs["grid"].StartIndexLocation;
	gridRI->BaseVertexLocation = gridRI->Geo->DrawArgs["grid"].BaseVertexLocation;
	mRenderItemLayer[(int)RenderLayer::Opaque].push_back(gridRI.get());
	mAllRenderItems.push_back(std::move(gridRI));

	UINT objCBIndex = 2;
	for (int i = 0; i < 5; ++i)
	{
		auto leftCylRitem = std::make_unique<RenderItem>();
		auto rightCylRitem = std::make_unique<RenderItem>();
		auto leftSphereRitem = std::make_unique<RenderItem>();
		auto rightGeoSphereRitem = std::make_unique<RenderItem>();

		XMMATRIX leftCylWorld = XMMatrixTranslation(-5.0f, 1.5f, -10.0f + i * 5.0f);
		XMMATRIX rightCylWorld = XMMatrixTranslation(+5.0f, 1.5f, -10.0f + i * 5.0f);

		XMMATRIX leftSphereWorld = XMMatrixTranslation(-5.0f, 3.5f, -10.0f + i * 5.0f);
		XMMATRIX rightSphereWorld = XMMatrixTranslation(+5.0f, 3.5f, -10.0f + i * 5.0f);

		XMStoreFloat4x4(&leftCylRitem->World, leftCylWorld);
		leftCylRitem->ObjCBIndex = objCBIndex++;
		leftCylRitem->Geo = mGeometries["shapeGeo"].get();
		leftCylRitem->Mat = mMaterials["bricks0"].get();
		leftCylRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		leftCylRitem->IndexCount = leftCylRitem->Geo->DrawArgs["cylinder"].IndexCount;
		leftCylRitem->StartIndexLocation = leftCylRitem->Geo->DrawArgs["cylinder"].StartIndexLocation;
		leftCylRitem->BaseVertexLocation = leftCylRitem->Geo->DrawArgs["cylinder"].BaseVertexLocation;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(leftCylRitem.get());

		XMStoreFloat4x4(&rightCylRitem->World, rightCylWorld);
		rightCylRitem->ObjCBIndex = objCBIndex++;
		rightCylRitem->Geo = mGeometries["shapeGeo"].get();
		rightCylRitem->Mat = mMaterials["bricks0"].get();
		rightCylRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		rightCylRitem->IndexCount = rightCylRitem->Geo->DrawArgs["cylinder"].IndexCount;
		rightCylRitem->StartIndexLocation = rightCylRitem->Geo->DrawArgs["cylinder"].StartIndexLocation;
		rightCylRitem->BaseVertexLocation = rightCylRitem->Geo->DrawArgs["cylinder"].BaseVertexLocation;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(rightCylRitem.get());

		XMStoreFloat4x4(&leftSphereRitem->World, leftSphereWorld);
		leftSphereRitem->ObjCBIndex = objCBIndex++;
		leftSphereRitem->Geo = mGeometries["shapeGeo"].get();
		leftSphereRitem->Mat = mMaterials["stone0"].get();
		leftSphereRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		leftSphereRitem->IndexCount = leftSphereRitem->Geo->DrawArgs["sphere"].IndexCount;
		leftSphereRitem->StartIndexLocation = leftSphereRitem->Geo->DrawArgs["sphere"].StartIndexLocation;
		leftSphereRitem->BaseVertexLocation = leftSphereRitem->Geo->DrawArgs["sphere"].BaseVertexLocation;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(leftSphereRitem.get());

		XMStoreFloat4x4(&rightGeoSphereRitem->World, rightSphereWorld);
		rightGeoSphereRitem->ObjCBIndex = objCBIndex++;
		rightGeoSphereRitem->Geo = mGeometries["shapeGeo"].get();
		rightGeoSphereRitem->Mat = mMaterials["stone0"].get();
		rightGeoSphereRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		rightGeoSphereRitem->IndexCount = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].IndexCount;
		rightGeoSphereRitem->StartIndexLocation = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].StartIndexLocation;
		rightGeoSphereRitem->BaseVertexLocation = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].BaseVertexLocation;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(rightGeoSphereRitem.get());

		mAllRenderItems.push_back(std::move(leftCylRitem));
		mAllRenderItems.push_back(std::move(rightCylRitem));
		mAllRenderItems.push_back(std::move(leftSphereRitem));
		mAllRenderItems.push_back(std::move(rightGeoSphereRitem));
	}

	//skull용
	auto skullRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&skullRI->World, XMMatrixScaling(0.2f, 0.2f, 0.2f) * XMMatrixTranslation(0.f, 1.f, 0.f));
	skullRI->ObjCBIndex = objCBIndex++;
	skullRI->Geo = mGeometries["shapeGeo"].get();
	skullRI->Mat = mMaterials["skullMat"].get();
	skullRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	skullRI->IndexCount = skullRI->Geo->DrawArgs["skull"].IndexCount;
	skullRI->StartIndexLocation = skullRI->Geo->DrawArgs["skull"].StartIndexLocation;
	skullRI->BaseVertexLocation = skullRI->Geo->DrawArgs["skull"].BaseVertexLocation;
	mRenderItemLayer[(int)RenderLayer::Opaque].push_back(skullRI.get());
	mAllRenderItems.push_back(std::move(skullRI));

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
	mRenderItemLayer[(int)RenderLayer::Opaque].push_back(landRI.get());
	mAllRenderItems.push_back(std::move(landRI));

	//waves용
	auto waveRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&waveRI->World, XMMatrixScaling(1, 1, 1) * XMMatrixTranslation(0, -1, 0));
	XMStoreFloat4x4(&waveRI->TexTransform, XMMatrixScaling(5.0f, 5.0f, 1.0f));
	waveRI->ObjCBIndex = objCBIndex++;
	waveRI->Geo = mGeometries["waterGeo"].get();
	waveRI->Mat = mMaterials["water0"].get();
	waveRI->PrimitiveType = D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	waveRI->IndexCount = waveRI->Geo->DrawArgs["grid"].IndexCount;
	waveRI->StartIndexLocation = waveRI->Geo->DrawArgs["grid"].StartIndexLocation;
	waveRI->BaseVertexLocation = waveRI->Geo->DrawArgs["grid"].BaseVertexLocation;
	mRenderItemLayer[(int)RenderLayer::Transparent].push_back(waveRI.get());
	mWavesRenderItem = waveRI.get();
	mAllRenderItems.push_back(std::move(waveRI));

	auto boxRI2 = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&boxRI2->World, XMMatrixScaling(2.f, 2.f, 2.f) * XMMatrixTranslation(0.f, 2.f, 5.f));
	boxRI2->ObjCBIndex = objCBIndex++;
	boxRI2->Geo = mGeometries["shapeGeo"].get();
	boxRI2->Mat = mMaterials["swirling"].get();
	boxRI2->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	boxRI2->IndexCount = boxRI2->Geo->DrawArgs["box"].IndexCount;
	boxRI2->StartIndexLocation = boxRI2->Geo->DrawArgs["box"].StartIndexLocation;
	boxRI2->BaseVertexLocation = boxRI2->Geo->DrawArgs["box"].BaseVertexLocation;
	mRenderItemLayer[(int)RenderLayer::Multi].push_back(boxRI2.get());
	mAllRenderItems.push_back(std::move(boxRI2));

	auto boxRI3 = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&boxRI3->World, XMMatrixScaling(1.f, 1.f, 1.f)* XMMatrixTranslation(0.f, 1.f, -5.f));
	boxRI3->ObjCBIndex = objCBIndex++;
	boxRI3->Geo = mGeometries["shapeGeo"].get();
	boxRI3->Mat = mMaterials["wireFence"].get();
	boxRI3->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	boxRI3->IndexCount = boxRI3->Geo->DrawArgs["box"].IndexCount;
	boxRI3->StartIndexLocation = boxRI3->Geo->DrawArgs["box"].StartIndexLocation;
	boxRI3->BaseVertexLocation = boxRI3->Geo->DrawArgs["box"].BaseVertexLocation;
	mRenderItemLayer[(int)RenderLayer::AlphaTest].push_back(boxRI3.get());
	mAllRenderItems.push_back(std::move(boxRI3));
}

void AppD3D::BuildFrameResources()
{
	for (int i = 0; i < gNumFrameResources; i++)
	{
		mFrameResources.push_back(
			std::make_unique<FrameResource>(
				md3dDevice.Get(),
				1,
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
	opaquePsoDesc.SampleDesc.Quality = m4xMsaaState ? (m4xMsaaQuality) : 0;
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

	transparentPsoDesc.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;
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
}

void AppD3D::OnKeyboardInput(const GameTimer& gt)
{
	static bool prevKeyDown = false;

	bool currKeyDown = (GetAsyncKeyState('1') & 0x8000) != 0;

	// 키가 "눌린 순간"만 감지
	if (currKeyDown && !prevKeyDown)
		mIsWireframe = !mIsWireframe;

	prevKeyDown = currKeyDown;

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
	mMainPassCB.gFogRange = 100.f;

	XMVECTOR lightDir = -MathHelper::SphericalToCatesian(1.0, mSunTheta, mSunPhi);
	XMStoreFloat3(&mMainPassCB.Lights[0].Direction, lightDir);

	auto currPassCB = mCurrFrameResource->PassCB.get();
	currPassCB->CopyData(0, mMainPassCB);
}

void AppD3D::UpdateWaves(const GameTimer& gt)
{
	//정점 버퍼 설정.
	static float t_base = 0.0f;
	if ((mTimer.TotalTime() - t_base) >= 0.25f)
	{
		t_base += 0.25f;

		int i = MathHelper::Rand(4, mWaves->RowCount() - 5);
		int j = MathHelper::Rand(4, mWaves->ColumnCount() - 5);

		float r = MathHelper::RandF(0.2f, 0.5f);

		mWaves->Disturb(i, j, r);
	}

	mWaves->Update(gt.DeltaTime());

	auto currWavesVB = mCurrFrameResource->WavesVB.get();
	for (int i = 0; i < mWaves->VertexCount(); i++)
	{
		Vertex v;
		v.Pos = mWaves->Position(i);
		v.Normal = mWaves->Normal(i);

		v.TexC.x = 0.5f + v.Pos.x / mWaves->Width();
		v.TexC.y = 0.5f - v.Pos.z / mWaves->Depth();

		currWavesVB->CopyData(i, v);
	}

	mWavesRenderItem->Geo->VertexBufferGPU = currWavesVB->Resource();
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
