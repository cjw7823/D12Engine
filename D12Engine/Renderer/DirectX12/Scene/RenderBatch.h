#pragma once

#include "Renderer/DirectX12/Scene/SceneObject.h"

#include <vector>


/*
	하나의 SceneObject가 여러 Submesh로 구성된 경우,
	GPU 인스턴싱은 SceneObject 전체가 아니라 Submesh 단위로 배치된다.

	예:
		HouseGeometry
		- Wall
		- Roof
		- Window

		Scene
		- House A
		- House B
		- House C

	생성되는 RenderBatch:
		Wall Batch
		- House A의 Wall 슬롯
		- House B의 Wall 슬롯
		- House C의 Wall 슬롯

		Roof Batch
		- House A의 Roof 슬롯
		- House B의 Roof 슬롯
		- House C의 Roof 슬롯

		Window Batch
		- House A의 Window 슬롯
		- House B의 Window 슬롯
		- House C의 Window 슬롯

	각 RenderBatch는 동일한 Geometry/Submesh/Topology/RenderLayer를
	사용하는 슬롯들을 하나의 DrawIndexedInstanced() 호출로 렌더링한다.

	동일한 SceneObject는 자신이 가진 Submesh 수만큼 여러 RenderBatch에서
	참조될 수 있지만, SceneObject 자체가 복제되는 것은 아니다.
*/

enum class MeshType : std::uint8_t
{
	None,
	Skinned
};

struct RenderBatchKey
{
	MeshGeometry* Geometry = nullptr;
	const SubmeshGeometry* Submesh = nullptr;

	D3D12_PRIMITIVE_TOPOLOGY Topology = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;

	MeshType Type = MeshType::None;

	bool operator==(const RenderBatchKey& rhs) const
	{
		return Geometry == rhs.Geometry &&
			Submesh == rhs.Submesh &&
			Topology == rhs.Topology &&
			Type == rhs.Type;
	}
};

struct RenderInstanceRef
{
	SceneObject* Object = nullptr;

	// Object의 MeshComponent::SubmeshSlots 인덱스
	std::uint32_t SubMeshSlotIndex = UINT32_MAX;

	// 현재 프레임 GPU 인스턴스 버퍼 위치
	UINT GpuInstanceIndex = UINT_MAX;
};

struct RenderBatch
{
	RenderBatchKey Key;

	// 같은 Primitive를 사용하는 SceneObject/RenderPart 묶음
	std::vector<RenderInstanceRef> Instances;

	// 현재 프레임 InstanceBuffer에서 이 배치가 시작되는 위치
	UINT StartInstanceLocation = 0;

	// 현재 프레임에서 가시성 검사를 통과한 개수
	UINT VisibleInstanceCount = 0;
};