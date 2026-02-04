#pragma once

// 디버그 빌드에서만 C Runtime에 c/c++ 힙 할당을 추적 가능하게 만듦.
// 프로그램 종료 시 메모리 누수 보고서를 출력함.
#if defined(DEBUG) || defined(_DEBUG)
#define _CRTDBG_MAP_ALLOC
#include <crtdbg.h>
#endif

#include "d3dUtil.h"
#include "GameTimer.h"

//링커가 병합해서 무시하겠지만, 원칙상으로 .h에 두는 것은 중복 링크위험이 있다.
//추후 cpp로 이전.
#pragma comment (lib, "d3dcompiler.lib")
#pragma comment (lib, "d3d12.lib")
#pragma comment (lib, "dxgi.lib")
#pragma comment (lib, "dxguid.lib")	// 예제 코드엔 없지만 필수적으로 추가 해주어야 함. d3dx12.h가 변화되었음.

struct WinHandle
{
	HANDLE h = nullptr;
	WinHandle() = default;
	WinHandle(const WinHandle&) = delete;
	WinHandle& operator=(const WinHandle&) = delete;
	~WinHandle() { if (h) CloseHandle(h); }

	HANDLE Get() const { return h; }
};

class InitAppD3D
{
protected:
	InitAppD3D(HINSTANCE hInstance);
	InitAppD3D(const InitAppD3D& rhs) = delete;
	InitAppD3D& operator=(const InitAppD3D& rhs) = delete;
	virtual ~InitAppD3D();

public:
	static InitAppD3D* GetApp() { return mApp; };
	int Run();
	virtual bool Initialize();
	virtual LRESULT MsgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

	void Set4xMsaaState(bool value);
	float AspectRatio()const;

protected:
	virtual void OnResize();
	virtual void Update(const GameTimer& gt) = 0;
	virtual void Draw(const GameTimer& gt) = 0;
	virtual void CreateRtvDsvDescriptorHeaps();

	virtual void OnMouseDown(WPARAM btnState, int x, int y) {};
	virtual void OnMouseUp(WPARAM btnState, int x, int y) {};
	virtual void OnMouseMove(WPARAM btnState, int x, int y) {};
	virtual void OnMouseWheel(short zDelta, int x, int y) {};
	virtual void OnKeyDown(WPARAM key) {};
	virtual void OnKeyUp(WPARAM key) {};

	bool InitMainWindow();
	bool InitDirect3D();
	void CreateCommandObjects();
	void CreateSwapChain();
	void FlushCommandQueue();

	void CalculateFrameStats();

	void LogAdapters();
	void LogAdapterOutputs(IDXGIAdapter* adapter);
	void LogOutputDisplayModes(IDXGIOutput* output, DXGI_FORMAT format);

	ID3D12Resource* CurrentBackBuffer()const
	{
		return mSwapChainBuffer[mCurrBackBuffer].Get();
	}

	D3D12_CPU_DESCRIPTOR_HANDLE CurrentBackBufferView()const
	{
		// RTV 힙에는 SwapChainBufferCount 개의 RTV가 연속으로 배치되어 있다.
		// 힙의 시작 CPU 핸들을 기준으로
		// (현재 백버퍼 인덱스 × RTV 디스크립터 크기) 만큼 오프셋을 적용해
		// 현재 백버퍼에 대응하는 RTV CPU 디스크립터 핸들을 반환한다.
		return CD3DX12_CPU_DESCRIPTOR_HANDLE(mRtvHeap->GetCPUDescriptorHandleForHeapStart(),
			mCurrBackBuffer, mRtvDescriptorSize);
	}

	D3D12_CPU_DESCRIPTOR_HANDLE DepthStencilView()const
	{
		return mDsvHeap->GetCPUDescriptorHandleForHeapStart();
	}

protected:
	inline static InitAppD3D* mApp = nullptr;
	static const int SwapChainBufferCount = 2;
	
	HINSTANCE mhAppInst = nullptr;
	HWND mhMainWnd = nullptr;
	bool mAppPaused = false;
	bool mMinimized = false;
	bool mMaximized = false;
	bool mResizing = false;
	GameTimer mTimer;

	bool m4xMsaaState = false; //4x MSAA 활성화 여부
	UINT m4xMsaaQuality = 0; //지원되는 4x MSAA 품질 수준

	Microsoft::WRL::ComPtr<IDXGIFactory4> mdxgiFactory;
	Microsoft::WRL::ComPtr<ID3D12Device> md3dDevice;
	Microsoft::WRL::ComPtr<IDXGISwapChain> mSwapChain;
	Microsoft::WRL::ComPtr<ID3D12Fence> mFence;

	Microsoft::WRL::ComPtr<ID3D12CommandQueue> mCommandQueue;
	Microsoft::WRL::ComPtr<ID3D12CommandAllocator> mDirectCmdListAlloc;
	Microsoft::WRL::ComPtr<ID3D12GraphicsCommandList> mCommandList;

	Microsoft::WRL::ComPtr<ID3D12Resource> mSwapChainBuffer[SwapChainBufferCount];
	Microsoft::WRL::ComPtr<ID3D12Resource> mDepthStencilBuffer;
	Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mRtvHeap;
	Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mDsvHeap;

	D3D12_VIEWPORT mScreenViewport = {};
	D3D12_RECT mScissorRect = {};

	int mCurrBackBuffer = 0;
	WinHandle mFenceEvent;
	UINT64 mCurrentFence = 0;

	UINT mRtvDescriptorSize = 0;
	UINT mDsvDescriptorSize = 0;
	UINT mCbvSrvUavDescriptorSize = 0;

	std::wstring mMainWndCaption = L"copy code";
	DXGI_FORMAT mBackBufferFormat = DXGI_FORMAT_R8G8B8A8_UNORM; //Unsigned Normalized 8-bit RGBA format
	DXGI_FORMAT mDepthStencilFormat = DXGI_FORMAT_D24_UNORM_S8_UINT; //24-bit depth, 8-bit stencil format
	int mClientWidth = 800;
	int mClientHeight = 600;
};