#include "AppD3D.h"
#include "RenderItem.h"
#include "GeometryGenerator.h"
#include "FrameResource.h"

using namespace Microsoft::WRL;

bool AppD3D::Initialize()
{
	if (!InitAppD3D::Initialize())
		return false;

	ThrowIfFailed(mDirectCmdListAlloc->Reset());
	// OnResize()에서 close되었으므로 재사용을 위해 Reset.
	ThrowIfFailed(mCommandList->Reset(mDirectCmdListAlloc.Get(), nullptr));

	//순서 종속성 : 1->2 / 5 / 3->4->6
	/*BuildDescriptorHeaps();
	BuildConstantsBuffer();
	BuildRootsignature();
	BuildShadersAndInputLayout();
	BuildBoxGeometry();
	BuildPSO();*/

	BuildRootsignature();
	BuildShadersAndInputLayout();
	BuildShapeGeometry();
	BuildRenderItem();
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
	using namespace DirectX;

	XMVECTOR v = MathHelper::SphericalToCatesian(mRadius, mTheta, mPhi);
	XMVECTOR pos = XMVectorSetW(v, 1.0f);
	XMVECTOR target = XMVectorZero();
	XMVECTOR up = XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f);

	//좌수 좌표계 행렬 생성.
	XMMATRIX view = XMMatrixLookAtLH(pos, target, up);
	XMStoreFloat4x4(&mView, view);

	XMMATRIX world = XMLoadFloat4x4(&mWorld);
	XMMATRIX proj = XMLoadFloat4x4(&mProj);
	XMMATRIX cam = XMLoadFloat4x4(&mCamPos);

	view *= cam;
	XMMATRIX worldViewProj = world * view * proj;

	ObjectConstants objConstants;
	//CPU: row-major matrix
	//HLSL: column_major + mul(v, M)
	//HLSL에서 mul(v, M)꼴로 사용하기 위해 전치.
	XMStoreFloat4x4(&objConstants.WorldViewProj, XMMatrixTranspose(worldViewProj));
	
	mObjectCB->CopyData(0, objConstants);

	//이동 로직. 회전과 연동 안됨.
	float dt = gt.DeltaTime();
	if (isMoving)
	{
		float speed = 2.f; // units/sec
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
	//Fence로 완료를 보장한 뒤 Reset가능.
	ThrowIfFailed(mDirectCmdListAlloc->Reset());
	ThrowIfFailed(mCommandList->Reset(mDirectCmdListAlloc.Get(), mPSO.Get()));

	mCommandList->RSSetViewports(1, &mScreenViewport);
	mCommandList->RSSetScissorRects(1, &mScissorRect);

	auto barrier = CD3DX12_RESOURCE_BARRIER::Transition(
		CurrentBackBuffer(),
		D3D12_RESOURCE_STATE_PRESENT,
		D3D12_RESOURCE_STATE_RENDER_TARGET);
	mCommandList->ResourceBarrier(1, &barrier);

	mCommandList->ClearRenderTargetView(CurrentBackBufferView(), DirectX::Colors::LightSteelBlue, 0, nullptr);
	mCommandList->ClearDepthStencilView(DepthStencilView(), D3D12_CLEAR_FLAG_DEPTH | D3D12_CLEAR_FLAG_STENCIL, 1.0f, 0, 0, nullptr);

	auto rtvHandle = CurrentBackBufferView();
	auto dsvHandle = DepthStencilView();
	mCommandList->OMSetRenderTargets(1, &rtvHandle, true, &dsvHandle);

	ID3D12DescriptorHeap* descriptorHeaps[] = { mCbvHeap.Get() };
	mCommandList->SetDescriptorHeaps(_countof(descriptorHeaps), descriptorHeaps);
	mCommandList->SetGraphicsRootSignature(mRootSignature.Get());

	D3D12_VERTEX_BUFFER_VIEW vbv[] = {
		mBoxGeo->VertexBufferView(0),
		mBoxGeo->VertexBufferView(1),
	};
	mCommandList->IASetVertexBuffers(0, 2, vbv);
	auto ibv = mBoxGeo->IndexBufferView();
	mCommandList->IASetIndexBuffer(&ibv);

	mCommandList->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

	mCommandList->SetGraphicsRootDescriptorTable(0, mCbvHeap->GetGPUDescriptorHandleForHeapStart());

	auto submesh = mBoxGeo->DrawArgs["box"];
	mCommandList->DrawIndexedInstanced(
		submesh.IndexCount,
		1,
		submesh.StartIndexLocation,
		submesh.BaseVertexLocation,
		0);

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

	//이 대기는 비효율적이라고 설명됨.
	//추후 프레임별로 기다릴 필요가 없도록 렌더링 코드를 구성하는 방법을 보여준다고 한다.
	FlushCommandQueue();
}

