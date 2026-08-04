#pragma once

#include <array>
#include <string>
#include <unordered_map>
#include <memory>
#include <vector>
#include <wrl.h>
#include <DirectXCollision.h>
#include <DirectXMath.h>
#include <d3dcommon.h>

#include "DirectX-Headers/d3dx12.h"

#include "AssetPipeline/Importers/LoadM3d.h"

#include "Renderer/DirectX12/Scene/Scene.h"
#include "Renderer/DirectX12/Scene/SceneObject.h"
#include "Renderer/DirectX12/Scene/SceneRenderTypes.h"
#include "Renderer/DirectX12/Scene/RenderBatch.h"
#include "Renderer/DirectX12/Scene/Camera/Camera.h"
#include "Renderer/DirectX12/Effects/GpuWaves.h"
#include "Renderer/DirectX12/Effects/BlurFilter.h"
#include "Renderer/DirectX12/Effects/SobelFilter.h"
#include "Renderer/DirectX12/Components/TransformComponent.h"
#include "Renderer/DirectX12/D3D12RenderTarget.h"
#include "Renderer/DirectX12/FrameResource.h"
#include "Renderer/Resources/TextureManager.h"
#include "Renderer/Resources/SkeletalMeshAsset.h"

#include "Editor/Gizmo/Gizmo.h"

class D3D12Context;
class Scene;
class GameTimer;
struct GizmoState;

class SceneRenderer
{
	friend class EditorApplication;
public:
	SceneRenderer(Scene& scene);
	SceneRenderer() = default;
	SceneRenderer(const SceneRenderer&) = delete;
	SceneRenderer& operator=(const SceneRenderer&) = delete;

	bool Initialize(D3D12Context& context, DXGI_FORMAT colorFormat, DXGI_FORMAT depthFormat);
	void Shutdown();

	void OnResize(D3D12Context& context, const D3D12RenderTarget& renderTarget);

	void Tick(D3D12Context& context, D3D12RenderTarget& renderTarget, const Scene& scene);
	
	float AspectRatio() const;
	bool IsInitialized() const { return mInitialized; }

	//For Input
	void SetRenderSetting(SceneRenderMode mode);
	void ToggleSobel();
	void NextBlurCount();
	void PickRenderItem(int vx, int vy);
	void ZoomCamera(int wheelDelta);
	void RotateCamera(POINT mouseDelta);
	void MoveCameraForward(float speed) { mCamera.MoveForward(speed * mTimer.DeltaTime()); }
	void MoveCameraRight(float speed) { mCamera.MoveRight(speed * mTimer.DeltaTime()); }
	void MoveCameraUp(float speed) { mCamera.MoveUp(speed * mTimer.DeltaTime()); }
	void MoveSun(float deltaTheta, float deltaPhi);
	void ChangeMsaa(const D3D12Context& context);

private:
	void Update(const Scene& scene, float deltaTime);
	void Render(D3D12Context& context, D3D12RenderTarget& renderTarget, const Scene& scene);

	void ReadbackTimestampData(int frameResourceIndex);

	MeshData LoadModelFromFile_dx12ex(const std::wstring& path);
	void LoadSkinnedModel_dx12ex(D3D12Context& context);
	void LoadBuiltInTextures(D3D12Context& context);

	void BuildDescriptorHeaps(D3D12Context& context);
	void BuildMaterials(D3D12Context& context);

	void BuildRootSignature(D3D12Context& context);
	void BuildRootSignature_Default(D3D12Context& context);
	void BuildRootSignature_DepthComplexity(D3D12Context& context);
	void BuildRootSignature_PostProcess(D3D12Context& context);
	void BuildRootSignature_Waves(D3D12Context& context);
	void BuildShadersAndInputLayout();

	void BuildGeometry(D3D12Context& context);
	void BuildShapeGeometry(D3D12Context& context);
	void BuildLandGeometry(D3D12Context& context);
	void BuildWavesGeometry(D3D12Context& context);
	void BuildTreeBillboardGeometry(D3D12Context& context);
	void BuildCylinderWithoutTopGeometry(D3D12Context& context);
	void BuildBrickWallGeometry(D3D12Context& context);
	void BuildFBXGeometry(D3D12Context& context);
	void BuildScene();
	void BuildSceneObject_Common();
	void BuildSceneObject_InMirror();
	void BuildSceneObject_Gizmo();
	void BuildSceneObject_FBX();
	void BuildFrameResources(D3D12Context& context);
	void BuildPSOs(const D3D12Context& context);

	void BuildImportedTextures(D3D12Context& context);

	SceneObject* CreateStaticMeshObject(
		const wchar_t* objName,
		const char* GeoName,
		const char* subMeshName,
		const char* matName,
		D3D12_PRIMITIVE_TOPOLOGY topology,
		const TransformComponent& transform,
		std::vector<RenderPass> layer,
		bool InMirror, 
		DirectX::XMMATRIX matTransform = DirectX::XMMatrixIdentity());
	SceneObject* CreateSkeletalMeshObject(
		const wchar_t* objName,
		const char* GeoName,
		const char* matName,
		const SkeletalMeshAsset& asset,
		const TransformComponent& transform);

