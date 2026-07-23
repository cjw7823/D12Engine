#pragma once

#include "DirectX-Headers\d3dx12.h"
#include <functional>

/// <summary>
/// 생성자 매개변수로 렌더 텍스처(블러용)를 생성하므로 화면 크기가 변경되면 새로 생성해야 한다.
/// </summary>
class BlurFilter
{
public:
	using AllocateDescriptorCallback =
		std::function<void(
			D3D12_CPU_DESCRIPTOR_HANDLE* outCpu,
			D3D12_GPU_DESCRIPTOR_HANDLE* outGpu)>;

	BlurFilter(ID3D12Device* device, UINT width, UINT height, DXGI_FORMAT format);

	BlurFilter(const BlurFilter& rhs) = delete;
	BlurFilter& operator=(const BlurFilter& rhs) = delete;
	~BlurFilter() = default;

	ID3D12Resource* SobelOutput();

	void BuildDescriptors(const AllocateDescriptorCallback& allocateDescriptor);

	void OnResize(UINT newWidth, UINT newHeight);

	void Excute(
		ID3D12GraphicsCommandList* cmdList,
		ID3D12RootSignature* rootSig,
		ID3D12PipelineState* horzBlurPSO,
		ID3D12PipelineState* vertBlurPSO,
		ID3D12Resource* input,
		D3D12_RESOURCE_STATES& inputState,
		int mBlurCount);

	UINT DescriptorCount() const;

private:
	std::vector<float> CalcGaussWeights(float sigma) const;

	void BuildDescriptors();
	void BuildResources();

private:
	const int MaxBlurRadius = 5;

	ID3D12Device* md3dDevice = nullptr;

	UINT mWidth = 0;
	UINT mHeight = 0;
	DXGI_FORMAT mFormat = DXGI_FORMAT_R8G8B8A8_UNORM;

	CD3DX12_CPU_DESCRIPTOR_HANDLE mBlur0CpuSrv;
	CD3DX12_CPU_DESCRIPTOR_HANDLE mBlur0CpuUav;

	CD3DX12_CPU_DESCRIPTOR_HANDLE mBlur1CpuSrv;
	CD3DX12_CPU_DESCRIPTOR_HANDLE mBlur1CpuUav;

	CD3DX12_GPU_DESCRIPTOR_HANDLE mBlur0GpuSrv;
	CD3DX12_GPU_DESCRIPTOR_HANDLE mBlur0GpuUav;

	CD3DX12_GPU_DESCRIPTOR_HANDLE mBlur1GpuSrv;
	CD3DX12_GPU_DESCRIPTOR_HANDLE mBlur1GpuUav;

	Microsoft::WRL::ComPtr<ID3D12Resource> mBlurMap0 = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> mBlurMap1 = nullptr;
};