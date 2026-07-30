#include "pch.h"
#include "SkeletalMeshComponent.h"

#include <cassert>
#include <algorithm>

static DirectX::XMFLOAT3 SampleVector(const std::vector<VectorKey>& keys, float timePos)
{
	using namespace DirectX;
	assert(!keys.empty());

	if (keys.size() == 1 || timePos <= keys.front().TimePos)
		return keys.front().Value;
	if (timePos >= keys.back().TimePos)
		return keys.back().Value;

	const auto nextIt = std::upper_bound(
		keys.begin(), keys.end(), timePos,
		[](float time, const VectorKey& key)
		{
			return time < key.TimePos;
		});

	const VectorKey& next = *nextIt;
	const VectorKey& previous = *(nextIt - 1);
	const float deltaTime =	next.TimePos - previous.TimePos;

	//방어적 코드
	if (deltaTime <= 0.0f) return next.Value;

	const float alpha = (timePos - previous.TimePos) / deltaTime;
	XMVECTOR a = XMLoadFloat3(&previous.Value);
	XMVECTOR b = XMLoadFloat3(&next.Value);
	XMFLOAT3 result;
	XMStoreFloat3(&result, XMVectorLerp(a, b, alpha));

	return result;
}

static DirectX::XMFLOAT4 SampleQuaternion(const std::vector<QuaternionKey>& keys, float timePos)
{
	using namespace DirectX;
	assert(!keys.empty());

	if (keys.size() == 1 || timePos <= keys.front().TimePos)
		return keys.front().Value;
	if (timePos >= keys.back().TimePos)
		return keys.back().Value;

	const auto nextIt = std::upper_bound(
		keys.begin(), keys.end(), timePos,
		[](float time, const QuaternionKey& key)
		{
			return time < key.TimePos;
		});

	const QuaternionKey& next = *nextIt;
	const QuaternionKey& previous = *(nextIt - 1);
	const float deltaTime = next.TimePos - previous.TimePos;

	//방어적 코드
	if (deltaTime <= 0.0f) return next.Value;

	const float alpha = (timePos - previous.TimePos) / deltaTime;
	XMVECTOR a = XMQuaternionNormalize(XMLoadFloat4(&previous.Value));
	XMVECTOR b = XMQuaternionNormalize(XMLoadFloat4(&next.Value));
	// 동일 회전을 나타내는 반대 부호 Quaternion 처리
	if (XMVectorGetX(XMVector4Dot(a, b)) < 0.0f)
		b = XMVectorNegate(b);
	XMVECTOR rotation = XMQuaternionSlerp(a, b, alpha);
	XMFLOAT4 result;
	XMStoreFloat4(&result, XMQuaternionNormalize(rotation));

	return result;
}

void JointAnimation::Sample(float timePos, JointTransform& inOutTransform) const
{
	if (!TranslationKeys.empty())
		inOutTransform.Translation = SampleVector(TranslationKeys, timePos);

	if (!RotationKeys.empty())
		inOutTransform.Rotation = SampleQuaternion(RotationKeys, timePos);

	if (!ScaleKeys.empty())
		inOutTransform.Scale = SampleVector(ScaleKeys, timePos);
}
