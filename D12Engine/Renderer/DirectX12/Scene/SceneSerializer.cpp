#include "pch.h"
#include "SceneSerializer.h"

#include <cstdint>
#include <fstream>
#include <system_error>
#include <utility>

#include "EngineCore/StringUtil.h"
#include "Renderer/DirectX12/Scene/Scene.h"
#include "Renderer/DirectX12/Components/SkeletalMeshComponent.h"
#include "Renderer/DirectX12/Components/StaticMeshComponent.h"
#include "Serialization/Generated/Scene.pb.h"

namespace
{
    using namespace d12engine::serialization;

    constexpr std::uint32_t CurrentSceneFormatVersion = 3;

    void WriteVector3(Vector3Data* destination, const DirectX::XMFLOAT3& source)
    {
        destination->set_x(source.x);
        destination->set_y(source.y);
        destination->set_z(source.z);
    }

    DirectX::XMFLOAT3 ReadVector3(const Vector3Data& source)
    {
        return
        {
            source.x(),
            source.y(),
            source.z()
        };
    }

    void WriteVector4(Vector4Data* destination, const DirectX::XMFLOAT4& source)
    {
        destination->set_x(source.x);
        destination->set_y(source.y);
        destination->set_z(source.z);
        destination->set_w(source.w);
    }

    void WriteFloat4X4(Float4X4* destination, const DirectX::XMFLOAT4X4& source)
    {
        WriteVector4(destination->mutable_row1(), { source._11, source._12, source._13, source._14 });
        WriteVector4(destination->mutable_row2(), { source._21, source._22, source._23, source._24 });
        WriteVector4(destination->mutable_row3(), { source._31, source._32, source._33, source._34 });
        WriteVector4(destination->mutable_row4(), { source._41, source._42, source._43, source._44 });
    }

    DirectX::XMFLOAT4 ReadVector4(const Vector4Data& source)
    {
        return
        {
            source.x(),
            source.y(),
            source.z(),
            source.w()
        };
    }

    bool ReadFloat4X4(const Float4X4& source, DirectX::XMFLOAT4X4& destination)
    {
        if (!source.has_row1() || !source.has_row2() || !source.has_row3() || !source.has_row4())
            return false;

        const DirectX::XMFLOAT4 row1 = ReadVector4(source.row1());
        const DirectX::XMFLOAT4 row2 = ReadVector4(source.row2());
        const DirectX::XMFLOAT4 row3 = ReadVector4(source.row3());
        const DirectX::XMFLOAT4 row4 = ReadVector4(source.row4());

        destination = DirectX::XMFLOAT4X4
        {
            row1.x, row1.y, row1.z, row1.w,
            row2.x, row2.y, row2.z, row2.w,
            row3.x, row3.y, row3.z, row3.w,
            row4.x, row4.y, row4.z, row4.w
        };

        return true;
    }

    void WriteMeshComponent(MeshComponentData* destination, const MeshComponent& source)
    {
        destination->set_geometry_name(source.GeometryName);
        destination->set_topology(static_cast<std::uint32_t>(source.Topology));
        destination->set_visible(source.Visible);
        destination->set_in_mirror(source.InMirror);

        for (const SubmeshSlot& slot : source.SubmeshSlots)
        {
            SubmeshSlotData* slotData = destination->add_slots();

            slotData->set_submesh_name(slot.SubmeshName);
            slotData->set_material_name(slot.MaterialName);
            slotData->set_visible(slot.Visible);
            WriteFloat4X4(slotData->mutable_materialdata()->mutable_mattransform(), slot.MatTransform);

            for (RenderPass renderPass : slot.Layers)
                slotData->add_render_passes(static_cast<std::uint32_t>(renderPass));
        }
    }

    bool ReadMeshComponent(MeshComponent& destination, const MeshComponentData& source)
    {
        destination.GeometryName = source.geometry_name();
        destination.Topology = static_cast<D3D12_PRIMITIVE_TOPOLOGY>(source.topology());
        destination.Visible = source.visible();
        destination.InMirror = source.in_mirror();
        destination.SubmeshSlots.clear();
        destination.SubmeshSlots.reserve(source.slots_size());

        for (const SubmeshSlotData& slotData : source.slots())
        {
            if (!slotData.has_materialdata()) return false;

            const MaterialData& materialData = slotData.materialdata();
            if (!materialData.has_mattransform()) return false;

            SubmeshSlot slot{};
            slot.SubmeshName = slotData.submesh_name();
            slot.MaterialName = slotData.material_name();
            slot.Visible = slotData.visible();

            if (!ReadFloat4X4(materialData.mattransform(), slot.MatTransform))
                return false;

            for (std::uint32_t renderPass : slotData.render_passes())
                slot.Layers.push_back(static_cast<RenderPass>(renderPass));

            slot.Submesh = nullptr;
            slot.MaterialData = nullptr;
            destination.SubmeshSlots.push_back(std::move(slot));
        }

        destination.Geometry = nullptr;
        return true;
    }
}

