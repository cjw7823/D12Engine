#pragma once

#include <Windows.h>
#include <DirectXMath.h>

class MathHelper
{
public:
	static float RandF();
	static float RandF(float a, float b);
	static int Rand(int a, int b);

	template<typename T>
	static T Min(const T& a, const T& b)
	{
		return a < b ? a : b;
	}

	template<typename T>
	static T Max(const T& a, const T& b)
	{
		return a > b ? a : b;
	}

	template<typename T>
	static T Lerp(const T& a, const T& b, float t)
	{
		return a + (b - a) * t;
	}

	template<typename T>
	static T Clamp(const T& x, const T& low, const T& high)
	{
		return x < low ? low : (x > high ? high : x);
	}

	static DirectX::XMFLOAT4X4 Identity4x4();

	// phi : 극각 / theta : 수평 방위각, 기준방향 +X축 / Y-up 축
	static DirectX::XMVECTOR SphericalToCatesian(float radius, float theta, float phi);

	//+X축 기준 각도. [0, 2*PI)
	static float AngleFromXY(float x, float y);
	static DirectX::XMVECTOR RandUnitVec3();
	//매개변수 값을 반구의 중심 축으로 하는 반구 이내의 랜덤 벡터.
	static DirectX::XMVECTOR RandHemisphereUnitVec3(DirectX::XMVECTOR n);
	//역전치 계산
	static DirectX::XMMATRIX InverseTranspose(DirectX::CXMMATRIX M);

public:
	inline static const float Infinity = FLT_MAX;
	inline static const float Pi = 3.1415926535f;
};