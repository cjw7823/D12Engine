#include "pch.h"
#include "Gizmo.h"
#include "EngineCore/Logging/Logger.h"
#include "EngineCore/StringUtil.h"

#include "Renderer/DirectX12/Components/StaticMeshComponent.h"

#include <DirectXMath.h>

using namespace DirectX;

void Gizmo::SetGigmoObjects(SceneObject* x, SceneObject* y, SceneObject* z)
{
	mGizmoX = x;
	mGizmoY = y;
	mGizmoZ = z;
}

void Gizmo::Update(Camera* camera, int viewportWidth, int viewportHeight)
{
	mCamera = camera;
	mViewportWidth = viewportWidth;
	mViewportHeight = viewportHeight;

	UpdateGizmo();
}

bool Gizmo::BeginGizmoDrag(int vx, int vy)
{
	SceneObject* selectedObj = GetPrimarySelectedObject();
	if (selectedObj == nullptr) return false;

	GizmoAxis pickedAxis = PickGizmoAxis(vx, vy);
	if (pickedAxis == GizmoAxis::None) return false;

	XMFLOAT3 objectPosF = selectedObj->Transform.Position;
	XMVECTOR objectPosW = XMLoadFloat3(&objectPosF);
	XMVECTOR axisW = GetGizmoAxisVector(pickedAxis);

	// 카메라 forward를 월드 공간으로 구한다.
	XMMATRIX V = mCamera->GetView();
	XMVECTOR detView = XMMatrixDeterminant(V);
	XMMATRIX invView = XMMatrixInverse(&detView, V);
	XMVECTOR cameraForwardW = XMVector3TransformNormal(XMVectorSet(0.0f, 0.0f, 1.0f, 0.0f), invView);
	cameraForwardW = XMVector3Normalize(cameraForwardW);

	XMVECTOR planeNormal = BuildDragPlaneNormal(axisW, cameraForwardW);

	XMVECTOR dragPlane = MakePlaneFromPointNormal(objectPosW, planeNormal);

	XMVECTOR rayOriginW, rayDirW;
	BuildWorldRayFromViewport(vx, vy, rayOriginW, rayDirW);

	XMVECTOR startHitW;
	if (!IntersectRayPlane(rayOriginW, rayDirW, dragPlane, startHitW)) return false;

	mGizmo.Dragging = true;
	mGizmo.ActiveAxis = pickedAxis;

	DirectX::XMStoreFloat3(&mGizmo.StartObjectPosW, objectPosW);
	DirectX::XMStoreFloat3(&mGizmo.StartHitPosW, startHitW);
	DirectX::XMStoreFloat3(&mGizmo.DragAxisW, axisW);
	DirectX::XMStoreFloat4(&mGizmo.DragPlane, dragPlane);

	return true;
}

