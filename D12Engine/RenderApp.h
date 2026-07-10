#pragma once

#include <array>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

#include <DirectXCollision.h>
#include <DirectXMath.h>
#include <d3d12.h>
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

/*
	1. Resource Heap / Resource Memory
	├─ Default Heap
	│  └─ GPU가 빠르게 접근하는 리소스 저장소
	│     예: Texture, Vertex Buffer, Index Buffer, Render Target
	│
	├─ Upload Heap
	│  └─ CPU가 쓰고 GPU가 읽거나 복사 소스로 사용하는 리소스 저장소
	│     예: 업로드 버퍼, 동적 상수 버퍼
	│
	└─ Readback Heap
	   └─ GPU 결과를 CPU가 읽기 위한 리소스 저장소

	2. 실행 / 제어 관련 객체
	├─ Command Allocator
	│  └─ Command List가 기록한 GPU 명령의 실제 저장 공간
	│     CPU가 명령을 기록하고, GPU/드라이버가 나중에 소비한다.
	│     ID3D12Resource가 아니며 실제 물리 위치는 드라이버/하드웨어 구현 의존.
	│
	├─ Command List
	│  └─ GPU 명령을 기록하는 인터페이스
	│     자체가 대량의 명령 데이터를 소유한다기보다 Command Allocator를 backing storage로 사용한다.
	│
	├─ Descriptor Heap
	│  └─ CBV/SRV/UAV/RTV/DSV/Sampler descriptor 배열
	│     리소스 데이터 자체가 아니라 리소스를 어떻게 접근할지에 대한 View 정보 저장.
	│     Shader-visible heap은 CPU가 작성하고 GPU가 읽을 수 있는 descriptor storage.
	│     실제 물리 위치는 드라이버/하드웨어 구현 의존.
	│
	├─ Root Signature
	│  └─ 셰이더 리소스 바인딩 구조 정의
	│
	└─ PSO
	   └─ 셰이더 및 고정 파이프라인 상태 묶음

	물리 메모리 관점 요약
	├─ Default / Upload / Readback Heap
	│  └─ D3D12_HEAP_TYPE으로 성격이 비교적 명확함
	│
	├─ Command Allocator
	│  └─ GPU 명령 스트림 저장소.
	│     CPU가 기록하고 GPU/드라이버가 실행 시 읽는다.
	│     실제 위치는 구현 의존이며, 프로그래머가 heap type으로 지정하지 않는다.
	│
	├─ Descriptor Heap
	│  └─ descriptor 저장소.
	│     Shader-visible이면 GPU가 descriptor table을 통해 읽을 수 있다.
	│     실제 위치는 구현 의존.
	│
	└─ Root Signature / PSO / 기타 객체
	   └─ 드라이버가 내부 표현으로 관리
*/
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