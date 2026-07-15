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

#include "EngineCore/LoadM3d.h"

#include "Renderer/DirectX12/D3D12RenderTarget.h"
#include "Renderer/DirectX12/FrameResource.h"
#include "Renderer/DirectX12/GpuWaves.h"
#include "Renderer/DirectX12/BlurFilter.h"
#include "Renderer/DirectX12/SobelFilter.h"
#include "Renderer/DirectX12/Camera.h"
#include "Renderer/Assets/TextureManager.h"

class D3D12Context;
class Scene;
class GameTimer;
struct GizmoState;

enum class SceneRenderMode
{
	Lit,
	Wireframe,
	DepthComplexity,
	VertexNormal,
	Sobel
};

struct SceneRenderSettings
{
	SceneRenderMode Mode = SceneRenderMode::Lit;
	bool FrustumCullingEnabled = true;

	void NextBlurCount()
	{
		static const std::array<UINT, 4> counts = { 1, 2, 4, 8 };
		static UINT index = 0;

		index = (index + 1) % counts.size();
		BlurCount = counts[index];
	}
private:
	UINT BlurCount = 0;
};

class SceneRenderer
{
public:
	SceneRenderer() = default;
	SceneRenderer(const SceneRenderer&) = delete;
	SceneRenderer& operator=(const SceneRenderer&) = delete;

	bool Initialize(D3D12Context& context, D3D12RenderTarget& rt);
	void Shutdown();

	void OnResize(D3D12Context& context, const D3D12RenderTarget& renderTarget);

	void Tick(D3D12Context& context, D3D12RenderTarget& renderTarget, const Scene& scene);
	
	float AspectRatio() const;

	//For Input
	void ZoomCamera(int wheelDelta);
	void RotateCamera(POINT mouseDelta);
	void MoveCameraForward(float speed) { mCamera.MoveForward(speed * mTimer.DeltaTime()); }
	void MoveCameraRight(float speed) { mCamera.MoveRight(speed * mTimer.DeltaTime()); }
	void MoveCameraUp(float speed) { mCamera.MoveUp(speed * mTimer.DeltaTime()); }
	void MoveSun(float deltaTheta, float deltaPhi);

private:
	void Update(const Scene& scene, float deltaTime);
	void Render(D3D12Context& context, D3D12RenderTarget& renderTarget, const Scene& scene);

	void ReadbackTimestampData(int frameResourceIndex);

	void LoadTextures(D3D12Context& context);

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

	void BuildRenderItems();
	void BuildRenderItems_Common(UINT& InstanceBufferIndex);
	void BuildRenderItems_InMirror(UINT& InstanceBufferIndex);
	void BuildRenderItems_Gizmo(UINT& InstanceBufferIndex);
	void BuildRenderItems_SkinnedModel(UINT& IinstanceBufferIndex);
	void BuildFrameResources(D3D12Context& context);
	void BuildPSOs(D3D12Context& context, D3D12RenderTarget& rt);

	std::array<const CD3DX12_STATIC_SAMPLER_DESC, 7> GetStaticSamplers();
	DirectX::XMVECTOR GetMirrorPlane();
	float GetHillsHeight(float x, float z) const;
	MeshData LoadModelFromFile(const std::wstring& path);

	void UpdateSkinnedCBs();
	void UpdateMainPassCB();
	void UpdateReflectedPassCB();
	void UpdateInstanceBuffer();
	void UpdateMaterialBuffer();
	void UpdateWavesGPU(ID3D12GraphicsCommandList* cmdList);
	void UpdateShadowTransform();
	void UpdateGizmo();
	void AnimateMaterials();

	void DrawRenderItems(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers);
	void DrawSelectedInstance(ID3D12GraphicsCommandList* cmdList);
	void DrawRenderItems_VertexNormalDebug(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers);
	void DrawDebugColorTriangle(ID3D12GraphicsCommandList* cmdList);

