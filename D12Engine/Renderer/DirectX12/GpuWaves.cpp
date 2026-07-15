#include "pch.h"
#include "GpuWaves.h"
#include "Renderer/DirectX12/D3D12Util.h"
#include "Renderer/DirectX12/MACRO.h"

GpuWaves::GpuWaves(ID3D12Device* device, ID3D12GraphicsCommandList* cmdList, int m, int n, float dx, float dt, float speed, float damping)
{
	md3dDevice = device;
	mNumRows = m;
	mNumCols = n;
	assert((m * n) % 256 == 0); //업로드 버퍼의 크기는 256바이트의 배수여야 함.

	mVertexCount = m * n;
	mTriangleCount = (m - 1) * (n - 1) * 2;

	mTimeStep = dt;
	mSpatialStep = dx;

	float d = damping * dt + 2.0f;
	float e = (speed * speed) * (dt * dt) / (dx * dx);
	mK[0] = (damping * dt - 2.0f) / d;
	mK[1] = (4.0f - 8.0f * e) / d;
	mK[2] = (2.0f * e) / d;

	BuildResource(cmdList);
}

UINT GpuWaves::RowCount() const
{
	return mNumRows;
}

UINT GpuWaves::ColumnCount() const
{
	return mNumCols;
}

UINT GpuWaves::VertexCount() const
{
	return mVertexCount;
}

UINT GpuWaves::TriangleCount() const
{
	return mTriangleCount;
}

float GpuWaves::Width() const
{
	return mNumCols * mSpatialStep;
}

float GpuWaves::Depth() const
{
	return mNumRows * mSpatialStep;
}

float GpuWaves::SpatialStep() const
{
	return mSpatialStep;
}

D3D12_GPU_DESCRIPTOR_HANDLE GpuWaves::DisplacementMap() const
{
	return mCurrSolSrv;
}

UINT GpuWaves::DescriptorCount() const
{
	//GpuWaves의 필드 중 디스크립터 수.
	return 6;
}

void GpuWaves::BuildResource(ID3D12GraphicsCommandList* cmdList)
{
	D3D12_RESOURCE_DESC texDesc;
	ZeroMemory(&texDesc, sizeof(D3D12_RESOURCE_DESC));
	texDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
	texDesc.Alignment = 0;
	texDesc.Width = mNumCols;
	texDesc.Height = mNumRows;
	texDesc.DepthOrArraySize = 1;
	texDesc.MipLevels = 1;
	texDesc.Format = DXGI_FORMAT_R32_FLOAT;
	texDesc.SampleDesc.Count = 1;
	texDesc.SampleDesc.Quality = 0;
	texDesc.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
	texDesc.Flags = D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS;

	CD3DX12_HEAP_PROPERTIES defaultHeapProps(D3D12_HEAP_TYPE_DEFAULT);
	
	ThrowIfFailed(md3dDevice->CreateCommittedResource(
		&defaultHeapProps,
		D3D12_HEAP_FLAG_NONE,
		&texDesc,
		D3D12_RESOURCE_STATE_COMMON,
		nullptr,
		IID_PPV_ARGS(mPrevSol.GetAddressOf())));
	ThrowIfFailed(md3dDevice->CreateCommittedResource(
		&defaultHeapProps,
		D3D12_HEAP_FLAG_NONE,
		&texDesc,
		D3D12_RESOURCE_STATE_COMMON,
		nullptr,
		IID_PPV_ARGS(mCurrSol.GetAddressOf())));
	ThrowIfFailed(md3dDevice->CreateCommittedResource(
		&defaultHeapProps,
		D3D12_HEAP_FLAG_NONE,
		&texDesc,
		D3D12_RESOURCE_STATE_COMMON,
		nullptr,
		IID_PPV_ARGS(mNextSol.GetAddressOf())));

	const UINT num2DSubresources = texDesc.DepthOrArraySize * texDesc.MipLevels;
	const UINT64 uploadBufferSize = GetRequiredIntermediateSize(mPrevSol.Get(), 0, num2DSubresources);
	
	CD3DX12_HEAP_PROPERTIES uploadHeapProps(D3D12_HEAP_TYPE_UPLOAD);
	CD3DX12_RESOURCE_DESC defaultResourceDesc = CD3DX12_RESOURCE_DESC::Buffer(uploadBufferSize);

	ThrowIfFailed(md3dDevice->CreateCommittedResource(
		&uploadHeapProps,
		D3D12_HEAP_FLAG_NONE,
		&defaultResourceDesc,
		D3D12_RESOURCE_STATE_GENERIC_READ,
		nullptr,
		IID_PPV_ARGS(&mPrevUploadBuffer)));

	ThrowIfFailed(md3dDevice->CreateCommittedResource(
		&uploadHeapProps,
		D3D12_HEAP_FLAG_NONE,
		&defaultResourceDesc,
		D3D12_RESOURCE_STATE_GENERIC_READ,
		nullptr,
		IID_PPV_ARGS(&mCurrUploadBuffer)));

	std::vector<float> initData(mNumRows * mNumCols, 0.0f);

	D3D12_SUBRESOURCE_DATA subResourceData = {};
	subResourceData.pData = initData.data();
	subResourceData.RowPitch = mNumCols * sizeof(float);
	subResourceData.SlicePitch = subResourceData.RowPitch * mNumRows;

	//셰이더에서 출력 대상이 되므로 UAV. 버퍼를 돌렸는 구조(핑퐁 방식).
	CD3DX12_RESOURCE_BARRIER barrier = CD3DX12_RESOURCE_BARRIER::Transition(
		mPrevSol.Get(),
		D3D12_RESOURCE_STATE_COMMON,
		D3D12_RESOURCE_STATE_COPY_DEST);
	cmdList->ResourceBarrier(1, &barrier);

	UpdateSubresources(cmdList, mPrevSol.Get(), mPrevUploadBuffer.Get(), 0, 0, num2DSubresources, &subResourceData);

	barrier = CD3DX12_RESOURCE_BARRIER::Transition(
		mPrevSol.Get(),
		D3D12_RESOURCE_STATE_COPY_DEST,
		D3D12_RESOURCE_STATE_UNORDERED_ACCESS);
	cmdList->ResourceBarrier(1, &barrier);

	//초기 프레임에서 현재 상태를 읽어야 하기 때문에 READ 상태로 복사.
	barrier = CD3DX12_RESOURCE_BARRIER::Transition(
		mCurrSol.Get(),
		D3D12_RESOURCE_STATE_COMMON,
		D3D12_RESOURCE_STATE_COPY_DEST);
	cmdList->ResourceBarrier(1, &barrier);

	UpdateSubresources(cmdList, mCurrSol.Get(), mCurrUploadBuffer.Get(), 0, 0, num2DSubresources, &subResourceData);

	barrier = CD3DX12_RESOURCE_BARRIER::Transition(
		mCurrSol.Get(),
		D3D12_RESOURCE_STATE_COPY_DEST,
		D3D12_RESOURCE_STATE_GENERIC_READ);
	cmdList->ResourceBarrier(1, &barrier);

	barrier = CD3DX12_RESOURCE_BARRIER::Transition(
		mNextSol.Get(),
		D3D12_RESOURCE_STATE_COMMON,
		D3D12_RESOURCE_STATE_UNORDERED_ACCESS);
	cmdList->ResourceBarrier(1, &barrier);
}