void Gizmo::Pick(int vx, int vy, const std::array<std::vector<RenderBatch>, (int)RenderLayer::Count>& renderBatch)
{
	if (!mCamera || !mCamera->IsReady()) return;
	mSelectedObjects.clear();

	// ray를 월드공간으로 변환.
	XMVECTOR worldRayOrigin, worldRayDir;
	BuildWorldRayFromViewport(vx, vy, worldRayOrigin, worldRayDir);

	std::vector<SelectedSceneObject> candidates;

	auto checkLayers = { RenderLayer::Opaque, RenderLayer::SkinnedOpaque, RenderLayer::TessLand, RenderLayer::MultiTextureBlend, RenderLayer::AlphaTestOpaque, RenderLayer::GeoSphereLOD, RenderLayer::GeoExplode, RenderLayer::LineToCylinder, RenderLayer::Waves };
	for (auto Layer : checkLayers)
	{
		for (const RenderBatch& batch : renderBatch[(int)Layer])
		{
			for (const RenderInstanceRef& instanceRef : batch.Instances)
			{
				SceneObject* sceneObj = instanceRef.Object;
				StaticMeshComponent* mesh = sceneObj->GetComponent<StaticMeshComponent>();
				SubmeshSlot& sm = mesh->SubmeshSlots[instanceRef.SubMeshSlotIndex];
				
				if (sceneObj->Visible == false) continue;
				if (sceneObj->FrustumVisible == false) continue;

				XMMATRIX W = sceneObj->Transform.GetWorldMatrix();
				BoundingBox worldBounds;
				sm.Submesh->Bounds.Transform(worldBounds, W);

				float boundT = 0.0f;
				// 광선이 메시의 바운딩 박스와 교차하는지 확인
				if (worldBounds.Intersects(worldRayOrigin, worldRayDir, boundT))
				{
					SelectedSceneObject sceneObj;
					sceneObj.InstanceRef = &instanceRef;
					sceneObj.BoundHitDistW = boundT;
					candidates.push_back(sceneObj);
				}
			}
		}
	}

	std::sort(candidates.begin(), candidates.end(),
		[](const SelectedSceneObject& a, const SelectedSceneObject& b)
		{
			return a.BoundHitDistW < b.BoundHitDistW;
		});

	SelectedSceneObject selectedRenderItem;
	float closestDistW = FLT_MAX;

	// 2차: 후보에 대해서만 실제 triangle test
	for (const SelectedSceneObject& c : candidates)
	{
		// 이미 찾은 실제 hit보다 Bounds 진입점이 더 뒤면 더 볼 필요 없음
		if (c.BoundHitDistW > closestDistW) break;

		auto& instance = c.InstanceRef->Object;
		StaticMeshComponent* mesh = instance->GetComponent<StaticMeshComponent>();
		auto sm = mesh->SubmeshSlots[c.InstanceRef->SubMeshSlotIndex].Submesh;

		XMMATRIX W = instance->Transform.GetWorldMatrix();
		XMVECTOR detW = XMMatrixDeterminant(W);
		XMMATRIX invWorld = XMMatrixInverse(&detW, W);

		XMVECTOR localRayOrigin = XMVector3TransformCoord(worldRayOrigin, invWorld);
		XMVECTOR localRayDir = XMVector3TransformNormal(worldRayDir, invWorld);
		localRayDir = XMVector3Normalize(localRayDir);

		auto vertices = reinterpret_cast<Vertex*>(mesh->Geometry->VertexBufferCPU->GetBufferPointer());
		void* indexData = mesh->Geometry->IndexBufferCPU->GetBufferPointer();

		auto GetIndex = [&](UINT indexLocation) -> UINT
			{
				if (mesh->Geometry->IndexFormat == DXGI_FORMAT_R16_UINT)
				{
					auto indices16 = reinterpret_cast<std::uint16_t*>(indexData);
					return static_cast<UINT>(indices16[indexLocation]);
				}
				else
				{
					auto indices32 = reinterpret_cast<std::uint32_t*>(indexData);
					return indices32[indexLocation];
				}
			};

		UINT triCount = sm->IndexCount / 3;

		for (UINT i = 0; i < triCount; ++i)
		{
			auto ri = sm;
			UINT indexBase = ri->StartIndexLocation + i * 3;
			UINT i0 = GetIndex(indexBase + 0) + ri->BaseVertexLocation;
			UINT i1 = GetIndex(indexBase + 1) + ri->BaseVertexLocation;
			UINT i2 = GetIndex(indexBase + 2) + ri->BaseVertexLocation;

			XMVECTOR v0 = XMLoadFloat3(&vertices[i0].Position);
			XMVECTOR v1 = XMLoadFloat3(&vertices[i1].Position);
			XMVECTOR v2 = XMLoadFloat3(&vertices[i2].Position);

			float triT = 0.0f;
			if (TriangleTests::Intersects(localRayOrigin, localRayDir, v0, v1, v2, triT))
			{
				XMVECTOR hitLocal = localRayOrigin + localRayDir * triT;
				XMVECTOR hitWorld = XMVector3TransformCoord(hitLocal, W);
				float distW = XMVectorGetX(XMVector3Length(hitWorld - worldRayOrigin));

				if (distW < closestDistW)
				{
					closestDistW = distW;
					selectedRenderItem = c;
				}
			}
		}
	}

	if (selectedRenderItem.InstanceRef->Object != nullptr && 
		selectedRenderItem.InstanceRef->SubMeshSlotIndex != UINT_MAX)
	{
		mSelectedObjects.push_back(selectedRenderItem);
		std::wstring text(L"선택한 인스턴스 : ");
		text += selectedRenderItem.InstanceRef->Object->Name;
		Logger::Info(text);
	}
}

void Gizmo::UpdateGizmoDrag(int vx, int vy)
{
	if (!mGizmo.Dragging) return;
	if (mGizmo.ActiveAxis == GizmoAxis::None) return;

	SceneObject* selectedObj = GetPrimarySelectedObject();
	if (selectedObj == nullptr)
	{
		EndGizmoDrag();
		return;
	}

	XMVECTOR rayOriginW, rayDirW;
	BuildWorldRayFromViewport(vx, vy, rayOriginW, rayDirW);

	XMVECTOR dragPlane = XMLoadFloat4(&mGizmo.DragPlane);
	XMVECTOR currentHitW;
	if (!IntersectRayPlane(rayOriginW, rayDirW, dragPlane, currentHitW)) return;

	XMVECTOR startHitW = XMLoadFloat3(&mGizmo.StartHitPosW);
	XMVECTOR startObjectPosW = XMLoadFloat3(&mGizmo.StartObjectPosW);
	XMVECTOR axisW = XMLoadFloat3(&mGizmo.DragAxisW);
	axisW = XMVector3Normalize(axisW);

	// 마우스가 drag plane 위에서 움직인 월드 이동량
	XMVECTOR deltaW = currentHitW - startHitW;

	// 이동량을 선택 축 방향으로 투영
	float moveAmount = XMVectorGetX(XMVector3Dot(deltaW, axisW));

	// 오브젝트 시작 위치 + 축 방향 이동량
	XMVECTOR newObjectPosW = startObjectPosW + axisW * moveAmount;

	XMFLOAT3 newPosF;
	XMStoreFloat3(&newPosF, newObjectPosW);

	SetSelectedObjectPositionW(newPosF);
}

