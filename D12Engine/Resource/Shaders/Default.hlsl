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

Texture2D gDisplacementMap : register(t0, space2);

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

cbuffer cbSkinned : register(b2)
{
    float4x4 gBoneTransforms[96];
};

struct VertexIn
{
    float3 PosL : POSITION;
    float3 NormalL : NORMAL;
    float3 Tangent : TANGENT;
    float2 TexC : TEXCOORD;
#ifdef SKINNED
    float4 BoneWeights : WEIGHTS;
    uint4 BoneIndices : BONEINDICES;
#endif
};

struct VertexOut
{
    float4 PosH : SV_Position;
    float3 PosW : POSITION;
    float3 NormalW : NORMAL;
    float2 TexC : TEXCOORD;
    
    //보간 방지
    nointerpolation uint MatIndex : MATINDEX;
};

VertexOut VS(VertexIn vin, uint instanceID : SV_InstanceID)
{
    VertexOut vout = (VertexOut) 0.0f;
    
    InstanceData instData = gInstanceData[gInstanceIndex + instanceID];
    float4x4 world = instData.World;
    float4x4 worldInvTranspose = instData.WorldInvTranspose;
    float2 displacementMapTexelSize = instData.DisplacementMapTexelSize;
    float gridSpatialStep = instData.GridSpatialStep;
    uint matIndex = instData.MaterialIndex;
    vout.MatIndex = matIndex;
    
    MaterialData matData = gMaterialData[matIndex];
    
#ifdef DISPLACEMENT_MAP
    //변환되지 않은 [0,1]^2 tex 좌표를 사용하여 변위 맵을 샘플링.
    vin.PosL.y += gDisplacementMap.SampleLevel(gsamPointWrap, vin.TexC, 1.0f).r;
	
	//유한차분법을 이용하여 정규분포를 추정.
    float du = displacementMapTexelSize.x;
    float dv = displacementMapTexelSize.y;
    float l = gDisplacementMap.SampleLevel(gsamPointWrap, vin.TexC - float2(du, 0.0f), 0.0f).r;
    float r = gDisplacementMap.SampleLevel(gsamPointWrap, vin.TexC + float2(du, 0.0f), 0.0f).r;
    float t = gDisplacementMap.SampleLevel(gsamPointWrap, vin.TexC - float2(0.0f, dv), 0.0f).r;
    float b = gDisplacementMap.SampleLevel(gsamPointWrap, vin.TexC + float2(0.0f, dv), 0.0f).r;
    vin.NormalL = normalize(float3(-r + l, 2.0f * gridSpatialStep, b - t));
#endif
    
#ifdef SKINNED
    float weights[4] = { 0.0f, 0.0f, 0.0f, 0.0f };
    weights[0] = vin.BoneWeights.x;
    weights[1] = vin.BoneWeights.y;
    weights[2] = vin.BoneWeights.z;
    weights[3] = vin.BoneWeights.w;

    float3 posL = float3(0.0f, 0.0f, 0.0f);
    float3 normalL = float3(0.0f, 0.0f, 0.0f);
    float3 tangentL = float3(0.0f, 0.0f, 0.0f);
    for(int i = 0; i < 4; ++i)
    {
        // Assume no nonuniform scaling when transforming normals, so 
        // that we do not have to use the inverse-transpose.

        posL += weights[i] * mul(float4(vin.PosL, 1.0f), gBoneTransforms[vin.BoneIndices[i]]).xyz;
        normalL += weights[i] * mul(vin.NormalL, (float3x3)gBoneTransforms[vin.BoneIndices[i]]);
        tangentL += weights[i] * mul(vin.Tangent.xyz, (float3x3)gBoneTransforms[vin.BoneIndices[i]]);
    }

    vin.PosL = posL;
    vin.NormalL = normalL;
    vin.Tangent.xyz = tangentL;
#endif
    
    float4 posW = mul(float4(vin.PosL, 1.0f), world);
    vout.PosW = posW.xyz;
    
    // 균일 스케일링을 가정. 아니라면 월드 행렬의 역전치 행렬을 사용해야 한다.
    vout.NormalW = mul(vin.NormalL, (float3x3) worldInvTranspose);
    
    // homogeneous clip 공간으로 변환.
    vout.PosH = mul(posW, gViewProj);
    
    vout.TexC = mul(float4(vin.TexC, 0.f, 1.f), matData.MatTransform).xy;
    
    return vout;
}
 
float4 PS(VertexOut pin) : SV_Target
{
    MaterialData matData = gMaterialData[pin.MatIndex];
    float4 diffuseAlbedo = matData.DiffuseAlbedo;
    float3 fresnelR0 = matData.FresnelR0;
    float roughness = matData.Roughness;
    uint diffuseTexIndex = matData.DiffuseMapIndex;
	
    diffuseAlbedo = gDiffuseMap[diffuseTexIndex].Sample(gsamPointWrap, pin.TexC) * diffuseAlbedo;
    
#ifdef TEXTURE_BLEND
    diffuseAlbedo *= (gDiffuseMap[2].Sample(gsamPointWrap, pin.TexC) * diffuseAlbedo).r;
#endif
    
#ifdef ALPHA_TEST
	//value < 0 이면 현재 픽셀을 버리고 더 이상 렌더 타깃에 기록하지 않는다.
	clip(diffuseAlbedo.a - 0.1f);
#endif
    
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

float4 PS_MirrorBaseFill(VertexOut pin) : SV_Target
{
    return gMaterialData[pin.MatIndex].DiffuseAlbedo;
}