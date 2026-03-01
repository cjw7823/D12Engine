#pragma once

#include "InitAppD3D.h"
#include "MathHelper.h"
#include "UploadBuffer.h"
#include "FrameResource.h"
#include "RenderItem.h"
#include "GeometryGenerator.h"
#include "Waves.h"

/*
	GPU 관련 메모리 (개념적 분류)
	├─ A. 리소스 데이터 메모리 (Heap + Resource)
	│  ├─ Default Heap   (보통 VRAM, GPU 최적)
	│  ├─ Upload Heap    (시스템 RAM, CPU→GPU, GPU-visible)
	│  └─ Readback Heap  (시스템 RAM, GPU→CPU, GPU-visible)
	│
	└─ B. 실행 / 제어 메모리 (비-Resource)
	   ├─ Command Allocator (GPU 명령 스트림, 시스템 RAM, GPU-visible)
	   ├─ Command List (명령 기록 인터페이스, 메모리 실체 없음)
	   ├─ PSO / Root Signature (GPU/드라이버 내부 상태 객체)
	   └─ Descriptor Heap (디스크립터 테이블, 시스템 RAM, GPU-visible)

	물리 메모리 관점
	├─ VRAM (GPU 전용 물리 메모리)
	│  ├─ Default Heap 리소스
	│  ├─ GPU 캐시 / 일부 PSO 내부 표현 (드라이버 판단)
	│
	├─ 시스템 RAM
	│  ├─ Upload Heap (GPU-visible)
	│  ├─ Readback Heap (GPU-visible)
	│  ├─ Command Allocator (GPU-visible)
	│  ├─ Descriptor Heap (GPU-visible)
	│  └─ 드라이버 관리 객체(PSO, RootSig 등 — 위치는 드라이버가 결정)
	│
	└─ 일반 CPU 메모리
	   └─ GPU 접근 불가
*/

inline const int gNumFrameResources = 3;

class AppD3D : public InitAppD3D
{
public:
	AppD3D(HINSTANCE hInstance) : InitAppD3D(hInstance) {};
	AppD3D(const AppD3D& rhs) = delete;
	AppD3D& operator=(const AppD3D& rhs) = delete;
	~AppD3D() override;

	virtual bool Initialize() override;

private:
	virtual void OnResize() override;
	virtual void Update(const GameTimer& gt) override;
	virtual void Draw(const GameTimer& gt) override;

	void BuildDescriptorHeaps();
	void BuildRootsignature();
	void BuildShadersAndInputLayout();
	void BuildShapeGeometry();
	void BuildLandGeometry();
	void BuildWavesGeometryBuffers();
	void BuildPSO();
	void BuildRenderItems();
	void BuildFrameResources();
	void BuildConstantsBufferView();
	void BuildMaterials();
	void DrawRenderItems(ID3D12GraphicsCommandList* cmdList, const std::vector<const RenderItem*>* allRenderItem);
	void LoadTextures();

	GeometryGenerator::MeshData LoadModelFile(const std::wstring& path);

	virtual void OnMouseDown(WPARAM btnState, int x, int y) override;
	virtual void OnMouseUp(WPARAM btnState, int x, int y) override;
	virtual void OnMouseMove(WPARAM btnState, int x, int y) override;
	virtual void OnMouseWheel(short zDelta, int x, int y) override;
	virtual void OnKeyUp(WPARAM key) override;
	virtual void OnKeyDown(WPARAM key) override;

	void OnKeyboardInput(const GameTimer& gt);
	void UpdateCamera(const GameTimer& gt);
	void UpdateObjectCBs(const GameTimer& gt);
	void UpdateMainPassCB(const GameTimer& gt);
	void UpdateWaves(const GameTimer& gt);
	void UpdateMaterialCBs(const GameTimer& gt);
	void AnimateMaterials(const GameTimer& gt);

	inline float GetHillsHeight(float x, float z)const
	{
		return 0.3 * (z * sinf(0.05f * x) + x * cosf(0.1f * z));
	}

	inline DirectX::XMFLOAT3 GetHillsNormal(float x, float z)const
	{
		// n = (-df/dx, 1, -df/dz)
		DirectX::XMFLOAT3 n(
			-0.03f * z * cosf(0.1f * x) - 0.3f * cosf(0.1f * z),
			1.0f,
			-0.3f * sinf(0.1f * x) + 0.03f * x * sinf(0.1f * z));

		DirectX::XMVECTOR unitNormal = DirectX::XMVector3Normalize(DirectX::XMLoadFloat3(&n));
		DirectX::XMStoreFloat3(&n, unitNormal);

		return n;
	}

	std::array<const CD3DX12_STATIC_SAMPLER_DESC, 7> GetStaticSamplers();

private:
	std::vector<std::unique_ptr<FrameResource>> mFrameResources;
	FrameResource* mCurrFrameResource = nullptr;
	int mCurrFrameResourceIndex = 0;

	std::unordered_map<std::string, Microsoft::WRL::ComPtr<ID3DBlob>> mShaders;
	std::unordered_map<std::string, std::unique_ptr<MeshGeometry>> mGeometries;
	std::unordered_map<std::string, Microsoft::WRL::ComPtr<ID3D12PipelineState>> mPSOs;
	std::unordered_map<std::string, std::unique_ptr<Material>> mMaterials;
	std::unordered_map<std::string, std::unique_ptr<Texture>> mTextures;

	std::vector<std::unique_ptr<RenderItem>> mAllRenderItems;
	//Observer pointer 이므로 const강제.
	//렌더 아이템을 유형별로 보관.
	std::vector<const RenderItem*> mRenderItemLayer[(int)RenderLayer::Count];

	//추후 동적 메시 일반화 수정 필요.
	std::unique_ptr<Waves> mWaves;
	RenderItem* mWavesRenderItem = nullptr;

	UINT mPassCbvOffset = 0;
	PassConstants mMainPassCB;

	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mCbvHeap;
	Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mSrvHeap;

	std::vector<D3D12_INPUT_ELEMENT_DESC> mInputLayout;

	DirectX::XMFLOAT4X4 mView= MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 mProj = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 mCamPos = MathHelper::Identity4x4();
	DirectX::XMFLOAT3 mEyePos = { 0.f,0.f,0.f };

	float mTheta = 1.55f * DirectX::XM_PI;
	float mPhi = DirectX::XM_PIDIV4;
	float mRadius = 50.0f;

	float mSunTheta = 1.25f * DirectX::XM_PI;
	float mSunPhi = DirectX::XM_PIDIV4;

	bool mIsWireframe = false;
	bool isMoving = false;
	/*
		1 : w
		2 : s
		3 : a
		4 : d
	*/
	int md = 0;

	POINT mLastMousePos = {};
};

