/*
    소벨 연산자를 사용하여 에지 검출
*/

Texture2D gInput1 : register(t0);
Texture2D gInput2 : register(t1);
RWTexture2D<float4> gOutput : register(u0);

//RGB값으로부터 휘도, 즉 밝기를 근사한다.
//이 가중치는 서로 다른 빛의 파장에 대한 인간 눈의 민감도를 바탕으로 실험적으로 도출된 값이다.
float Calcuminance(float3 color)
{
    return dot(color, float3(0.299f, 0.587f, 0.114f));
}

[numthreads(16, 16, 1)]
void SobelCS(int3 dispatchThreadID : SV_DispatchThreadID)
{
    //현재 픽셀 주변의 이웃 픽셀들을 샘플링
    float4 c[3][3];
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            int2 xy = dispatchThreadID.xy + int2(-1 + j, -1 + i);
            c[i][j] = gInput1[xy];
        }
    }
    
    //각 색상 채널에 대해 Sobel 방식을 사용하여 x방향 편미분을 추정한다.
    float4 Gx = -1.0f * c[0][0] - 2.0f * c[1][0] - 1.0f * c[2][0] + 1.0f * c[0][2] + 2.0f * c[1][2] + 1.0f * c[2][2];
    
    //각 색상 채널에 대해 Sobel 방식을 사용하여 y방향 편미분을 추정한다.
    float4 Gy = -1.0f * c[2][0] - 2.0f * c[2][1] - 1.0f * c[2][2] + 1.0f * c[0][0] + 2.0f * c[0][1] + 1.0f * c[0][2];
    
    //그래디언트는 (Gx, Gy)다. 각 색상 채널에 대해 그래디언트의 크기를 계산하여 변화율의 최대값을 구한다.
    float4 mag = sqrt(Gx * Gx + Gy + Gy);
    
    //엣지는 검은색, 다른 부분은 흰색
    mag = 1.0f - saturate(Calcuminance(mag.rgb));
    
    gOutput[dispatchThreadID.xy] = mag;
}

[numthreads(16, 16, 1)]
void CompositeCS(uint3 tid : SV_DispatchThreadID)
{
    float4 a = gInput1[tid.xy];
    float4 b = gInput2[tid.xy];

    gOutput[tid.xy] = a * b;
}