void AppD3D::BuildDescriptorHeaps()
{
	D3D12_DESCRIPTOR_HEAP_DESC cbvHeapDesc;
	cbvHeapDesc.NumDescriptors = 1;
	cbvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
	cbvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
	cbvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&cbvHeapDesc, IID_PPV_ARGS(&mCbvHeap)));
}

void AppD3D::BuildConstantsBuffer()
{
	mObjectCB = std::make_unique<UploadBuffer<ObjectConstants>>(md3dDevice.Get(), 1, true);

	UINT objCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(ObjectConstants));

	D3D12_CONSTANT_BUFFER_VIEW_DESC cbvDesc = {};
	cbvDesc.BufferLocation = mObjectCB->Resource()->GetGPUVirtualAddress();
	cbvDesc.SizeInBytes = objCBByteSize;

	D3D12_CPU_DESCRIPTOR_HANDLE handle = mCbvHeap->GetCPUDescriptorHandleForHeapStart();

	md3dDevice->CreateConstantBufferView(&cbvDesc, handle);
}

void AppD3D::BuildRootsignature()
{
	CD3DX12_DESCRIPTOR_RANGE cbvTable0;
	cbvTable0.Init(D3D12_DESCRIPTOR_RANGE_TYPE_CBV, 1, 0); //b0 매핑
	CD3DX12_DESCRIPTOR_RANGE cbvTable1;
	cbvTable1.Init(D3D12_DESCRIPTOR_RANGE_TYPE_CBV, 1, 1); //b1 매핑

	CD3DX12_ROOT_PARAMETER slotRootParameter[2] = {};
	slotRootParameter[0].InitAsDescriptorTable(1, &cbvTable0);
	slotRootParameter[0].InitAsDescriptorTable(1, &cbvTable1);

	//그래프 구조.
	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(
		2,
		slotRootParameter,
		0,
		nullptr,
		D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

	//루트 시그니처는 보통 DESC → Serialize(Blob) → Create
	//표준 바이너리로 직렬화하면서 일부 검증/버전 호환 처리를 사전 수행.
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
	mvsByteCode = d3dUtil::CompileShader(L"Shaders\\color.hlsl", nullptr, "VS", "vs_5_1");
	mpsByteCode = d3dUtil::CompileShader(L"Shaders\\color.hlsl", nullptr, "PS", "ps_5_1");

	mInputLayout =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
		{ "COLOR", 0, DXGI_FORMAT_B8G8R8X8_UNORM, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
	};
}

void AppD3D::BuildShapeGeometry()
{
	GeometryGenerator geoGen;
	GeometryGenerator::MeshData box = geoGen.CreateBox(1.5, 0.5, 1.5, 3);
	GeometryGenerator::MeshData grid = geoGen.CreateGrid(20, 30, 60, 40);
	GeometryGenerator::MeshData sphere = geoGen.CreateSphere(0.5, 20, 20);
	GeometryGenerator::MeshData cylinder = geoGen.CreateCylinder(0.5, 0.3, 3, 20, 20);

	UINT boxVertexOffset = 0;
	UINT gridVertexOffset = (UINT)box.Vertices.size();
	UINT sphereVertexOffset = gridVertexOffset + (UINT)grid.Vertices.size();
	UINT cylinderVertexOffset = sphereVertexOffset + (UINT)sphere.Vertices.size();

	UINT boxIndexOffset = 0;
	UINT gridIndexOffset = (UINT)box.Indices32.size();
	UINT sphereIndexOffset = gridIndexOffset + (UINT)grid.Indices32.size();
	UINT cylinderIndexOffset = sphereIndexOffset + (UINT)grid.Indices32.size();

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

	SubmeshGeometry cylinderSubmesh;
	cylinderSubmesh.IndexCount = (UINT)cylinder.Indices32.size();
	cylinderSubmesh.StartIndexLocation = cylinderIndexOffset;
	cylinderSubmesh.BaseVertexLocation = cylinderVertexOffset;

	auto totalVertexCount =
		box.Vertices.size() +
		grid.Vertices.size() +
		sphere.Vertices.size() +
		cylinder.Vertices.size();

	std::vector<Vertex> vertices(totalVertexCount);

	//작성중..


	mBoxGeo = std::make_unique<MeshGeometry>();
	mBoxGeo->InitializeVertexBuffers(2);
	mBoxGeo->Name = "Box";

	ThrowIfFailed(D3DCreateBlob(vbpByteSize, mBoxGeo->VertexBufferCPU[0].GetAddressOf()));
	{
		auto* dst = reinterpret_cast<char*>(mBoxGeo->VertexBufferCPU[0]->GetBufferPointer());
		CopyMemory(dst, verticesPos.data(), vbpByteSize);
	}
	ThrowIfFailed(D3DCreateBlob(vbcByteSize, mBoxGeo->VertexBufferCPU[1].GetAddressOf()));
	{
		auto* dst = reinterpret_cast<char*>(mBoxGeo->VertexBufferCPU[1]->GetBufferPointer());
		CopyMemory(dst, verticesCol.data(), vbcByteSize);
	}
	ThrowIfFailed(D3DCreateBlob(ibByteSize, mBoxGeo->IndexBufferCPU.GetAddressOf()));
	{
		auto* dst = reinterpret_cast<char*>(mBoxGeo->IndexBufferCPU->GetBufferPointer());
		CopyMemory(dst, indices.data(), ibByteSize);
	}

	mBoxGeo->VertexBufferGPU[0] = d3dUtil::CreateDefaultBuffer(
		md3dDevice.Get(),
		mCommandList.Get(),
		verticesPos.data(),
		vbpByteSize,
		mBoxGeo->VertexBufferUploader[0]);
	mBoxGeo->VertexBufferGPU[1] = d3dUtil::CreateDefaultBuffer(
		md3dDevice.Get(),
		mCommandList.Get(),
		verticesCol.data(),
		vbcByteSize,
		mBoxGeo->VertexBufferUploader[1]);
	mBoxGeo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(
		md3dDevice.Get(),
		mCommandList.Get(),
		indices.data(),
		ibByteSize,
		mBoxGeo->IndexBufferUploader);

	mBoxGeo->VertexByteStride[0] = sizeof(Vertex1);
	mBoxGeo->VertexByteStride[1] = sizeof(Vertex2);
	mBoxGeo->VertexBufferByteSize[0] = vbpByteSize;
	mBoxGeo->VertexBufferByteSize[1] = vbcByteSize;
	mBoxGeo->IndexFormat = DXGI_FORMAT_R16_UINT;
	mBoxGeo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry subMesh;
	subMesh.IndexCount = (UINT)indices.size();
	subMesh.StartIndexLocation = 0;
	subMesh.BaseVertexLocation = 0;

	mBoxGeo->DrawArgs["box"] = subMesh;
}

void AppD3D::BuildPSO()
{
	D3D12_GRAPHICS_PIPELINE_STATE_DESC psoDesc;
	ZeroMemory(&psoDesc, sizeof(D3D12_GRAPHICS_PIPELINE_STATE_DESC));
	psoDesc.InputLayout = { mInputLayout.data(), (UINT)mInputLayout.size() };	//해당 PSO는 이 입력 레이아웃으로 들어오는 정점만 해석.
	psoDesc.pRootSignature = mRootSignature.Get();
	psoDesc.VS = {
		reinterpret_cast<BYTE*>(mvsByteCode->GetBufferPointer()),
		mvsByteCode->GetBufferSize()
	};
	psoDesc.PS = {
		reinterpret_cast<BYTE*>(mpsByteCode->GetBufferPointer()),
		mpsByteCode->GetBufferSize()
	};
	auto RasterizerState = CD3DX12_RASTERIZER_DESC(D3D12_DEFAULT); //FillMode,CullMode 등 설정 가능.
	psoDesc.RasterizerState = RasterizerState;
	psoDesc.BlendState = CD3DX12_BLEND_DESC(D3D12_DEFAULT);	//색 합성
	psoDesc.DepthStencilState = CD3DX12_DEPTH_STENCIL_DESC(D3D12_DEFAULT);
	psoDesc.SampleMask = UINT_MAX;	//모든 샘플 사용
	psoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE::D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
	psoDesc.NumRenderTargets = 1;
	psoDesc.RTVFormats[0] = mBackBufferFormat;	//백 버퍼와 설정 동기화.
	psoDesc.SampleDesc.Count = m4xMsaaState ? 4 : 1;
	psoDesc.SampleDesc.Quality = m4xMsaaState ? (m4xMsaaQuality - 1) : 0;
	psoDesc.DSVFormat = mDepthStencilFormat;

	ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&psoDesc, IID_PPV_ARGS(&mPSO)));
}

void AppD3D::BuildRenderItem()
{
}

void AppD3D::BuildFrameResources()
{
}

void AppD3D::BuildConstantsBufferView()
{
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
	mRadius -= static_cast<long long>(zDelta) * 0.005f;
	mRadius = MathHelper::Clamp(mRadius, 0.1f, 50.0f);
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
}