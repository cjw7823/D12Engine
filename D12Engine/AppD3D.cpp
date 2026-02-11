#include "AppD3D.h"

using namespace Microsoft::WRL;
using namespace DirectX;

AppD3D::~AppD3D()
{
	if (md3dDevice != nullptr)
		FlushCommandQueue();
}

bool AppD3D::Initialize()
{
	if (!InitAppD3D::Initialize())
		return false;

	ThrowIfFailed(mDirectCmdListAlloc->Reset());
	// OnResize()에서 close되었으므로 재사용을 위해 Reset.
	ThrowIfFailed(mCommandList->Reset(mDirectCmdListAlloc.Get(), nullptr));

	BuildRootsignature();
	BuildShadersAndInputLayout();
	BuildShapeGeometry();
	BuildLandGeometry();
	BuildWavesGeometryBuffers();
	BuildRenderItems();
	BuildFrameResources();
	BuildDescriptorHeaps();
	BuildConstantsBufferView();
	BuildPSO();

	ThrowIfFailed(mCommandList->Close());
	ID3D12CommandList* cmdsLists[] = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(_countof(cmdsLists), cmdsLists);

	FlushCommandQueue();

	return true;
}

void AppD3D::OnResize()
{
	__super::OnResize();	//InitAppD3D::OnResize();

	//투영 행렬은 종횡비가 변할 때 한 번 초기화하므로 OnResize()에 위치.
	DirectX::XMMATRIX P = DirectX::XMMatrixPerspectiveFovLH(0.25f * MathHelper::Pi, AspectRatio(), 1.0f, 1000.0f);
	DirectX::XMStoreFloat4x4(&mProj, P);
}

void AppD3D::Update(const GameTimer& gt)
{
	OnKeyboardInput(gt);
	UpdateCamera(gt);

	mCurrFrameResourceIndex = (mCurrFrameResourceIndex + 1) % gNumFrameResources;
	mCurrFrameResource = mFrameResources[mCurrFrameResourceIndex].get();

	if (mCurrFrameResource->Fence != 0 && mFence->GetCompletedValue() < mCurrFrameResource->Fence)
	{
		HANDLE eventHandle = CreateEventEx(nullptr, nullptr, false, EVENT_ALL_ACCESS);
		ThrowIfFailed(mFence->SetEventOnCompletion(mCurrFrameResource->Fence, eventHandle));
		WaitForSingleObject(eventHandle, INFINITE);
		CloseHandle(eventHandle);
	}

	UpdateObjectCBs(gt);
	UpdateMainPassCB(gt);
	UpdateWaves(gt);

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
	auto cmdListAlloc = mCurrFrameResource->CmdListAlloc;
	ThrowIfFailed(cmdListAlloc->Reset());

	if (mIsWireframe)
	{
		ThrowIfFailed(mCommandList->Reset(cmdListAlloc.Get(), mPSOs["opaque_wireframe"].Get()));
	}
	else
	{
		ThrowIfFailed(mCommandList->Reset(cmdListAlloc.Get(), mPSOs["opaque"].Get()));
	}

	mCommandList->RSSetViewports(1, &mScreenViewport);	//Rasterizer 단계
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
		0,
		nullptr);
	mCommandList->ClearDepthStencilView(
		dsvHandle,
		D3D12_CLEAR_FLAG_DEPTH | D3D12_CLEAR_FLAG_STENCIL,
		1.0f,
		0,
		0,
		nullptr);
	mCommandList->OMSetRenderTargets(1, &rtvHandle, true, &dsvHandle);
	
	ID3D12DescriptorHeap* descriptorHeaps[] = { mCbvHeap.Get() };
	mCommandList->SetDescriptorHeaps(_countof(descriptorHeaps), descriptorHeaps);
	mCommandList->SetGraphicsRootSignature(mRootSignature.Get());

	int passCbvIndex = mPassCbvOffset + mCurrFrameResourceIndex;
	auto passCbvHandle = CD3DX12_GPU_DESCRIPTOR_HANDLE(mCbvHeap->GetGPUDescriptorHandleForHeapStart());
	passCbvHandle.Offset(passCbvIndex, mCbvSrvUavDescriptorSize);
	//mCommandList->SetGraphicsRootDescriptorTable(1, passCbvHandle);

	auto passCB = mCurrFrameResource->PassCB->Resource();
	mCommandList->SetGraphicsRootConstantBufferView(1, passCB->GetGPUVirtualAddress());

	DrawRenderItems(mCommandList.Get(), mRenderItemLayer[(int)RenderLayer::Opaque]);

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

