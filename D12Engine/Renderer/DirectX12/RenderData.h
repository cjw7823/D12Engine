#pragma once

#include "EngineCore/MathHelper.h"
#include <stdint.h>
#include "EngineCore/SkinnedData.h"
#include "EngineCore/RenderConfig.h"
#include <DirectXCollision.h>
#include <string>
#include <wrl.h>
#include <d3d12.h>

inline constexpr int MaxLights = 16;

//HLSL cbuffer는 16바이트(float4) 슬롯 단위로 패킹되므로,
//C++ 구조체도 멤버 배치가 어긋나지 않도록 padding을 둔다.
struct Light
{
	DirectX::XMFLOAT3 Strength = { 0.5f, 0.5f, 0.5f };
	float FalloffStart = 1.0f;								//point,		spot
	DirectX::XMFLOAT3 Direction = { 0.0f, -1.0f, 0.0f };	//directional,	spot
	float FalloffEnd = 10.0f;								//point,		spot
	DirectX::XMFLOAT3 Position = { 0.0f, 0.0f, 0.0f };		//point,		spot
	float SpotPower = 64.0f;								//spot
};

struct [[deprecated("Use InstanceData instead.")]]
ObjectConstants
{
	DirectX::XMFLOAT4X4 World = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 TexTransform = MathHelper::Identity4x4();
	DirectX::XMFLOAT2 DisplacementMapTexelSize = { 1.0f,1.0f };
	float GridSpatialStep = 1.0f;
	UINT MaterialIndex = 0;
};

struct SkinnedConstants
{
	DirectX::XMFLOAT4X4 BoneTransforms[96];
};

struct InstanceData
{
	DirectX::XMFLOAT4X4 World = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 WorldInvTranspose = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 TexTransform = MathHelper::Identity4x4();
	DirectX::XMFLOAT2 DisplacementMapTexelSize = { 1.0f,1.0f };
	float GridSpatialStep = 1.0f;
	UINT MaterialIndex = 0;

	bool visible = true;			//사용자가 숨김.
	bool FrustumVisible = true;		//프레임 컬링 결과

	DirectX::BoundingBox Bounds;
	UINT GpuInstanceIndex = UINT_MAX;
};

struct InstanceData_GPU
{
	DirectX::XMFLOAT4X4 World = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 WorldInvTranspose = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 TexTransform = MathHelper::Identity4x4();
	DirectX::XMFLOAT2 DisplacementMapTexelSize = { 1.0f,1.0f };
	float GridSpatialStep = 1.0f;
	UINT MaterialIndex = 0;
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
	DirectX::XMFLOAT4 gFogColor = {0.7f, 0.7f, 0.7f, 1.0f};
	float gFogStart = 5.0f;
	float gFogRange = 150.0f;
	DirectX::XMFLOAT2 cbPassPadding2 = {};
};

struct MaterialData
{
	DirectX::XMFLOAT4 DiffuseAlbedo = { 1.0f, 1.0f, 1.0f, 1.0f };
	DirectX::XMFLOAT3 FresnelR0 = { 0.01f, 0.01f, 0.01f };
	float Roughness = 0.25;

	DirectX::XMFLOAT4X4 MatTransform = MathHelper::Identity4x4();

	UINT DiffuseMapIndex = 0;
	UINT Pad[3]{};
};

struct DebugColorConstants
{
	DirectX::XMFLOAT4 debugColor;
};

struct SubmeshGeometry
{
	UINT IndexCount = 0;
	UINT StartIndexLocation = 0;
	INT BaseVertexLocation = 0;
	UINT VertexCount = 0;

	//이 서브메시로 정의된 기하 도형의 경계 상자.
	DirectX::BoundingBox Bounds;
};

struct MeshGeometry
{
	std::string Name;

	Microsoft::WRL::ComPtr<ID3DBlob> VertexBufferCPU = nullptr;
	Microsoft::WRL::ComPtr<ID3DBlob> IndexBufferCPU = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> VertexBufferGPU = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> IndexBufferGPU = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> VertexBufferUploader = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> IndexBufferUploader = nullptr;

	UINT VertexByteStride = 0;
	UINT VertexBufferByteSize = 0;
	DXGI_FORMAT IndexFormat = DXGI_FORMAT_R16_UINT;
	UINT IndexBufferByteSize = 0;

	std::unordered_map<std::string, SubmeshGeometry> DrawArgs;

	D3D12_VERTEX_BUFFER_VIEW VertexBufferView() const
	{
		D3D12_VERTEX_BUFFER_VIEW vbv;
		vbv.BufferLocation = VertexBufferGPU->GetGPUVirtualAddress();
		vbv.StrideInBytes = VertexByteStride;
		vbv.SizeInBytes = VertexBufferByteSize;

		return vbv;
	}

	D3D12_INDEX_BUFFER_VIEW IndexBufferView() const
	{
		D3D12_INDEX_BUFFER_VIEW ibv;
		ibv.BufferLocation = IndexBufferGPU->GetGPUVirtualAddress();
		ibv.Format = IndexFormat;
		ibv.SizeInBytes = IndexBufferByteSize;

		return ibv;
	}

	void DisposeUploaders()
	{
		VertexBufferUploader = nullptr;
		IndexBufferUploader = nullptr;
	}
};

//실제 엔진에서는 Material 클래스 계층 구조로 존재할 수 있다.
struct Material
{
	std::string Name;

