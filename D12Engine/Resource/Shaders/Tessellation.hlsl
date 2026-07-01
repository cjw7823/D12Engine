#ifndef NUM_DIR_LIGHTS
    #define NUM_DIR_LIGHTS 3
#endif

#ifndef NUM_POINT_LIGHTS
    #define NUM_POINT_LIGHTS 0
#endif

#ifndef NUM_SPOT_LIGHTS
    #define NUM_SPOT_LIGHTS 0
#endif

//#define CARTOON

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
StructuredBuffer<InstanceData> gInstanceData : register(t1, space1);

SamplerState gsamPointWrap : register(s0);
SamplerState gsamPointClamp : register(s1);
SamplerState gsamLinearWrap : register(s2);
SamplerState gsamLinearClamp : register(s3);
SamplerState gsamAnisotropicWrap : register(s4);
SamplerState gsamAnisotropicClamp : register(s5);

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
    
    // 인덱스 [0, NUM_DIR_LIGHTS)는 방향광입니다.
	// 인덱스[NUM_DIR_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS)는 점광원입니다.
	// 인덱스[NUM_DIR_LIGHTS + NUM_POINT_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHT + NUM_SPOT_LIGHTS)는 스포트라이트이며, 객체당 최대 MaxLights 개수까지 사용할 수 있습니다.
    Light gLights[MaxLights];
    
    //앱이 프레임당 한 번씩 안개 매개변수를 변경할 수 있도록 합니다.
    //특정 시간대에만 안개를 사용할 수 있습니다.
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
    float2 TexC : TEXCOORD;
};

struct VertexOut
{
    float3 PosL : POSITION;
    float3 NormalL : NORMAL;
    float2 TexC : TEXCOORD;
    
    //보간 방지
    nointerpolation uint MatIndex : MATINDEX;
    nointerpolation uint gInstanceID : INSTANCEID;
};

struct PatchTess
{
    float EdgeTess[4] : SV_TessFactor;
    float InsideTess[2] : SV_InsideTessFactor;
};

struct DomainOut
{
    float4 PosH : SV_Position;
    float3 PosW : POSITION;
    float3 NormalW : NORMAL;
    float2 TexC : TEXCOORD;
    
    nointerpolation uint MatIndex : MATINDEX;
};

float GetHillsHeight(float x, float z)
{
    return 0.3f * (z * sin(0.05f * x) + x * cos(0.1f * z));
}

float3 GetHillsNormal(float x, float z)
{
    // y = f(x, z)
    // normal = normalize((-df/dx, 1, -df/dz))

    float df_dx = 0.3f * (0.05f * z * cos(0.05f * x) + cos(0.1f * z));
    float df_dz = 0.3f * (sin(0.05f * x) - 0.1f * x * sin(0.1f * z));

    return normalize(float3(-df_dx, 1.0f, -df_dz));
}

VertexOut VS(VertexIn vin, uint instanceID : SV_InstanceID)
{
    uint globalInstanceID = gInstanceIndex + instanceID;
    
    VertexOut vout;
    vout.PosL = vin.PosL;
    vout.NormalL = vin.NormalL;
    vout.TexC = vin.TexC;
    vout.MatIndex = gInstanceData[globalInstanceID].MaterialIndex;
    vout.gInstanceID = globalInstanceID;
    
    return vout;
}

PatchTess ConstantHS(InputPatch<VertexOut, 4> patch, uint patchID : SV_PrimitiveID)
{
    PatchTess pt;
    
    float3 centerL = 0.25f * (patch[0].PosL + patch[1].PosL + patch[2].PosL + patch[3].PosL);
    float3 centerW = mul(float4(centerL, 1.0f), gInstanceData[patch[0].gInstanceID].World).xyz;
    
    float d = distance(centerW, gEyePosW);
    
    // 시점(eye)으로부터의 거리에 따라 패치를 테셀레이션합니다.
    // 이때 거리가 d1 이상이면 테셀레이션 수준은 0이 되고, d0 이하이면 64가 됩니다.
    // 구간 [d0, d1]은 테셀레이션이 수행되는 범위를 정의합니다.
    
    const float d0 = 20.0f;
    const float d1 = 100.0f;
    float tess = 64.0f * saturate((d1 - d) / (d1 - d0));
    
    //균일하게 패치를 tessellate
    
    pt.EdgeTess[0] = tess;
    pt.EdgeTess[1] = tess;
    pt.EdgeTess[2] = tess;
    pt.EdgeTess[3] = tess;
	
    pt.InsideTess[0] = tess;
    pt.InsideTess[1] = tess;
	
    return pt;
}

