#pragma once

#include <string>
#include <cstdint>
#include "Transform.h"
#include "Renderer/DirectX12/RenderData.h"
#include "Renderer/Assets/TextureDesc.h"

using SceneObjectID = std::uint64_t;

struct RenderInstanceBinding
{
    RenderItem* RenderData = nullptr;
    UINT InstanceIndex = UINT_MAX;
    Material* MaterialData = nullptr;
};

struct SceneObject
{
	SceneObjectID Id = 0;
	std::wstring Name = L"오브젝트";

    TransformComponent Transform;

    std::vector<RenderInstanceBinding> RenderBindings;

    //인스펙터에서 Transform 수정 시 사용.
    bool TransformDirty = true;
};