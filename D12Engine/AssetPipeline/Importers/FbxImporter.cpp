#include "pch.h"
#include "FbxImporter.h"

#include "ufbx.h"

#include "EngineCore/Logging/Logger.h"

#include "Renderer/DirectX12/MACRO.h"

#include <sstream>
#include <stdexcept>
#include <string>
#include <system_error>
#include <unordered_set>
#include <unordered_map>

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
    
    DirectX::XMFLOAT4X4 ToFloat4x4(const ufbx_matrix& value)
    {
        return DirectX::XMFLOAT4X4(
            static_cast<float>(value.cols[0].x),
            static_cast<float>(value.cols[0].y),
            static_cast<float>(value.cols[0].z),
            0.0f,

            static_cast<float>(value.cols[1].x),
            static_cast<float>(value.cols[1].y),
            static_cast<float>(value.cols[1].z),
            0.0f,

            static_cast<float>(value.cols[2].x),
            static_cast<float>(value.cols[2].y),
            static_cast<float>(value.cols[2].z),
            0.0f,

            static_cast<float>(value.cols[3].x),
            static_cast<float>(value.cols[3].y),
            static_cast<float>(value.cols[3].z),
            1.0f);
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

        //fbx의 face는 삼각형만이 아님. 주의.
        std::vector<std::uint32_t> triangleIndices(mesh->max_face_triangles * 3);
        for (std::size_t faceIndex = 0; faceIndex < mesh->faces.count; ++faceIndex)
        {
            const ufbx_face face = mesh->faces.data[faceIndex];
            if (face.num_indices < 3) continue;

            // FBX의 hole face는 렌더링 X
            if (faceIndex < mesh->face_hole.count && mesh->face_hole.data[faceIndex])
                continue;

            const std::uint32_t triangleCount = ufbx_triangulate_face(
                triangleIndices.data(),
                triangleIndices.size(),
                mesh,
                face);

            const std::size_t indexCount = static_cast<std::size_t>(triangleCount) * 3;
            for (std::size_t i = 0; i < indexCount; i++)
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

                Vertex vertex{};
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

SkeletalMeshAsset FbxImporter::ImportSkeletalMesh(const std::filesystem::path& filePath)
{
    ScenePtr scene = LoadScene(filePath);

    std::unordered_map<std::uint32_t, JointIndex> nodeIdToJointIndex;
    SkeletonAsset skeleton = BuildSkeletonAsset(*scene, nodeIdToJointIndex);

    std::unordered_map<std::uint32_t, ImportedMaterialIndex> materialIdToIndex;
	std::vector<ImportedMaterial> materials = ImportMaterials(*scene, materialIdToIndex);

    std::vector<SkeletalMeshPart> meshParts = BuildSkeletalSubmeshes(*scene, nodeIdToJointIndex, materialIdToIndex);

    std::unordered_map<std::string, AnimationClip> anims = ImportAnimations(*scene, skeleton, nodeIdToJointIndex);

    SkeletalMeshAsset skeletalMesh{};
    skeletalMesh.Skeleton = std::move(skeleton);
    skeletalMesh.MeshParts = std::move(meshParts);
    skeletalMesh.Animations = std::move(anims);
    skeletalMesh.Materials = std::move(materials);

    return skeletalMesh;
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

SkeletonAsset FbxImporter::BuildSkeletonAsset(const ufbx_scene& scene, std::unordered_map<std::uint32_t, JointIndex>& outNodeIdToJointIndex)
{
    outNodeIdToJointIndex.clear();

    SkeletonAsset skeleton;

    //서브메시 순회하며 노드 id 수집
    std::unordered_set<std::uint32_t> requiredSkeletonNodeIds;
    for (const ufbx_node* node : scene.nodes)
    {
        if (node == nullptr || node->mesh == nullptr) continue;

        const ufbx_mesh* mesh = node->mesh;
        if (mesh->skin_deformers.count == 0) continue;
        if (mesh->skin_deformers.count != 1)
        {
            throw DxException(
                E_NOTIMPL,
                L"Only one skin deformer per mesh is supported.",
                AnsiToWString(__FILE__),
                __LINE__);
        }

        ufbx_skin_deformer* skin = mesh->skin_deformers[0]; // 서브메시 한개
        /*
            mesh
                └─ skin_deformers[0]
                    ├─ clusters[]
                    │   ├─ bone_node
                    │   └─ geometry_to_bone
                    ├─ vertices[]
                    └─ weights[]

            bone node들 탐색.
        */
        for (const ufbx_skin_cluster* cluster : skin->clusters)
        {
            if (cluster == nullptr || cluster->bone_node == nullptr)
            {
                throw DxException(
                    E_FAIL,
                    L"Skin contains an invalid cluster.",
                    AnsiToWString(__FILE__),
                    __LINE__);
            }

            const ufbx_node* jointNode = cluster->bone_node;
            while (jointNode != nullptr)
            {
                requiredSkeletonNodeIds.insert(jointNode->typed_id);
                jointNode = jointNode->parent;
            }
        }
    }

    if (requiredSkeletonNodeIds.empty())
    {
        throw DxException(
            E_FAIL,
            L"FBX contains no skinned mesh or skeleton.",
            AnsiToWString(__FILE__),
            __LINE__);
    }

    //Joint를 ufbx노드 순서대로.
    for (const ufbx_node* node : scene.nodes)
    {
        if (node == nullptr || !requiredSkeletonNodeIds.count(node->typed_id)) continue;

        const JointIndex jointIndex = static_cast<JointIndex>(skeleton.Joints.size());

        outNodeIdToJointIndex.emplace(node->typed_id, jointIndex);

        SkeletonJoint joint;
        joint.Name.assign(node->name.data, node->name.length);
        skeleton.NameToJoint.emplace(joint.Name, jointIndex);
        skeleton.Joints.push_back(std::move(joint));
    }

    //joint들의 parent와 bind local transform 채우기
    for (const ufbx_node* node : scene.nodes)
    {
        if (node == nullptr) continue;

        const auto jointIt = outNodeIdToJointIndex.find(node->typed_id);
        if (jointIt == outNodeIdToJointIndex.end()) continue;

        SkeletonJoint& joint = skeleton.Joints[jointIt->second];

        if (node->parent != nullptr)
        {
            const auto parentIt = outNodeIdToJointIndex.find(node->parent->typed_id);
            if (parentIt != outNodeIdToJointIndex.end())
            {
                joint.Parent = parentIt->second;
            }
        }

        const ufbx_transform& transform = node->local_transform;
        joint.BindLocalTransform.Translation =
        {
            static_cast<float>(transform.translation.x),
            static_cast<float>(transform.translation.y),
            static_cast<float>(transform.translation.z)
        };

        joint.BindLocalTransform.Rotation =
        {
            static_cast<float>(transform.rotation.x),
            static_cast<float>(transform.rotation.y),
            static_cast<float>(transform.rotation.z),
            static_cast<float>(transform.rotation.w)
        };

        joint.BindLocalTransform.Scale =
        {
            static_cast<float>(transform.scale.x),
            static_cast<float>(transform.scale.y),
            static_cast<float>(transform.scale.z)
        };
    }

    //EvaluationOrder 생성
    // 1. children 그래프 생성
    std::vector<std::vector<JointIndex>> children(skeleton.Joints.size());
    std::vector<JointIndex> roots;

    for (JointIndex jointIndex = 0; jointIndex < skeleton.Joints.size(); jointIndex++)
    {
        const JointIndex parent = skeleton.Joints[jointIndex].Parent;

        if (parent == InvalidJoint)
        {
            roots.push_back(jointIndex);
        }
        else
        {
            children[parent].push_back(jointIndex);
        }
    }

    // 2. DFS
    std::function<void(JointIndex)> visit =
        [&](JointIndex jointIndex)
        {
            skeleton.EvaluationOrder.push_back(jointIndex);
            for (JointIndex child : children[jointIndex])
            {
                visit(child);
            }
        };

    for (JointIndex root : roots)
    {
        visit(root);
    }

    // 3. 검증
    if (skeleton.EvaluationOrder.size() != skeleton.Joints.size())
    {
        throw DxException(
            E_FAIL,
            L"Skeleton hierarchy contains an invalid parent relationship or cycle.",
            AnsiToWString(__FILE__),
            __LINE__);
    }

    return skeleton;
}

std::vector<SkeletalMeshPart> FbxImporter::BuildSkeletalSubmeshes(const ufbx_scene& scene, const std::unordered_map<std::uint32_t, JointIndex>& nodeIdToJointIndex, const std::unordered_map<std::uint32_t, ImportedMaterialIndex>& materialIdToIndex)
{
    std::vector<SkeletalMeshPart> result;

    for (const ufbx_node* node : scene.nodes)
    {
        if (node == nullptr || node->mesh == nullptr) continue;

        const ufbx_mesh* mesh = node->mesh;

        // 정적 메시는 제외
        if (mesh->skin_deformers.count == 0) continue;
        if (mesh->skin_deformers.count != 1)
        {
            throw DxException(
                E_NOTIMPL,
                L"Only one skin deformer per mesh is supported.",
                AnsiToWString(__FILE__),
                __LINE__);
        }

        const ufbx_skin_deformer* skin = mesh->skin_deformers[0];
        if (skin == nullptr || skin->clusters.count == 0)
        {
            throw DxException(
                E_FAIL,
                L"Skinned mesh contains no valid skin clusters.",
                AnsiToWString(__FILE__),
                __LINE__);
        }

        if (!mesh->vertex_position.exists)
        {
            throw DxException(
                E_FAIL,
                L"Skinned mesh contains no vertex positions.",
                AnsiToWString(__FILE__),
                __LINE__);
        }

		SkeletalMeshPart meshPart;
        meshPart.Name.assign(node->name.data, node->name.length);
        if (meshPart.Name.empty())
            meshPart.Name = "SkeletalSubmesh_" + std::to_string(node->typed_id);

        // SkinBinding 생성
        meshPart.Skin.PaletteToSkeletonJoint.reserve(skin->clusters.count);
        meshPart.Skin.OffsetMatrices.reserve(skin->clusters.count);

        //클러스터 순회
        for (std::size_t clusterIndex = 0; clusterIndex < skin->clusters.count; clusterIndex++)
        {
            const ufbx_skin_cluster* cluster = skin->clusters[clusterIndex];
            if (cluster == nullptr || cluster->bone_node == nullptr)
            {
                throw DxException(
                    E_FAIL,
                    L"Skin contains an invalid cluster.",
                    AnsiToWString(__FILE__),
                    __LINE__);
            }

            const auto jointIt = nodeIdToJointIndex.find(cluster->bone_node->typed_id);
            if (jointIt == nodeIdToJointIndex.end())
            {
                throw DxException(
                    E_FAIL,
                    L"Skin cluster bone is not part of the skeleton.",
                    AnsiToWString(__FILE__),
                    __LINE__);
            }

            // cluster index == palette index
            meshPart.Skin.PaletteToSkeletonJoint.push_back(jointIt->second);
            meshPart.Skin.OffsetMatrices.push_back(ToFloat4x4(cluster->geometry_to_bone));
        }

        const std::size_t estimatedVertexCount = mesh->num_triangles * 3;
        meshPart.Vertices.reserve(estimatedVertexCount);
        meshPart.Indices.reserve(estimatedVertexCount);

        std::vector<std::uint32_t> triangleIndices(mesh->max_face_triangles * 3);
        for (int i = 0; i < mesh->material_parts.count; i++)
        {
            const ufbx_mesh_part& part = mesh->material_parts.data[i];

            SkeletalSubmesh submesh;
            submesh.StartIndexLocation = (UINT)meshPart.Indices.size();
            submesh.MaterialIndex = ResolveMaterialIndex(
                *node,
                *mesh,
                i,
                materialIdToIndex);

            //submesh 이름 생성
            {
                std::string nodeName = ToString(node->name);
                if (nodeName.empty())
                    nodeName = "SkeletalMesh_" + std::to_string(node->typed_id);

                std::string materialName = "DefaultMaterial";

                if (i < node->materials.count && node->materials[i] != nullptr)
                    materialName = ToString(node->materials[i]->name);
                else if (i < mesh->materials.count && mesh->materials[i] != nullptr)
                    materialName = ToString(mesh->materials[i]->name);

                if (materialName.empty())
                    materialName = "Material";

                submesh.Name = nodeName + "_" + materialName + "_" + std::to_string(i);
            }

            //fbx의 face는 삼각형만이 아님. 주의.
            for (std::size_t partFaceIndex = 0; partFaceIndex < part.face_indices.count; partFaceIndex++)
            {
                const std::uint32_t faceIndex = part.face_indices[partFaceIndex];
                const ufbx_face face = mesh->faces[faceIndex];
                if (face.num_indices < 3) continue;

                // FBX의 hole face는 렌더링 X
                if (faceIndex < mesh->face_hole.count && mesh->face_hole.data[faceIndex])
                    continue;

                const std::uint32_t triangleCount = ufbx_triangulate_face(
                    triangleIndices.data(),
                    triangleIndices.size(),
                    mesh,
                    face);

                const std::size_t indexCount = static_cast<std::size_t>(triangleCount) * 3;
                for (std::size_t i = 0; i < indexCount; i++)
                {
                    const std::uint32_t meshIndex = triangleIndices[i];
                    if (meshIndex >= mesh->vertex_indices.count)
                    {
                        throw DxException(
                            E_FAIL,
                            L"Polygon vertex index is out of range.",
                            AnsiToWString(__FILE__),
                            __LINE__);
                    }

                    SkinnedVertex vertex{};

                    // geometry_to_bone과 같은 Mesh Geometry 공간 유지
                    const ufbx_vec3 position = ufbx_get_vertex_vec3(&mesh->vertex_position, meshIndex);
                    //ImportStaticMesh와 달리 월드행렬 곱하지 않음.
                    vertex.Position = ToFloat3(position);

                    // Normal
                    ufbx_vec3 normal = { 0.0, 1.0, 0.0 };
                    if (mesh->vertex_normal.exists)
                    {
                        normal = ufbx_get_vertex_vec3(&mesh->vertex_normal, meshIndex);
                        normal = ufbx_vec3_normalize(normal);
                    }
                    vertex.Normal = ToFloat3(normal);

                    // Tangent
                    ufbx_vec3 tangent = { 1.0, 0.0, 0.0 };
                    if (mesh->vertex_tangent.exists)
                    {
                        tangent = ufbx_get_vertex_vec3(&mesh->vertex_tangent, meshIndex);
                        tangent = ufbx_vec3_normalize(tangent);
                    }
                    vertex.Tangent = ToFloat3(tangent);

                    // UV
                    ufbx_vec2 texCoord = { 0.0, 0.0 };
                    if (mesh->vertex_uv.exists)
                    {
                        texCoord = ufbx_get_vertex_vec2(&mesh->vertex_uv, meshIndex);
                    }
                    vertex.TexCoord = ToFloat2(texCoord);

                    // Polygon vertex index → Logical vertex index
                    const std::uint32_t logicalVertexIndex = mesh->vertex_indices[meshIndex];
                    if (logicalVertexIndex >= skin->vertices.count)
                    {
                        throw DxException(
                            E_FAIL,
                            L"Skin logical vertex index is out of range.",
                            AnsiToWString(__FILE__),
                            __LINE__);
                    }

                    const ufbx_skin_vertex& skinVertex = skin->vertices[logicalVertexIndex];
                    struct Influence
                    {
                        std::uint32_t PaletteIndex = 0;
                        float Weight = 0.0f;
                    };

                    std::vector<Influence> influences;
                    influences.reserve(skinVertex.num_weights);
                    for (std::size_t influenceIndex = 0; influenceIndex < skinVertex.num_weights; influenceIndex++)
                    {
                        const std::size_t weightIndex = skinVertex.weight_begin + influenceIndex;
                        if (weightIndex >= skin->weights.count)
                        {
                            throw DxException(
                                E_FAIL,
                                L"Skin weight index is out of range.",
                                AnsiToWString(__FILE__),
                                __LINE__);
                        }

                        const ufbx_skin_weight& weight = skin->weights[weightIndex];
                        if (weight.cluster_index >= skin->clusters.count)
                        {
                            throw DxException(
                                E_FAIL,
                                L"Skin cluster index is out of range.",
                                AnsiToWString(__FILE__),
                                __LINE__);
                        }

                        influences.push_back({ weight.cluster_index, (float)weight.weight });
                    }

                    //여러 가중치 중 상위 4개만 사용.
                    std::sort(influences.begin(), influences.end(),
                        [](const Influence& lhs, const Influence& rhs)
                        {
                            return lhs.Weight > rhs.Weight;
                        });

                    const std::size_t influenceCount = std::min<std::size_t>(influences.size(), 4);
                    float weightSum = 0.0f;
                    for (std::size_t influenceIndex = 0; influenceIndex < influenceCount; influenceIndex++)
                    {
                        const Influence& influence = influences[influenceIndex];

                        vertex.PaletteJointIndices[influenceIndex] = influence.PaletteIndex;
                        vertex.JointWeights[influenceIndex] = influence.Weight;
                        weightSum += influence.Weight;
                    }

                    //가중치 합을 1로 정규화
                    if (weightSum > 0.0f)
                    {
                        const float inverseWeightSum = 1.0f / weightSum;

                        for (std::size_t influenceIndex = 0; influenceIndex < influenceCount; influenceIndex++)
                        {
                            vertex.JointWeights[influenceIndex] *= inverseWeightSum;
                        }
                    }
                    else
                    {
                        // 임시 정책: palette[0]에 완전히 바인딩
                        vertex.PaletteJointIndices[0] = 0;
                        vertex.JointWeights[0] = 1.0f;
                    }

                    const std::uint32_t newIndex = static_cast<std::uint32_t>(meshPart.Vertices.size());

                    meshPart.Vertices.push_back(vertex);
                    meshPart.Indices.push_back(newIndex);
                }
            }
            submesh.IndexCount = (UINT)meshPart.Indices.size() - submesh.StartIndexLocation;

            if (submesh.IndexCount > 0)
                meshPart.Submeshes.push_back(std::move(submesh));
        }

        if (meshPart.Vertices.empty() || meshPart.Indices.empty())
        {
            throw DxException(
                E_FAIL,
                L"Skinned mesh contains no renderable triangles.",
                AnsiToWString(__FILE__),
                __LINE__);
        }

        result.push_back(std::move(meshPart));
    }

    if (result.empty())
    {
        throw DxException(
            E_FAIL,
            L"FBX contains no supported skinned submeshes.",
            AnsiToWString(__FILE__),
            __LINE__);
    }

    return result;
}

std::unordered_map<std::string, AnimationClip>
FbxImporter::ImportAnimations(const ufbx_scene& scene, const SkeletonAsset& skeleton, const std::unordered_map<std::uint32_t, JointIndex>& nodeIdToJointIndex)
{
    PrintSceneInfo(scene);

    std::unordered_map<std::string, AnimationClip> animations;

    for (const ufbx_anim_stack* stack : scene.anim_stacks)
    {
        if (stack == nullptr || stack->anim == nullptr) continue;

        std::string clipName(stack->name.data, stack->name.length);

        if (clipName.empty())
            clipName = "Animation_" + std::to_string(stack->typed_id);

        ufbx_bake_opts bakeOptions{};

        // 키 시간을 0초부터 시작시킴
        bakeOptions.trim_start_time = true;

        // 일정 간격으로 샘플링
        bakeOptions.resample_rate = 30.0;

        ufbx_error error{};

        ufbx_baked_anim* rawBakedAnim = ufbx_bake_anim(&scene, stack->anim, &bakeOptions, &error);

        if (rawBakedAnim == nullptr)
        {
            char errorBuffer[2048]{};
            ufbx_format_error(errorBuffer, sizeof(errorBuffer), &error);
            throw DxException(
                E_FAIL,
                AnsiToWString(errorBuffer),
                AnsiToWString(__FILE__),
                __LINE__);
        }

        using BakedAnimPtr = std::unique_ptr<ufbx_baked_anim, decltype(&ufbx_free_baked_anim)>;
        BakedAnimPtr bakedAnim(rawBakedAnim, &ufbx_free_baked_anim);

        AnimationClip clip;
        clip.StartTime = 0.0f;
        clip.EndTime = (float)bakedAnim->playback_duration;
        // JointIndex로 직접 접근할 수 있도록 Skeleton 크기로 생성
        clip.JointAnimations.resize(skeleton.Joints.size());

        for (const ufbx_baked_node& bakedNode : bakedAnim->nodes)
        {
            // ufbx node ID → 엔진 JointIndex
            const auto jointIt = nodeIdToJointIndex.find(bakedNode.typed_id);

            // 메시 노드, 카메라 등 Skeleton 외 노드는 무시
            if (jointIt == nodeIdToJointIndex.end()) continue;

            const JointIndex jointIndex = jointIt->second;
            if (jointIndex >= clip.JointAnimations.size())
            {
                throw DxException(
                    E_FAIL,
                    L"Animation joint index is out of range.",
                    AnsiToWString(__FILE__),
                    __LINE__);
            }

            JointAnimation& jointAnimation = clip.JointAnimations[jointIndex];

            // Translation
            jointAnimation.TranslationKeys.reserve(bakedNode.translation_keys.count);

            for (const ufbx_baked_vec3& sourceKey : bakedNode.translation_keys)
            {
                VectorKey key;
                key.TimePos = static_cast<float>(sourceKey.time);
                key.Value = { (float)sourceKey.value.x, (float)sourceKey.value.y, (float)sourceKey.value.z };
                jointAnimation.TranslationKeys.push_back(key);
            }

            // Rotation
            jointAnimation.RotationKeys.reserve(bakedNode.rotation_keys.count);

            for (const ufbx_baked_quat& sourceKey : bakedNode.rotation_keys)
            {
                QuaternionKey key;
                key.TimePos = static_cast<float>(sourceKey.time);
                key.Value = { (float)sourceKey.value.x, (float)sourceKey.value.y, (float)sourceKey.value.z, (float)sourceKey.value.w };
                jointAnimation.RotationKeys.push_back(key);
            }

            // Scale
            jointAnimation.ScaleKeys.reserve(bakedNode.scale_keys.count);
            for (const ufbx_baked_vec3& sourceKey : bakedNode.scale_keys)
            {
                VectorKey key;
                key.TimePos = static_cast<float>(sourceKey.time);
                key.Value = { (float)sourceKey.value.x, (float)sourceKey.value.y, (float)sourceKey.value.z };
                jointAnimation.ScaleKeys.push_back(key);
            }
        }

        const auto [it, inserted] = animations.emplace(clipName, std::move(clip));
        if (!inserted)
        {
            throw DxException(
                E_FAIL,
                L"Duplicate animation clip name.",
                AnsiToWString(__FILE__),
                __LINE__);
        }
    }

    return animations;
}

std::vector<ImportedMaterial> FbxImporter::ImportMaterials(const ufbx_scene& scene, std::unordered_map<std::uint32_t, ImportedMaterialIndex>& outMaterialIdToIndex)
{
    std::vector<ImportedMaterial> result;

    outMaterialIdToIndex.clear();
    result.reserve(scene.materials.count);

    for (const ufbx_material* sourceMaterial : scene.materials)
    {
        if (sourceMaterial == nullptr)
            continue;

        ImportedMaterial material;
        material.Name = ToString(sourceMaterial->name);

        if (material.Name.empty())
            material.Name = "Material_" + std::to_string(sourceMaterial->typed_id);

        //ImportMaterialProperties(*sourceMaterial, material);
        //ImportMaterialTextures(*sourceMaterial, material);

        outMaterialIdToIndex.emplace(
            sourceMaterial->typed_id,
            (ImportedMaterialIndex)result.size());

        result.push_back(std::move(material));
    }

    return result;
}

ImportedMaterialIndex FbxImporter::ResolveMaterialIndex(const ufbx_node& node, const ufbx_mesh& mesh, std::size_t materialSlot, const std::unordered_map<std::uint32_t, ImportedMaterialIndex>& materialIdToIndex)
{
    const ufbx_material* material = nullptr;
    if (materialSlot < node.materials.count)
        material = node.materials[materialSlot];
    else if (materialSlot < mesh.materials.count)
        material = mesh.materials[materialSlot];

    if (material == nullptr)
        return InvalidMaterialIndex;

    const auto it = materialIdToIndex.find(material->typed_id);
    if (it == materialIdToIndex.end())
        return InvalidMaterialIndex;

    return it->second;
}
