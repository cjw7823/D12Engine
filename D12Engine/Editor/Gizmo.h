#pragma once

#include "DirectX-Headers\d3dx12.h"
#include "Renderer/DirectX12/RenderData.h"
#include <DirectXMath.h>

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

class Gizmo
{
public:

private:
	InstanceData* GetPrimarySelectedInstance(std::vector<SelectedInstance> instances);



	void SelectRenderItemByMouseClick(int sx, int sy);
	void ClearSelectedInstance();
	void BuildWorldRayFromScreen(int sx, int sy, DirectX::XMVECTOR& rayOriginW, DirectX::XMVECTOR& rayDirW) const;
	DirectX::XMVECTOR BuildDragPlaneNormal(DirectX::XMVECTOR axisW, DirectX::XMVECTOR cameraForwardW) const;
	DirectX::XMVECTOR MakePlaneFromPointNormal(DirectX::XMVECTOR pointW, DirectX::XMVECTOR normalW) const;
	bool IntersectRayPlane(DirectX::XMVECTOR rayOriginW, DirectX::XMVECTOR rayDirW, DirectX::XMVECTOR plane, DirectX::XMVECTOR& hitPointW) const;
	bool BeginGizmoDrag(int sx, int sy);
	void UpdateGizmoDrag(int sx, int sy);
	void EndGizmoDrag();
	DirectX::XMVECTOR GetGizmoAxisVector(GizmoAxis axis) const;
	void SetSelectedObjectPositionW(const DirectX::XMFLOAT3& posW);
	float CalcGizmoAxisLength(const DirectX::XMFLOAT3& pivotW) const;
	GizmoAxis PickGizmoAxis(int sx, int sy);
};