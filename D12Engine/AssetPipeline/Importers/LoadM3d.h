#pragma once

#include "EngineCore/Animation/SkinnedData.h"
#include <fstream>

class M3DLoader
{
public:
    struct BoneVertex
    {
        DirectX::XMFLOAT3 Pos;
        DirectX::XMFLOAT3 Normal;
        DirectX::XMFLOAT2 TexC;
        DirectX::XMFLOAT4 TangentU;
    };

    struct SkinnedVertex
    {
        DirectX::XMFLOAT3 Pos;
        DirectX::XMFLOAT3 Normal;
        DirectX::XMFLOAT2 TexC;
        DirectX::XMFLOAT3 TangentU;
        DirectX::XMFLOAT3 BoneWeights;
        BYTE BoneIndices[4];
    };

    struct Subset
    {
        UINT Id = -1;
        UINT VertexStart = 0;
        UINT VertexCount = 0;
        UINT FaceStart = 0;
        UINT FaceCount = 0;
    };

    struct M3dMaterial
    {
        std::string Name;

        DirectX::XMFLOAT4 DiffuseAlbedo = { 1.0f, 1.0f, 1.0f, 1.0f };
        DirectX::XMFLOAT3 FresnelR0 = { 0.01f, 0.01f, 0.01f };
        float Roughness = 0.8f;
        bool AlphaClip = false;

        std::string MaterialTypeName;
        std::string DiffuseMapName;
        std::string NormalMapName;
    };

    bool LoadM3d(const std::string& filePath,
        std::vector<BoneVertex>& vertices,
        std::vector<uint16_t>& indices,
        std::vector<Subset>& subsets,
        std::vector<M3dMaterial>& mats);

    bool LoadM3d(const std::string& filePath,
        std::vector<SkinnedVertex>& vertices,
        std::vector<uint16_t>& indices,
        std::vector<Subset>& subsets,
        std::vector<M3dMaterial>& mats,
        SkinnedData& skinInfo);
        
private:
    void ReadMaterials(std::ifstream& fin, UINT numMaterials, std::vector<M3dMaterial>& mats);
    void ReadSubsetTable(std::ifstream& fin, UINT numSubsets, std::vector<Subset>& subsets);
    void ReadVertices(std::ifstream& fin, UINT numVertices, std::vector<BoneVertex>& vertices);
    void ReadSkinnedVertices(std::ifstream& fin, UINT numVertices, std::vector<SkinnedVertex>& vertices);
    void ReadTriangles(std::ifstream& fin, UINT numTriangles, std::vector<USHORT>& indices);
    void ReadBoneOffsets(std::ifstream& fin, UINT numBones, std::vector<DirectX::XMFLOAT4X4>& boneOffsets);
    void ReadBoneHierarchy(std::ifstream& fin, UINT numBones, std::vector<int>& boneIndexToParentIndex);
    void ReadAnimationClips(std::ifstream& fin, UINT numBones, UINT numAnimationClips, std::unordered_map<std::string, AnimationClip>& animations);
    void ReadBoneKeyframes(std::ifstream& fin, UINT numBones, BoneAnimation& boneAnimation);
};