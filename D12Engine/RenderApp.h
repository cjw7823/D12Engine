#pragma once

#include <array>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

#include <DirectXCollision.h>
#include <DirectXMath.h>
#include <d3dcommon.h>
#include <wrl/client.h>

#include "DirectX-Headers/d3dx12.h"

#include "Dx12App.h"
#include "Renderer/DirectX12/FrameResource.h"
#include "Renderer/DirectX12/GpuWaves.h"
#include "Renderer/DirectX12/RenderData.h"
#include "Renderer/DirectX12/BlurFilter.h"
#include "Renderer/DirectX12/SobelFilter.h"
#include "Renderer/DirectX12/Camera.h"

#include "EngineCore/LoadM3d.h"
#include "EngineCore/GameTimer.h"
#include "EngineCore/TextureLoader_Blocking.h"

class RenderApp : public Dx12App
{
public:
	RenderApp(HINSTANCE hInstance) : Dx12App(hInstance) {}
	RenderApp(const RenderApp& rhs) = delete;
	RenderApp& operator=(const RenderApp& rhs) = delete;
	virtual ~RenderApp() override;

	virtual bool Initialize() override;
	virtual void NextMsaaOoption() override;
	virtual void SetMsaaOption(UINT value) override;

	void NextBlurCount();

private:
	virtual void OnResize() override;
	void Update(const GameTimer& gt) override;
	void Draw(const GameTimer& gt) override;

	virtual void OnMouseDown(WPARAM btnState, int x, int y) override;
	virtual void OnMouseUp(WPARAM btnState, int x, int y) override;
	virtual void OnMouseMove(WPARAM btnState, int x, int y) override;
	virtual void OnMouseWheel(short zDelta, int x, int y) override;
	virtual void OnKeyUp(WPARAM key) override;
	virtual void OnKeyDown(WPARAM key) override;
	virtual void ReadbackTimestampData(int frameResourceIndex) override;

	void LoadSkinnedModel();
	void LoadTextures();
	void BuildDescriptorHeaps();
	void BuildMaterials();
	void BuildRootSignature();
	void BuildWavesRootSignature();
	void BuildShadersAndInputLayout();
	void BuildBackbufferSRV();

	void BuildShapeGeometry();
	void BuildLandGeometry();
	void BuildWavesGeometry();
	void BuildTreeBillboardGeometry();
	void BuildCylinderWithoutTopGeometry();
	void BuildBrickWallGeometry();

	void BuildRenderItems();
	void BuildRenderItems_Common(UINT& InstanceBufferIndex);
	void BuildRenderItems_InMirror(UINT& InstanceBufferIndex);
	void BuildRenderItems_Gizmo(UINT& InstanceBufferIndex);
	void BuildRenderItems_SkinnedModel(UINT& IinstanceBufferIndex);
	void BuildFrameResources();
	void BuildPSOs();

	bool InitImGui();
	void RenderImGui();
	void ResolveMsaaToBackBuffer();

	void DrawDebugColorTriangle(ID3D12GraphicsCommandList* cmdList);

	//for gizmo
	void SelectRenderItemByMouseClick(int sx, int sy);
	void ClearSelectedInstance();
	void BuildWorldRayFromScreen(int sx, int sy, DirectX::XMVECTOR& rayOriginW, DirectX::XMVECTOR& rayDirW) const;
	DirectX::XMVECTOR BuildDragPlaneNormal(DirectX::XMVECTOR axisW, DirectX::XMVECTOR cameraForwardW) const;
	DirectX::XMVECTOR MakePlaneFromPointNormal(DirectX::XMVECTOR pointW, DirectX::XMVECTOR normalW) const;
	bool IntersectRayPlane(DirectX::XMVECTOR rayOriginW, DirectX::XMVECTOR rayDirW, DirectX::XMVECTOR plane, DirectX::XMVECTOR& hitPointW) const;
	bool BeginGizmoDrag(int sx, int sy);
	void UpdateGizmoDrag(int sx, int sy);
	void EndGizmoDrag();
	DirectX::XMVECTOR GetGizmoAxisVector(GizmoAxis axis) const;
	void SetSelectedObjectPositionW(const DirectX::XMFLOAT3& posW);
	InstanceData* GetPrimarySelectedInstance();
	float CalcGizmoAxisLength(const DirectX::XMFLOAT3& pivotW) const;
	GizmoAxis PickGizmoAxis(int sx, int sy);	

