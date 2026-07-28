#pragma once

#include <DirectXMath.h>

inline constexpr int MaxLights = 16;

//HLSL cbuffer는 16바이트(float4) 슬롯 단위로 패킹되므로,
//C++ 구조체도 멤버 배치가 어긋나지 않도록 padding을 둔다.
struct Light
{
	DirectX::XMFLOAT3 Strength = { 0.5f, 0.5f, 0.5f };
	float FalloffStart = 1.0f;								//point,		spot
	DirectX::XMFLOAT3 Direction = { 0.0f, -1.0f, 0.0f };	//directional,	spot
	float FalloffEnd = 10.0f;								//point,		spot
	DirectX::XMFLOAT3 Position = { 0.0f, 0.0f, 0.0f };		//point,		spot
	float SpotPower = 64.0f;								//spot
};