void AppD3D::BuildDescriptorHeaps()
{
	UINT objCount = (UINT)mRenderItemLayer[(int)RenderLayer::Opaque].size();

	//각 프레임마다 objCount + PassCBV
	UINT numDescriptors = (objCount + 1) * gNumFrameResources;

	//objCBV 다음 passCBV
	mPassCbvOffset = objCount * gNumFrameResources;

	D3D12_DESCRIPTOR_HEAP_DESC cbvHeapDesc;
	cbvHeapDesc.NumDescriptors = numDescriptors;
	cbvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
	cbvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
	cbvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&cbvHeapDesc, IID_PPV_ARGS(mCbvHeap.GetAddressOf())));
}

void AppD3D::BuildRootsignature()
{
	CD3DX12_DESCRIPTOR_RANGE cbvTable0;
	cbvTable0.Init(D3D12_DESCRIPTOR_RANGE_TYPE_CBV, 1, 0); //b0 매핑
	CD3DX12_DESCRIPTOR_RANGE cbvTable1;
	cbvTable1.Init(D3D12_DESCRIPTOR_RANGE_TYPE_CBV, 1, 1); //b1 매핑

	/*CD3DX12_ROOT_PARAMETER slotRootParameter[2] = {};
	slotRootParameter[0].InitAsDescriptorTable(1, &cbvTable0);
	slotRootParameter[1].InitAsDescriptorTable(1, &cbvTable1);*/

	/*CD3DX12_ROOT_PARAMETER slotRootParameter[2] = {};
	slotRootParameter[0].InitAsConstants(16, 0);
	slotRootParameter[1].InitAsDescriptorTable(1, &cbvTable1);*/

	CD3DX12_ROOT_PARAMETER slotRootParameter[2] = {};
	slotRootParameter[0].InitAsConstantBufferView(0);
	slotRootParameter[1].InitAsConstantBufferView(1);

	//그래프 구조.
	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(
		2,
		slotRootParameter,
		0,
		nullptr,
		D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

	//루트 시그니처는 보통 DESC → Serialize(Blob) → Create
	//표준 바이너리로 직렬화하면서 루트 시그니처 자체가 문법/제약/버전 관점에서 유효한지
	//직렬화된 Blob은 표준화된 바이너리 표현이라 저장/전달/비교(해시)에 유리하다.
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
}

void AppD3D::BuildShadersAndInputLayout()
{
	mShaders["standardVS"] = d3dUtil::CompileShader(L"Shaders\\color.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["opaquePS"] = d3dUtil::CompileShader(L"Shaders\\color.hlsl", nullptr, "PS", "ps_5_1");

	mInputLayout =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
		{ "COLOR", 0, DXGI_FORMAT_R32G32B32A32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
	};
}

void AppD3D::BuildShapeGeometry()
{
	GeometryGenerator::MeshData skull = LoadModelFile(L"../skull.txt");

	GeometryGenerator geoGen;
	GeometryGenerator::MeshData box = geoGen.CreateBox(1.5, 0.5, 1.5, 3);
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
		vertices[k].Color = XMFLOAT4(Colors::DarkGreen);
	}
	for (size_t i = 0; i < grid.Vertices.size(); i++, k++)
	{
		vertices[k].Pos = grid.Vertices[i].Position;
		vertices[k].Color = XMFLOAT4(Colors::ForestGreen);
	}
	for (size_t i = 0; i < sphere.Vertices.size(); i++, k++)
	{
		vertices[k].Pos = sphere.Vertices[i].Position;
		vertices[k].Color = XMFLOAT4(Colors::Crimson);
	}
	for (size_t i = 0; i < geoSphere.Vertices.size(); i++, k++)
	{
		vertices[k].Pos = geoSphere.Vertices[i].Position;
		vertices[k].Color = XMFLOAT4(Colors::Crimson);
	}
	for (size_t i = 0; i < cylinder.Vertices.size(); i++, k++)
	{
		vertices[k].Pos = cylinder.Vertices[i].Position;
		vertices[k].Color = XMFLOAT4(Colors::SteelBlue);
	}
	for (size_t i = 0; i < skull.Vertices.size(); i++, k++)
	{
		vertices[k].Pos = skull.Vertices[i].Position;
		vertices[k].Color = XMFLOAT4(Colors::GhostWhite);
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

	ThrowIfFailed(D3DCreateBlob(vbByteSize, &geo->VertexBufferCPU));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, &geo->IndexBufferCPU));
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

		auto& pos = vertices[i].Pos.y;
		auto& col = vertices[i].Color;
		if (pos < -10.f)
			col = XMFLOAT4(1.0, 0.96f, 0.62f, 1.0f);
		else if (pos < 5.0f)
			col = XMFLOAT4(0.48f, 0.77f, 0.46f, 1.0f);
		else if (pos < 12.0f)
			col = XMFLOAT4(0.1f, 0.48f, 0.19f, 1.0f);
		else if (pos < 20.0f)
			col = XMFLOAT4(0.45f, 0.39f, 0.34f, 1.0f);
		else
			col = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
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
	geo->VertexBufferCPU = nullptr;	//따로 설정x. FrameResource->UpdateBuffer에 존재.
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
	opaquePsoDesc.BlendState = CD3DX12_BLEND_DESC(D3D12_DEFAULT); //색 합성
	opaquePsoDesc.DepthStencilState = CD3DX12_DEPTH_STENCIL_DESC(D3D12_DEFAULT);
	opaquePsoDesc.SampleMask = UINT_MAX; //모든 샘플 사용.
	opaquePsoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
	opaquePsoDesc.NumRenderTargets = 1;
	opaquePsoDesc.RTVFormats[0] = mBackBufferFormat;
	opaquePsoDesc.SampleDesc.Count = m4xMsaaState ? 4 : 1;
	opaquePsoDesc.SampleDesc.Quality = m4xMsaaState ? (m4xMsaaQuality - 1) : 0;
	opaquePsoDesc.DSVFormat = mDepthStencilFormat;
	ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&opaquePsoDesc, IID_PPV_ARGS(&mPSOs["opaque"])));
	
	D3D12_GRAPHICS_PIPELINE_STATE_DESC opaqueWireframePsoDesc = opaquePsoDesc;
	opaqueWireframePsoDesc.RasterizerState.FillMode = D3D12_FILL_MODE_WIREFRAME;
	ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&opaqueWireframePsoDesc, IID_PPV_ARGS(&mPSOs["opaque_wireframe"])));
}

