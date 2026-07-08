#pragma once

#include "d3dUtil.h"
#include "MathHelper.h"
#include <vector>
#include <unordered_map>

/// <summary>
/// 특정 시각에서의 Bone 변환을 정의.
/// </summary>
struct Keyframe
{
	float TimePos = 0.0f;
	DirectX::XMFLOAT3 Translation = { 0.0f, 0.0f, 0.0f };
	DirectX::XMFLOAT3 Scale = { 1.0f, 1.0f, 1.0f };;
	DirectX::XMFLOAT4 RotationQuat = { 0.0f, 0.0f, 0.0f, 1.0f };
};

/// <summary>
/// 키프레임의 목록.
/// 두 키프레임 사이의 시간 값에 대해서는 해당 시간을 경계로 하는 가장 가까운 두 키프레임 사이를 보간.
/// 최소 두 개의 키프레임을 가진다고 가정.
/// </summary>
struct BoneAnimation
{
	float GetStartTime() const;
	float GetEndTime() const;

	void Interpolate(float t, DirectX::XMFLOAT4X4& M) const;

	//시간 순서로 sorting되어야 함.
	std::vector<Keyframe> keyframes;
};

/// <summary>
/// AnimationClip의 예로는 "뛰기", "걷기", "공격하기" 등이 있다.
/// 하나의 애니메이션 클립을 구성하기 위해 모든 본에 대한 BoneAnimation을 필요로 한다.
/// </summary>
struct AnimationClip
{
	float GetClipStartTime() const;
	float GetClipEndTime() const;

	void Interpolate(float t, std::vector<DirectX::XMFLOAT4X4>& boneTransforms) const;

	std::vector<BoneAnimation> boneAnimations; // 모든 본에 대한 애니메이션
};

class SkinnedData
{
public:
	UINT BoneCount() const;

	float GetClipStartTime(const std::string& clipName) const;
	float GetClipEndTime(const std::string& clipName) const;

	void Set(std::vector<int>& boneHierachy,
		std::vector<DirectX::XMFLOAT4X4>& boneOffsets,
		std::unordered_map<std::string, AnimationClip> animations);

	//동일한 clipName과 timePos로 이 함수를 여러번 호출할 가능성이 있다면,
	//결과를 캐싱하는 구조가 좋다.(추후 개선사항)
	void GetFinalTransforms(const std::string& clipName,
		float timePos,
		std::vector<DirectX::XMFLOAT4X4>& finalTransforms) const;

private:
	// mBoneHierachy[i] = i의 부모
	std::vector<int> mBoneHierachy;
	std::vector<DirectX::XMFLOAT4X4> mBoneOffsets;
	std::unordered_map<std::string, AnimationClip> mAnimations;
};