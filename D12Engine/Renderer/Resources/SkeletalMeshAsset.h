#pragma once

#include <cstdint>
#include <limits>
#include <string>
#include <vector>
#include <unordered_map>
#include <DirectXMath.h>

#include "EngineCore/Math/MathHelper.h"
#include "Renderer/Resources/ImportedMaterial.h"

using JointIndex = std::uint32_t;
inline constexpr JointIndex InvalidJoint = (std::numeric_limits<JointIndex>::max)();

struct VectorKey
{
	float TimePos = 0.0f;
	DirectX::XMFLOAT3 Value{};
};

struct QuaternionKey
{
	float TimePos = 0.0f;
	DirectX::XMFLOAT4 Value = { 0.0f, 0.0f, 0.0f, 1.0f };
};

struct JointTransform
{
    DirectX::XMFLOAT3 Translation = { 0.0f, 0.0f, 0.0f };
    DirectX::XMFLOAT4 Rotation = { 0.0f, 0.0f, 0.0f, 1.0f };
    DirectX::XMFLOAT3 Scale = { 1.0f, 1.0f, 1.0f };
};

struct JointAnimation
{
	//키가 없는 채널의 값을 바인드 포즈 값으로 유지하기 위해 JointTransform를 입출력으로 사용.
	void Sample(float timePos, JointTransform& inOutTransform) const;

	std::vector<VectorKey> TranslationKeys;
	std::vector<QuaternionKey> RotationKeys;
	std::vector<VectorKey> ScaleKeys;
};

struct AnimationClip
{
	float StartTime = 0.0f;
	float EndTime = 0.0f;

	float GetDuration() const
	{
		return EndTime - StartTime;
	}

	// JointAnimations[i]는 SkeletonAsset::Joints[i]에 대응
	std::vector<JointAnimation> JointAnimations;
};

struct SkeletonJoint
{
    std::string Name;
	//fbx 전체 노드의 인덱스가 아니라
	//std::vector<SkeletonJoint> Joints의 인덱스
    JointIndex Parent = InvalidJoint;
	JointTransform BindLocalTransform;
};

struct SkeletonAsset
{
    std::vector<SkeletonJoint> Joints;

    // 부모가 자식보다 먼저 나오도록 계산된 순회 순서
    std::vector<JointIndex> EvaluationOrder;

    // 검색/디버그용
    std::unordered_map<std::string, JointIndex> NameToJoint;
};

struct SkinnedVertex
{
	DirectX::XMFLOAT3 Position;
	DirectX::XMFLOAT3 Normal;
	DirectX::XMFLOAT3 Tangent;
	DirectX::XMFLOAT2 TexCoord;

	std::uint16_t PaletteJointIndices[4]{};
	float JointWeights[4]{};
};

struct SkinBinding
{
	// GPU palette index -> Skeleton joint index
    std::vector<JointIndex> PaletteToSkeletonJoint;

    // Mesh bind space -> Joint bind space
    std::vector<DirectX::XMFLOAT4X4> OffsetMatrices;
};

struct SkeletalSubmesh
{
	std::string Name;

	std::uint32_t IndexCount = 0;
	std::uint32_t StartIndexLocation = 0;

	ImportedMaterialIndex MaterialIndex = InvalidMaterialIndex;
};

struct SkeletalMeshPart
{
	std::string Name;

	std::vector<SkinnedVertex> Vertices;
	std::vector<std::uint32_t> Indices;

	SkinBinding Skin;
	std::vector<SkeletalSubmesh> Submeshes;
};

struct SkeletalMeshAsset
{
	SkeletonAsset Skeleton;

	std::vector<SkeletalMeshPart> MeshParts;

	std::unordered_map<std::string, AnimationClip> Animations;
	std::vector<ImportedMaterial> Materials;

	UINT GetSubmeshCount() const
	{
		UINT count = 0;
		for (const auto& part : MeshParts)
		{
			count += static_cast<UINT>(part.Submeshes.size());
		}
		return count;
	}
};