#pragma once

#include "Renderer/Resources/MeshGeometry.h"
#include "Renderer/Resources/Material.h"
#include "Renderer/DirectX12/Scene/Light/Light.h"
#include "Renderer/DirectX12/Scene/SceneRenderTypes.h"
#include "Renderer/Resources/SkeletalMeshAsset.h"

struct Vertex
{
	Vertex() = default;
	Vertex(const DirectX::XMFLOAT3& p,
		const DirectX::XMFLOAT3& n,
		const DirectX::XMFLOAT3& t,
		const DirectX::XMFLOAT2& uv) :
		Position(p),
		Normal(n),
		TangentU(t),
		TexC(uv) {
	}
	Vertex(
		float px, float py, float pz,
		float nx, float ny, float nz,
		float tx, float ty, float tz,
		float u, float v) :
		Position(px, py, pz),
		Normal(nx, ny, nz),
		TangentU(tx, ty, tz),
		TexC(u, v) {
	}

	DirectX::XMFLOAT3 Position;
	DirectX::XMFLOAT3 Normal;
	DirectX::XMFLOAT3 TangentU;
	DirectX::XMFLOAT2 TexC;
};

struct MeshData
{
	std::vector<Vertex> Vertices;
	std::vector<uint32_t> Indices32;
};

struct PassConstants
{
	DirectX::XMFLOAT4X4 View = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 InvView = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 Proj = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 InvProj = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 ViewProj = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 InvViewProj = MathHelper::Identity4x4();
	DirectX::XMFLOAT3 EyePosW = { 0.0f, 0.0f, 0.0f };
	float cbPassPadding1 = 0.0f;
	DirectX::XMFLOAT2 RenderTargetSize = { 0.0f, 0.0f };
	DirectX::XMFLOAT2 InvRenderTargetSize = { 0.0f, 0.0f };
	float NearZ = 0.0f;
	float FarZ = 0.0f;
	float TotalTime = 0.0f;
	float DeltaTime = 0.0f;

	DirectX::XMFLOAT4 AmbientLight = { 0.0f, 0.0f, 0.0f, 1.0f };

	//인덱스 [0, NUM_DIR_LIGHTS)는 방향광
	//인덱스 [NUM_DIR_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS)는 점광원
	//인덱스 [NUM_DIR_LIGHTS + NUM_POINT_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS)는 스포트라이트
	//객체당 최대 MaxLights 개수까지 사용 가능.
	Light Lights[MaxLights];

	//프레임당 한 번씩 안개 매개변수를 변경->특정 시간대에만 안개를 사용.
	DirectX::XMFLOAT4 gFogColor = { 0.7f, 0.7f, 0.7f, 1.0f };
	float gFogStart = 5.0f;
	float gFogRange = 150.0f;
	DirectX::XMFLOAT2 cbPassPadding2 = {};
};

struct SkinnedData_GPU
{
	DirectX::XMFLOAT4X4 BoneTransforms;
};

struct InstanceData_GPU
{
	DirectX::XMFLOAT4X4 World = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 WorldInvTranspose = MathHelper::Identity4x4();

	float GridSpatialStep = 1.0f;

	UINT MaterialIndex = 0;

	// 이 캐릭터의 본 팔레트가 시작되는 행렬 인덱스
	std::uint32_t SkinnedBufferIndex = 0;
	std::uint32_t InstancePad = 0;
};

struct MaterialData_GPU
{
	DirectX::XMFLOAT4 DiffuseAlbedo = { 1.0f, 1.0f, 1.0f, 1.0f };
	DirectX::XMFLOAT3 FresnelR0 = { 0.01f, 0.01f, 0.01f };
	float Roughness = 0.25;

	DirectX::XMFLOAT4X4 MatTransform = MathHelper::Identity4x4();

	UINT DiffuseMapIndex = 0;
	UINT Pad[3]{};
};

struct SkinnedModelInstance
{
	const SkeletalMeshAsset* Asset = nullptr;

	std::string ClipName;
	float TimePos = 0.0f;

	// Skeleton JointIndex 기준 현재 Pose
	std::vector<DirectX::XMFLOAT4X4> JointToRootTransforms;

	// Submesh별 GPU Skin Palette
	std::vector<std::vector<DirectX::XMFLOAT4X4>> SubmeshFinalTransforms;

	void Initialize(const SkeletalMeshAsset& asset, std::string clipName = {});
	void UpdateAnimation(float deltaTime);
};