void AppD3D::BuildRenderItems()
{
	auto boxRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&boxRI->World, XMMatrixScaling(2.f, 2.f, 2.f) * XMMatrixTranslation(0.f, 0.5f, 0.f));
	boxRI->ObjCBIndex = 0;
	boxRI->Geo = mGeometries["shapeGeo"].get();
	boxRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	boxRI->IndexCount = boxRI->Geo->DrawArgs["box"].IndexCount;
	boxRI->StartIndexLocation = boxRI->Geo->DrawArgs["box"].StartIndexLocation;
	boxRI->BaseVertexLocation = boxRI->Geo->DrawArgs["box"].BaseVertexLocation;
	mAllRenderItems.push_back(std::move(boxRI));

	auto gridRI = std::make_unique<RenderItem>();
	gridRI->World = MathHelper::Identity4x4();
	gridRI->ObjCBIndex = 1;
	gridRI->Geo = mGeometries["shapeGeo"].get();
	gridRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	gridRI->IndexCount = gridRI->Geo->DrawArgs["grid"].IndexCount;
	gridRI->StartIndexLocation = gridRI->Geo->DrawArgs["grid"].StartIndexLocation;
	gridRI->BaseVertexLocation = gridRI->Geo->DrawArgs["grid"].BaseVertexLocation;
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

		XMMATRIX leftSphereWorld = XMMatrixScaling(0.5f, 0.5f, 0.5f) * XMMatrixTranslation(-5.0f, 3.5f, -10.0f + i * 5.0f);
		XMMATRIX rightSphereWorld = XMMatrixTranslation(+5.0f, 3.5f, -10.0f + i * 5.0f);

		XMStoreFloat4x4(&leftCylRitem->World, rightCylWorld);
		leftCylRitem->ObjCBIndex = objCBIndex++;
		leftCylRitem->Geo = mGeometries["shapeGeo"].get();
		leftCylRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		leftCylRitem->IndexCount = leftCylRitem->Geo->DrawArgs["cylinder"].IndexCount;
		leftCylRitem->StartIndexLocation = leftCylRitem->Geo->DrawArgs["cylinder"].StartIndexLocation;
		leftCylRitem->BaseVertexLocation = leftCylRitem->Geo->DrawArgs["cylinder"].BaseVertexLocation;

		XMStoreFloat4x4(&rightCylRitem->World, leftCylWorld);
		rightCylRitem->ObjCBIndex = objCBIndex++;
		rightCylRitem->Geo = mGeometries["shapeGeo"].get();
		rightCylRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		rightCylRitem->IndexCount = rightCylRitem->Geo->DrawArgs["cylinder"].IndexCount;
		rightCylRitem->StartIndexLocation = rightCylRitem->Geo->DrawArgs["cylinder"].StartIndexLocation;
		rightCylRitem->BaseVertexLocation = rightCylRitem->Geo->DrawArgs["cylinder"].BaseVertexLocation;

		XMStoreFloat4x4(&leftSphereRitem->World, leftSphereWorld);
		leftSphereRitem->ObjCBIndex = objCBIndex++;
		leftSphereRitem->Geo = mGeometries["shapeGeo"].get();
		leftSphereRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		leftSphereRitem->IndexCount = leftSphereRitem->Geo->DrawArgs["sphere"].IndexCount;
		leftSphereRitem->StartIndexLocation = leftSphereRitem->Geo->DrawArgs["sphere"].StartIndexLocation;
		leftSphereRitem->BaseVertexLocation = leftSphereRitem->Geo->DrawArgs["sphere"].BaseVertexLocation;

		XMStoreFloat4x4(&rightGeoSphereRitem->World, rightSphereWorld);
		rightGeoSphereRitem->ObjCBIndex = objCBIndex++;
		rightGeoSphereRitem->Geo = mGeometries["shapeGeo"].get();
		rightGeoSphereRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		rightGeoSphereRitem->IndexCount = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].IndexCount;
		rightGeoSphereRitem->StartIndexLocation = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].StartIndexLocation;
		rightGeoSphereRitem->BaseVertexLocation = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].BaseVertexLocation;

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
	skullRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	skullRI->IndexCount = skullRI->Geo->DrawArgs["skull"].IndexCount;
	skullRI->StartIndexLocation = skullRI->Geo->DrawArgs["skull"].StartIndexLocation;
	skullRI->BaseVertexLocation = skullRI->Geo->DrawArgs["skull"].BaseVertexLocation;
	mAllRenderItems.push_back(std::move(skullRI));

	//land용
	auto landRI = std::make_unique<RenderItem>();
	//landRI->World = MathHelper::Identity4x4();
	XMStoreFloat4x4(&landRI->World, XMMatrixScaling(1, 1, 1) * XMMatrixTranslation(0, -5, 0));
	landRI->ObjCBIndex = objCBIndex++;
	landRI->Geo = mGeometries["landGeo"].get();
	landRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	landRI->IndexCount = landRI->Geo->DrawArgs["grid"].IndexCount;
	landRI->StartIndexLocation = landRI->Geo->DrawArgs["grid"].StartIndexLocation;
	landRI->BaseVertexLocation = landRI->Geo->DrawArgs["grid"].BaseVertexLocation;
	mAllRenderItems.push_back(std::move(landRI));

	//waves용
	auto waveRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&waveRI->World, XMMatrixScaling(1, 1, 1) * XMMatrixTranslation(0, -1, 0));
	waveRI->ObjCBIndex = objCBIndex++;
	waveRI->Geo = mGeometries["waterGeo"].get();
	waveRI->PrimitiveType = D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	waveRI->IndexCount = waveRI->Geo->DrawArgs["grid"].IndexCount;
	waveRI->StartIndexLocation = waveRI->Geo->DrawArgs["grid"].StartIndexLocation;
	waveRI->BaseVertexLocation = waveRI->Geo->DrawArgs["grid"].BaseVertexLocation;

	mWavesRenderItem = waveRI.get();
	mAllRenderItems.push_back(std::move(waveRI));

	for (auto& e : mAllRenderItems)
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(e.get());
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
				mWaves->VertexCount()));
	}
}

