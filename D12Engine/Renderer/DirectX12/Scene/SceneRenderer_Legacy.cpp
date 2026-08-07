#include "pch.h"
#include "SceneRenderer.h"

#include "Renderer/DirectX12/Components/SkeletalMeshComponent.h"
#include "EngineCore/Logging/Logger.h"

#include <DirectXMath.h>

using namespace Microsoft::WRL;
using namespace DirectX;

void SceneRenderer::BuildScene()
{
	mRenderBatchesDirty = true;

	BuildSceneObject_Common();
	BuildSceneObject_InMirror();
	BuildSceneObject_Gizmo();
}

void SceneRenderer::BuildSceneObject_Common()
{
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 0.5f, 2.0f };
		transform.Rotation = { 0.0f, 0.0f, 0.0f };
		transform.Scale = { 2.0f, 2.0f / 3.0f, 2.0f };

		CreateStaticMeshObject(L"밉맵 상자", "shapeGeo", "box", "woodCrate",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
			{ RenderPass::Opaque }, true);
	}
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 2.0f, 15.0f };
		transform.Scale = { 2.0f, 2.0f, 2.0f };

		CreateStaticMeshObject(L"회전 블랜딩 상자", "shapeGeo", "box", "swirling",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
			{ RenderPass::MultiTextureBlend }, true);
	}
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 1.0f, -3.0f };

		CreateStaticMeshObject(L"철망 상자", "shapeGeo", "box", "wireFence",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
			{ RenderPass::AlphaTestOpaque }, true);
	}
	{
		TransformComponent transform;
		transform.Position = { -3.0f, 0.0f, 7.0f };
		transform.Scale = { 1.5f, 1.0f, 1.4f };

		CreateStaticMeshObject(L"바닥", "shapeGeo", "grid", "checkerTileMat",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
			{ RenderPass::Opaque }, true, XMMatrixScaling(8.0f, 8.0f, 1.0f));
	}

	for (int i = 0; i < 8; ++i)
	{
		TransformComponent leftCylTransform;
		leftCylTransform.Position = { -12.0f, 1.5f, -10.0f + i * 5.0f };

		TransformComponent rightCylTransform;
		rightCylTransform.Position = { -2.0f, 1.5f, -10.0f + i * 5.0f };

		TransformComponent leftSphereTransform;
		leftSphereTransform.Position = { -12.0f, 3.5f, -10.0f + i * 5.0f };

		TransformComponent rightSphereTransform;
		rightSphereTransform.Position = { -2.0f, 3.5f, -10.0f + i * 5.0f };
		rightSphereTransform.Scale = { 2.0f, 2.0f, 2.0f };

		std::wstring objectName1 = L"왼쪽 기둥" + std::to_wstring(i);
		std::wstring objectName2 = L"오른쪽 기둥" + std::to_wstring(i);
		std::wstring objectName3 = L"왼쪽 돌" + std::to_wstring(i);
		std::wstring objectName4 = L"오른쪽 돌" + std::to_wstring(i);

		CreateStaticMeshObject(objectName1.c_str(), "shapeGeo", "cylinder", "bricks0",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, leftCylTransform,
			{ RenderPass::Opaque }, true);
		CreateStaticMeshObject(objectName2.c_str(), "shapeGeo", "cylinder", "bricks0",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, rightCylTransform,
			{ RenderPass::Opaque }, true);

		CreateStaticMeshObject(objectName3.c_str(), "shapeGeo", "sphere", "stone0",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, leftSphereTransform,
			{ RenderPass::Opaque }, true);
		CreateStaticMeshObject(objectName4.c_str(), "shapeGeo", "geoSphere", "stone0",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, rightSphereTransform,
			{ RenderPass::GeoSphereLOD }, true);
	}

	//skull
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 1.0f, 7.0f };
		transform.Scale = { 0.2f, 0.2f, 0.2f };

		mSkull = CreateStaticMeshObject(L"해골", "shapeGeo", "skull", "defaultMat",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
			{ RenderPass::Opaque }, true);
	}

	//land
	{
		TransformComponent transform;
		transform.Position = { 0.0f, -5.0f, 0.0f };

		CreateStaticMeshObject(L"땅", "landGeo", "grid", "grass0",
			D3D_PRIMITIVE_TOPOLOGY_4_CONTROL_POINT_PATCHLIST, transform,
			{ RenderPass::TessLand }, false,
			XMMatrixScaling(5.0f, 5.0f, 1.0f));
	}

	//wave
	{
		TransformComponent transform;
		transform.Position = { 0.0f, -1.0f, 0.0f };

		CreateStaticMeshObject(L"물", "waterGeo", "grid", "water0",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
			{ RenderPass::Waves }, false,
			XMMatrixScaling(5.0f, 5.0f, 1.0f));
	}

	//mirror
	{
		TransformComponent transform;
		transform.Position = { -18.0f, 2.0f, 7.0f };
		transform.Rotation = { 0.0f, 0.0f, -90.0f };
		transform.Scale = { 0.2f, 1.0f, 0.5f };

		mMirror = CreateStaticMeshObject(L"거울", "shapeGeo", "grid", "iceMirrorMat",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
			{ RenderPass::MirrorStencil, RenderPass::Transparent }, false,
			XMMatrixScaling(1.0f, 2.0f, 1.0f) * XMMatrixRotationZ(XM_PIDIV2));
	}
	{
		TransformComponent transform;
		transform.Position = { -18.001f, 3.0f, 7.0f };
		transform.Rotation = { 0.0f, 0.0f, -90.0f };
		transform.Scale = { 0.3f, 1.0f, 1.4f };

		auto ri = CreateStaticMeshObject(L"거울 벽", "brickWallGeo", "brickWall", "bricks1",
			D3D_PRIMITIVE_TOPOLOGY_4_CONTROL_POINT_PATCHLIST, transform,
			{ RenderPass::TessWall }, false,
			XMMatrixScaling(2.5f, 11.0f, 1.0f) * XMMatrixRotationZ(XM_PIDIV2));
		ri->mObjectFlags = static_cast<SceneObjectFlags>(SceneObjectFlags::NotSelectable);
	}
	//거울 백플레이트
	{
		TransformComponent transform;
		transform.Position = { -18.0f, 2.0f, 7.0f };
		transform.Rotation = { 0.0f, 0.0f, -90.0f };
		transform.Scale = { 0.2f, 1.0f, 0.5f };

		CreateStaticMeshObject(L"거울 백플레이트", "shapeGeo", "grid", "mirrorBaseMat",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
			{ RenderPass::MirrorBaseFill }, false);
	}

	//skull shadow
	{
		TransformComponent transform;
		transform.Position = { 3.0f, 3.0f, 0.0f };

		mSkullShadow = CreateStaticMeshObject(L"해골 그림자", "shapeGeo", "skull", "shadowMat_skull",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
			{ RenderPass::Shadow }, true);
		mSkullShadow->mObjectFlags = static_cast<SceneObjectFlags>(SceneObjectFlags::NotSelectable);
	}

	//tree billboard
	{
		TransformComponent transform;
		auto ri = CreateStaticMeshObject(L"나무 빌보드", "treeBillboard", "tree", "treeBillboardMat",
			D3D_PRIMITIVE_TOPOLOGY_POINTLIST, transform,
			{ RenderPass::A2C_TreeBillboard }, false);
		ri->mObjectFlags = static_cast<SceneObjectFlags>(SceneObjectFlags::NotSelectable);
	}

	//extended Cylinder
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 0.0f, 20.0f };

		CreateStaticMeshObject(L"GS확장 원통", "cylinderWithoutTop", "cylinderWithoutTop", "bricks0",
			D3D_PRIMITIVE_TOPOLOGY_LINESTRIP, transform,
			{ RenderPass::LineToCylinder }, false);
	}

	//explode
	{
		TransformComponent transform;
		transform.Position = { -7.0f, 6.0f, 7.0f };

		CreateStaticMeshObject(L"폭발하는 돌", "shapeGeo", "geoSphere", "bricks0",
			D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
			{ RenderPass::GeoExplode }, true);
	}
}