	int MatBufferIndex = -1;
	int DiffuseSrvHeapIndex = -1;
	int NormalSrvHeapIndex = -1;

	int NumFramesDirty = RenderConfig::NumFrameResources;

	DirectX::XMFLOAT4 DiffuseAlbedo = { 1.0f, 1.0f, 1.0f, 1.0f };
	DirectX::XMFLOAT3 FresnelR0 = { 0.01f, 0.01f, 0.01f };
	float Roughness = 0.25f;
	DirectX::XMFLOAT4X4 MatTransform = MathHelper::Identity4x4();
};

struct Texture
{
	std::string Name;
	std::wstring FilePath;
	Microsoft::WRL::ComPtr<ID3D12Resource> Resource = nullptr; //Default Heap 용도
	Microsoft::WRL::ComPtr<ID3D12Resource> UploadHeap = nullptr;

	int SrvHeapIndex = -1;
};

//렌더링 순서에 영향
enum class RenderLayer : int
{
	Opaque = 0,
	SkinnedOpaque,
	TessLand,
	MultiTextureBlend,
	AlphaTestOpaque,
	A2C_TreeBillboard,			//트리 빌보드
	GeoSphereLOD,				//GeometryShader로 LOD 구현한 GeoShperes
	GeoExplode,
	LineToCylinder,				//선분으로 그리는 원통
	Waves,
	MirrorStencil,
	MirrorWall,
	TessWall,
	MirrorBaseFill,
	Reflected,
	Shadow,
	Transparent,
	
	Gizmo,

	Count,
};

struct SkinnedModelInstance;
struct RenderItem
{
	RenderItem() = default;
	RenderItem(const RenderItem& rhs) = delete;

	bool Visible = true;	//사용자가 숨김. 프레임 컬링과는 별도.
	bool InMirror = false;

	D3D12_PRIMITIVE_TOPOLOGY PrimitiveType = D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST;

	MeshGeometry* Geo = nullptr;
	//Geo의 특정 서브메시를 그리도록 책임.
	//추후 LOD 등 해당 서브메시에서 또 인덱스 제한을 걸 수도 있음.
	UINT IndexCount = 0;
	UINT BaseVertexLocation = 0;
	UINT StartIndexLocation = 0;

	//For GPU waves render items.
	DirectX::XMFLOAT2 DisplacementMapTexelSize = { 1.0f,1.0f };
	float GridSpatialStep = 1.0f;

	UINT StartInstanceLocation = 0;
	UINT VisibleInstanceCount = 0;
	std::vector<InstanceData> Instances;

	//스킨이 있는 경우만 유효
	UINT SkinnedCBIndex = -1;

	//애니메이션이 없는 RI는 nullptr로 둔다.
	SkinnedModelInstance* SkinnedModelInstance = nullptr;
};

struct SelectedInstance
{
	RenderItem* renderItem = nullptr;
	UINT instanceIndex = UINT_MAX;
	float BoundHitDistW = FLT_MAX;
};

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
		TexC(uv) {}
	Vertex(
		float px, float py, float pz,
		float nx, float ny, float nz,
		float tx, float ty, float tz,
		float u, float v) :
		Position(px, py, pz),
		Normal(nx, ny, nz),
		TangentU(tx, ty, tz),
		TexC(u, v) {}
		
	DirectX::XMFLOAT3 Position;
	DirectX::XMFLOAT3 Normal;
	DirectX::XMFLOAT3 TangentU;
	DirectX::XMFLOAT2 TexC;
};

struct MeshData
{
	std::vector<Vertex> Vertices;
	std::vector<uint32_t> Indices32;

	std::vector<uint16_t>& GetIndices16()
	{
		if (mIndices16.empty())
		{
			mIndices16.resize(Indices32.size());
			for (size_t i = 0; i < Indices32.size(); i++)
				mIndices16[i] = static_cast<uint16_t>(Indices32[i]);
		}
		return mIndices16;
	}

private:
	std::vector<uint16_t> mIndices16;
};

enum class GizmoAxis
{
	None,
	X,
	Y,
	Z
};

struct GizmoState
{
	bool Dragging = false;

	GizmoAxis ActiveAxis = GizmoAxis::None;

	DirectX::XMFLOAT3 StartObjectPosW = { 0.0f, 0.0f, 0.0f };
	DirectX::XMFLOAT3 StartHitPosW = { 0.0f, 0.0f, 0.0f };
	DirectX::XMFLOAT3 DragAxisW = { 1.0f, 0.0f, 0.0f };

	// plane: ax + by + cz + d = 0
	DirectX::XMFLOAT4 DragPlane = { 0.0f, 1.0f, 0.0f, 0.0f };
};

struct SkinnedModelInstance
{
	SkinnedData* skinnedInfo = nullptr;
	std::vector<DirectX::XMFLOAT4X4> finalTransforms;
	std::string clipName;
	float timePos = 0.0f;

	// 매 프레임 애니메이션 시간을 증가시키고, 현재 애니메이션 클립에 따라 각 본의 보간된 변환을 계산
	// 이후 최종 본 행렬 배열을 SkinnedCB에 복사하고, vertex shader에서 이 행렬들을 사용해 스키닝
	void UpdateSkinnedAnimation(float dt)
	{
		timePos += dt;

		if (timePos > skinnedInfo->GetClipEndTime(clipName))
			timePos = 0.0f;

		skinnedInfo->GetFinalTransforms(clipName, timePos, finalTransforms);
	}
};