#pragma once

#include "Renderer/DirectX12/Components/IComponent.h"
#include "EngineCore/Math/MathHelper.h"
#include <DirectXMath.h>

struct TransformComponent : IComponent
{
	DirectX::XMFLOAT3 Position = { 0.0f, 0.0f, 0.0f };
	DirectX::XMFLOAT3 Rotation = { 0.0f, 0.0f, 0.0f }; //에디터에서는 degree단위로 관리
	DirectX::XMFLOAT3 Scale = { 1.0f, 1.0f, 1.0f };

	bool UseWorldOverride = false;
	DirectX::XMFLOAT4X4 WorldOverride = MathHelper::Identity4x4();

	DirectX::XMMATRIX GetWorldMatrix() const
	{
		using namespace DirectX;

		if (UseWorldOverride) return XMLoadFloat4x4(&WorldOverride);

		XMMATRIX scale = XMMatrixScaling(Scale.x, Scale.y, Scale.z);
		const XMMATRIX rotation = XMMatrixRotationRollPitchYaw(
				XMConvertToRadians(Rotation.x),
				XMConvertToRadians(Rotation.y),
				XMConvertToRadians(Rotation.z));

		XMMATRIX translation = XMMatrixTranslation(Position.x, Position.y, Position.z);

		return scale * rotation * translation; //SRT 순서 보장
	}
};