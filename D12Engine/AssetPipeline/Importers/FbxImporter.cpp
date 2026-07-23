#include "pch.h"
#include "FbxImporter.h"

#include "ufbx.h"

#include "EngineCore/Logging/Logger.h"

#include "Renderer/DirectX12/MACRO.h"

#include <sstream>
#include <stdexcept>
#include <string>
#include <system_error>

namespace
{
    std::string ToString(const ufbx_string& value)
    {
        if (value.data == nullptr || value.length == 0)
            return {};

        return std::string(value.data, value.length);
    }

    DirectX::XMFLOAT3 ToFloat3(const ufbx_vec3& value)
    {
        return
        {
            static_cast<float>(value.x),
            static_cast<float>(value.y),
            static_cast<float>(value.z)
        };
    }

    DirectX::XMFLOAT2 ToFloat2(const ufbx_vec2& value)
    {
        return
        {
            static_cast<float>(value.x),
            static_cast<float>(value.y)
        };
    }
}

void FbxImporter::SceneDeleter::operator()(
    ufbx_scene* scene) const noexcept
{
    if (scene != nullptr)
        ufbx_free_scene(scene);
}

MeshData FbxImporter::ImportStaticMesh(const std::filesystem::path& filePath)
{
    ScenePtr scene = LoadScene(filePath);
    MeshData result;

    // 현재는 중복 정점을 제거하지 않습니다.
    // 삼각형의 각 꼭짓점을 독립적인 엔진 정점으로 생성합니다.
    std::size_t estimatedTriangleCount = 0;

    for (const ufbx_node* node : scene->nodes)
    {
        if (node == nullptr || node->mesh == nullptr) continue;
        estimatedTriangleCount += node->mesh->num_triangles;
    }

    result.Vertices.reserve(estimatedTriangleCount * 3);
    result.Indices32.reserve(estimatedTriangleCount * 3);

    for (const ufbx_node* node : scene->nodes)
    {
        if (node == nullptr || node->mesh == nullptr) continue;

        const ufbx_mesh* mesh = node->mesh;
        if (!mesh->vertex_position.exists) continue;

        const ufbx_matrix& geometryToWorld = node->geometry_to_world;
        const ufbx_matrix normalMatrix = ufbx_matrix_for_normals(&geometryToWorld);

        //fbxx의 face는 삼각형만이 아님. 주의.
        std::vector<std::uint32_t> triangleIndices(mesh->max_face_triangles * 3);
        for (std::size_t faceIndex = 0; faceIndex < mesh->faces.count; ++faceIndex)
        {
            const ufbx_face face = mesh->faces.data[faceIndex];
            if (face.num_indices < 3) continue;

            // FBX의 hole face는 렌더링하지 않습니다.
            if (faceIndex < mesh->face_hole.count && mesh->face_hole.data[faceIndex])
                continue;

            const std::uint32_t triangleCount = ufbx_triangulate_face(
                triangleIndices.data(),
                triangleIndices.size(),
                mesh,
                face);

            const std::size_t indexCount = static_cast<std::size_t>(triangleCount) * 3;
            for (std::size_t i = 0; i < indexCount; ++i)
            {
                const std::uint32_t meshIndex = triangleIndices[i];

                // Position
                ufbx_vec3 position = ufbx_get_vertex_vec3(&mesh->vertex_position, meshIndex);
                position = ufbx_transform_position(&geometryToWorld, position);

                // Normal
                ufbx_vec3 normal = { 0.0, 1.0, 0.0 };

                if (mesh->vertex_normal.exists)
                {
                    normal = ufbx_get_vertex_vec3(&mesh->vertex_normal, meshIndex);
                    normal = ufbx_transform_direction(&normalMatrix, normal);
                    normal = ufbx_vec3_normalize(normal);
                }

                // Tangent
                ufbx_vec3 tangent = { 1.0, 0.0, 0.0 };

                if (mesh->vertex_tangent.exists)
                {
                    tangent = ufbx_get_vertex_vec3(&mesh->vertex_tangent, meshIndex);
                    tangent = ufbx_transform_direction(&geometryToWorld, tangent);
                    tangent = ufbx_vec3_normalize(tangent);
                }

                // UV
                ufbx_vec2 texCoord = { 0.0, 0.0 };
                if (mesh->vertex_uv.exists)
                {
                    texCoord = ufbx_get_vertex_vec2(&mesh->vertex_uv, meshIndex);
                }

                Vertex vertex;
                vertex.Position = ToFloat3(position);
                vertex.Normal = ToFloat3(normal);
                vertex.TangentU = ToFloat3(tangent);
                vertex.TexC = ToFloat2(texCoord);

                const std::uint32_t newIndex = static_cast<std::uint32_t>(result.Vertices.size());

                result.Vertices.push_back(vertex);
                result.Indices32.push_back(newIndex);
            }
        }
    }

    if (result.Vertices.empty() || result.Indices32.empty())
    {
        std::wstring msg = AnsiToWString("FBX contains no renderable triangle mesh: " + filePath.string());
        throw DxException(HRESULT(), msg, AnsiToWString(__FILE__), __LINE__);
    }

    return result;
}

