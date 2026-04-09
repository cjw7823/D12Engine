#pragma once

#include "pch.h"
#include "MathHelper.h"

extern const int gNumFrameResources;

//렌더링 순서에 영향
enum class RenderLayer : int
{
	Opaque = 0,
	Multi,
	MirrorStencil,
	MirrorWall,
	Reflected,
	AlphaTestedTreeSprites,	//트리 빌보드
	LineStrip,				//선분으로 그리는 원통
	TriangleList,			//삼각형 리스트로 LOD 구현한 GeoSpheres
	Explode,				//GeometryShader로 삼각형을 폭발시키는 효과.
	Transparent,
	AlphaTest,				//철망 박스
	Shadow,
	Count
};

struct RenderItem
{
	RenderItem() = default;

	DirectX::XMFLOAT4X4 World = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 TexTransform = MathHelper::Identity4x4();

	int NumFramesDirty = gNumFrameResources;

	UINT ObjCBIndex = -1;

	MeshGeometry* Geo = nullptr;
	Material* Mat = nullptr;

	D3D12_PRIMITIVE_TOPOLOGY PrimitiveType = D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST;

	//Geo의 특정 서브메시를 그리도록 책임.
	//추후 LOD 등 해당 서브메시에서 또 인덱스 제한을 둘 수도 있음.
	UINT IndexCount = 0;
	UINT StartIndexLocation = 0;
	int BaseVertexLocation = 0;

	UINT VertexCount = 0;
};