void SceneRenderer::BuildSceneObject_InMirror()
{
	if (mMirror == nullptr) return;

	const XMMATRIX R = XMMatrixReflect(GetMirrorPlane()); // x = -10 plane

	std::vector<SceneObject*> copySceneObjects;
	for (const auto& obj : mScene.GetObjects())
		copySceneObjects.push_back(obj.get());

	for (auto sceneObjPtr : copySceneObjects)
	{
		MeshComponent* originMesh = sceneObjPtr->GetComponent<MeshComponent>();
		if (!originMesh || originMesh->InMirror == false) continue;

		SceneObject& reflected = mScene.CreateObject(sceneObjPtr->Name + L"_InMirror");
		XMStoreFloat4x4(&reflected.Transform.WorldOverride,
			sceneObjPtr->Transform.GetWorldMatrix() * R);
		reflected.Transform.UseWorldOverride = true;
		reflected.mObjectFlags = static_cast<SceneObjectFlags>(
			SceneObjectFlags::HideInHierarchy |
			SceneObjectFlags::NotSelectable |
			SceneObjectFlags::Transient);

		auto& reflectedMesh = reflected.AddComponent<MeshComponent>();
		reflectedMesh = *originMesh;
		reflectedMesh.InMirror = false;

		for (SubmeshSlot& slot : reflectedMesh.SubmeshSlots)
			slot.Layers = { RenderPass::Reflected };

		if (sceneObjPtr == mSkullShadow) mSkullShadowMirror = &reflected;
		if (sceneObjPtr == mSkull) mSkullMirror = &reflected;
	}
}

void SceneRenderer::BuildSceneObject_Gizmo()
{
	TransformComponent transform;

	auto gizmoX = CreateStaticMeshObject(L"기즈모 X", "shapeGeo", "box", "gizmoX",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
		{ RenderPass::Gizmo }, false);
	gizmoX->Visible = false;

	auto gizmoY = CreateStaticMeshObject(L"기즈모 Y", "shapeGeo", "box", "gizmoY",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
		{ RenderPass::Gizmo }, false);
	gizmoY->Visible = false;

	auto gizmoZ = CreateStaticMeshObject(L"기즈모 Z", "shapeGeo", "box", "gizmoZ",
		D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST, transform,
		{ RenderPass::Gizmo }, false);
	gizmoZ->Visible = false;

	SceneObjectFlags flag = static_cast<SceneObjectFlags>(SceneObjectFlags::HideInHierarchy | SceneObjectFlags::NotSelectable | SceneObjectFlags::EditorOnly | SceneObjectFlags::Transient);

	gizmoX->mObjectFlags = flag;
	gizmoY->mObjectFlags = flag;
	gizmoZ->mObjectFlags = flag;

	mGizmo.SetGigmoObjects(gizmoX, gizmoY, gizmoZ);
}