#include "pch.h"
#include "FrameResource.h"
#include "Renderer/DirectX12/MACRO.h"

FrameResource::FrameResource(ID3D12Device* device, UINT passCount, UINT maxInstanceCount, UINT waveVertexCount, UINT materialCount, UINT skinnedObjectCount)
{
	ThrowIfFailed(device->CreateCommandAllocator(
		D3D12_COMMAND_LIST_TYPE_DIRECT,
		IID_PPV_ARGS(cmdAlloc.GetAddressOf())));

	//ObjectCB = std::make_unique<UploadBuffer<ObjectConstants>>(device, objectCount, true);
	PassCB = std::make_unique<UploadBuffer<PassConstants>>(device, passCount, true);
	MaterialBuffer = std::make_unique<UploadBuffer<MaterialData>>(device, materialCount, false);

	WavesVB = std::make_unique<UploadBuffer<Vertex>>(device, waveVertexCount, false);

	InstanceBuffer = std::make_unique<UploadBuffer<InstanceData_GPU>>(device, maxInstanceCount, false);

	SkinnedCB = std::make_unique<UploadBuffer<SkinnedConstants>>(device, skinnedObjectCount, true);
}
