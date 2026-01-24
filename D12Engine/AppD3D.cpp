#include "AppD3D.h"
#include <commdlg.h>
#include <shlobj.h>
#include <numeric>

bool AppD3D::Initialize()
{
	if (!InitD3DApp::Initialize())
		return false;

	//Initialize()->OnResize()에서 사용 후 재사용을 위한 Reset.
	ThrowIfFailed(mCommandList->Reset(mDirectCmdListAlloc.Get(), nullptr));

	BuildDescriptorHeaps();			//CBV 힙 생성.
	BuildConstantBuffers();			//CBV 힙에 CBV 생성.
	BuildRootSignature();			//루트 시그니처 생성.
	BuildShadersAndInputLayout();	//셰이더 및 입력 레이아웃 생성.
	BuildBoxGeometry();				//박스 메쉬 생성.
	BuildPSO();						//파이프라인 상태 객체(PSO) 생성.

	ThrowIfFailed(mCommandList->Close());
	ID3D12CommandList* cmdsLists[] = { mCommandList.Get() };
	//_countof : 배열의 원소 개수를 컴파일 타임에 계산하는 매크로. std::size()와 동일.
	mCommandQueue->ExecuteCommandLists(_countof(cmdsLists), cmdsLists);

	FlushCommandQueue();

	return true;
}

void AppD3D::OnResize()
{
	InitD3DApp::OnResize();
	
	DirectX::XMMATRIX P = DirectX::XMMatrixPerspectiveFovLH(0.25f * MathHelper::Pi, AspectRatio(), 1.0f, 1000.0f);
	XMStoreFloat4x4(&mProj, P);
}

void AppD3D::Update(const GameTimer& gt)
{
	//구면좌표계 -> 데카르트 좌표계 변환.
	//방위각은 XZ평면에서 +X축을 기준으로 +Z방향으로 증가.
	float x = mRadius * sinf(mPhi) * cosf(mTheta);
	float y = mRadius * cosf(mPhi);
	float z = mRadius * sinf(mPhi) * sinf(mTheta);

	DirectX::XMVECTOR pos = DirectX::XMVectorSet(x, y, z, 1.0f);
	DirectX::XMVECTOR target = DirectX::XMVectorZero();
	DirectX::XMVECTOR up = DirectX::XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f);

	//좌수 좌표계 행렬 생성.
	DirectX::XMMATRIX view = DirectX::XMMatrixLookAtLH(pos, target, up);
	DirectX::XMStoreFloat4x4(&mView, view);

	DirectX::XMMATRIX world = DirectX::XMLoadFloat4x4(&mWorld);
	DirectX::XMMATRIX proj= DirectX::XMLoadFloat4x4(&mProj);
	DirectX::XMMATRIX worldViewProj1 = world * DirectX::XMMatrixTranslation(-2.0f, 0.0f, 0.0f) * view * proj;
	DirectX::XMMATRIX worldViewProj2 = world * DirectX::XMMatrixTranslation(2.0f, 0.0f, 0.0f) * view * proj;

	ObjectConstants objConstants1;
	//CPU와 GPU는 서로 다른 팀, 다른 시대, 다른 목적에서 설계됐다.
	//CPU는 RowMajor, GPU는 ColumnMajor 행렬을 선호.
	//따라서 행렬을 전치(transpose)해서 복사해야 한다.
	DirectX::XMStoreFloat4x4(&objConstants1.WorldViewProj, DirectX::XMMatrixTranspose(worldViewProj1));
	objConstants1.Time = gt.TotalTime();

	mObjectCB->CopyData(0, objConstants1);

	ObjectConstants objConstants2;
	DirectX::XMStoreFloat4x4(&objConstants2.WorldViewProj, DirectX::XMMatrixTranspose(worldViewProj2));
	objConstants2.Time = gt.TotalTime();

	mObjectCB->CopyData(1, objConstants2);
}