void GpuWaves::BuildDescriptors(const AllocateDescriptorCallback& allocateDescriptor)
{
	assert(allocateDescriptor);

	D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc = {};
	srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
	srvDesc.Format = DXGI_FORMAT_R32_FLOAT;
	srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
	srvDesc.Texture2D.MipLevels = 1;
	srvDesc.Texture2D.MostDetailedMip = 0;

	D3D12_UNORDERED_ACCESS_VIEW_DESC uavDesc = {};
	uavDesc.Format = DXGI_FORMAT_R32_FLOAT;
	uavDesc.ViewDimension = D3D12_UAV_DIMENSION_TEXTURE2D;
	uavDesc.Texture2D.MipSlice = 0;

	CD3DX12_CPU_DESCRIPTOR_HANDLE hCpu{};
	CD3DX12_GPU_DESCRIPTOR_HANDLE hGpu{};

	allocateDescriptor(&hCpu, &hGpu);
	md3dDevice->CreateShaderResourceView(mPrevSol.Get(), &srvDesc, hCpu);
	mPrevSolSrv = hGpu;
	allocateDescriptor(&hCpu, &hGpu);
	md3dDevice->CreateShaderResourceView(mCurrSol.Get(), &srvDesc, hCpu);
	mCurrSolSrv = hGpu;
	allocateDescriptor(&hCpu, &hGpu);
	md3dDevice->CreateShaderResourceView(mNextSol.Get(), &srvDesc, hCpu);
	mNextSolSrv = hGpu;

	allocateDescriptor(&hCpu, &hGpu);
	md3dDevice->CreateUnorderedAccessView(mPrevSol.Get(), nullptr, &uavDesc, hCpu);
	mPrevSolUav = hGpu;
	allocateDescriptor(&hCpu, &hGpu);
	md3dDevice->CreateUnorderedAccessView(mCurrSol.Get(), nullptr, &uavDesc, hCpu);
	mCurrSolUav = hGpu;
	allocateDescriptor(&hCpu, &hGpu);
	md3dDevice->CreateUnorderedAccessView(mNextSol.Get(), nullptr, &uavDesc, hCpu);
	mNextSolUav = hGpu;
}

