#include "LightingUtil.hlsli"

struct InstanceData
{
    float4x4 World;
    float4x4 WorldInvTranspose;
    float4x4 TexTransform;
    float2 DisplacementMapTexelSize;
    float GridSpatialStep;
    uint MaterialIndex;
};

StructuredBuffer<InstanceData> gInstanceData : register(t1, space1);
Texture2D selectionMask : register(t0, space4);

SamplerState gsamPointWrap : register(s0);

cbuffer cbPass : register(b0)
{
    float4x4 gView;
    float4x4 gInvView;
    float4x4 gProj;
    float4x4 gInvProj;
    float4x4 gViewProj;
    float4x4 gInvViewProj;
    float3 gEyePosW;
    float cbPerPassPad1;
    float2 gRenderTargetSize;
    float2 gInvRenderTargetSize;
    float gNearZ;
    float gFarZ;
    float gTotalTime;
    float gDeltaTime;
    float4 gAmbientLight;
    
    Light gLights[MaxLights];
    
    float4 gFogColor;
    float gFogStart;
    float gFogRange;
    float2 cbPerObjectPad2;
};

cbuffer cbInstanceIndex : register(b1)
{
    uint gInstanceIndex;
};

struct VertexIn
{
    float3 PosL : POSITION;
    float3 NormalL : NORMAL;
    float3 Tangent : TANGENT;
    float2 TexC : TEXCOORD;
};

struct VertexOut
{
    float4 PosH : SV_Position;
};

VertexOut VS(VertexIn vin)
{
    VertexOut vout;
    
    InstanceData inst = gInstanceData[gInstanceIndex];
    
    float4 posW = mul(float4(vin.PosL, 1.0f), inst.World);
    float3 normalW = mul(vin.NormalL, (float3x3) inst.WorldInvTranspose);
    normalW = normalize(normalW);
    
    //외곽선을 위해 정점을 월드 공간 노멀 방향으로 확장
    posW.xyz += normalW * 0.1f;
    vout.PosH = mul(posW, gViewProj);
    
    return vout;
}

VertexOut VS_Mask(VertexIn vin)
{
    VertexOut vout;
    
    InstanceData inst = gInstanceData[gInstanceIndex];
    
    float4 posW = mul(float4(vin.PosL, 1.0f), inst.World);
    float3 normalW = mul(vin.NormalL, (float3x3) inst.WorldInvTranspose);
    normalW = normalize(normalW);
    
    vout.PosH = mul(posW, gViewProj);
    
    return vout;
}
 
float4 PS(VertexOut pin) : SV_Target
{
    return float4(1.0f, 0.82f, 0.08f, 1.0f);
}