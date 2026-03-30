#include "MathHelper.h"
#include <cstdlib>
#include <ctime>

using namespace DirectX;

namespace
{
    struct RandSeeder
    {
        RandSeeder()
        {
            std::srand(static_cast<unsigned int>(std::time(nullptr)));
        }
    };

    //프로그램 시작(모듈 초기화) 시 생성되어 시드를 설정.
    static RandSeeder g_RandSeeder;
}

float MathHelper::RandF()
{
	return static_cast<float>(rand()) / static_cast<float>(RAND_MAX);
}

float MathHelper::RandF(float a, float b)
{
	return a + RandF() * (b - a);
}

int MathHelper::Rand(int a, int b)
{
	return a + rand() % ((b - a) + 1);
}

DirectX::XMFLOAT4X4 MathHelper::Identity4x4()
{
	static DirectX::XMFLOAT4X4 I(
		1.0f, 0.0f, 0.0f, 0.0f,
		0.0f, 1.0f, 0.0f, 0.0f,
		0.0f, 0.0f, 1.0f, 0.0f,
		0.0f, 0.0f, 0.0f, 1.0f);

	return I;
}

DirectX::XMVECTOR MathHelper::SphericalToCatesian(float radius, float theta, float phi)
{
	return DirectX::XMVectorSet(
		radius * sinf(phi) * cosf(theta),
		radius * cosf(phi),
		radius * sinf(phi) * sinf(theta),
		1.0f);
}

float MathHelper::AngleFromXY(float x, float y)
{
	float theta = static_cast<float>(atan2(y, x));  // +X 기준, (-pi, pi]
	if (theta < 0.0f)			//3,4 사분면
		theta += 2.0f * Pi;     // [0, 2pi)

	return theta;
}

DirectX::XMVECTOR MathHelper::RandUnitVec3()
{
	XMVECTOR One = XMVectorSet(1.0f, 1.0f, 1.0f, 1.0f);

	while (true)
	{
		XMVECTOR v = XMVectorSet(
			MathHelper::RandF(-1.0f, 1.0f),
			MathHelper::RandF(-1.0f, 1.0f),
			MathHelper::RandF(-1.0f, 1.0f),
			0.0f);

		//단위 구 안의 벡터 필터링.
		if (XMVector3Greater(XMVector3LengthSq(v), One))
			continue;

		return XMVector3Normalize(v);
	}
}

DirectX::XMVECTOR MathHelper::RandHemisphereUnitVec3(DirectX::XMVECTOR n)
{
	XMVECTOR One = XMVectorSet(1.0f, 1.0f, 1.0f, 1.0f);
	XMVECTOR Zero = XMVectorZero();

	while (true)
	{
		XMVECTOR v = XMVectorSet(
			MathHelper::RandF(-1.0f, 1.0f),
			MathHelper::RandF(-1.0f, 1.0f),
			MathHelper::RandF(-1.0f, 1.0f),
			0.0f);

		if (XMVector3Greater(XMVector3LengthSq(v), One))
			continue;

		//반구 필터링.
		if (XMVector3Less(XMVector3Dot(n, v), Zero))
			continue;

		return XMVector3Normalize(v);
	}
}

DirectX::XMMATRIX MathHelper::InverseTranspose(DirectX::CXMMATRIX M)
{
	//역전치는 법선 벡터에만 적용된다. 따라서 변환행을 0으로 설정한다.
	XMMATRIX A = M;
	A.r[3] = XMVectorSet(0, 0, 0, 1);

	XMVECTOR det = XMMatrixDeterminant(A);

	return XMMatrixTranspose(XMMatrixInverse(&det, A));
}
