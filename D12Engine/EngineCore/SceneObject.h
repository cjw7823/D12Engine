#pragma once

#include <string>
#include <cstdint>
#include "Transform.h"

using SceneObjectID = std::uint64_t;

struct SceneObject
{
	SceneObjectID Id = 0;
	std::wstring Name = L"오브젝트";

	Transform TransformData;

	// 나중에 Mesh / Material 시스템이 생기면 추가.
	// uint32_t MeshId = InvalidMeshId;
	// uint32_t MaterialId = InvalidMaterialId;
};