void AppD3D::Draw(const GameTimer& gt)
{
	//fence로 완료를 보장한 뒤 Reset 가능.
	//Allocator가 제공하는 메모리 영역은 3대 힙메모리가 아님. (Default, Upload, Readback)
	ThrowIfFailed(mDirectCmdListAlloc->Reset()); //메모리 풀 초기화
	ThrowIfFailed(mCommandList->Reset(mDirectCmdListAlloc.Get(), mPSO.Get())); //커맨드 리스트 초기화 및 PSO셋팅

	mCommandList->RSSetViewports(1, &mScreenViewport);
	mCommandList->RSSetScissorRects(1, &mScissorRect);

	//백버퍼를 PREENT 상태에서 RENDER_TARGET 상태로 전환.
	//PRESENT: 스왑체인이 화면에 내보내는 용도
	//RENDER_TARGET: 픽셀을 써서 렌더링하는 용도
	auto barrier = CD3DX12_RESOURCE_BARRIER::Transition(
		CurrentBackBuffer(),
		D3D12_RESOURCE_STATE_PRESENT,
		D3D12_RESOURCE_STATE_RENDER_TARGET
	);
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
		mBoxGeo->VertexBufferView(1)
	};
	mCommandList->IASetVertexBuffers(0, 2, vbv);
	auto ibv = mBoxGeo->IndexBufferView();
	mCommandList->IASetIndexBuffer(&ibv);

	mCommandList->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

	auto heapstart = mCbvHeap->GetGPUDescriptorHandleForHeapStart();
	int index = 0;
	for( auto a = mBoxGeo->DrawArgs.begin() ; a!= mBoxGeo->DrawArgs.end() ; a++ )
	{
		D3D12_GPU_DESCRIPTOR_HANDLE heap = heapstart;
		heap.ptr += index * mCbvSrvUavDescriptorSize;

		mCommandList->SetGraphicsRootDescriptorTable(0, heap);

		auto submesh = a->second;
		mCommandList->DrawIndexedInstanced(
			submesh.IndexCount,
			1,
			submesh.StartIndexLocation,
			submesh.BaseVertexLocation,
			0
		);

		index++;
	}

	auto barrier2 = CD3DX12_RESOURCE_BARRIER::Transition(
		CurrentBackBuffer(),
		D3D12_RESOURCE_STATE_RENDER_TARGET,
		D3D12_RESOURCE_STATE_PRESENT
	);
	mCommandList->ResourceBarrier(1, &barrier2);

	ThrowIfFailed(mCommandList->Close());

	ID3D12CommandList* cmdsLists[] = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(_countof(cmdsLists), cmdsLists);

	//swap chain의 버퍼를 화면에 내보내기.
	ThrowIfFailed(mSwapChain->Present(0, 0));
	mCurrBackBuffer = (mCurrBackBuffer + 1) % SwapChainBufferCount;

	//이 대기는 비효율적이라고 설명됨.
	//추후 프레임별로 기다릴 필요가 없도록 렌더링 코드를 구성하는 방법을 보여준다고 한다.
	FlushCommandQueue();
}

void AppD3D::BuildDescriptorHeaps()
{
	D3D12_DESCRIPTOR_HEAP_DESC cbvHeapDesc;
	cbvHeapDesc.NumDescriptors = 2;
	cbvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
	cbvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
	cbvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&cbvHeapDesc, IID_PPV_ARGS(&mCbvHeap)));
}

void AppD3D::BuildConstantBuffers()
{
	mObjectCB = std::make_unique<UploadBuffer<ObjectConstants>>(md3dDevice.Get(), 2, true);

	UINT objCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(ObjectConstants));

	for (int i = 0; i < 2; ++i)
	{
		D3D12_GPU_VIRTUAL_ADDRESS cbAddress =
			mObjectCB->Resource()->GetGPUVirtualAddress() + i * objCBByteSize;

		D3D12_CONSTANT_BUFFER_VIEW_DESC cbvDesc = {};
		cbvDesc.BufferLocation = cbAddress;
		cbvDesc.SizeInBytes = objCBByteSize;

		D3D12_CPU_DESCRIPTOR_HANDLE handle =
			mCbvHeap->GetCPUDescriptorHandleForHeapStart();
		handle.ptr += i * mCbvSrvUavDescriptorSize;

		md3dDevice->CreateConstantBufferView(&cbvDesc, handle);
	}
}

