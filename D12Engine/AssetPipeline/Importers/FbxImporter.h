#pragma once

#include <filesystem>
#include <memory>

#include "Renderer/Resources/RenderData.h"
#include "Renderer/Resources/SkeletalMeshAsset.h"
#include "AssetPipeline/Desc/ImportedMaterial.h"

struct ufbx_scene;
struct ufbx_node;
struct ufbx_mesh;

class FbxImporter
{
public:
    //자동 해제를 위해
    struct SceneDeleter
    {
        void operator()(ufbx_scene* scene) const noexcept;
    };

    using ScenePtr = std::unique_ptr<ufbx_scene, SceneDeleter>;

public:
    [[nodiscard]]
    static MeshData ImportStaticMesh(const std::filesystem::path& filePath);
    [[nodiscard]]
    static SkeletalMeshAsset ImportSkeletalMesh(const std::filesystem::path& filePath);

private:
    [[nodiscard]]
    static ScenePtr LoadScene(const std::filesystem::path& filePath);
    static void PrintSceneInfo(const ufbx_scene& scene);

    [[nodiscard]]
    static SkeletonAsset BuildSkeletonAsset(const ufbx_scene& scene, std::unordered_map<std::uint32_t, JointIndex>& outNodeIdToJointIndex);

    [[nodiscard]]
    static std::vector<SkeletalMeshPart> BuildSkeletalSubmeshes(const ufbx_scene& scene, const std::unordered_map<std::uint32_t, JointIndex>& nodeIdToJointIndex);

    [[nodiscard]]
    static std::unordered_map<std::string, AnimationClip> ImportAnimations(const ufbx_scene& scene, const SkeletonAsset& skeleton, const std::unordered_map<std::uint32_t, JointIndex>& nodeIdToJointIndex);

	[[nodiscard]]
    static std::vector<ImportedMaterial> ImportMaterials(const ufbx_scene& scene);

    [[nodiscard]]
    static std::vector<ImportedTexture> ImportTextures(const ufbx_scene& scene);
};