#include "pch.h"
#include "SceneRenderer.h"

#include "D3D12Context.h"
#include "EngineCore/Scene.h"

bool SceneRenderer::Initialize(D3D12Context& context)
{
	if (mInitialized) return true;

	BuildDescriptorHeaps(context);
	BuildRootSignature(context);
	BuildShadersAndInputLayout(context);

	BuildGeometry(context);

	BuildMaterials(context);
	BuildRenderItems(context);
	BuildFrameResources(context);
	BuildPSOs(context);

	mInitialized = true;

	return true;
}

void SceneRenderer::Shutdown()
{
	if (!mInitialized) return;

	//추후 해제로직
	
	mInitialized = false;
}

void SceneRenderer::OnResize(int width, int height)
{
	mViewportWidth = std::max(1, width);
	mViewportHeight = std::max(1, height);

	//카메라 등 반영 예정.
}

void SceneRenderer::Update(const Scene& scene, float deltaTime)
{
	if (!mInitialized) return;


}

void SceneRenderer::Render(D3D12Context& context, const Scene& scene)
{
	if (!mInitialized) return;

	ID3D12GraphicsCommandList* cmdList = context.GetCommandList();


}

void SceneRenderer::BuildDescriptorHeaps(D3D12Context& context)
{
}

void SceneRenderer::BuildMaterials(D3D12Context& context)
{
}

void SceneRenderer::BuildRootSignature(D3D12Context& context)
{
}

void SceneRenderer::BuildRootSignature_Waves(D3D12Context& context)
{
}

void SceneRenderer::BuildShadersAndInputLayout(D3D12Context& context)
{
}

void SceneRenderer::BuildBackbufferSRV()
{
}

void SceneRenderer::BuildGeometry(D3D12Context& context)
{
}

void SceneRenderer::BuildShapeGeometry(D3D12Context& context)
{
}

void SceneRenderer::BuildLandGeometry()
{
}

void SceneRenderer::BuildWavesGeometry()
{
}

void SceneRenderer::BuildTreeBillboardGeometry()
{
}

void SceneRenderer::BuildCylinderWithoutTopGeometry()
{
}

void SceneRenderer::BuildBrickWallGeometry()
{
}

void SceneRenderer::BuildRenderItems(D3D12Context& context)
{
}

void SceneRenderer::BuildRenderItems_Common(unsigned short& InstanceBufferIndex)
{
}

void SceneRenderer::BuildRenderItems_InMirror(unsigned short& InstanceBufferIndex)
{
}

void SceneRenderer::BuildRenderItems_Gizmo(unsigned short& InstanceBufferIndex)
{
}

void SceneRenderer::BuildRenderItems_SkinnedModel(unsigned short& IinstanceBufferIndex)
{
}

void SceneRenderer::BuildFrameResources(D3D12Context& context)
{
}

void SceneRenderer::BuildPSOs(D3D12Context& context)
{
}


