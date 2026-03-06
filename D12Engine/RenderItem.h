#pragma once

#include "d3dUtil.h"
#include "MathHelper.h"

extern const int gNumFrameResources;

enum class RenderLayer : int
{
	Opaque = 0,
	Multi,
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

	RenderLayer layer = RenderLayer::Opaque;
};