//루트 파라미터로 테이블을 사용하는 이유는
//테이블에 CBV 뿐만 아니라 SRV/샘플러 등 확장에 용이하기 때문이다.
void AppD3D::BuildRootSignature()
{
	//루트 시그니처는 쉐이더 프로그램의 함수 시그니처라고 생각하면 된다.
	CD3DX12_ROOT_PARAMETER slotRootParameter[1];				//루트 파라미터 1개
	CD3DX12_DESCRIPTOR_RANGE cbvTable;							//그 한개는 Table
	cbvTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_CBV, 2, 0);		//Table안에는 CBV1개 (b0에 매핑)
	slotRootParameter[0].InitAsDescriptorTable(1, &cbvTable);

	//루트 시그니처는 루트 파라미터의 배열이다.
	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(1, slotRootParameter,		//루트 파라미터 1개
		0, nullptr,														//정적 샘플러 없음
		D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);	//IA의 입력 레이아웃 허용

	Microsoft::WRL::ComPtr<ID3DBlob> serializedRootSig = nullptr;
	Microsoft::WRL::ComPtr<ID3DBlob> errorBlob = nullptr;
	//직렬화 바이너리 표현. 아직까지 GPU객체 아니고 메모리에 존재.
	HRESULT hr = D3D12SerializeRootSignature(&rootSigDesc, D3D_ROOT_SIGNATURE_VERSION_1,
		serializedRootSig.GetAddressOf(), errorBlob.GetAddressOf());

	if (errorBlob != nullptr)
		::OutputDebugStringA((char*)errorBlob->GetBufferPointer());
	ThrowIfFailed(hr);

	//GPU가 인식하는 루트 서명 객체.
	ThrowIfFailed(md3dDevice->CreateRootSignature(
		0,										//GPU 노드
		serializedRootSig->GetBufferPointer(),	//직렬화 바이너리의 시작 주소 / 크기
		serializedRootSig->GetBufferSize(),
		IID_PPV_ARGS(&mRootSignature)));
}

void AppD3D::BuildShadersAndInputLayout()
{
	HRESULT hr = S_OK;

	mvsByteCode = d3dUtil::CompileShader(L"../Shaders/color.hlsl", nullptr, "VS", "vs_5_0");
	mpsByteCode = d3dUtil::CompileShader(L"../Shaders/color.hlsl", nullptr, "PS", "ps_5_0");

	mInputLayout =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
		{ "COLOR", 0, DXGI_FORMAT_R32G32B32A32_FLOAT, 1, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 }
	};
}