[domain("quad")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(4)]
[patchconstantfunc("ConstantHS")]
[maxtessfactor(64.0f)]
VertexOut HS(InputPatch<VertexOut, 4> p,
           uint i : SV_OutputControlPointID,
           uint patchId : SV_PrimitiveID)
{
    return p[i];
}

//유사 랜덤함수
float Hash12(float2 p)
{
    return frac(sin(dot(p, float2(127.1f, 311.7f))) * 43758.5453123f);
}

// 도메인 셰이더는 테셀레이터가 생성한 모든 정점마다 호출된다.
// 테셀레이션 이후의 정점 셰이더와 비슷한 역할을 한다.
[domain("quad")]
DomainOut DS(PatchTess patchTess,
            float2 uv : SV_DomainLocation,
            const OutputPatch<VertexOut, 4> quad)
{
    DomainOut dout;
    
    //쌍선형 보간
    float3 v1 = lerp(quad[0].PosL, quad[1].PosL, uv.x);
    float3 v2 = lerp(quad[2].PosL, quad[3].PosL, uv.x);
    float3 posL = lerp(v1, v2, uv.y);
    
    float3 n1 = lerp(quad[0].NormalL, quad[1].NormalL, uv.x);
    float3 n2 = lerp(quad[2].NormalL, quad[3].NormalL, uv.x);
    float3 normalL = normalize(lerp(n1, n2, uv.y));
    
    float h = Hash12(floor(uv * 128.0f)) * 0.1f;
#ifdef WALL
    // 벽돌 벽: normal 방향으로 밀기
    posL += normalL * h;
#else
    // 지형: y 높이를 함수로 결정
    posL.y = GetHillsHeight(posL.x, posL.z);
    posL.y += h * 10;
    normalL = GetHillsNormal(posL.x, posL.z);
#endif
    
    InstanceData instData = gInstanceData[quad[0].gInstanceID];
    float4x4 world = instData.World;
    float4x4 worldInvTranspose = instData.WorldInvTranspose;
    float4x4 texTransform = instData.TexTransform;
    float2 displacementMapTexelSize = instData.DisplacementMapTexelSize;
    float gridSpatialStep = instData.GridSpatialStep;
    uint matIndex = instData.MaterialIndex;
    
    //변위 매핑
    float4 posW = mul(float4(posL, 1.0f), world);
    dout.PosW = posW.xyz;
    dout.PosH = mul(posW, gViewProj);
    dout.NormalW = normalize(mul(normalL, (float3x3) worldInvTranspose));
    float4 texC = mul(float4(uv, 0.f, 1.f), texTransform);
    dout.TexC = mul(texC, gMaterialData[matIndex].MatTransform).xy;
    dout.MatIndex = matIndex;
    
    return dout;
}

float4 PS(DomainOut pin) : SV_Target
{
    MaterialData matData = gMaterialData[pin.MatIndex];
    
    float4 diffuseAlbedo = matData.DiffuseAlbedo;
    float3 fresnelR0 = matData.FresnelR0;
    float roughness = matData.Roughness;
    uint diffuseTexIndex = matData.DiffuseMapIndex;
    
    diffuseAlbedo = gDiffuseMap[diffuseTexIndex].Sample(gsamPointWrap, pin.TexC) * diffuseAlbedo;
    
    //보간된 법선 벡터는 길이가 1이 아닐 수 있으므로.
    pin.NormalW = normalize(pin.NormalW);

    //광원에서 카메라로 향하는 벡터.
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

    //일반적으로 알파 값은 디퓨즈 머티리얼의 알파 값을 사용한다.
    litColor.a = diffuseAlbedo.a;
    
    return litColor;
}