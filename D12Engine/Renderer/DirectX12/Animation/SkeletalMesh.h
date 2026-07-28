#pragma once

#include <cstdint>
#include <limits>
#include <string>
#include <vector>
#include <unordered_map>
#include <DirectXMath.h>

#include "EngineCore/Math/MathHelper.h"

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

	std::vector<SkinnedVertex> Vertices;
	std::vector<std::uint32_t> Indices;

	SkinBinding Skin;
};

struct SkeletalMesh
{
	SkeletonAsset Skeleton;

	std::vector<SkeletalSubmesh> Submeshes;

	std::unordered_map<std::string, AnimationClip> Animations;
};