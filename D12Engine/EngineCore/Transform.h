#pragma once

#include <DirectXMath.h>

struct Transform
{
	DirectX::XMFLOAT3 Position = { 0.0f, 0.0f, 0.0f };
	DirectX::XMFLOAT3 Rotation = { 0.0f, 0.0f, 0.0f };
	DirectX::XMFLOAT3 Scale = { 1.0f, 1.0f, 1.0f };

	DirectX::XMMATRIX GetWorldMatrix() const
	{
		using namespace DirectX;

		XMMATRIX scale = XMMatrixScaling(Scale.x, Scale.y, Scale.z);
		XMMATRIX rotation = XMMatrixScaling(Rotation.x, Rotation.y, Rotation.z);
		XMMATRIX translation = XMMatrixScaling(Position.x, Position.y, Position.z);

		return scale * rotation * translation; //SRT 순서 보장
	}
};