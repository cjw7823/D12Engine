#pragma once

#include "DirectX-Headers\d3dx12.h"
#include "Renderer/DirectX12/RenderData.h"
#include "EngineCore/Camera.h"

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

//ÃßÈÄ ¾Àºä Á¶ÀÛ ÆÐ³Î·Î ½Â°Ý ¿¹Á¤.
class Gizmo
{
public:
	void SetGigmoRenderItem(RenderItem* ri);
	inline std::vector<SelectedInstance> GetSelectedInstances() const { return mSelectedInstances; }

	void Update(Camera* camera, int viewportWidth, int viewportHeight);

	bool BeginGizmoDrag(int vx, int vy);
	void Pick(int vx, int vy, std::vector<RenderItem*> RenderItemLayer[]);
	void UpdateGizmoDrag(int vx, int vy);
	void EndGizmoDrag();

	bool IsGizmoDragging() const { return mGizmo.Dragging; }

private:
	void UpdateGizmo();

	InstanceData* GetPrimarySelectedInstance();
	DirectX::XMVECTOR GetGizmoAxisVector(GizmoAxis axis) const;
	float CalcGizmoAxisLength(const DirectX::XMFLOAT3& pivotW) const;
	void BuildWorldRayFromViewport(int sx, int sy, DirectX::XMVECTOR& rayOriginW, DirectX::XMVECTOR& rayDirW) const;
	GizmoAxis PickGizmoAxis(int sx, int sy);

	void SetSelectedObjectPositionW(const DirectX::XMFLOAT3& posW);

	DirectX::XMVECTOR BuildDragPlaneNormal(DirectX::XMVECTOR axisW, DirectX::XMVECTOR cameraForwardW) const;
	DirectX::XMVECTOR MakePlaneFromPointNormal(DirectX::XMVECTOR pointW, DirectX::XMVECTOR normalW) const;
	bool IntersectRayPlane(DirectX::XMVECTOR rayOriginW, DirectX::XMVECTOR rayDirW, DirectX::XMVECTOR plane, DirectX::XMVECTOR& hitPointW) const;

private:
	RenderItem* mGizmoRI = nullptr;
	GizmoState mGizmo;
	std::vector<SelectedInstance> mSelectedInstances;

	Camera* mCamera;
	int mViewportWidth = 1;
	int mViewportHeight = 1;
};