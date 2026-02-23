#ifndef NUM_DIR_LIGHTS
    #define NUM_DIR_LIGHTS 3
#endif

#ifndef NUM_POINT_LIGHTS
    #define NUM_POINT_LIGHTS 0
#endif

#ifndef NUM_SPOT_LIGHTS
    #define NUM_SPOT_LIGHTS 0
#endif

#include "LightingUtil.hlsli"

cbuffer cbPerObject : register(b0)
{
    float4x4 gWorld; //16DWARD
};

cbuffer cbMaterial : register(b1)
{
    float4 gDiffuseAlbedo;
    float3 gFresnelR0;
    float gRoughness;
    float4x4 gMatTransform;
};

cbuffer cbPass : register(b2)
{
    float4x4 gView;
    float4x4 gInvView;
    float4x4 gProj;
    float4x4 gInvProj;
    float4x4 gViewProj;
    float4x4 gInvViewProj;
    float3 gEyePosW;
    float cbPerObjectPad1;
    float2 gRenderTargetSize;
    float2 gInvRenderTargetSize;
    float gNearZ;
    float gFarZ;
    float gTotalTime;
    float gDeltaTime;
    float4 gAmbientLight;
    
    // 인덱스 [0, NUM_DIR_LIGHTS)는 방향광입니다.
	// 인덱스[NUM_DIR_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS)는 점광원입니다.
	// 인덱스[NUM_DIR_LIGHTS + NUM_POINT_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHT + NUM_SPOT_LIGHTS)는 스포트라이트이며, 객체당 최대 MaxLights 개수까지 사용할 수 있습니다.
    Light gLights[MaxLights];
};

struct VertexIn
{
    float3 PosL : POSITION;
    float3 NormalL : NORMAL;
};

struct VertexOut
{
    float4 PosH : SV_Position;
    float3 PosW : POSITION;
    float3 NormalW : NORMAL;
};

VertexOut VS(VertexIn vin)
{
    VertexOut vout = (VertexOut)0.0f;
    
    float4 posW = mul(float4(vin.PosL, 1.0f), gWorld);
    vout.PosW = posW.xyz;
    
    // 비균일 스케일링을 가정. 아니라면 월드 행렬의 역전치 행렬을 사용해야 한다.
    vout.NormalW = mul(vin.NormalL, (float3x3) gWorld);
    
    // homogeneous clip 공간으로 변환.
    vout.PosH = mul(posW, gViewProj);
    
    return vout;
}

float4 PS(VertexOut pin) : SV_Target
{
    //보간된 법선 벡터는 길이가 1이 아닐 수 있으므로.
    pin.NormalW = normalize(pin.NormalW);

    //광원에서 카메라로 향하는 벡터.
    float3 toEyeW = normalize(gEyePosW - pin.PosW);
    float4 ambient = gAmbientLight * gDiffuseAlbedo;
    const float shininess = 1.0f - gRoughness;
    Material mat = { gDiffuseAlbedo, gFresnelR0, shininess };
    float3 shadowFactor = 1.0f;
    
    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,
        pin.NormalW, toEyeW, shadowFactor);

    float4 litColor = ambient + directLight;

    //일반적으로 알파 값은 디퓨즈 머티리얼의 알파 값을 사용한다.
    litColor.a = gDiffuseAlbedo.a;

    return litColor;
}