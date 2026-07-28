#pragma once

#include "EngineCore/GameTimer.h"
#include <functional>

class GpuWaves
{
public:
	using AllocateDescriptorCallback =
		std::function<void(
			D3D12_CPU_DESCRIPTOR_HANDLE* outCpu,
			D3D12_GPU_DESCRIPTOR_HANDLE* outGpu)>;

	using FreeDescriptorCallback =
		std::function<void(D3D12_GPU_DESCRIPTOR_HANDLE gpu)>;

	GpuWaves(ID3D12Device* device, ID3D12GraphicsCommandList* cmdList,
		int m, int n, float dx, float dt, float speed, float damping);
	GpuWaves(const GpuWaves& rhs) = delete;
	GpuWaves& operator=(const GpuWaves& rhs) = delete;
	~GpuWaves();

	UINT RowCount() const;
	UINT ColumnCount() const;
	UINT VertexCount() const;
	UINT TriangleCount() const;
	float Width() const;
	float Depth() const;
	float SpatialStep() const;

	D3D12_GPU_DESCRIPTOR_HANDLE DisplacementMap() const;

	UINT DescriptorCount() const;

	void BuildResource(ID3D12GraphicsCommandList* cmdList);

	void BuildDescriptors(const AllocateDescriptorCallback& allocateDescriptor,
		FreeDescriptorCallback freeDescriptor);

	void Update(
		const GameTimer& gt,
		ID3D12GraphicsCommandList* cmdList,
		ID3D12RootSignature* rootSig,
		ID3D12PipelineState* pso);

	void Disturb(
		ID3D12GraphicsCommandList* cmdList,
		ID3D12RootSignature* rootSig,
		ID3D12PipelineState* pso,
		UINT i, UINT j, float magnitude);

	void PrepareDraw(ID3D12GraphicsCommandList* cmdList);

private:
	void TransitionIfNeeded(
		ID3D12GraphicsCommandList* cmdList,
		ID3D12Resource* resource,
		D3D12_RESOURCE_STATES& currState,
		D3D12_RESOURCE_STATES newState);

private:
	UINT mNumRows;
	UINT mNumCols;

	UINT mVertexCount;
	UINT mTriangleCount;

	float mK[3];

	float mTimeStep;
	float mSpatialStep;

	ID3D12Device* md3dDevice = nullptr;

	CD3DX12_GPU_DESCRIPTOR_HANDLE mPrevSolSrv;
	CD3DX12_GPU_DESCRIPTOR_HANDLE mCurrSolSrv;
	CD3DX12_GPU_DESCRIPTOR_HANDLE mNextSolSrv;

	CD3DX12_GPU_DESCRIPTOR_HANDLE mPrevSolUav;
	CD3DX12_GPU_DESCRIPTOR_HANDLE mCurrSolUav;
	CD3DX12_GPU_DESCRIPTOR_HANDLE mNextSolUav;

	D3D12_RESOURCE_STATES mPrevSolState = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;
	D3D12_RESOURCE_STATES mCurrSolState = D3D12_RESOURCE_STATE_GENERIC_READ;
	D3D12_RESOURCE_STATES mNextSolState = D3D12_RESOURCE_STATE_UNORDERED_ACCESS;

	Microsoft::WRL::ComPtr<ID3D12Resource> mPrevSol = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> mCurrSol = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> mNextSol = nullptr;

	Microsoft::WRL::ComPtr<ID3D12Resource> mPrevUploadBuffer = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> mCurrUploadBuffer = nullptr;

	FreeDescriptorCallback mFreeDescriptorCallback;

	DirectX::XMFLOAT2 DisplacementMapTexelSize = { 1.0f, 1.0f };
	float GridSpatialStep = 1.0f;
};