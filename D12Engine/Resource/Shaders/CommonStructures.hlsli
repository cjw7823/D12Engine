#include "LightingUtil.hlsli"

struct InstanceData
{
    float4x4 World;
    float4x4 WorldInvTranspose;
    float GridSpatialStep;
    uint MaterialIndex;
    
    //이 인스턴스의 현재 서브메시 본 팔레트가
    //gBoneTransforms에서 시작되는 행렬 인덱스
    uint SkinnedBufferIndex;
    uint InstPad;
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
StructuredBuffer<float4x4> gBoneTransforms : register(t2, space1);

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