void AppD3D::BuildConstantsBufferView()
{
	UINT objCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(ObjectConstants));
	UINT objCount = (UINT)mRenderItemLayer[(int)RenderLayer::Opaque].size();

	//// |(Frame i) -> (Obj0)(Obj1)(Obj2)...| for i in [0, gNumFrameResources) 꼴의 구조
	/*for (int frameIndex = 0; frameIndex < gNumFrameResources; frameIndex++)
	{
		auto objectCB = mFrameResources[frameIndex]->ObjectCB->Resource();
		for (UINT i = 0; i < objCount; i++)
		{
			D3D12_GPU_VIRTUAL_ADDRESS cbAddress = objectCB->GetGPUVirtualAddress();

			cbAddress += i * objCBByteSize;

			int heapIndex = frameIndex * objCount + i;
			auto handle = CD3DX12_CPU_DESCRIPTOR_HANDLE(mCbvHeap->GetCPUDescriptorHandleForHeapStart());
			handle.Offset(heapIndex, mCbvSrvUavDescriptorSize);

			D3D12_CONSTANT_BUFFER_VIEW_DESC cbvDesc;
			cbvDesc.BufferLocation = cbAddress;
			cbvDesc.SizeInBytes = objCBByteSize;

			md3dDevice->CreateConstantBufferView(&cbvDesc, handle);
		}
	}*/

	UINT passCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(PassConstants));

	//모든 objCB 이후에 (Frame0-passCB0),(Frame1-passCB1),(Frame2-passCB2)...
	for (int frameIndex = 0; frameIndex < gNumFrameResources; frameIndex++)
	{
		auto passCB = mFrameResources[frameIndex]->PassCB->Resource();
		D3D12_GPU_VIRTUAL_ADDRESS cbAddress = passCB->GetGPUVirtualAddress();

		int heapIndex = mPassCbvOffset + frameIndex;
		auto handle = CD3DX12_CPU_DESCRIPTOR_HANDLE(mCbvHeap->GetCPUDescriptorHandleForHeapStart());
		handle.Offset(heapIndex, mCbvSrvUavDescriptorSize);

		D3D12_CONSTANT_BUFFER_VIEW_DESC cbvDesc;
		cbvDesc.BufferLocation = cbAddress;
		cbvDesc.SizeInBytes = passCBByteSize;

		md3dDevice->CreateConstantBufferView(&cbvDesc, handle);
	}
}

