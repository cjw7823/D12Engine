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

Texture2D gDiffuseMap : register(t0);

SamplerState gsamPointWrap : register(s0);
SamplerState gsamPointClamp : register(s1);
SamplerState gsamLinearWrap : register(s2);
SamplerState gsamLinearClamp : register(s3);
SamplerState gsamAnisotropicWrap : register(s4);
SamplerState gsamAnisotropicClamp : register(s5);

cbuffer cbPerObject : register(b0)
{
    float4x4 gWorld; //16DWARD
    float4x4 gTexTransform;
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
    
    Light gLights[MaxLights];
    
    float4 gFogColor;
    float gFogStart;
    float gFogRange;
    float2 cbPerObjectPad2;
};

struct VertexIn
{
    float3 PosW : POSITION;
    float3 NormalL : NORMAL;
    float2 TexC : TEXCOORD;
};

struct VertexOut
{
    float3 CenterW : POSITION;
    float2 SizeW : SIZE;
};

struct GeoOut
{
    float4 PosH : SV_POSITION;
    float3 PosW : POSITION;
    float3 NormalW : NORMAL;
    float2 TexC : TEXCOORD;
    uint PrimID : SV_PrimitiveID;
};

//그냥 패스스루 셰이더.
VertexOut VS(VertexIn vin)
{
    VertexOut vout;
    
    float4 posW = mul(float4(vin.PosW, 1.0f), gWorld);
    vout.CenterW = posW.xyz;

    return vout;
}
 
[maxvertexcount(4)]
void GS(line VertexOut gin[2],
        uint primID : SV_PrimitiveID,
        inout TriangleStream<GeoOut> triStream)
{
    float3 up = float3(0.0f, 1.0f, 0.0f);
    float3 look = gEyePosW - gin[0].CenterW;
    look.y = 0.0f; //project to xz-plane
    look = normalize(look);
    float3 right = cross(up, look);

    //float halfWidth = 0.5f * gin[0].SizeW.x;
    //float halfHeight = 0.5f * gin[0].SizeW.y;
	
    float4 v[4];
    v[0] = float4(gin[0].CenterW, 1.0f);
    v[1] = float4(gin[1].CenterW, 1.0f);
    v[2] = float4(gin[0].CenterW + up * 3.0f, 1.0f);
    v[3] = float4(gin[1].CenterW + up * 3.0f, 1.0f);
    
    float2 texC[4] =
    {
        float2(0.0f, 1.0f),
		float2(0.0f, 0.0f),
		float2(1.0f, 1.0f),
		float2(1.0f, 0.0f)
    };
	
    GeoOut gout;
	[unroll]//컴파일할 때 루프를 풀어서 각 반복마다 별도의 명령어로 만들어준다. 이렇게 하면 GPU가 명령어를 더 효율적으로 실행할 수 있다.
    for (int i = 0; i < 4; ++i)
    {
        gout.PosH = mul(v[i], gViewProj);
        gout.PosW = v[i].xyz;
        gout.NormalW = look;
        gout.TexC = texC[i];
        gout.PrimID = primID;
		
        triStream.Append(gout);
    }
}

[maxvertexcount(4)]
void GS_LOD(triangle VertexOut gin[3],
        uint primID : SV_PrimitiveID,
        inout TriangleStream<GeoOut> triStream)
{
    float3 up = float3(0.0f, 1.0f, 0.0f);
    float3 look = gEyePosW - gin[0].CenterW;
    look.y = 0.0f; //project to xz-plane
    look = normalize(look);
    float3 right = cross(up, look);
    
    float4 v[4];
    v[0] = float4(gin[0].CenterW, 1.0f);
    v[1] = float4(gin[1].CenterW, 1.0f);
    v[2] = float4(gin[0].CenterW + up * 3.0f, 1.0f);
    v[3] = float4(gin[1].CenterW + up * 3.0f, 1.0f);
    
    float2 texC[4] =
    {
        float2(0.0f, 1.0f),
		float2(0.0f, 0.0f),
		float2(1.0f, 1.0f),
		float2(1.0f, 0.0f)
    };
	
    GeoOut gout;
	[unroll]
    for (int i = 0; i < 4; ++i)
    {
        gout.PosH = mul(v[i], gViewProj);
        gout.PosW = v[i].xyz;
        gout.NormalW = look;
        gout.TexC = texC[i];
        gout.PrimID = primID;
		
        triStream.Append(gout);
    }
}

float4 PS(GeoOut pin) : SV_Target
{
    float3 uvw = float3(pin.TexC, pin.PrimID % 3);
    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamAnisotropicClamp, pin.TexC) * gDiffuseAlbedo;
    
    pin.NormalW = normalize(pin.NormalW);
    
    float3 toEyeW = gEyePosW - pin.PosW;
    float distToEye = length(toEyeW);
    toEyeW /= distToEye; // normalize
    
    float4 ambient = gAmbientLight * diffuseAlbedo;

    const float shininess = 1.0f - gRoughness;
    Material mat = { diffuseAlbedo, gFresnelR0, shininess };
    float3 shadowFactor = 1.0f;
    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,
        pin.NormalW, toEyeW, shadowFactor);

    float4 litColor = ambient + directLight;

#ifdef FOG
	float fogAmount = saturate((distToEye - gFogStart) / gFogRange);
	litColor = lerp(litColor, gFogColor, fogAmount);
#endif
    
    litColor.a = diffuseAlbedo.a;

    return litColor;
}