	DirectX::XMVECTOR GetMirrorPlane();

	void OnKeyboardInput(const GameTimer& gt);
	[[deprecated("ObjectCB is Closed.")]]
	void UpdateObjectCBs(const GameTimer& gt);
	void UpdateSkinnedCBs(const GameTimer& gt);
	void UpdateMainPassCB(const GameTimer& gt);
	void UpdateReflectedPassCB(const GameTimer& gt);
	void UpdateInstanceBuffer(const GameTimer& gt);
	void UpdateMaterialBuffer(const GameTimer& gt);
	void UpdateWavesGPU(const GameTimer& gt);
	void UpdateShadowTransform();
	void UpdateGizmo();
	void AnimateMaterials(const GameTimer& gt);

	void DrawRenderItems(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers);
	void DrawSelectedInstance(ID3D12GraphicsCommandList* cmdList);
	void DrawRenderItems_VertexNormalDebug(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers);

	std::array<const CD3DX12_STATIC_SAMPLER_DESC, 7> GetStaticSamplers();
	MeshData LoadModelFromFile(const std::wstring& path);

	float GetHillsHeight(float x, float z) const;
	DirectX::XMFLOAT3 GetHillsNormal(float x, float z) const;

	CD3DX12_GPU_DESCRIPTOR_HANDLE CurrentBackBufferSRV() const;

private:
	std::vector<std::unique_ptr<FrameResource>> mFrameResources;
	FrameResource* mCurrFrameResource = nullptr;
	int mCurrFrameResourceIndex = 0;

	std::unordered_map<std::string, Microsoft::WRL::ComPtr<ID3DBlob>> mShaders;
	std::unordered_map<std::string, Microsoft::WRL::ComPtr<ID3D12PipelineState>> mPSOs;
	std::unordered_map<std::string, std::unique_ptr<MeshGeometry>> mGeometries;
	std::unordered_map<std::string, std::unique_ptr<Material>> mMaterials;
	std::unordered_map<std::string, std::unique_ptr<Texture>> mTextures;

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
	std::unique_ptr<TextureLoader_Blocking> mTexLoader;
	std::unique_ptr<BlurFilter> mBlurFilter;
	std::unique_ptr<SobelFilter> mSobelFilter;

	RenderItem* mMirror = nullptr;
	std::vector<RenderItem*> excludeRI_InMirror;
	RenderItem* mSkull = nullptr;
	RenderItem* mSkullMirror = nullptr;
	RenderItem* mSkullShadow = nullptr;
	RenderItem* mSkullShadowMirror = nullptr;

	std::vector<SelectedInstance> mSelectedInstances;

	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature_debug = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mWavesRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mPostProcessRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mSrvHeap = nullptr;

	float mSunTheta = 1.25f * DirectX::XM_PI;
	float mSunPhi = DirectX::XM_PIDIV4;

	bool mIsWireframe = false;
	bool mIsDepthComplexityDebug = false;
	bool mIsVertexNormalDebug = false;
	bool mFrustumCullingEnabled = true;

	UINT mInstanceCount = 0;
	UINT mVisibleInstanceCount = 0;
	DirectX::BoundingFrustum mCamFrustum;

	Camera mCamera;

	POINT mLastMousePos = {};

	bool mIsShowHelper = false;
	bool mImGuiInitialized = false;

	bool is_Blur = false;
	UINT mBlurCount = 1;

	bool is_Sobel = false;

	double mFullGpuMs = 0.0;
	double mSceneGpuMs = 0.0;

	RenderItem* mGizmoRI = nullptr;
	GizmoState mGizmo;

	UINT mSkinnedSrvHeapStart = 0;
	std::unique_ptr<SkinnedModelInstance> mSkinnedModelInstance;
	SkinnedData mSkinnedInfo;
	std::vector<M3DLoader::Subset> mSkinnedSubsets;
	std::vector<M3DLoader::M3dMaterial> mSkinnedMats;
	std::vector<std::string> mSkinnedTextureNames;
	std::vector<std::string> mSkinnedNormalTextureNames;
};