//추후 파일에서 loading 하자.
void AppD3D::BuildBoxGeometry()
{
	using namespace DirectX;

    std::array<Vertex1, 8> BoxPos =
    {
		Vertex1({ XMFLOAT3(-1.0f, -1.0f, -1.0f) }),
		Vertex1({ XMFLOAT3(-1.0f, +1.0f, -1.0f) }),
		Vertex1({ XMFLOAT3(+1.0f, +1.0f, -1.0f) }),
		Vertex1({ XMFLOAT3(+1.0f, -1.0f, -1.0f) }),
		Vertex1({ XMFLOAT3(-1.0f, -1.0f, +1.0f) }),
		Vertex1({ XMFLOAT3(-1.0f, +1.0f, +1.0f) }),
		Vertex1({ XMFLOAT3(+1.0f, +1.0f, +1.0f) }),
		Vertex1({ XMFLOAT3(+1.0f, -1.0f, +1.0f) })
    };

    std::array<Vertex2, 8> BoxCol =
    {
		Vertex2({ XMFLOAT4(Colors::White) }),
		Vertex2({ XMFLOAT4(Colors::Black) }),
		Vertex2({ XMFLOAT4(Colors::Red) }),
		Vertex2({ XMFLOAT4(Colors::Green) }),
		Vertex2({ XMFLOAT4(Colors::Blue) }),
		Vertex2({ XMFLOAT4(Colors::Yellow) }),
		Vertex2({ XMFLOAT4(Colors::Cyan) }),
		Vertex2({ XMFLOAT4(Colors::Magenta) })
    };

	std::array<std::uint16_t, 36> indicesBox =
	{
		// front face
		0, 1, 2,
		0, 2, 3,

		// back face
		4, 6, 5,
		4, 7, 6,

		// left face
		4, 5, 1,
		4, 1, 0,

		// right face
		3, 2, 6,
		3, 6, 7,

		// top face
		1, 5, 6,
		1, 6, 2,

		// bottom face
		4, 0, 3,
		4, 3, 7
	};

	//고정크기, 크기정보 포함 이므로 array사용.
	std::array<Vertex1, 5> verticesPos =
	{
		Vertex1({XMFLOAT3(-1.0f, -1.0f, -1.0f)}),
		Vertex1({XMFLOAT3(+1.0f, -1.0f, -1.0f)}),
		Vertex1({XMFLOAT3(-1.0f, -1.0f, +1.0f)}),
		Vertex1({XMFLOAT3(+1.0f, -1.0f, +1.0f)}),
		Vertex1({XMFLOAT3(0.0f, +1.0f, 0.0f)}),
	};

	std::array<Vertex2, 5> verticesCol =
	{
		Vertex2({XMFLOAT4(Colors::Green)}),
		Vertex2({XMFLOAT4(Colors::Green)}),
		Vertex2({XMFLOAT4(Colors::Green)}),
		Vertex2({XMFLOAT4(Colors::Green)}),
		Vertex2({XMFLOAT4(Colors::Red)}),
	};

	std::array<std::uint16_t, 18> indices =
	{
		//아래면
		0,1,2,
		1,3,2,

		//앞면
		0,4,1,

		//오른쪽면
		1,4,3,

		//뒷면
		3,4,2,

		//왼쪽면
		2,4,0
	};

	std::vector<UINT> vbpByteSizes;
	vbpByteSizes.push_back((UINT)BoxPos.size() * sizeof(Vertex1));
	vbpByteSizes.push_back((UINT)verticesPos.size() * sizeof(Vertex1));
	std::vector<UINT> vbcByteSizes;
	vbcByteSizes.push_back((UINT)BoxCol.size() * sizeof(Vertex2));
	vbcByteSizes.push_back((UINT)verticesCol.size() * sizeof(Vertex2));
	std::vector<UINT> ibByteSizes;
	ibByteSizes.push_back((UINT)indicesBox.size() * sizeof(std::uint16_t));
	ibByteSizes.push_back((UINT)indices.size() * sizeof(std::uint16_t));

	int allVbpByteSizes = std::accumulate(vbpByteSizes.begin(), vbpByteSizes.end(), 0);
	int allVbcByteSizes = std::accumulate(vbcByteSizes.begin(), vbcByteSizes.end(), 0);
	int allIbByteSizes = std::accumulate(ibByteSizes.begin(), ibByteSizes.end(), 0);

	mBoxGeo = std::make_unique<MeshGeometry>();
	mBoxGeo->InitializeVertexBuffers(2); //정점 버퍼 2개
	mBoxGeo->Name = "mergeMesh";

	ThrowIfFailed(D3DCreateBlob(allVbpByteSizes, mBoxGeo->VertexBufferCPU[0].GetAddressOf()));
	{
		auto* dst = reinterpret_cast<char*>(mBoxGeo->VertexBufferCPU[0]->GetBufferPointer());
		CopyMemory(dst, BoxPos.data(), vbpByteSizes[0]);
		CopyMemory(dst + vbpByteSizes[0], verticesPos.data(), vbpByteSizes[1]);
	}
	ThrowIfFailed(D3DCreateBlob(allVbcByteSizes, mBoxGeo->VertexBufferCPU[1].GetAddressOf()));
	{
		auto* dst = reinterpret_cast<char*>(mBoxGeo->VertexBufferCPU[1]->GetBufferPointer());
		CopyMemory(dst, BoxCol.data(), vbcByteSizes[0]);
		CopyMemory(dst + vbcByteSizes[0], verticesCol.data(), vbcByteSizes[1]);
	}

	ThrowIfFailed(D3DCreateBlob(allIbByteSizes, &mBoxGeo->IndexBufferCPU));
	{
		auto* dst = reinterpret_cast<char*>(mBoxGeo->IndexBufferCPU->GetBufferPointer());
		CopyMemory(dst, indicesBox.data(), ibByteSizes[0]);
		CopyMemory(dst + ibByteSizes[0], indices.data(), ibByteSizes[1]);
	}
	
	std::vector<Vertex1> mergeBoxPos;
	mergeBoxPos.insert(mergeBoxPos.end(), BoxPos.begin(), BoxPos.end());
	mergeBoxPos.insert(mergeBoxPos.end(), verticesPos.begin(), verticesPos.end());
	std::vector<Vertex2> mergeBoxCol;
	mergeBoxCol.insert(mergeBoxCol.end(), BoxCol.begin(), BoxCol.end());
	mergeBoxCol.insert(mergeBoxCol.end(), verticesCol.begin(), verticesCol.end());
	std::vector<std::uint16_t> indicesBoxMerged;
	indicesBoxMerged.insert(indicesBoxMerged.end(), indicesBox.begin(), indicesBox.end());
	indicesBoxMerged.insert(indicesBoxMerged.end(), indices.begin(), indices.end());

	mBoxGeo->VertexBufferGPU[0] = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(),
		mCommandList.Get(), mergeBoxPos.data(), allVbpByteSizes, mBoxGeo->VertexBufferUploader[0]);
	mBoxGeo->VertexBufferGPU[1] = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(),
		mCommandList.Get(), mergeBoxCol.data(), allVbcByteSizes, mBoxGeo->VertexBufferUploader[1]);
	mBoxGeo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(),
		mCommandList.Get(), indicesBoxMerged.data(), allIbByteSizes, mBoxGeo->IndexBufferUploader);

	mBoxGeo->VertexByteStride[0] = sizeof(Vertex1);
	mBoxGeo->VertexByteStride[1] = sizeof(Vertex2);
	mBoxGeo->VertexBufferByteSize[0] = std::accumulate(vbpByteSizes.begin(), vbpByteSizes.end(), 0);
	mBoxGeo->VertexBufferByteSize[1] = std::accumulate(vbcByteSizes.begin(), vbcByteSizes.end(), 0);
	mBoxGeo->IndexFormat = DXGI_FORMAT_R16_UINT;
	mBoxGeo->IndexBufferByteSize = std::accumulate(ibByteSizes.begin(), ibByteSizes.end(), 0);

	SubmeshGeometry submesh;
	submesh.IndexCount = indicesBox.size();
	submesh.StartIndexLocation = 0;
	submesh.BaseVertexLocation = 0;

	mBoxGeo->DrawArgs["box"] = submesh;

	SubmeshGeometry submesh2;
	submesh2.IndexCount = indices.size();
	submesh2.StartIndexLocation = indicesBox.size();
	submesh2.BaseVertexLocation = BoxPos.size();

	mBoxGeo->DrawArgs["square pyramid"] = submesh2;
}

