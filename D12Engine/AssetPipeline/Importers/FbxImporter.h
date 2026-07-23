#pragma once

#include <filesystem>
#include <memory>

#include "Renderer/DirectX12/RenderData.h"

struct ufbx_scene;

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
    static MeshData ImportSkeletalMesh(const std::filesystem::path& filePath);
    [[nodiscard]]
    static ScenePtr LoadScene(const std::filesystem::path& filePath);
    static void PrintSceneInfo(const ufbx_scene& scene);
};