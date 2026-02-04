#include "MathHelper.h"

using namespace DirectX;

float MathHelper::AngleFromXY(float x, float y)
{
    //개선된 코드
    float theta = static_cast<float>(atan2(y, x));  // +X 기준, (-pi, pi]
    if (theta < 0.0f)
        theta += 2.0f * Pi;     // [0, 2pi)

    return theta;

    /*
        C/C++ 표준은 부동소수점 나눗셈이 무한대를 낸다는 걸 보장하지 않는다
        대부분의 플랫폼에서 그렇게 동작할 뿐, 안전한 코드가 아니다.
        
    float theta = 0.0f;

    if (x >= 0.0f) //1,4사분면
    {
        // If x = 0, then atanf(y/x) = +pi/2 if y > 0
        //                atanf(y/x) = -pi/2 if y < 0
        theta = atanf(y / x);

        if (theta < 0.0f) //4사분면
            theta += 2.0f * Pi;
    }
    else //2,3사분면
        theta = atanf(y / x) + Pi;

    return theta;
    */
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
        //필터링 하지 않으면,
        //정육면체의 귀퉁이 방향 벡터들이 같은 구면 영역에 대해 더 많이 대응되게 됨.
        if (XMVector3Greater(XMVector3LengthSq(v), One))
            continue;

        return XMVector3Normalize(v);
    }
}

//매개변수 값을 반구의 중심 축으로 하는 반구 이내의 랜덤 벡터.
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