void GpuWaves::Update(const GameTimer & gt, ID3D12GraphicsCommandList * cmdList, ID3D12RootSignature * rootSig, ID3D12PipelineState * pso)
{
	static float t = 0.0f;
	t += gt.DeltaTime();
	if (t >= mTimeStep)
	{
		cmdList->SetPipelineState(pso);
		cmdList->SetComputeRootSignature(rootSig);

		TransitionIfNeeded(cmdList, mPrevSol.Get(), mPrevSolState, D3D12_RESOURCE_STATE_UNORDERED_ACCESS);
		TransitionIfNeeded(cmdList, mCurrSol.Get(), mCurrSolState, D3D12_RESOURCE_STATE_UNORDERED_ACCESS);
		TransitionIfNeeded(cmdList, mNextSol.Get(), mNextSolState, D3D12_RESOURCE_STATE_UNORDERED_ACCESS);

		cmdList->SetComputeRoot32BitConstants(0, 3, mK, 0);
		cmdList->SetComputeRootDescriptorTable(1, mPrevSolUav);
		cmdList->SetComputeRootDescriptorTable(2, mCurrSolUav);
		cmdList->SetComputeRootDescriptorTable(3, mNextSolUav);

		//wave 격자를 모두 덮기 위해 몇 개의 그룹을 dispatch해야 하는지 계산.
		//mNumRows, mNumCols는 16으로 나누어 떨어져야 나머지가 생기지 않음.
		UINT numGroupsX = mNumCols / 16;
		UINT numGroupsY = mNumRows / 16;
		cmdList->Dispatch(numGroupsX, numGroupsY, 1);

		/*
			다음 업데이트를 준비하기 위해 버퍼를 ping-pong한다.
			이전 해는 더 이상 필요 없으므로 다음 업데이트에서 새로운 결과를 쓸 대상이 된다.
		*/
		std::swap(mPrevSol, mCurrSol);
		std::swap(mCurrSol, mNextSol);

		std::swap(mPrevSolSrv, mCurrSolSrv);
		std::swap(mCurrSolSrv, mNextSolSrv);

		std::swap(mPrevSolUav, mCurrSolUav);
		std::swap(mCurrSolUav, mNextSolUav);

		std::swap(mPrevSolState, mCurrSolState);
		std::swap(mCurrSolState, mNextSolState);

		t = 0.0f;
	}
}

void GpuWaves::Disturb(ID3D12GraphicsCommandList * cmdList, ID3D12RootSignature * rootSig, ID3D12PipelineState * pso, UINT i, UINT j, float magnitude)
{
	cmdList->SetPipelineState(pso);
	cmdList->SetComputeRootSignature(rootSig);

	//직전 렌더 패스에서 vertex shader가 읽기 위해 GENERIC_READ였던 mCurrSol을, 지금 compute disturb 패스에서는 RWTexture2D로 수정할 것이므로 UNORDERED_ACCESS로 전이한다.
	TransitionIfNeeded(cmdList, mCurrSol.Get(), mCurrSolState, D3D12_RESOURCE_STATE_UNORDERED_ACCESS);

	UINT disturbIndex[] = { i, j };
	cmdList->SetComputeRoot32BitConstants(0, 1, &magnitude, 3);
	cmdList->SetComputeRoot32BitConstants(0, 2, disturbIndex, 4);
	cmdList->SetComputeRootDescriptorTable(3, mCurrSolUav);
	

	//하나의 스레드 그룹이 하나의 스레드를 실행하고, 그 스레드가 하나의 정점과 그 주변 정점들의 높이를 변화시킨다.
	cmdList->Dispatch(1, 1, 1);

	//이후 Update()에서 UAV 접근이 이뤄질 수 있다.
	//UAV -> UAV 접근은 상태 전환이 발생하지 않으므로, UAV barrier로 이전 write의 완료/가시성을 보장한다.
	auto barrier = CD3DX12_RESOURCE_BARRIER::UAV(mCurrSol.Get());
	cmdList->ResourceBarrier(1, &barrier);
}

void GpuWaves::PrepareDraw(ID3D12GraphicsCommandList* cmdList)
{
	TransitionIfNeeded(
		cmdList,
		mCurrSol.Get(),
		mCurrSolState,
		D3D12_RESOURCE_STATE_GENERIC_READ);
}

void GpuWaves::TransitionIfNeeded(ID3D12GraphicsCommandList * cmdList, ID3D12Resource * resource, D3D12_RESOURCE_STATES& currState, D3D12_RESOURCE_STATES newState)
{
	if (currState != newState)
	{
		auto barrier = CD3DX12_RESOURCE_BARRIER::Transition(resource, currState, newState);
		cmdList->ResourceBarrier(1, &barrier);	
		currState = newState;
	}
}