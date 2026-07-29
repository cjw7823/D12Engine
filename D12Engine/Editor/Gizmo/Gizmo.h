#pragma once

#include "DirectX-Headers\d3dx12.h"
#include "Renderer/DirectX12/RenderData.h"
#include "Renderer/DirectX12/Scene/SceneRenderTypes.h"
#include "Renderer/DirectX12/Scene/Camera/Camera.h"
#include "Renderer/DirectX12/Scene/SceneObject.h"
#include "Renderer/DirectX12/Scene/RenderBatch.h"

#include <DirectXMath.h>
#include <vector>

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
	void SetGigmoObjects(SceneObject* x, SceneObject* y, SceneObject* z);
	inline std::vector<SelectedSceneObject> GetSelectedInstances() const { return mSelectedObjects; }

	void Update(Camera* camera, int viewportWidth, int viewportHeight);

	bool BeginGizmoDrag(int vx, int vy);
	void Pick(int vx, int vy, const std::array<std::vector<RenderBatch>, (int)RenderLayer::Count>& renderBatch);
	void UpdateGizmoDrag(int vx, int vy);
	void EndGizmoDrag();

	bool IsGizmoDragging() const { return mGizmo.Dragging; }

private:
	void UpdateGizmo();

	SceneObject* GetPrimarySelectedObject();
	DirectX::XMVECTOR GetGizmoAxisVector(GizmoAxis axis) const;
	float CalcGizmoAxisLength(const DirectX::XMFLOAT3& pivotW) const;
	void BuildWorldRayFromViewport(int sx, int sy, DirectX::XMVECTOR& rayOriginW, DirectX::XMVECTOR& rayDirW) const;
	GizmoAxis PickGizmoAxis(int sx, int sy);

	void SetSelectedObjectPositionW(const DirectX::XMFLOAT3& posW);

	DirectX::XMVECTOR BuildDragPlaneNormal(DirectX::XMVECTOR axisW, DirectX::XMVECTOR cameraForwardW) const;
	DirectX::XMVECTOR MakePlaneFromPointNormal(DirectX::XMVECTOR pointW, DirectX::XMVECTOR normalW) const;
	bool IntersectRayPlane(DirectX::XMVECTOR rayOriginW, DirectX::XMVECTOR rayDirW, DirectX::XMVECTOR plane, DirectX::XMVECTOR& hitPointW) const;

private:
	SceneObject* mGizmoX = nullptr;
	SceneObject* mGizmoY = nullptr;
	SceneObject* mGizmoZ = nullptr;

	GizmoState mGizmo;
	std::vector<SelectedSceneObject> mSelectedObjects;

	Camera* mCamera;
	int mViewportWidth = 1;
	int mViewportHeight = 1;
};