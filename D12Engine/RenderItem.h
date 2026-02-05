#pragma once

#include "d3dUtil.h"
#include "MathHelper.h"

/*
	하나의 드로우 콜에 필요한 최소 단위.
	앱마다(요구사항에 따라) 다를 수 있음.
	MeshGeometry = 버퍼 + 서브메시 목록.
	RenderItem = 어떤 서브메시를 특정 상태로 그려라(=draw call 1개).
*/
struct RenderItem
{
	inline static int NumFrameResources = 0;

	RenderItem() = delete;
	RenderItem(int frameNum) : NumFramesDirty(frameNum)
	{
		RenderItem::NumFrameResources = frameNum;
	};

	//같은 메시라도 world 행렬만 다르면 서로 다른 위치에 배치 가능.
	DirectX::XMFLOAT4X4 World = MathHelper::Identify4x4();

	//FrameResource마다 object cbuffer가 존재한다.
	//객체의 데이터가 수정되면 NumFramesDirty = NumFrameResources 설정 한다.
	int NumFramesDirty;

	//GPU 상수 버퍼의 인덱스.
	//하나의 큰 ObjectCB 배열을 여러 RenderItem이 공유하므로
	UINT ObjCBIndex = -1;

	//포인터를 사용하여 하나의 메시를 여러 RenderItem으로 그려낼 수 있음.
	MeshGeometry* Geo = nullptr;

	D3D12_PRIMITIVE_TOPOLOGY PrimitiveType = D3D10_PRIMITIVE_TOPOLOGY_TRIANGLELIST;

	//Geo의 특정 서브메시를 그리도록 책임.
	//추후 LOD 등 해당 서브메시에서 또 인덱스 제한을 둘 수도 있음.
	UINT IndexCount = 0;
	UINT StartIndexLocation = 0;
	int BaseVertexLocation = 0;
};