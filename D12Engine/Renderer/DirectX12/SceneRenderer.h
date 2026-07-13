#pragma once

class D3D12Context;
class Scene;

class SceneRenderer
{
public:
	SceneRenderer() = default;
	SceneRenderer(const SceneRenderer&) = delete;
	SceneRenderer& operator=(const SceneRenderer&) = delete;

	bool Initialize(D3D12Context& context);
	void Shutdown();

	void OnResize(int width, int height);

	void Update(const Scene& scene, float deltaTime);
	void Render(D3D12Context& context, const Scene& scene);

private:
	void LoadTextures();

	void BuildDescriptorHeaps(D3D12Context& context);
	void BuildMaterials(D3D12Context& context);
	void BuildRootSignature(D3D12Context& context);
	void BuildRootSignature_Waves(D3D12Context& context);
	void BuildShadersAndInputLayout(D3D12Context& context);
	void BuildBackbufferSRV();

	void BuildGeometry(D3D12Context& context);
	void BuildShapeGeometry(D3D12Context& context);
	void BuildLandGeometry();
	void BuildWavesGeometry();
	void BuildTreeBillboardGeometry();
	void BuildCylinderWithoutTopGeometry();
	void BuildBrickWallGeometry();

	void BuildRenderItems(D3D12Context& context);
	void BuildRenderItems_Common(unsigned short& InstanceBufferIndex);
	void BuildRenderItems_InMirror(unsigned short& InstanceBufferIndex);
	void BuildRenderItems_Gizmo(unsigned short& InstanceBufferIndex);
	void BuildRenderItems_SkinnedModel(unsigned short& IinstanceBufferIndex);
	void BuildFrameResources(D3D12Context& context);
	void BuildPSOs(D3D12Context& context);

private:
	bool mInitialized = false;

	int mViewportWidth = 1;
	int mViewportHeight = 1;
};