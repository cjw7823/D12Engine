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
#include "EngineCore/Camera.h"
#include "EngineCore/Scene.h"
#include "EngineCore/SceneObject.h"
#include "EngineCore/Transform.h"

#include "Renderer/DirectX12/D3D12RenderTarget.h"
#include "Renderer/DirectX12/FrameResource.h"
#include "Renderer/DirectX12/GpuWaves.h"
#include "Renderer/DirectX12/BlurFilter.h"
#include "Renderer/DirectX12/SobelFilter.h"
#include "Renderer/Assets/TextureManager.h"

#include "Editor/Gizmo.h"

class D3D12Context;
class Scene;
class GameTimer;
struct GizmoState;

enum class ComputePass
{
	WavesUpdate,
	WavesDisturb,

	BlurHorizontal,
	BlurVertical,

	SobelExcute,
	SobelComposite,

	Count
};

enum class GraphicsPass
{
	DepthComplexityVisualize,

	SelectedMask,
	SelectedOutline,

	VertexNormalVisualize,

	Count
};

//상호 베타적인 렌더 모드들. 해당 모드에 따라서 특정 GraphicsPass On/Off
enum class SceneRenderMode
{
	Lit,
	Wireframe,
	DepthComplexity,
	VertexNormal,

	Count
};

struct SceneRenderSettings
{
	SceneRenderMode Mode = SceneRenderMode::Lit;
	bool FrustumCullingEnabled = true;
	bool SobelEnabled = false;

	UINT GetBlurCount() const { return BlurCounts[mBlurCountIndex]; }
	void NextBlurCount()
	{
		mBlurCountIndex = (mBlurCountIndex + 1) % BlurCounts.size();
	}
private:
	inline static constexpr std::array<UINT, 5> BlurCounts =
	{
		0, 1, 2, 4, 8
	};

	size_t mBlurCountIndex = 0;
};

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
	void BuildRenderItems_SkinnedModel(UINT& InstanceBufferIndex);
	RenderItem* CreateRenderItem(const char* GeoName,
		const char* submeshName,
		D3D12_PRIMITIVE_TOPOLOGY topology,
		std::vector<RenderLayer> layer,
		bool InMirror = false);
	InstanceData& AddInstance(
		RenderItem* renderItem,
		const char* matName,
		const wchar_t* objectName,
		const TransformComponent& transform,
		bool RegisterSceneObject = true);
	void FinalizeRenderItem(
		RenderItem* renderItem,
		UINT& nextInstanceBufferIndex);
	void BuildFrameResources(D3D12Context& context);
	void BuildPSOs(const D3D12Context& context);

	std::array<const CD3DX12_STATIC_SAMPLER_DESC, 7> GetStaticSamplers();
	DirectX::XMVECTOR GetMirrorPlane();
	float GetHillsHeight(float x, float z) const;

	[[deprecated("ObjectCB is Closed.")]]
	void UpdateObjectCBs(const GameTimer& gt);

	void UpdateSkinnedCBs();
	void UpdateMainPassCB();
	void UpdateReflectedPassCB();
	void UpdateInstanceBuffer();
	void UpdateMaterialBuffer();
	void UpdateWavesGPU(ID3D12GraphicsCommandList* cmdList);
	void UpdateShadowTransform();
	void AnimateMaterials();

	void DrawRenderItems(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers);
	void DrawSelectedInstance(ID3D12GraphicsCommandList* cmdList);
	void DrawRenderItems_VertexNormalDebug(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers);
	void DrawDebugColorTriangle(ID3D12GraphicsCommandList* cmdList);

	void CreateQueryHeap(D3D12Context& context);

	ID3D12PipelineState* ResolvePSO(RenderLayer layer, SceneRenderMode mode) const;

	SceneObject& RegisterSceneObject(
		const std::wstring& name,
		RenderItem& renderItem,
		std::uint32_t instanceIndex);

	Material* FindMaterialByIndex(
		std::uint32_t materialIndex);

	TransformComponent DecomposeTransform(
		const DirectX::XMFLOAT4X4& world) const;

public:
	//For Gizmo / Selected Instances
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

	//mPSOs[RenderLayer][SceneRenderMode].get();
	std::array < std::array< Microsoft::WRL::ComPtr<ID3D12PipelineState>, (int)SceneRenderMode::Count>, (int)RenderLayer::Count> mLayerPSOs;
	std::array<Microsoft::WRL::ComPtr<ID3D12PipelineState>, (int)ComputePass::Count> mComputePSOs;
	std::array<Microsoft::WRL::ComPtr<ID3D12PipelineState>, (int)GraphicsPass::Count> mGraphicsPSOs;

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

	//For Animation
	std::unique_ptr<SkinnedModelInstance> mSkinnedModelInstance;
	SkinnedData mSkinnedInfo;
	std::vector<M3DLoader::M3dMaterial> mSkinnedMats;
	std::vector<std::wstring> mSkinnedTexturePaths;
	std::vector<std::wstring> mSkinnedNormalTexturePaths;

	//For Camera
	DirectX::BoundingFrustum mCamFrustum;
	Camera mCamera;

	GameTimer mTimer;

	Scene& mScene;
};