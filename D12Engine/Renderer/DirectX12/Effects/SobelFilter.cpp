#include "pch.h"
#include "SobelFilter.h"
#include "Renderer/DirectX12/MACRO.h"

#include <cassert>

SobelFilter::SobelFilter(ID3D12Device* device, UINT width, UINT height, DXGI_FORMAT format)
{
	md3dDevice = device;
	mWidth = width;
	mHeight = height;
	mFormat = format;

	BuildResource();
}

ID3D12Resource* SobelFilter::SobelOutput() const
{
	return mOutput_Sobel.Get();
}

ID3D12Resource* SobelFilter::CompositeOutput() const
{
	return mOutput_Composite.Get();
}

CD3DX12_GPU_DESCRIPTOR_HANDLE SobelFilter::SobelOutputSrv() const
{
	return mhGpuSrv;
}

UINT SobelFilter::DescriptorCount() const
{
	return 4;
}

void SobelFilter::BuildDescriptors(const AllocateDescriptorCallback& allocateDescriptor)
{
	assert(allocateDescriptor);

	CD3DX12_CPU_DESCRIPTOR_HANDLE hCpu{};
	CD3DX12_GPU_DESCRIPTOR_HANDLE hGpu{};

	allocateDescriptor(&hCpu, &hGpu);
	mhCpuSrv = hCpu;
	mhGpuSrv = hGpu;

	allocateDescriptor(&hCpu, &hGpu);
	mhCpuUav = hCpu;
	mhGpuUav = hGpu;

	allocateDescriptor(&hCpu, &hGpu);
	mhCompositeCpuSrv = hCpu;
	mhCompositeGpuSrv = hGpu;

	allocateDescriptor(&hCpu, &hGpu);
	mhCompositeCpuUav = hCpu;
	mhCompositeGpuUav = hGpu;

	BuildDescriptors();
}

void SobelFilter::OnResize(UINT newWidth, UINT newHeight)
{
	if ((mWidth != newWidth) || (mHeight != newHeight))
	{
		mWidth = newWidth;
		mHeight = newHeight;

		BuildResource();
		BuildDescriptors();
	}
}

void SobelFilter::Excute(ID3D12GraphicsCommandList * cmdList, ID3D12RootSignature * rootSig, ID3D12PipelineState * pso, CD3DX12_GPU_DESCRIPTOR_HANDLE input)
{
	cmdList->SetComputeRootSignature(rootSig);
	cmdList->SetPipelineState(pso);
	cmdList->SetComputeRootDescriptorTable(1, input);
	cmdList->SetComputeRootDescriptorTable(3, mhGpuUav);

	CD3DX12_RESOURCE_BARRIER barrier = CD3DX12_RESOURCE_BARRIER::Transition(mOutput_Sobel.Get(),
		D3D12_RESOURCE_STATE_GENERIC_READ,
		D3D12_RESOURCE_STATE_UNORDERED_ACCESS);
	cmdList->ResourceBarrier(1, &barrier);

	UINT numGroupsX = (UINT)ceilf(mWidth / 16.0f);
	UINT numGroupsY = (UINT)ceilf(mHeight / 16.0f);
	cmdList->Dispatch(numGroupsX, numGroupsY, 1);

	barrier = CD3DX12_RESOURCE_BARRIER::Transition(mOutput_Sobel.Get(),
		D3D12_RESOURCE_STATE_UNORDERED_ACCESS,
		D3D12_RESOURCE_STATE_GENERIC_READ);
	cmdList->ResourceBarrier(1, &barrier);
}

void SobelFilter::Composite(ID3D12GraphicsCommandList* cmdList, ID3D12RootSignature* rootSig, ID3D12PipelineState* pso, CD3DX12_GPU_DESCRIPTOR_HANDLE input1, CD3DX12_GPU_DESCRIPTOR_HANDLE input2)
{
	cmdList->SetComputeRootSignature(rootSig);
	cmdList->SetPipelineState(pso);
	cmdList->SetComputeRootDescriptorTable(1, input1);
	cmdList->SetComputeRootDescriptorTable(2, input2);
	cmdList->SetComputeRootDescriptorTable(3, mhCompositeGpuUav);

	CD3DX12_RESOURCE_BARRIER barrier = CD3DX12_RESOURCE_BARRIER::Transition(mOutput_Composite.Get(),
		D3D12_RESOURCE_STATE_GENERIC_READ,
		D3D12_RESOURCE_STATE_UNORDERED_ACCESS);
	cmdList->ResourceBarrier(1, &barrier);

	UINT numGroupsX = (UINT)ceilf(mWidth / 16.0f);
	UINT numGroupsY = (UINT)ceilf(mHeight / 16.0f);
	cmdList->Dispatch(numGroupsX, numGroupsY, 1);

	barrier = CD3DX12_RESOURCE_BARRIER::Transition(mOutput_Composite.Get(),
		D3D12_RESOURCE_STATE_UNORDERED_ACCESS,
		D3D12_RESOURCE_STATE_GENERIC_READ);
	cmdList->ResourceBarrier(1, &barrier);
}

void SobelFilter::BuildDescriptors()
{
	D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc{};
	srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
	srvDesc.Format = mFormat;
	srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
	srvDesc.Texture2D.MostDetailedMip = 0;
	srvDesc.Texture2D.MipLevels = 1;

	D3D12_UNORDERED_ACCESS_VIEW_DESC uavDesc{};

	uavDesc.Format = mFormat;
	uavDesc.ViewDimension = D3D12_UAV_DIMENSION_TEXTURE2D;
	uavDesc.Texture2D.MipSlice = 0;

	md3dDevice->CreateShaderResourceView(mOutput_Sobel.Get(), &srvDesc, mhCpuSrv);
	md3dDevice->CreateUnorderedAccessView(mOutput_Sobel.Get(), nullptr, &uavDesc, mhCpuUav);

	md3dDevice->CreateShaderResourceView(mOutput_Composite.Get(), &srvDesc, mhCompositeCpuSrv);
	md3dDevice->CreateUnorderedAccessView(mOutput_Composite.Get(), nullptr, &uavDesc, mhCompositeCpuUav);
}

void SobelFilter::BuildResource()
{
	D3D12_RESOURCE_DESC texDesc{};
	texDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
	texDesc.Alignment = 0;
	texDesc.Width = mWidth;
	texDesc.Height = mHeight;
	texDesc.DepthOrArraySize = 1;
	texDesc.MipLevels = 1;
	texDesc.Format = mFormat;
	texDesc.SampleDesc.Count = 1;
	texDesc.SampleDesc.Quality = 0;
	texDesc.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
	texDesc.Flags = D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS;

	CD3DX12_HEAP_PROPERTIES heapProp(D3D12_HEAP_TYPE_DEFAULT);
	ThrowIfFailed(md3dDevice->CreateCommittedResource(
		&heapProp,
		D3D12_HEAP_FLAG_NONE,
		&texDesc,
		D3D12_RESOURCE_STATE_GENERIC_READ,
		nullptr,
		IID_PPV_ARGS(&mOutput_Sobel)));

	ThrowIfFailed(md3dDevice->CreateCommittedResource(
		&heapProp,
		D3D12_HEAP_FLAG_NONE,
		&texDesc,
		D3D12_RESOURCE_STATE_GENERIC_READ,
		nullptr,
		IID_PPV_ARGS(&mOutput_Composite)));
}
