#include "InitD3DApp.h"
#include "../SampleSrc/MathHelper.h"
#include "../SampleSrc/UploadBuffer.h"

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

//struct Vertex
//{
//	DirectX::XMFLOAT3 Pos;
//	DirectX::XMFLOAT4 Color;
//};

struct Vertex1
{
	DirectX::XMFLOAT3 Pos;
};

struct Vertex2
{
	DirectX::XMFLOAT4 Color;
};

struct ObjectConstants
{
	DirectX::XMFLOAT4X4 WorldViewProj = MathHelper::Identity4x4();
};

class AppD3D : public InitD3DApp
{
public:
	AppD3D(HINSTANCE hInstance) : InitD3DApp(hInstance) {};
	~AppD3D() {};

	virtual bool Initialize() override;

private:
	virtual void OnResize() override;
	virtual void Update(const GameTimer& gt) override;
	virtual void Draw(const GameTimer& gt) override;

	void BuildDescriptorHeaps();
	void BuildConstantBuffers();
	void BuildRootSignature();
	void BuildShadersAndInputLayout();
	void BuildBoxGeometry();
	void BuildPSO();

	virtual void OnMouseDown(WPARAM btnState, int x, int y) override;
	virtual void OnMouseUp(WPARAM btnState, int x, int y) override;
	virtual void OnMouseMove(WPARAM btnState, int x, int y) override;
private:
	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mCbvHeap;
	
	std::unique_ptr<UploadBuffer<ObjectConstants>> mObjectCB = nullptr;
	std::unique_ptr<MeshGeometry> mBoxGeo = nullptr;

	Microsoft::WRL::ComPtr<ID3DBlob> mvsByteCode = nullptr;
	Microsoft::WRL::ComPtr<ID3DBlob> mpsByteCode = nullptr;

	std::vector<D3D12_INPUT_ELEMENT_DESC> mInputLayout;

	Microsoft::WRL::ComPtr<ID3D12PipelineState> mPSO = nullptr;

	DirectX::XMFLOAT4X4 mWorld = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 mView = MathHelper::Identity4x4();
	DirectX::XMFLOAT4X4 mProj = MathHelper::Identity4x4();

	float mTheta = 1.55f * DirectX::XM_PI;	//방위각
	float mPhi = DirectX::XM_PIDIV4;		//극각
	float mRadius = 5.0f;					//거리

	POINT mLastMousePos;
};