#pragma once

#include <filesystem>

class Scene;

class SceneSerializer
{
public:
    [[nodiscard]]
    static bool Save(const Scene& scene, const std::filesystem::path& filePath);

    [[nodiscard]]
    static bool Load(Scene& scene, const std::filesystem::path& filePath);
};