#include "pch.h"
#include "FrameResource.h"

FrameResource::FrameResource(ID3D12Device* device, UINT passCount, UINT maxInstanceCount, UINT waveVertexCount, UINT materialCount)
{
	ThrowIfFailed(device->CreateCommandAllocator(
		D3D12_COMMAND_LIST_TYPE_DIRECT,
		IID_PPV_ARGS(cmdListAlloc.GetAddressOf())));

	//ObjectCB = std::make_unique<UploadBuffer<ObjectConstants>>(device, objectCount, true);
	PassCB = std::make_unique<UploadBuffer<PassConstants>>(device, passCount, true);
	MaterialBuffer = std::make_unique<UploadBuffer<MaterialData>>(device, materialCount, false);
	debugColorCB = std::make_unique<UploadBuffer<DebugColorConstants>>(device, debugColorNum, true);

	WavesVB = std::make_unique<UploadBuffer<Vertex>>(device, waveVertexCount, false);

	InstanceBuffer = std::make_unique<UploadBuffer<InstanceData_GPU>>(device, maxInstanceCount, false);
}
