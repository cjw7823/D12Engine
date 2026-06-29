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

struct MaterialData
{
    float4 DiffuseAlbedo;
    float3 FresnelR0;
    float Roughness;
    float4x4 MatTransform;
    uint DiffuseMapIndex;
    uint3 MatPad;
};

Texture2D gDiffuseMap[] : register(t0);
StructuredBuffer<MaterialData> gMaterialData : register(t0, space1);

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
    float2 gDisplacementMapTexelSize;
    float gGridSpatialStep;
    uint gMaterialIndex;
};

cbuffer cbPass : register(b1)
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
    float3 PosL : POSITION;
    float3 NormalL : NORMAL;
    float2 TexC : TEXCOORD;
};

struct VertexOut
{
    float3 PosW : POSITION;
    float3 NormalW : NORMAL;
    float2 TexC : TEXCOORD;
};

struct SubVertex
{
    float3 PosW;
    float3 NormalW;
    float2 TexC;
};

struct GeoOut
{
    float4 PosH : SV_POSITION;
    float3 PosW : POSITION;
    float3 NormalW : NORMAL;
    float2 TexC : TEXCOORD;
    uint PrimID : SV_PrimitiveID;
    nointerpolation uint LODLevel : TEXCOORD1;
};

SubVertex MakeMidVertex(SubVertex a, SubVertex b, float3 centerW, float radius)
{
    SubVertex r;

    float3 p = 0.5f * (a.PosW + b.PosW);
    p = centerW + normalize(p - centerW) * radius;

    r.PosW = p;
    r.NormalW = normalize(r.PosW - centerW);
    r.TexC = 0.5f * (a.TexC + b.TexC);

    return r;
}

void EmitTriangle(SubVertex a, SubVertex b, SubVertex c, uint primID, uint lodLevel, inout TriangleStream<GeoOut> triStream)
{
    GeoOut gout;

    gout.PosW = a.PosW;
    gout.PosH = mul(float4(a.PosW, 1.0f), gViewProj);
    gout.NormalW = a.NormalW;
    gout.TexC = a.TexC;
    gout.PrimID = primID;
    gout.LODLevel = lodLevel;
    triStream.Append(gout);

    gout.PosW = b.PosW;
    gout.PosH = mul(float4(b.PosW, 1.0f), gViewProj);
    gout.NormalW = b.NormalW;
    gout.TexC = b.TexC;
    gout.PrimID = primID;
    gout.LODLevel = lodLevel;
    triStream.Append(gout);

    gout.PosW = c.PosW;
    gout.PosH = mul(float4(c.PosW, 1.0f), gViewProj);
    gout.NormalW = c.NormalW;
    gout.TexC = c.TexC;
    gout.PrimID = primID;
    gout.LODLevel = lodLevel;
    triStream.Append(gout);

    triStream.RestartStrip();
}

void SubdivideOnce(SubVertex v0, SubVertex v1, SubVertex v2, float3 centerW, float radius, uint primID, uint lodLevel, inout TriangleStream<GeoOut> triStream)
{
    SubVertex m0 = MakeMidVertex(v0, v1, centerW, radius);
    SubVertex m1 = MakeMidVertex(v1, v2, centerW, radius);
    SubVertex m2 = MakeMidVertex(v2, v0, centerW, radius);

    EmitTriangle(v0, m0, m2, primID, lodLevel, triStream);
    EmitTriangle(m0, m1, m2, primID, lodLevel, triStream);
    EmitTriangle(m2, m1, v2, primID, lodLevel, triStream);
    EmitTriangle(m0, v1, m1, primID, lodLevel, triStream);
}

//그냥 패스스루 셰이더.
VertexOut VS(VertexIn vin)
{
    VertexOut vout;
    
    float4 posW = mul(float4(vin.PosL, 1.0f), gWorld);
    vout.PosW = posW.xyz;
    vout.NormalW = mul(vin.NormalL, (float3x3) gWorld);
    vout.TexC = vin.TexC;

    return vout;
}
 
[maxvertexcount(4)]
void GS(line VertexOut gin[2],
        uint primID : SV_PrimitiveID,
        inout TriangleStream<GeoOut> triStream)
{
    float3 up = float3(0.0f, 1.0f, 0.0f);
    float3 look = gEyePosW - gin[0].PosW;
    look.y = 0.0f; //project to xz-plane
    look = normalize(look);
    float3 right = cross(up, look);

    //float halfWidth = 0.5f * gin[0].SizeW.x;
    //float halfHeight = 0.5f * gin[0].SizeW.y;
	
    float4 v[4];
    v[0] = float4(gin[0].PosW, 1.0f);
    v[1] = float4(gin[1].PosW, 1.0f);
    v[2] = float4(gin[0].PosW + up * 3.0f, 1.0f);
    v[3] = float4(gin[1].PosW + up * 3.0f, 1.0f);
    
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
        gout.LODLevel = 0;
		
        triStream.Append(gout);
    }
}