	std::array<const CD3DX12_STATIC_SAMPLER_DESC, 7> GetStaticSamplers();
	DirectX::XMVECTOR GetMirrorPlane();
	float GetHillsHeight(float x, float z) const;

	void UpdateSkinnedBuffer();
	void UpdateMainPassCB();
	void UpdateReflectedPassCB();
	void UpdateInstanceBuffer();
	void UpdateMaterialBuffer();
	void UpdateWavesGPU(ID3D12GraphicsCommandList* cmdList);
	void UpdateShadowTransform();
	void AnimateMaterials();
	
	void DrawSelectedSceneObject(ID3D12GraphicsCommandList* cmdList);
	void DrawDebugColorTriangle(ID3D12GraphicsCommandList* cmdList);

	void CreateQueryHeap(D3D12Context& context);

	ID3D12PipelineState* ResolvePSO(RenderPass layer, SceneRenderMode mode) const;

	//for Render Batch
	void RebuildRenderBatches();
	RenderBatch& FindOrCreateBatch(RenderPass layer, const RenderBatchKey& key);
	void DrawLayer(ID3D12GraphicsCommandList* cmdList, RenderPass layer);
	void DrawLayer_VertexNormalDebug(ID3D12GraphicsCommandList* cmdList, RenderPass layer);

public:
	Gizmo mGizmo;

private:
	bool mInitialized = false;

	int mViewportWidth = 1;
	int mViewportHeight = 1;

	DXGI_FORMAT mColorFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
	DXGI_FORMAT mDepthFormat = DXGI_FORMAT_D24_UNORM_S8_UINT;

	std::vector<std::unique_ptr<FrameResource>> mFrameResources;
	FrameResource* mCurrFrameResource = nullptr;
	int mCurrFrameResourceIndex = 0;

	std::unordered_map<std::string, Microsoft::WRL::ComPtr<ID3DBlob>> mShaders;

	std::array < std::array< Microsoft::WRL::ComPtr<ID3D12PipelineState>, (int)SceneRenderMode::Count>, (int)RenderPass::Count> mLayerPSOs;
	std::array<Microsoft::WRL::ComPtr<ID3D12PipelineState>, (int)ComputePass::Count> mComputePSOs;
	std::array<Microsoft::WRL::ComPtr<ID3D12PipelineState>, (int)GraphicsPass::Count> mGraphicsPSOs;

	std::unordered_map<std::string, std::unique_ptr<MeshGeometry>> mGeometries;
	std::unordered_map<std::string, std::unique_ptr<Material>> mMaterials;

	//Render Batch
	std::array<std::vector<RenderBatch>, (int)RenderPass::Count> mRenderBatches;
	bool mRenderBatchesDirty = true;
	std::vector<D3D12_INPUT_ELEMENT_DESC> mInputLayout;
	std::vector<D3D12_INPUT_ELEMENT_DESC> mTreeBillboardInputLayout;
	std::vector<D3D12_INPUT_ELEMENT_DESC> mSkinnedInputLayout;

	//추후 동적 메시 일반화 수정 필요.
	std::unique_ptr<GpuWaves> mWaves;
	SceneObject* mWavesRenderItem = nullptr;
	PassConstants mMainPassCB;
	PassConstants mReflectedPassCB;
	std::unique_ptr<BlurFilter> mBlurFilter;
	std::unique_ptr<SobelFilter> mSobelFilter;

	SceneObject* mMirror = nullptr;
	SceneObject* mSkull = nullptr;
	SceneObject* mSkullMirror = nullptr;
	SceneObject* mSkullShadow = nullptr;
	SceneObject* mSkullShadowMirror = nullptr;

	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature_debug = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mWavesRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mPostProcessRootSignature = nullptr;

	//GPU Timestamp를 위한 qury heap
	Microsoft::WRL::ComPtr<ID3D12QueryHeap> mTimestampQueryHeap = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> mTimestampReadbackBuffer = nullptr;
	UINT64 mGpuTimestampFrequency = 0;

	//For Directional Light
	float mSunTheta = 1.25f * DirectX::XM_PI;
	float mSunPhi = DirectX::XM_PIDIV4;

	//Render Mode
	SceneRenderSettings mRenderSettings;
	bool mFrustumCullingEnabled = true;

	//For Performance Measurement
	double mFullGpuMs = 0.0;
	double mSceneGpuMs = 0.0;
	UINT mInstanceCount = 0;
	UINT mVisibleInstanceCount = 0;

	//For FBX Animation
	std::unordered_map<std::string, SkeletalMeshAsset> mSkeletalMesheAssets;

	//For Camera
	DirectX::BoundingFrustum mCamFrustum;
	Camera mCamera;

	GameTimer mTimer;

	Scene& mScene;
};