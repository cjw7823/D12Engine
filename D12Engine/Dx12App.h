#pragma once

#ifndef NOMINMAX
#define NOMINMAX
#endif

#include <Windows.h>

#include <array>
#include <string>
#include <utility>
#include <vector>

#include <dxgi1_4.h>
#include <wrl/client.h>

#include "EngineCore/GameTimer.h"
#include "EngineCore/WinHandle.h"
#include "EngineCore/MsaaOption.h"
#include "EngineCore/RenderConfig.h"

class Dx12App
{
protected:
	Dx12App(HINSTANCE hInstance);
	Dx12App(const Dx12App& rhs) = delete;
	Dx12App& operator=(const Dx12App& rhs) = delete;
	virtual ~Dx12App();

public:
	static Dx12App* GetApp() { return mApp; }
	int Run();
	virtual bool Initialize();
	virtual LRESULT MsgProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
	
	virtual void NextMsaaOoption();
	virtual void SetMsaaOption(UINT value);
	float AspectRatio() const;

protected:
	virtual void OnResize();
	virtual void Update(const GameTimer& gt) = 0;
	virtual void Draw(const GameTimer& gt) = 0;
	virtual void CreateRtvDsvDescriptorHeaps();

	virtual void OnMouseDown(WPARAM btnState, int x, int y) {}
	virtual void OnMouseUp(WPARAM btnState, int x, int y) {}
	virtual void OnMouseMove(WPARAM btnState, int x, int y) {}
	virtual void OnMouseWheel(short zDelta, int x, int y) {}
	virtual void OnKeyDown(WPARAM key) {}
	virtual void OnKeyUp(WPARAM key) {}

	bool InitMainWindow();
	bool InitDirect3D();
	void CreateCommandObjects();
	void CreateSwapChain();
	void FlushCommandQueue();

	void CreateQueryHeap();
	virtual void ReadbackTimestampData(int frameResourceIndex) {};

	void CalculateFrameStats();

	void LogAdapters();
	void LogAdapterOutputs(IDXGIAdapter* adapter);
	void LogOutputDisplayModes(IDXGIOutput* output, DXGI_FORMAT format);

	ID3D12Resource* CurrentBackBuffer() const;
	D3D12_CPU_DESCRIPTOR_HANDLE CurrentBackBufferView() const;
	D3D12_CPU_DESCRIPTOR_HANDLE DepthStencilView() const;
	D3D12_CPU_DESCRIPTOR_HANDLE MsaaRenderTargetView() const;

protected:
	inline static Dx12App* mApp = nullptr;

	HINSTANCE mhInstance = nullptr;
	HWND mhMainWnd = nullptr;
	bool mAppPaused = false;
	bool mMinimized = false;
	bool mMaximized = false;
	bool mResizing = false;
	GameTimer mTimer;

	MsaaOption mMsaaOption{ 2 };

	Microsoft::WRL::ComPtr<IDXGIFactory4> mdxgiFactory;
	Microsoft::WRL::ComPtr<ID3D12Device> md3dDevice;
	Microsoft::WRL::ComPtr<IDXGISwapChain> mSwapChain;
	Microsoft::WRL::ComPtr<ID3D12Fence> mFence;

	Microsoft::WRL::ComPtr<ID3D12CommandQueue> mCommandQueue;
	Microsoft::WRL::ComPtr<ID3D12CommandAllocator> mCommandAlloc;
	Microsoft::WRL::ComPtr<ID3D12GraphicsCommandList> mCommandList;

	Microsoft::WRL::ComPtr<ID3D12Resource> mSwapChainBuffer[RenderConfig::SwapChainBufferCount];
	Microsoft::WRL::ComPtr<ID3D12Resource> mDepthStencilBuffer;
	Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mRtvHeap;
	Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mDsvHeap;
	Microsoft::WRL::ComPtr<ID3D12Resource> mMsaaRenderTarget;

	//GPU Timestamp¸¦ À§ÇÑ qury heap
	Microsoft::WRL::ComPtr<ID3D12QueryHeap> mTimestampQueryHeap = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> mTimestampReadbackBuffer = nullptr;
	UINT64 mGpuTimestampFrequency = 0;

	D3D12_VIEWPORT mScreenViewport = {};
	D3D12_RECT mScissorRect = {};

	int mCurrBackBuffer = 0;
	WinHandle mFenceEvent;
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