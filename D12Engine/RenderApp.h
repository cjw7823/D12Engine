#pragma once

#include "Dx12App.h"
#include "GameTimer.h"
#include "FrameResource.h"
#include "TextureLoader_Blocking.h"
#include "GpuWaves.h"
#include "RenderData.h"
#include <unordered_map>
#include "BlurFilter.h"
#include "SobelFilter.h"

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
	~RenderApp() override;

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
	void BuildRenderItems_InMirror(UINT& objCBIndex);
	void BuildFrameResources();
	void BuildPSOs();
	void SetDebugColorCB();

	bool InitImGui();
	void RenderImGui();
	void ResolveMsaaToBackBuffer();

	void DrawDebugColorTriangle(ID3D12GraphicsCommandList* cmdList);

	DirectX::XMVECTOR GetMirrorPlane();

	void OnKeyboardInput(const GameTimer& gt);
	void UpdateCamera(const GameTimer& gt);
	void UpdateObjectCBs(const GameTimer& gt);
	void UpdateMainPassCB(const GameTimer& gt);
	void UpdateReflectedPassCB(const GameTimer& gt);
	void UpdateMaterialCBs(const GameTimer& gt);
	void UpdateWavesGPU(const GameTimer& gt);
	void UpdateShadowTransform();
	void AnimateMaterials(const GameTimer& gt);
	void DrawRenderItems(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers);
	void DrawRenderItems_VertexNormalDebug(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers);

	std::array<const CD3DX12_STATIC_SAMPLER_DESC, 7> GetStaticSamplers();
	MeshData LoadModelFromFile(const std::wstring& path);

	float GetHillsHeight(float x, float z) const;
	DirectX::XMFLOAT3 GetHillsNormal(float x, float z) const;

private:
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

	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature_debug = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mWavesRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mPostProcessRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mSrvHeap = nullptr;

	DirectX::XMFLOAT4X4 mView = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 mProj = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 mCamPos = MathHelper::Identity4x4();
	DirectX::XMFLOAT3 mEyePos = { 0.0f, 0.0f, 0.0f };

	float mTheta = 1.55f * DirectX::XM_PI;
	float mPhi = DirectX::XM_PIDIV4;
	float mRadius = 50.0f;

	float mSunTheta = 1.25f * DirectX::XM_PI;
	float mSunPhi = DirectX::XM_PIDIV4;

	bool mIsWireframe = false;
	bool mIsDepthComplexityDebug = false;
	bool mIsVertexNormalDebug = false;
	bool isMoving = false;

	/*
		1 : w
		2 : s
		3 : a
		4 : d
	*/
	int md = 0;

	POINT mLastMousePos = {};

	bool mIsShowHelper = false;
	bool mImGuiInitialized = false;

	bool is_Blur = false;
	UINT mBlurCount = 1;

	bool is_Sobel = false;
};