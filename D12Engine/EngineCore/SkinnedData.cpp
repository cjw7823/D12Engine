#include "pch.h"
#include "SkinnedData.h"

using namespace DirectX;

float BoneAnimation::GetStartTime() const
{
    return keyframes.front().TimePos;
}

float BoneAnimation::GetEndTime() const
{
    return keyframes.back().TimePos;
}

void BoneAnimation::Interpolate(float t, DirectX::XMFLOAT4X4& M) const
{
    if (t <= keyframes.front().TimePos)
    {
        XMVECTOR S = XMLoadFloat3(&keyframes.front().Scale);
        XMVECTOR P = XMLoadFloat3(&keyframes.front().Translation);
        XMVECTOR Q = XMLoadFloat4(&keyframes.front().RotationQuat);

        XMVECTOR zero = XMVectorSet(0.0f, 0.0f, 0.0f, 1.0f);
        XMStoreFloat4x4(&M, XMMatrixAffineTransformation(S, zero, Q, P));
    }
    else if (t >= keyframes.back().TimePos)
    {
        XMVECTOR S = XMLoadFloat3(&keyframes.back().Scale);
        XMVECTOR P = XMLoadFloat3(&keyframes.back().Translation);
        XMVECTOR Q = XMLoadFloat4(&keyframes.back().RotationQuat);

        XMVECTOR zero = XMVectorSet(0.0f, 0.0f, 0.0f, 1.0f);
        XMStoreFloat4x4(&M, XMMatrixAffineTransformation(S, zero, Q, P));
    }
    else
    {
        for (UINT i = 0; i < keyframes.size() - 1; i++)
        {
            if (t >= keyframes[i].TimePos && t <= keyframes[i + 1].TimePos)
            {
                float lerpPercent = (t - keyframes[i].TimePos) / (keyframes[i + 1].TimePos - keyframes[i].TimePos);

                XMVECTOR s0 = XMLoadFloat3(&keyframes[i].Scale);
                XMVECTOR s1 = XMLoadFloat3(&keyframes[i + 1].Scale);

                XMVECTOR p0 = XMLoadFloat3(&keyframes[i].Translation);
                XMVECTOR p1 = XMLoadFloat3(&keyframes[i + 1].Translation);

                XMVECTOR q0 = XMLoadFloat4(&keyframes[i].RotationQuat);
                XMVECTOR q1 = XMLoadFloat4(&keyframes[i + 1].RotationQuat);

                XMVECTOR S = XMVectorLerp(s0, s1, lerpPercent);
                XMVECTOR P = XMVectorLerp(p0, p1, lerpPercent);
                XMVECTOR Q = XMQuaternionSlerp(q0, q1, lerpPercent);

                XMVECTOR zero = XMVectorSet(0.0f, 0.0f, 0.0f, 1.0f);
                XMStoreFloat4x4(&M, XMMatrixAffineTransformation(S, zero, Q, P));

                break;
            }
        }
    }
}

float AnimationClip::GetClipStartTime() const
{
    float t = FLT_MAX;
    for (UINT i = 0; i < boneAnimations.size(); i++)
        t = std::min(t, boneAnimations[i].GetStartTime());

    return t;
}

float AnimationClip::GetClipEndTime() const
{
    float t = 0.0f;
    for (UINT i = 0; i < boneAnimations.size(); i++)
        t = std::max(t, boneAnimations[i].GetEndTime());

    return t;
}

void AnimationClip::Interpolate(float t, std::vector<DirectX::XMFLOAT4X4>& boneTransforms) const
{
    for (UINT i = 0; i < boneAnimations.size(); i++)
    {
        boneAnimations[i].Interpolate(t, boneTransforms[i]);
    }
}

UINT SkinnedData::BoneCount() const
{
    return (UINT)mBoneHierachy.size();
}

float SkinnedData::GetClipStartTime(const std::string& clipName) const
{
    auto clip = mAnimations.find(clipName);
    return clip->second.GetClipStartTime();
}

float SkinnedData::GetClipEndTime(const std::string& clipName) const
{
    auto clip = mAnimations.find(clipName);
    return clip->second.GetClipEndTime();
}

void SkinnedData::Set(std::vector<int>& boneHierachy, std::vector<DirectX::XMFLOAT4X4>& boneOffsets, std::unordered_map<std::string, AnimationClip> animations)
{
    mBoneHierachy = boneHierachy;
    mBoneOffsets = boneOffsets;
    mAnimations = animations;
}

void SkinnedData::GetFinalTransforms(const std::string & clipName, float timePos, std::vector<DirectX::XMFLOAT4X4>&finalTransforms) const
{
    UINT numBones = (UINT)mBoneOffsets.size();
    std::vector<XMFLOAT4X4> toParentTransforms(numBones);

    auto clip = mAnimations.find(clipName);
    clip->second.Interpolate(timePos, toParentTransforms);

    //모든 본을 루트 공간으로 변환.
    std::vector<XMFLOAT4X4> toRootTransforms(numBones);
    //Root Bone 의 인덱스는 0, Root Bone은 부모가 없으므로 부모변환이 자신의 좌표변환이다.
    toRootTransforms[0] = toParentTransforms[0];

    for (UINT i = 1; i < numBones; i++)
    {
        XMMATRIX toParent = XMLoadFloat4x4(&toParentTransforms[i]);

        int parentIndex = mBoneHierachy[i];
        XMMATRIX parentToRoot = XMLoadFloat4x4(&toRootTransforms[parentIndex]);
        XMMATRIX toRoot = XMMatrixMultiply(toParent, parentToRoot);

        XMStoreFloat4x4(&toRootTransforms[i], toRoot);
    }

    //최종 변환을 위해 오프셋 변환을 곱한다.
    for (UINT i = 0; i < numBones; i++)
    {
        XMMATRIX offset = XMLoadFloat4x4(&mBoneOffsets[i]);
        XMMATRIX toRoot = XMLoadFloat4x4(&toRootTransforms[i]);
        XMMATRIX finalTransform = XMMatrixMultiply(offset, toRoot);
        XMStoreFloat4x4(&finalTransforms[i], XMMatrixTranspose(finalTransform));
    }
}