void AppD3D::DrawRenderItems(ID3D12GraphicsCommandList* cmdList, const std::vector<const RenderItem*>& rItems)
{
	UINT objCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(ObjectConstants));

	auto objectCB = mCurrFrameResource->ObjectCB->Resource();

	for (size_t i = 0; i < rItems.size(); i++)
	{
		auto ri = rItems[i];

		auto vbv = ri->Geo->VertexBufferView();
		auto ibv = ri->Geo->IndexBufferView();

		cmdList->IASetVertexBuffers(0,1,&vbv);
		cmdList->IASetIndexBuffer(&ibv);
		cmdList->IASetPrimitiveTopology(ri->PrimitiveType);

		/*UINT cbvIndex = mCurrFrameResourceIndex * (UINT)mRenderItemLayer[(int)RenderLayer::Opaque].size() + ri->ObjCBIndex;
		auto cbvHandle = CD3DX12_GPU_DESCRIPTOR_HANDLE(mCbvHeap->GetGPUDescriptorHandleForHeapStart());
		cbvHandle.Offset(cbvIndex, mCbvSrvUavDescriptorSize);

		cmdList->SetGraphicsRootDescriptorTable(0, cbvHandle);*/

		/*XMMATRIX world = XMLoadFloat4x4(&ri->World);
		XMFLOAT4X4 worldT;
		XMStoreFloat4x4(&worldT, XMMatrixTranspose(world));

		cmdList->SetGraphicsRoot32BitConstants(
			0,      // RootParamIndex (b0)
			16,     // Num32BitValues
			&worldT,// 16 floats contiguous
			0
		);*/

		D3D12_GPU_VIRTUAL_ADDRESS objCBAddress = objectCB->GetGPUVirtualAddress();
		objCBAddress += ri->ObjCBIndex * objCBByteSize;
		cmdList->SetGraphicsRootConstantBufferView(0, objCBAddress);

		cmdList->DrawIndexedInstanced(ri->IndexCount, 1, ri->StartIndexLocation, ri->BaseVertexLocation, 0);
	}
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

	std::string label;
	int vertexCount=0;
	int indexCount=0;

	std::istringstream iss(lines[0]);
	iss >> label >> vertexCount;
	iss.str(lines[1]); iss.clear();
	iss >> label >> indexCount;
	indexCount;

	// 메시 생성
	GeometryGenerator::MeshData meshData;

	for (int i = 4; i < 4 + vertexCount; i++)
	{
		iss.str(lines[i]); iss.clear();
		float v1, v2, v3, n1, n2, n3;
		iss >> v1 >> v2 >> v3 >> n1 >> n2 >> n3;

		GeometryGenerator::Vertex v;
		v.Position = { v1,v2,v3 };
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

void AppD3D::OnKeyboardInput(const GameTimer& gt)
{
	static bool prevKeyDown = false;

	bool currKeyDown = (GetAsyncKeyState('1') & 0x8000) != 0;

	// 키가 "눌린 순간"만 감지
	if (currKeyDown && !prevKeyDown)
		mIsWireframe = !mIsWireframe;

	prevKeyDown = currKeyDown;
}

void AppD3D::UpdateCamera(const GameTimer& gt)
{
	XMVECTOR v = MathHelper::SphericalToCatesian(mRadius, mTheta, mPhi);
	XMVECTOR pos = XMVectorSetW(v, 1.0f);
	XMVECTOR target = XMVectorZero();
	XMVECTOR up = XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f);

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

			ObjectConstants objConstants;
			XMStoreFloat4x4(&objConstants.World, XMMatrixTranspose(world));

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

		//float r = MathHelper::RandF(0.2f, 0.5f);
		float r = MathHelper::RandF(0.8f, 1.5f);

		mWaves->Disturb(i, j, r);
	}

	mWaves->Update(gt.DeltaTime());

	auto currWavesVB = mCurrFrameResource->WavesVB.get();
	for (int i = 0; i < mWaves->VertexCount(); i++)
	{
		Vertex v;
		v.Pos = mWaves->Position(i);
		v.Color = XMFLOAT4(DirectX::Colors::Blue);

		currWavesVB->CopyData(i, v);
	}

	mWavesRenderItem->Geo->VertexBufferGPU = currWavesVB->Resource();
}
