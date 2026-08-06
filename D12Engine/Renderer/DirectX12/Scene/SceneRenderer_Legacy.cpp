#include "pch.h"
#include "SceneRenderer.h"

#include <DirectXMath.h>

using namespace Microsoft::WRL;
using namespace DirectX;

void SceneRenderer::BuildScene()
{
	mRenderBatchesDirty = true;

	//BuildSceneObject_Common();
	BuildSceneObject_InMirror();
	BuildSceneObject_Gizmo();
	//BuildSceneObject_FBX();

	RebuildRenderBatches();
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

void SceneRenderer::BuildSceneObject_FBX()
{
	const std::string assetName = "fbxPreviewGeo";
	const auto skeletalMeshIt = mSkeletalMesheAssets.find(assetName);
	SkeletalMeshAsset& skeletalMesh = skeletalMeshIt->second;

	TransformComponent transform;
	transform.Position = { 5.0f, 0.0f, 0.0f };
	transform.Rotation = { 0.0f, 180.0f, 0.0f };
	transform.Scale = { 0.03f, 0.03f, 0.03f };

	CreateSkeletalMeshObject(L"FBX 미리보기", assetName.c_str(), skeletalMesh, transform);

	transform.Position = { 15.0f, 0.0f, 0.0f };
	transform.Rotation = { 0.0f, 180.0f, 0.0f };
	transform.Scale = { 0.03f, 0.03f, 0.03f };

	CreateSkeletalMeshObject(L"FBX 미리보기2", assetName.c_str(), skeletalMesh, transform);
}