void AppD3D::BuildPSO()
{
	D3D12_GRAPHICS_PIPELINE_STATE_DESC psoDesc;
	ZeroMemory(&psoDesc, sizeof(D3D12_GRAPHICS_PIPELINE_STATE_DESC));	//쓰레기 값 초기화. 안전장치.
	psoDesc.InputLayout = { mInputLayout.data(), (UINT)mInputLayout.size() };	//해당 PSO는 이 입력 레이아웃으로 들어오는 정점만 해석.
	psoDesc.pRootSignature = mRootSignature.Get();	//셰이더가 기대하는 바인딩 규칙.
	psoDesc.VS =
	{
		reinterpret_cast<BYTE*>(mvsByteCode->GetBufferPointer()),	//static_cast는 의미적으로 안전한 변환(상속 관계, 수치 변환 등)만 허용.
		mvsByteCode->GetBufferSize()
	};
	psoDesc.PS =
	{
		reinterpret_cast<BYTE*>(mpsByteCode->GetBufferPointer()),
		mpsByteCode->GetBufferSize()
	};
	psoDesc.RasterizerState = CD3DX12_RASTERIZER_DESC(D3D12_DEFAULT);		//기하->픽셀
	psoDesc.BlendState = CD3DX12_BLEND_DESC(D3D12_DEFAULT);					//색 합성
	psoDesc.DepthStencilState = CD3DX12_DEPTH_STENCIL_DESC(D3D12_DEFAULT);	//깊이 스텐실 테스트
	psoDesc.SampleMask = UINT_MAX;											//모든 샘플 사용
	psoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE::D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
	psoDesc.NumRenderTargets = 1;
	psoDesc.RTVFormats[0] = mBackBufferFormat;								//백 버퍼와 설정 동기화.
	psoDesc.SampleDesc.Count = m4xMsaaState ? 4 : 1;
	psoDesc.SampleDesc.Quality = m4xMsaaState ? (m4xMsaaQuality - 1) : 0;
	psoDesc.DSVFormat = mDepthStencilFormat;
	ThrowIfFailed(md3dDevice->CreateGraphicsPipelineState(&psoDesc, IID_PPV_ARGS(&mPSO)));
}

void AppD3D::OnMouseDown(WPARAM btnState, int x, int y)
{
	mLastMousePos.x = x;
	mLastMousePos.y = y;

	//마우스 커서가 창 밖으로 나가도 마우스 메시지가 계속 이 창으로 들어옴.
	SetCapture(mhMainWnd);
}

void AppD3D::OnMouseUp(WPARAM btnState, int x, int y)
{
	ReleaseCapture();
}

void AppD3D::OnMouseMove(WPARAM btnState, int x, int y)
{
	if ((btnState & MK_LBUTTON) != 0)	//회전
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
	//확대/축소
	mRadius -= static_cast<long long>(zDelta) * 0.005f;
	mRadius = MathHelper::Clamp(mRadius, 0.1f, 50.0f);
}

void AppD3D::OnKeyDown(WPARAM key)
{
}
