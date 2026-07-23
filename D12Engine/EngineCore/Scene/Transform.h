#pragma once

#include <DirectXMath.h>

struct TransformComponent
{
	DirectX::XMFLOAT3 Position = { 0.0f, 0.0f, 0.0f };
	DirectX::XMFLOAT3 Rotation = { 0.0f, 0.0f, 0.0f }; //에디터에서는 degree단위로 관리
	DirectX::XMFLOAT3 Scale = { 1.0f, 1.0f, 1.0f };

	DirectX::XMMATRIX GetWorldMatrix() const
	{
		using namespace DirectX;

		XMMATRIX scale = XMMatrixScaling(Scale.x, Scale.y, Scale.z);
		const XMMATRIX rotation = XMMatrixRotationRollPitchYaw(
				XMConvertToRadians(Rotation.x),
				XMConvertToRadians(Rotation.y),
				XMConvertToRadians(Rotation.z));

		XMMATRIX translation = XMMatrixTranslation(Position.x, Position.y, Position.z);

		return scale * rotation * translation; //SRT 순서 보장
	}
};