[maxvertexcount(48)]
void GS_LOD(triangle VertexOut gin[3],
        uint primID : SV_PrimitiveID,
        inout TriangleStream<GeoOut> triStream)
{
    float3 center = (gin[0].PosW + gin[1].PosW + gin[2].PosW) / 3.0f;
    float distToEye = distance(gEyePosW, center);
    
    float3 centerW = mul(float4(0, 0, 0, 1), gWorld).xyz; // 구 중심의 월드좌표
    float radius = length(gin[0].PosW - centerW);
    
    SubVertex v0, v1, v2;
    v0.PosW = gin[0].PosW;
    v0.NormalW = gin[0].NormalW;
    v0.TexC = gin[0].TexC;
    v1.PosW = gin[1].PosW;
    v1.NormalW = gin[1].NormalW;
    v1.TexC = gin[1].TexC;
    v2.PosW = gin[2].PosW;
    v2.NormalW = gin[2].NormalW;
    v2.TexC = gin[2].TexC;
    
    if(distToEye < 15)
    {
        //1차 세분화에 필요한 중점들
        SubVertex m0 = MakeMidVertex(v0, v1, centerW, radius);
        SubVertex m1 = MakeMidVertex(v1, v2, centerW, radius);
        SubVertex m2 = MakeMidVertex(v2, v0, centerW, radius);

        //1차 세분화로 나온 4개 삼각형을 각각 다시 세분화 (2차 세분화)
        SubdivideOnce(v0, m0, m2, centerW, radius, primID, 2, triStream);
        SubdivideOnce(m0, m1, m2, centerW, radius, primID, 2, triStream);
        SubdivideOnce(m2, m1, v2, centerW, radius, primID, 2, triStream);
        SubdivideOnce(m0, v1, m1, centerW, radius, primID, 2, triStream);
    }
    else if (distToEye >= 15 && distToEye < 25)
    {
        SubdivideOnce(v0, v1, v2, centerW, radius, primID, 1, triStream);
    }
    else //distToEye >= 25
    {
        int vertexNum = 3;
        GeoOut gout;
	    [unroll]
        for (int i = 0; i < vertexNum; ++i)
        {
            gout.PosH = mul(float4(gin[i].PosW, 1.0f), gViewProj);
            gout.PosW = gin[i].PosW;
            gout.NormalW = gin[i].NormalW;
            gout.TexC = gin[i].TexC;
            gout.PrimID = primID;
            gout.LODLevel = 0;
		
            triStream.Append(gout);
        }
    }
}

[maxvertexcount(4)]
void GS_Explode(triangle VertexOut gin[3],
        uint primID : SV_PrimitiveID,
        inout TriangleStream<GeoOut> triStream)
{    
    float rand = frac(sin(primID * 12.9898f) * 758.5453f);
    float t = frac(gTotalTime + rand * 0.13f);
    
    float explodeAmount;
    float explodeDuration = 0.95f; // 폭발이 완전히 진행되는 시간
    if (t < explodeDuration)
    {
        float localT = t / explodeDuration; // 0~1로 재정규화
        explodeAmount = pow(localT, 18.0f);
    }
    else
        explodeAmount = 1.0f;
    
    float3 e0 = gin[1].PosW - gin[0].PosW;
    float3 e1 = gin[2].PosW - gin[0].PosW;
    float3 faceNormal = normalize(cross(e0, e1)) * 2.0f;
    
    float3 explodeVector = explodeAmount * faceNormal;
    
    [unroll]
    for (int i = 0; i < 3; ++i)
    {
        GeoOut gout;

        float3 newPosW = gin[i].PosW + explodeVector;

        gout.PosW = newPosW;
        gout.NormalW = faceNormal;
        gout.TexC = gin[i].TexC;
        gout.PosH = mul(float4(newPosW, 1.0f), gViewProj);
        gout.PrimID = primID;
        gout.LODLevel = 0;

        triStream.Append(gout);
    }

    triStream.RestartStrip();
}

[maxvertexcount(2)]
void GS_Debugging(point VertexOut gin[1],
                  uint primID : SV_PrimitiveID,
                  inout LineStream<GeoOut> lineStream)
{
    GeoOut gout;

    float NormalLength = 0.2f;
    float3 p0 = gin[0].PosW;
    float3 p1 = gin[0].PosW + gin[0].NormalW * NormalLength;

    // 시작점
    gout.PosW = p0;
    gout.NormalW = gin[0].NormalW;
    gout.TexC = gin[0].TexC;
    gout.PosH = mul(float4(p0, 1.0f), gViewProj);
    gout.PrimID = primID;
    gout.LODLevel = 0;
    lineStream.Append(gout);

    // 끝점
    gout.PosW = p1;
    gout.NormalW = gin[0].NormalW;
    gout.TexC = gin[0].TexC;
    gout.PosH = mul(float4(p1, 1.0f), gViewProj);
    gout.PrimID = primID;
    gout.LODLevel = 0;
    lineStream.Append(gout);

    lineStream.RestartStrip();
}

float4 PS(GeoOut pin) : SV_Target
{
    MaterialData matData = gMaterialData[gMaterialIndex];
    
    float4 diffuseAlbedo = matData.DiffuseAlbedo;
    float3 fresnelR0 = matData.FresnelR0;
    float roughness = matData.Roughness;
    uint diffuseTexIndex = matData.DiffuseMapIndex;
    
    diffuseAlbedo = gDiffuseMap[diffuseTexIndex].Sample(gsamPointWrap, pin.TexC) * diffuseAlbedo;
    
    if (pin.LODLevel == 2)
    {
        diffuseAlbedo.rgb *= float3(1.15f, 0.95f, 0.95f); // 붉은기
    }
    else if (pin.LODLevel == 1)
    {
        diffuseAlbedo.rgb *= float3(0.95f, 1.15f, 0.95f); // 초록기
    }
    else
    {
        diffuseAlbedo.rgb *= float3(0.95f, 0.95f, 1.15f); // 푸른기
    }
    
    pin.NormalW = normalize(pin.NormalW);
    
    float3 toEyeW = gEyePosW - pin.PosW;
    float distToEye = length(toEyeW);
    toEyeW /= distToEye; //normalize
    
    float4 ambient = gAmbientLight * diffuseAlbedo;

    const float shininess = 1.0f - roughness;
    Material mat = { diffuseAlbedo, fresnelR0, shininess };
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

float4 PS_VertexNormal(GeoOut pin) : SV_Target
{
    float3 normalColor = pin.NormalW * 0.5f + 0.5f;
    return float4(normalColor, 1.0f);
}