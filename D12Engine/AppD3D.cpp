#include "AppD3D.h"

bool AppD3D::Initialize()
{
	if (!InitD3DApp::Initialize())
		return false;

	//Initialize()->OnResize()에서 사용 후 재사용을 위한 Reset.
	ThrowIfFailed(mCommandList->Reset(mDirectCmdListAlloc.Get(), nullptr));

	BuildDescriptorHeaps();			//CBV 힙 생성.
	BuildConstantBuffers();			//CBV 힙에 CBV 생성.
	BuildRootSignature();			//
	BuildShadersAndInputLayout();
	BuildBoxGeometry();
	BuildPSO();

	ThrowIfFailed(mCommandList->Close());
	ID3D12CommandList* cmdsLists[] = { mCommandList.Get() };
	//_countof : 배열의 원소 개수를 컴파일 타임에 계산하는 매크로. std::size()와 동일.
	mCommandQueue->ExecuteCommandLists(_countof(cmdsLists), cmdsLists);

	FlushCommandQueue();

	return true;
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

void AppD3D::BuildConstantBuffers()
{
	mObjectCB = std::make_unique<UploadBuffer<ObjectConstants>>(md3dDevice.Get(), 1, true);

	UINT objCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(ObjectConstants));

	D3D12_GPU_VIRTUAL_ADDRESS cbAddress = mObjectCB->Resource()->GetGPUVirtualAddress();
	int boxCBufIndex = 0;
	cbAddress += boxCBufIndex * objCBByteSize;

	D3D12_CONSTANT_BUFFER_VIEW_DESC cbvDesc;
	cbvDesc.BufferLocation = cbAddress;
	cbvDesc.SizeInBytes = objCBByteSize;

	md3dDevice->CreateConstantBufferView(&cbvDesc,
		mCbvHeap->GetCPUDescriptorHandleForHeapStart());
}

//루트 파라미터로 테이블을 사용하는 이유는
//테이블에 CBV 뿐만 아니라 SRV/샘플러 등 확장에 용이하기 때문이다.
void AppD3D::BuildRootSignature()
{
	//루트 시그니처는 쉐이더 프로그램의 함수 시그니처라고 생각하면 된다.
	CD3DX12_ROOT_PARAMETER slotRootParameter[1];				//루트 파라미터 1개
	CD3DX12_DESCRIPTOR_RANGE cbvTable;							//그 한개는 Table
	cbvTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_CBV, 1, 0);		//Table안에는 CBV1개 (b0에 매핑)
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
		{"POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA},
		{"COLOR", 0, DXGI_FORMAT_R32G32B32A32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA}
	};
}

void AppD3D::BuildBoxGeometry()
{
}

void AppD3D::BuildPSO()
{
}
