#pragma once

#include "DirectX-Headers\d3dx12.h"
#include <Windows.h>
#include <wrl.h>

class SobelFilter
{
public:
	/// <summary>
	/// 생성자 매개변수로 렌더 텍스처(블러용)를 생성하므로 화면 크기가 변경되면 새로 생성해야 한다.
	/// </summary>
	SobelFilter(ID3D12Device* device, UINT width, UINT height, DXGI_FORMAT format);

	SobelFilter(const SobelFilter& rhs) = delete;
	SobelFilter& operator=(const SobelFilter& rhs) = delete;
	~SobelFilter() = default;

	ID3D12Resource* SobelOutput() const;
	ID3D12Resource* CompositeOutput() const;
	CD3DX12_GPU_DESCRIPTOR_HANDLE SobelOutputSrv() const;

	UINT DescriptorCount() const;

	void BuildDescriptors(
		CD3DX12_CPU_DESCRIPTOR_HANDLE hCpuDesc,
		CD3DX12_GPU_DESCRIPTOR_HANDLE hGpuDesc,
		UINT descSize);

	void OnResize(UINT newWidth, UINT newHeight);

	void Excute(
		ID3D12GraphicsCommandList* cmdList,
		ID3D12RootSignature* rootSig,
		ID3D12PipelineState* pso,
		CD3DX12_GPU_DESCRIPTOR_HANDLE input);

	void Composite(
		ID3D12GraphicsCommandList* cmdList,
		ID3D12RootSignature* rootSig,
		ID3D12PipelineState* pso,
		CD3DX12_GPU_DESCRIPTOR_HANDLE input1,
		CD3DX12_GPU_DESCRIPTOR_HANDLE input2);

private:
	void BuildDescriptors();
	void BuildResource();
private:
	ID3D12Device* md3dDevice = nullptr;

	UINT mWidth = 0;
	UINT mHeight = 0;

	DXGI_FORMAT mFormat = DXGI_FORMAT_R8G8B8A8_UNORM;

	CD3DX12_CPU_DESCRIPTOR_HANDLE mhCpuSrv;
	CD3DX12_CPU_DESCRIPTOR_HANDLE mhCpuUav;

	CD3DX12_GPU_DESCRIPTOR_HANDLE mhGpuSrv;
	CD3DX12_GPU_DESCRIPTOR_HANDLE mhGpuUav;

	CD3DX12_CPU_DESCRIPTOR_HANDLE mhCompositeCpuSrv;
	CD3DX12_CPU_DESCRIPTOR_HANDLE mhCompositeCpuUav;

	CD3DX12_GPU_DESCRIPTOR_HANDLE mhCompositeGpuSrv;
	CD3DX12_GPU_DESCRIPTOR_HANDLE mhCompositeGpuUav;

	Microsoft::WRL::ComPtr<ID3D12Resource> mOutput_Sobel = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> mOutput_Composite = nullptr;
};