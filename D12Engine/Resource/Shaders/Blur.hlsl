/*
    최대 5픽셀 반경까지의 분리 가능한 가우시안 블러를 수행한다.
*/

static const int gMaxBlurRadius = 5;
static const int N = 256;
static const int CacheSize = N + 2*gMaxBlurRadius;

cbuffer cbSettings : register(b0)
{
    // 루트 상수(root constants)에 매핑되는 상수 버퍼에는
	// 배열 항목을 둘 수 없으므로, 각 요소를 개별적으로 나열한다.
    int gBlurRadius;
    
    float w0;
    float w1;
    float w2;
    float w3;
    float w4;
    float w5;
    float w6;
    float w7;
    float w8;
    float w9;
    float w10;
};

Texture2D gInput : register(t0);
RWTexture2D<float4> gOutput : register(u0);

groupshared float4 gCache[CacheSize];

[numthreads(N, 1, 1)]
void HorzBlurCS(int3 groupThreadID : SV_GroupThreadID,
                int3 dispatchThreadID : SV_DispatchThreadID)
{
	float weights[11] = { w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10 };
    uint width, height;
    gInput.GetDimensions(width, height);

    int2 texSize = int2(width, height);
    int2 lastTexel = texSize - int2(1, 1);
    
    //대역폭을 줄이기 위해 로컬 스레드 저장소를 채운다.
    //N개의 픽셀을 블러 처리하려면 블러 반경 때문에 N + 2*BlurRadius 개의 픽셀을 로드해야 한다.
    
    //이 스레드 그룹은 N개의 스레드를 실행한다.
    //추가로 필요한 2*BlurRadius개의 픽셀을 얻기 위해 2*BlurRadius개의 스레드가 추가 픽셀을 샘플링하게 한다.
    if (groupThreadID.x < gBlurRadius)
    {
        //이미지 경계에서 발생하는 범위 밖 샘플을 클램프.
        int x = max(dispatchThreadID.x - gBlurRadius, 0);
        gCache[groupThreadID.x] = gInput[int2(x, dispatchThreadID.y)];
    }
    if (groupThreadID.x >= N - gBlurRadius)
    {
        //이미지 경계에서 발생하는 범위 밖 샘플을 클램프.
        int x = min(dispatchThreadID.x + gBlurRadius, texSize.x - 1);
        gCache[groupThreadID.x + 2 * gBlurRadius] = gInput[int2(x, dispatchThreadID.y)];
    }
    
    gCache[groupThreadID.x + gBlurRadius] = gInput[min(dispatchThreadID.xy, lastTexel)];
    
    //모든 스레드가 완료될 때까지 대기.
    GroupMemoryBarrierWithGroupSync();
    
    //각 픽셀 블러처리
    float4 blurColor = float4(0, 0, 0, 0);

    for (int i = -gBlurRadius; i <= gBlurRadius; i++)
    {
        int k = groupThreadID.x + gBlurRadius + i;
        blurColor += weights[i + gBlurRadius] * gCache[k];
    }

    gOutput[dispatchThreadID.xy] = blurColor;
}

[numthreads(1, N, 1)]
void VertBlurCS(int3 groupThreadID : SV_GroupThreadID,
                int3 dispatchThreadID : SV_DispatchThreadID)
{
    float weights[11] = { w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10 };
    uint width, height;
    gInput.GetDimensions(width, height);

    int2 texSize = int2(width, height);
    int2 lastTexel = texSize - int2(1, 1);
    
    if(groupThreadID.y < gBlurRadius)
    {
        int y = max(dispatchThreadID.y - gBlurRadius, 0);
        gCache[groupThreadID.y] = gInput[int2(dispatchThreadID.x, y)];
    }
    if (groupThreadID.y >= N - gBlurRadius)
    {
        int y = min(dispatchThreadID.y + gBlurRadius, texSize.y - 1);
        gCache[groupThreadID.y + 2 * gBlurRadius] = gInput[int2(dispatchThreadID.x, y)];
    }
    
    gCache[groupThreadID.y + gBlurRadius] = gInput[min(dispatchThreadID.xy, lastTexel)];
    
    GroupMemoryBarrierWithGroupSync();
    
    float4 blurColor = float4(0, 0, 0, 0);
    
    for (int i = -gBlurRadius; i <= gBlurRadius; i++)
    {
        int k = groupThreadID.y + gBlurRadius + i;
        blurColor += weights[i + gBlurRadius] * gCache[k];
    }

    gOutput[dispatchThreadID.xy] = blurColor;
}