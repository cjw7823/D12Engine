#pragma once

// 디버그 빌드에서만 C Runtime에 c/c++ 힙 할당을 추적 가능하게 만듦.
// 프로그램 종료 시 메모리 누수 보고서를 출력함.
#if defined(DEBUG) || defined(_DEBUG)
#define _CRTDBG_MAP_ALLOC
#include <crtdbg.h>
#endif

#include "../SampleSrc/d3dUtil.h"
#include "../SampleSrc/GameTimer.h"

#pragma comment(lib,"d3dcompiler.lib")
#pragma comment(lib, "D3D12.lib")
#pragma comment(lib, "dxgi.lib")

class InitD3DApp
{
protected:
	InitD3DApp(HINSTANCE hInstance);
	InitD3DApp(const InitD3DApp& rhs) = delete;
	InitD3DApp& operator=(const InitD3DApp& rhs) = delete;
	virtual ~InitD3DApp();

public:
	static InitD3DApp* GetApp() { return mApp; };
	int Run();
	virtual bool Initialize();
	virtual LRESULT MsgProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);

	void Set4xMsaaState(bool value);

protected:
	virtual void OnResize();
	virtual void Update(const GameTimer& gt)=0;
	virtual void Draw(const GameTimer& gt)=0;
	virtual void CreateRtvDsvDescriptorHeaps();

	virtual void OnMouseDown(WPARAM btnState, int x, int y) {}
	virtual void OnMouseUp(WPARAM btnState, int x, int y) {}
	virtual void OnMouseMove(WPARAM btnState, int x, int y) {}

	bool InitMainWindow();
	bool InitDirect3D();
	void CreateCommandObjects();
	void CreateSwapChain();
	void FlushCommandQueue();

	void CalculateFrameStats();

	void PrintAdapters();
	void LogAdapters();
	void LogAdapterOutputs(IDXGIAdapter* adapter);
	void LogOutputDisplayModes(IDXGIOutput* output, DXGI_FORMAT format);
protected:
	inline static InitD3DApp* mApp = nullptr;
	static const int SwapChainBufferCount = 2;

	HINSTANCE mhAppInst = nullptr;
	HWND      mhMainWnd = nullptr;
	bool	  mAppPaused = false;
	bool	  mMinimized = false;
	bool	  mMaximized = false;
	bool	  mResizing = false;
	GameTimer mTimer;

	UINT m4xMsaaQuality = 0;
	bool m4xMsaaState = false;

	Microsoft::WRL::ComPtr<IDXGIFactory4> mdxgiFactory;
	Microsoft::WRL::ComPtr<IDXGISwapChain> mSwapChain;
	Microsoft::WRL::ComPtr<ID3D12Device> md3dDevice;
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
	UINT64 mCurrentFence = 0;

	UINT mRtvDescriptorSize = 0;
	UINT mDsvDescriptorSize = 0;
	UINT mCbvSrvUavDescriptorSize = 0;

	std::wstring mMainWndCaption = L"Direct3D 12 App";
	DXGI_FORMAT mBackBufferFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
	DXGI_FORMAT mDepthStencilFormat = DXGI_FORMAT_D24_UNORM_S8_UINT;
	int mClientWidth = 800;
	int mClientHeight = 600;
};