	void CreateQueryHeap(D3D12Context& context);

public:
	//Render Mode
	SceneRenderSettings mRenderSettings;

private:
	bool mInitialized = false;

	int mViewportWidth = 1;
	int mViewportHeight = 1;

	std::vector<std::unique_ptr<FrameResource>> mFrameResources;
	FrameResource* mCurrFrameResource = nullptr;
	int mCurrFrameResourceIndex = 0;

	std::unordered_map<std::string, Microsoft::WRL::ComPtr<ID3DBlob>> mShaders;
	std::unordered_map<std::string, Microsoft::WRL::ComPtr<ID3D12PipelineState>> mPSOs;
	std::unordered_map<std::string, std::unique_ptr<MeshGeometry>> mGeometries;
	std::unordered_map<std::string, std::unique_ptr<Material>> mMaterials;

	std::vector<std::unique_ptr<RenderItem>> mAllRenderItems;
	std::vector<RenderItem*> mRenderItemLayer[(int)RenderLayer::Count];
	std::vector<D3D12_INPUT_ELEMENT_DESC> mInputLayout;
	std::vector<D3D12_INPUT_ELEMENT_DESC> mTreeBillboardInputLayout;
	std::vector<D3D12_INPUT_ELEMENT_DESC> mSkinnedInputLayout;

	//추후 동적 메시 일반화 수정 필요.
	std::unique_ptr<GpuWaves> mWaves;
	RenderItem* mWavesRenderItem = nullptr;
	PassConstants mMainPassCB;
	PassConstants mReflectedPassCB;
	std::unique_ptr<BlurFilter> mBlurFilter;
	std::unique_ptr<SobelFilter> mSobelFilter;

	RenderItem* mMirror = nullptr;
	std::vector<RenderItem*> excludeRI_InMirror;
	RenderItem* mSkull = nullptr;
	RenderItem* mSkullMirror = nullptr;
	RenderItem* mSkullShadow = nullptr;
	RenderItem* mSkullShadowMirror = nullptr;

	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature_debug = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mWavesRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mPostProcessRootSignature = nullptr;

	//GPU Timestamp를 위한 qury heap
	Microsoft::WRL::ComPtr<ID3D12QueryHeap> mTimestampQueryHeap = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> mTimestampReadbackBuffer = nullptr;
	D3D12DescriptorHandle mTimestampDescriptorHandle{};
	UINT64 mGpuTimestampFrequency = 0;

	//For Directional Light
	float mSunTheta = 1.25f * DirectX::XM_PI;
	float mSunPhi = DirectX::XM_PIDIV4;

	bool mIsWireframe = false;
	bool mIsDepthComplexityDebug = false;
	bool mIsVertexNormalDebug = false;
	bool mFrustumCullingEnabled = true;
	bool is_Blur = false;
	UINT mBlurCount = 1;
	bool is_Sobel = false;

	//For Performance Measurement
	double mFullGpuMs = 0.0;
	double mSceneGpuMs = 0.0;
	UINT mInstanceCount = 0;
	UINT mVisibleInstanceCount = 0;

	//For Gizmo
	std::vector<SelectedInstance> mSelectedInstances;
	RenderItem* mGizmoRI = nullptr;
	GizmoState mGizmo;

	//For Animation
	UINT mSkinnedSrvHeapStart = 0;
	std::unique_ptr<SkinnedModelInstance> mSkinnedModelInstance;
	SkinnedData mSkinnedInfo;
	std::vector<M3DLoader::Subset> mSkinnedSubsets;
	std::vector<M3DLoader::M3dMaterial> mSkinnedMats;
	std::vector<std::string> mSkinnedTextureNames;
	std::vector<std::string> mSkinnedNormalTextureNames;

	//For Camera
	DirectX::BoundingFrustum mCamFrustum;
	Camera mCamera;

	GameTimer mTimer;
};