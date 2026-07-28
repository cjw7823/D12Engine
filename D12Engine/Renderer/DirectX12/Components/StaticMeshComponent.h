#pragma once

#include <vector>
#include "Renderer/DirectX12/Components/IComponent.h"
#include "Renderer/DirectX12/RenderData.h"

struct SubmeshSlot
{
    // StaticMeshComponent::Geometry 내부의 서브메시
    const SubmeshGeometry* Submesh = nullptr;
    Material* MaterialData = nullptr;

    RenderLayer Layer = RenderLayer::Opaque;

    bool Visible = true;
};

struct StaticMeshComponent : public IComponent
{
    MeshGeometry* Geometry = nullptr;
    std::vector<SubmeshSlot> SubmeshSlots;

    D3D12_PRIMITIVE_TOPOLOGY Topology = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;

    bool Visible = true;
    bool InMirror = false;
};