void Gizmo::EndGizmoDrag()
{
	mGizmo.Dragging = false;
	mGizmo.ActiveAxis = GizmoAxis::None;
}

void Gizmo::UpdateGizmo()
{
	assert(mGizmoX);
	assert(mGizmoY);
	assert(mGizmoZ);

	SceneObject* selectedObj = GetPrimarySelectedObject();

	if (selectedObj == nullptr)
	{
		mGizmoX->Visible = false;
		mGizmoY->Visible = false;
		mGizmoZ->Visible = false;
		return;
	}

	XMFLOAT3 pivot = selectedObj->Transform.Position;

	float axisLength = CalcGizmoAxisLength(pivot);
	float thickness = axisLength * 0.06f;

	mGizmoX->Visible = true;
	mGizmoY->Visible = true;
	mGizmoZ->Visible = true;

	// X axis: pivot에서 +X 방향으로 길게 뻗는 박스
	{
		mGizmoX->Transform.Scale = { axisLength, thickness, thickness };
		mGizmoX->Transform.Position = { 
				pivot.x + axisLength * 0.5f,
				pivot.y,
				pivot.z };
	}
	// Y axis
	{
		mGizmoY->Transform.Scale = { thickness, axisLength, thickness };
		mGizmoY->Transform.Position = {
				pivot.x,
				pivot.y + axisLength * 0.5f,
				pivot.z };
	}
	// Z axis
	{
		mGizmoZ->Transform.Scale = { thickness, thickness, axisLength };
		mGizmoZ->Transform.Position = {
				pivot.x,
				pivot.y,
				pivot.z + axisLength * 0.5f };
	}
}

SceneObject* Gizmo::GetPrimarySelectedObject()
{
	if (mSelectedObjects.empty())
		return nullptr;

	auto& selected = mSelectedObjects[0];

	if (selected.InstanceRef->Object == nullptr)
		return nullptr;

	if (selected.InstanceRef->SubMeshSlotIndex == UINT_MAX)
		return nullptr;

	return selected.InstanceRef->Object;
}

DirectX::XMVECTOR Gizmo::GetGizmoAxisVector(GizmoAxis axis) const
{
	switch (axis)
	{
	case GizmoAxis::X:
		return XMVectorSet(1.0f, 0.0f, 0.0f, 0.0f);

	case GizmoAxis::Y:
		return XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f);

	case GizmoAxis::Z:
		return XMVectorSet(0.0f, 0.0f, 1.0f, 0.0f);

	default:
		return XMVectorSet(0.0f, 0.0f, 0.0f, 0.0f);
	}
}

float Gizmo::CalcGizmoAxisLength(const DirectX::XMFLOAT3& pivotW) const
{
	XMVECTOR eye = mCamera->GetPosition();
	XMVECTOR pivot = XMLoadFloat3(&pivotW);

	float dist = XMVectorGetX(XMVector3Length(pivot - eye));

	XMFLOAT4X4 P = mCamera->GetProj4x4f();

	// P(1,1) = cot(fovY / 2)
	// 화면 높이 전체에 해당하는 월드 길이 = 2 * dist * tan(fovY / 2)
	// tan(fovY / 2) = 1 / P(1,1)
	float worldScreenHeight = 2.0f * dist / P(1, 1);

	float desiredPixelLength = 50.0f;
	float axisLength = worldScreenHeight * (desiredPixelLength / static_cast<float>(mViewportHeight));

	axisLength = std::clamp(axisLength, 0.5f, 10.0f);

	return axisLength;
}

