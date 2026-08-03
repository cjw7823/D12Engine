#include "CommonStructures.hlsli"

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