bool SceneSerializer::Save(const Scene& scene, const std::filesystem::path& filePath)
{
    if (filePath.empty()) return false;

    const std::filesystem::path parentPath = filePath.parent_path();
    if (!parentPath.empty())
    {
        std::error_code error;
        std::filesystem::create_directories(parentPath, error);

        if (error) return false;
    }

    d12engine::serialization::SceneFile sceneFile;
    sceneFile.set_format_version(CurrentSceneFormatVersion);

    for (const auto& objectPtr : scene.GetObjects())
    {
        if (!objectPtr) continue;

        const SceneObject& object = *objectPtr;
        if (object.HasFlag(SceneObjectFlags::EditorOnly) ||
            object.HasFlag(SceneObjectFlags::Transient))
            continue;

        auto* objectData = sceneFile.add_objects();

        objectData->set_name(WideToUtf8(object.Name));
        objectData->set_visible(object.Visible);
        objectData->set_flags(static_cast<std::uint32_t>(object.mObjectFlags));
        objectData->set_id(object.Id);
        objectData->set_parent_id(object.ParentId);

        if (const auto* skeletalMesh = object.GetComponent<SkeletalMeshComponent>())
        {
            SkeletalMeshComponentData* skeletalData = objectData->mutable_skeletal_mesh();

            WriteMeshComponent(skeletalData->mutable_mesh(), *skeletalMesh);
            skeletalData->set_skeletal_asset_name(skeletalMesh->SkeletalAssetName);
        }
        else if (const auto* staticMesh = object.GetComponent<StaticMeshComponent>())
        {
            StaticMeshComponentData* staticData = objectData->mutable_static_mesh();
            WriteMeshComponent(staticData->mutable_mesh(), *staticMesh);
        }

        auto* transformData = objectData->mutable_transform();

        WriteVector3(transformData->mutable_position(), object.Transform.Position);
        WriteVector3(transformData->mutable_rotation(), object.Transform.Rotation);
        WriteVector3(transformData->mutable_scale(), object.Transform.Scale);
    }

    std::ofstream output(filePath, std::ios::binary | std::ios::trunc);
    if (!output) return false;

    return sceneFile.SerializeToOstream(&output) && output.good();
}

bool SceneSerializer::Load(Scene& scene, const std::filesystem::path& filePath)
{
    if (filePath.empty()) return false;

    std::ifstream input(filePath, std::ios::binary);
    if (!input) return false;

    d12engine::serialization::SceneFile sceneFile;

    // 파싱에 실패했을 때 기존 Scene을 유지하기 위해
    // Clear()보다 먼저 수행한다.
    if (!sceneFile.ParseFromIstream(&input)) return false;

    if (sceneFile.format_version() != CurrentSceneFormatVersion)
        return false;

    scene.Clear();

    for (const auto& objectData : sceneFile.objects())
    {
        const SceneObjectId id = objectData.id();

        if (id == 0) return false;
        if (scene.FindObject(id) != nullptr) return false;

        SceneObject& object = scene.CreateObjectWithId(objectData.id(), Utf8ToWide(objectData.name()));

        object.ParentId = objectData.parent_id();
        object.Visible = objectData.visible();
        object.mObjectFlags = static_cast<SceneObjectFlags>(objectData.flags());

        if (objectData.has_transform())
        {
            const auto& transformData = objectData.transform();

            if (transformData.has_position())
                object.Transform.Position = ReadVector3(transformData.position());

            if (transformData.has_rotation())
                object.Transform.Rotation = ReadVector3(transformData.rotation());

            if (transformData.has_scale())
                object.Transform.Scale = ReadVector3(transformData.scale());
        }

        switch (objectData.mesh_component_case())
        {
        case SceneObjectData::kStaticMesh:
        {
            auto& staticMesh = object.AddComponent<StaticMeshComponent>();
            if (!ReadMeshComponent(staticMesh, objectData.static_mesh().mesh()))
                return false;
            break;
        }

        case SceneObjectData::kSkeletalMesh:
        {
            auto& skeletalMesh = object.AddComponent<SkeletalMeshComponent>();
            const SkeletalMeshComponentData& skeletalData = objectData.skeletal_mesh();

            if (!ReadMeshComponent(skeletalMesh, skeletalData.mesh()))
                return false;

            skeletalMesh.SkeletalAssetName = skeletalData.skeletal_asset_name();
            skeletalMesh.Asset = nullptr;

            break;
        }

        case SceneObjectData::MESH_COMPONENT_NOT_SET:
            break;
        }
    }

    for (const auto& objectPtr : scene.GetObjects())
        objectPtr->Children.clear();

    for (const auto& objectPtr : scene.GetObjects())
    {
        SceneObject& object = *objectPtr;

        if (object.ParentId == 0) continue;
        if (object.ParentId == object.Id) return false;
        SceneObject* parent = scene.FindObject(object.ParentId);
        if (!parent) return false;

        parent->Children.push_back(object.Id);
    }

    return true;
}