#pragma once

#include <memory>

#include <d3d12.h>
#include <wrl/client.h>

#include "Renderer/DirectX12/RenderData.h"
#include "Renderer/DirectX12/UploadBuffer.h"

struct FrameResource
{
public:
	FrameResource(ID3D12Device* device, UINT passCount, UINT maxInstanceCount, UINT waveVertexCount, UINT materialCount, UINT skinnedObjectCount);
	FrameResource(const FrameResource& rhs) = delete;
	FrameResource& operator=(const FrameResource& rhs) = delete;
	~FrameResource() {};

	Microsoft::WRL::ComPtr<ID3D12CommandAllocator> cmdAlloc;

	//std::unique_ptr<UploadBuffer<ObjectConstants>> ObjectCB = nullptr;
	std::unique_ptr<UploadBuffer<SkinnedConstants>> SkinnedCB = nullptr;
	std::unique_ptr<UploadBuffer<PassConstants>> PassCB = nullptr;
	std::unique_ptr<UploadBuffer<MaterialData>> MaterialBuffer = nullptr;

	std::unique_ptr<UploadBuffer<Vertex>> WavesVB = nullptr;

	// 단 하나의 렌더링 항목(render-item)만 인스턴싱할 경우, 인스턴싱 데이터를 저장할 구조화된 버퍼(structured buffer)도 하나만 사용합니다. 
	// 이를 더 범용적으로 구현하려면(즉, 여러 렌더링 항목의 인스턴싱을 지원하려면) 각 렌더링 항목마다 구조화된 버퍼를 준비해야 하며, 
	// 각 버퍼는 최대로 그릴 인스턴스 개수를 수용할 수 있을 만큼 충분한 크기로 할당해야 합니다. 
	// 이는 부담스러운 작업처럼 들릴 수 있지만, 실제로는 인스턴싱을 사용하지 않을 때 필요한 객체별 상수 데이터(per-object constant data)의 양과 다를 바 없습니다. 
	// 예를 들어, 인스턴싱 없이 1,000개의 객체를 그린다면 1,000개 분량의 데이터를 담을 수 있는 상수 버퍼(constant buffer)를 생성하게 됩니다. 
	// 인스턴싱을 사용할 때도 마찬가지로, 1,000개 인스턴스의 데이터를 저장할 수 있을 만큼 충분히 큰 구조화된 버퍼를 생성하기만 하면 됩니다.
	std::unique_ptr<UploadBuffer<InstanceData_GPU>> InstanceBuffer = nullptr;

	UINT64 FenceValue = 0;
};