struct ImpoertedBone
{
    const ufbx_node* Node = nullptr;
    const ufbx_skin_cluster* Cluster = nullptr;

    int ParentIndex = -1;
};

std::unordered_map<std::uint32_t, std::uint32_t> nodeIdtoBoneIndex;
MeshData FbxImporter::ImportSkeletalMesh(const std::filesystem::path& filePath)
{
    ScenePtr scene = LoadScene(filePath);
    MeshData result;
    SkinnedData skinnedInfo;
    for (const ufbx_node* node : scene->nodes)
    {
        const ufbx_mesh* mesh = node->mesh;

        if (mesh->skin_deformers.count == 0)
        {
            //정적 메시
        }
        else if (mesh->skin_deformers.count == 1) //현재는 한개만.
        {
            const ufbx_skin_deformer* skin = mesh->skin_deformers[0];

            /*
                mesh
                 └─ skin_deformers[0]
                     ├─ clusters[]
                     │   ├─ bone_node
                     │   └─ geometry_to_bone
                     ├─ vertices[]
                     └─ weights[]
            */
            for (const ufbx_skin_cluster* cluster : skin->clusters)
            {
                const ufbx_node* boneNode = cluster->bone_node;
            }
        }
    }

    return result;
}

FbxImporter::ScenePtr FbxImporter::LoadScene(
    const std::filesystem::path& filePath)
{
    std::error_code fileError;

    if (!std::filesystem::exists(filePath, fileError))
    {
        std::wstring message = L"FBX file does not exist: " + filePath.wstring();

        throw DxException(
            HRESULT_FROM_WIN32(ERROR_PATH_NOT_FOUND),
            message,
            AnsiToWString(__FILE__),
            __LINE__);
    }

    if (!std::filesystem::is_regular_file(filePath, fileError))
    {
        std::wstring message = L"FBX path is not a regular file: " + filePath.wstring();

        throw DxException(
            E_INVALIDARG,
            message,
            AnsiToWString(__FILE__),
            __LINE__);
    }

    //ufbx는 uft8을 사용하기 때문에.
    const std::string utf8Path = filePath.u8string();

    ufbx_load_opts loadOptions{};
    ufbx_error error{};
    ufbx_scene* rawScene = ufbx_load_file(utf8Path.c_str(), &loadOptions, &error);

    if (rawScene == nullptr)
    {
        char errorBuffer[2048]{};

        ufbx_format_error(errorBuffer, sizeof(errorBuffer), &error);

        std::ostringstream oss;
        oss << "Failed to load FBX file.\n"
            << "Path: " << utf8Path << '\n'
            << "Error: " << errorBuffer;

        throw DxException(HRESULT(), AnsiToWString(oss.str()), AnsiToWString(__FILE__), __LINE__);
    }

    return ScenePtr(rawScene);
}

void FbxImporter::PrintSceneInfo(const ufbx_scene& scene)
{
    std::ostringstream oss;

    oss << "\n========== FBX Scene ==========\n";

    oss << "Nodes: "
        << scene.nodes.count << '\n';

    oss << "Meshes: "
        << scene.meshes.count << '\n';

    oss << "Materials: "
        << scene.materials.count << '\n';

    oss << "Textures: "
        << scene.textures.count << '\n';

    oss << "Skin Deformers: "
        << scene.skin_deformers.count << '\n';

    oss << "Animation Stacks: "
        << scene.anim_stacks.count << '\n';

    oss << "Unit Meters: "
        << scene.settings.unit_meters << '\n';

    oss << "Frames Per Second: "
        << scene.settings.frames_per_second << '\n';

    oss << "\nHierarchy\n";

    for (const ufbx_node* node : scene.nodes)
    {
        if (node == nullptr)
            continue;

        // Root depth는 0, 그 자식부터 1.
        const std::size_t indentCount = static_cast<std::size_t>(node->node_depth) * 2;

        oss << std::string(indentCount, ' ')
            << "- "
            << ToString(node->name);

        if (node->mesh != nullptr)
        {
            oss << " [Mesh: "
                << ToString(node->mesh->name)
                << ']';
        }
        else if (node->bone != nullptr)
        {
            oss << " [Bone]";
        }
        else if (node->light != nullptr)
        {
            oss << " [Light]";
        }
        else if (node->camera != nullptr)
        {
            oss << " [Camera]";
        }

        oss << '\n';
    }

    oss << "===============================\n\n";

    Logger::Info(oss.str());
}