void Gizmo::BuildWorldRayFromViewport(int sx, int sy, DirectX::XMVECTOR& rayOriginW, DirectX::XMVECTOR& rayDirW) const
{
	XMFLOAT4X4 P = mCamera->GetProj4x4f();

	// Viewport 로컬 좌표를 뷰 공간 좌표로 변환
	float vx = (+2.0f * sx / mViewportWidth - 1.0f) / P(0, 0);
	float vy = (-2.0f * sy / mViewportHeight + 1.0f) / P(1, 1);

	// 뷰 공간에서 Ray 생성.
	XMVECTOR rayOriginV = XMVectorSet(0.0f, 0.0f, 0.0f, 1.0f);
	XMVECTOR rayDirV = XMVectorSet(vx, vy, 1.0f, 0.0f);

	XMMATRIX invView = mCamera->GetInvView();

	// ray를 월드공간으로 변환.
	rayOriginW = XMVector3TransformCoord(rayOriginV, invView);
	rayDirW = XMVector3TransformNormal(rayDirV, invView);
	rayDirW = XMVector3Normalize(rayDirW);
}

GizmoAxis Gizmo::PickGizmoAxis(int sx, int sy)
{
	if (!mGizmoX || !mGizmoY || !mGizmoZ) return GizmoAxis::None;
	if (!mGizmoX->Visible || !mGizmoY->Visible || !mGizmoZ->Visible) return GizmoAxis::None;

	XMVECTOR rayOriginW, rayDirW;
	BuildWorldRayFromViewport(sx, sy, rayOriginW, rayDirW);

	GizmoAxis pickedAxis = GizmoAxis::None;
	float closestDistW = FLT_MAX;

	std::vector<SceneObject*> v{ mGizmoX, mGizmoY ,mGizmoZ };
	for (UINT i = 0; i < 3; i++)
	{
		auto instance = v[i];
		if (instance->Visible == false) continue;

		XMMATRIX W = instance->Transform.GetWorldMatrix();
		BoundingBox gizmoBounds;
		//주의.
		instance->GetComponent<StaticMeshComponent>()->SubmeshSlots[0].Submesh->Bounds.Transform(gizmoBounds, W);

		float boundT = 0.0f;
		if (gizmoBounds.Intersects(rayOriginW, rayDirW, boundT))
		{
			if (boundT < closestDistW)
			{
				closestDistW = boundT;
				pickedAxis = static_cast<GizmoAxis>(i + 1);
			}
		}
	}

	return pickedAxis;
}

void Gizmo::SetSelectedObjectPositionW(const DirectX::XMFLOAT3& posW)
{
	SceneObject* sceneObj = GetPrimarySelectedObject();
	if (sceneObj == nullptr) return;

	sceneObj->Transform.Position = posW;
}

DirectX::XMVECTOR Gizmo::BuildDragPlaneNormal(DirectX::XMVECTOR axisW, DirectX::XMVECTOR cameraForwardW) const
{
	axisW = XMVector3Normalize(axisW);
	cameraForwardW = XMVector3Normalize(cameraForwardW);

	// cameraForward를 axis에 수직인 방향으로 투영.
	// 결과 normal은 axis와 수직이다.
	// 따라서 이 normal을 가진 plane은 axis를 포함한다.
	XMVECTOR n =
		cameraForwardW -
		axisW * XMVectorGetX(XMVector3Dot(cameraForwardW, axisW));

	float lenSq = XMVectorGetX(XMVector3LengthSq(n));

	if (lenSq < 1e-6f)
	{
		// 카메라 방향과 축이 거의 평행할 때 fallback.
		XMVECTOR fallback = XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f);

		if (fabsf(XMVectorGetX(XMVector3Dot(fallback, axisW))) > 0.9f)
			fallback = XMVectorSet(1.0f, 0.0f, 0.0f, 0.0f);

		n = fallback - axisW * XMVectorGetX(XMVector3Dot(fallback, axisW));
	}

	return XMVector3Normalize(n);
}

DirectX::XMVECTOR Gizmo::MakePlaneFromPointNormal(DirectX::XMVECTOR pointW, DirectX::XMVECTOR normalW) const
{
	normalW = XMVector3Normalize(normalW);

	float d = -XMVectorGetX(XMVector3Dot(normalW, pointW));

	return XMVectorSet(
		XMVectorGetX(normalW),
		XMVectorGetY(normalW),
		XMVectorGetZ(normalW),
		d);
}

bool Gizmo::IntersectRayPlane(DirectX::XMVECTOR rayOriginW, DirectX::XMVECTOR rayDirW, DirectX::XMVECTOR plane, DirectX::XMVECTOR& hitPointW) const
{
	XMVECTOR n = XMVectorSet(
		XMVectorGetX(plane),
		XMVectorGetY(plane),
		XMVectorGetZ(plane),
		0.0f);

	float d = XMVectorGetW(plane);

	float denom = XMVectorGetX(XMVector3Dot(n, rayDirW));

	if (fabsf(denom) < 1e-6f) return false;

	//교차거리 계산
	float t = -(XMVectorGetX(XMVector3Dot(n, rayOriginW)) + d) / denom;

	if (t < 0.0f) return false;

	hitPointW = rayOriginW + rayDirW * t;
	return true;
}
