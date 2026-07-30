#include "pch.h"

#include "RenderData.h"
#include "Renderer/DirectX12/MACRO.h"
#include "EngineCore/StringUtil.h"

void SkinnedModelInstance::Initialize(const SkeletalMeshComponent& asset, std::string clipName)
{
    Asset = &asset;
    ClipName = std::move(clipName);

    const auto clipIt = asset.Animations.find(ClipName);

    if (clipIt == asset.Animations.end())
    {
        std::ostringstream oss;

        oss << "Animation clip was not found: "
            << ClipName
            << "\nAvailable clips:";

        for (const auto& [name, clip] : asset.Animations)
        {
            oss << "\n- " << name;
        }

        throw DxException(
            E_INVALIDARG,
            AnsiToWString(oss.str()),
            AnsiToWString(__FILE__),
            __LINE__);
    }

    TimePos = clipIt->second.StartTime;

    JointToRootTransforms.resize(asset.Skeleton.Joints.size());
    SubmeshFinalTransforms.resize(asset.Submeshes.size());

    for (std::size_t submeshIndex = 0; submeshIndex < asset.Submeshes.size(); submeshIndex++)
    {
        const SkinBinding& skin = asset.Submeshes[submeshIndex].Skin;
        SubmeshFinalTransforms[submeshIndex].resize(skin.PaletteToSkeletonJoint.size());
    }

    // 초기 프레임 Pose 생성
    UpdateAnimation(0.0f);
}

void SkinnedModelInstance::UpdateAnimation(float deltaTime)
{
    using namespace DirectX;

    if (Asset == nullptr) return;

    const auto clipIt = Asset->Animations.find(ClipName);
    if (clipIt == Asset->Animations.end()) return;

    const AnimationClip& clip = clipIt->second;
    const SkeletonAsset& skeleton = Asset->Skeleton;
    const std::size_t jointCount = skeleton.Joints.size();
    if (jointCount == 0) return;

    // 1. 애니메이션 시간 갱신
    TimePos += deltaTime;
    const float duration = clip.GetDuration();

    if (duration > 0.0f)
    {
        while (TimePos > clip.EndTime) TimePos -= duration;
        while (TimePos < clip.StartTime) TimePos += duration;
    }
    else
    {
        TimePos = clip.StartTime;
    }

    if (clip.JointAnimations.size() != jointCount)
    {
        throw DxException(
            E_FAIL,
            L"Animation joint count does not match skeleton joint count.",
            AnsiToWString(__FILE__),
            __LINE__);
    }

    if (JointToRootTransforms.size() != jointCount)
    {
        JointToRootTransforms.resize(jointCount);
    }

    // 각 Joint의 부모 기준 Local 행렬
    std::vector<XMFLOAT4X4> jointToParentTransforms(jointCount);

    // 2. Local Transform 샘플링
    for (JointIndex jointIndex = 0; jointIndex < jointCount; jointIndex++)
    {
        const SkeletonJoint& joint = skeleton.Joints[jointIndex];

        // 키가 없는 채널은 Bind Local 값을 유지해야 함
        JointTransform localTransform = joint.BindLocalTransform;

        clip.JointAnimations[jointIndex].Sample(TimePos, localTransform);

        XMVECTOR scale = XMLoadFloat3(&localTransform.Scale);
        XMVECTOR rotation = XMQuaternionNormalize(XMLoadFloat4(&localTransform.Rotation));
        XMVECTOR translation = XMLoadFloat3(&localTransform.Translation);
        XMMATRIX localMatrix = XMMatrixAffineTransformation(
                scale,
                XMVectorZero(),
                rotation,
                translation);

        XMStoreFloat4x4(&jointToParentTransforms[jointIndex], localMatrix);
    }

    // 3. 부모 우선 순회로 Joint → Root 행렬 계산
    for (JointIndex jointIndex : skeleton.EvaluationOrder)
    {
        if (jointIndex >= jointCount)
        {
            throw DxException(
                E_FAIL,
                L"Skeleton evaluation order contains an invalid joint index.",
                AnsiToWString(__FILE__),
                __LINE__);
        }

        const JointIndex parentIndex = skeleton.Joints[jointIndex].Parent;

        XMMATRIX jointToParent = XMLoadFloat4x4(&jointToParentTransforms[jointIndex]);

        XMMATRIX jointToRoot;

        if (parentIndex == InvalidJoint)
        {
            // Skeleton root
            jointToRoot = jointToParent;
        }
        else
        {
            if (parentIndex >= jointCount)
            {
                throw DxException(
                    E_FAIL,
                    L"Skeleton contains an invalid parent index.",
                    AnsiToWString(__FILE__),
                    __LINE__);
            }

            XMMATRIX parentToRoot =XMLoadFloat4x4(&JointToRootTransforms[parentIndex]);

            // DirectXMath 행 벡터 규약:
            // JointToParent * ParentToRoot
            jointToRoot = XMMatrixMultiply(jointToParent, parentToRoot);
        }

        XMStoreFloat4x4(&JointToRootTransforms[jointIndex], jointToRoot);
    }

    // 4. 서브메시별 최종 GPU Skin Palette 생성
    if (SubmeshFinalTransforms.size() != Asset->Submeshes.size())
    {
        SubmeshFinalTransforms.resize(Asset->Submeshes.size());
    }

    for (std::size_t submeshIndex = 0; submeshIndex < Asset->Submeshes.size(); submeshIndex++)
    {
        const SkinBinding& skin = Asset->Submeshes[submeshIndex].Skin;
        const std::size_t paletteSize = skin.PaletteToSkeletonJoint.size();

        if (skin.OffsetMatrices.size() != paletteSize)
        {
            throw DxException(
                E_FAIL,
                L"Skin binding palette and offset matrix counts do not match.",
                AnsiToWString(__FILE__),
                __LINE__);
        }

        std::vector<XMFLOAT4X4>& finalTransforms = SubmeshFinalTransforms[submeshIndex];
        finalTransforms.resize(paletteSize);

        for (std::size_t paletteIndex = 0; paletteIndex < paletteSize; paletteIndex++)
        {
            const JointIndex jointIndex = skin.PaletteToSkeletonJoint[paletteIndex];

            if (jointIndex >= jointCount)
            {
                throw DxException(
                    E_FAIL,
                    L"Skin palette contains an invalid skeleton joint index.",
                    AnsiToWString(__FILE__),
                    __LINE__);
            }

            XMMATRIX offset = XMLoadFloat4x4(&skin.OffsetMatrices[paletteIndex]);

            XMMATRIX jointToRoot =XMLoadFloat4x4(&JointToRootTransforms[jointIndex]);

            // Mesh bind space
            // → Joint bind space
            // → 현재 Root space
            XMMATRIX finalTransform =
                XMMatrixMultiply(
                    offset,
                    jointToRoot);

            // 기존 HLSL이 mul(matrix, vector) 또는
            // 전치 행렬 업로드 규약을 사용한다는 전제
            XMStoreFloat4x4(&finalTransforms[paletteIndex], XMMatrixTranspose(finalTransform));
        }
    }

    for (const auto& submeshTransforms :SubmeshFinalTransforms)
    {
        for (const XMFLOAT4X4& matrix : submeshTransforms)
        {
            const float* values = reinterpret_cast<const float*>(&matrix);

            for (int i = 0; i < 16; ++i)
            {
                assert(std::isfinite(values[i]));
            }
        }
    }
}
