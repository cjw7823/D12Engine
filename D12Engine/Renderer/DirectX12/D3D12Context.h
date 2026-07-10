#pragma once

#if defined(DEBUG) || defined(_DEBUG)
#define DX12_ENABLE_DEBUG_LAYER
#endif

#include "D3D12Util.h"

#include <memory>
#include <vector>
#include <array>
#include <dxgi1_5.h>				//For DXGI Interfaces

#include "EngineCore/RenderConfig.h"
#include "EngineCore/WinHandle.h"
#include "EngineCore/MsaaOption.h"

struct ImDrawData;

struct D3D12FrameContext
{
   Microsoft::WRL::ComPtr<ID3D12CommandAllocator> CommandAllocator;
    UINT64 FenceValue = 0;
};

struct D3D12DescriptorHandle
{
    D3D12_CPU_DESCRIPTOR_HANDLE Cpu{};
    D3D12_GPU_DESCRIPTOR_HANDLE Gpu{};
    UINT Index = UINT_MAX;

    bool IsValid() const { return Index != UINT_MAX; }
};

struct D3D12ContextDesc
{
    // RTV 0 ~ SwapChainBufferCount - 1 are reserved for swap-chain back buffers.
    // Scene View render targets, picking buffers, debug render targets, etc. use the remaining RTV slots.
    UINT RtvDescriptorCount = RenderConfig::SwapChainBufferCount + 32;
    UINT DsvDescriptorCount = 16;
    UINT CbvSrvUavDescriptorMaxCount = 256;

    DXGI_FORMAT BackBufferFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
    DXGI_FORMAT DepthStencilFormat = DXGI_FORMAT_D24_UNORM_S8_UINT;

    bool EnableVSync = true;
    bool EnableTearing = true;

    std::array<float, 4> BackBufferClearColor = { 0.45f, 0.55f, 0.60f, 1.00f };
};

class D3D12Context
{
public:
    D3D12Context();
    ~D3D12Context();
    D3D12Context(const D3D12Context&) = delete;
    D3D12Context& operator=(const D3D12Context&) = delete;

    bool Initialize(HWND hwnd, int width, int height, const D3D12ContextDesc& desc = {});
    void Shutdown();

    void ResizeSwapChain(int width, int height);

    void BeginFrame();
    void RenderImGuiDrawData(ImDrawData* drawData);
    void EndFrame();

    void FlushCommandQueue();

    D3D12DescriptorHandle AllocateRtvDescriptor();
    D3D12DescriptorHandle AllocateDsvDescriptor();
    D3D12DescriptorHandle AllocateSrvDescriptor();

    void FreeRtvDescriptor(D3D12DescriptorHandle handle);
    void FreeDsvDescriptor(D3D12DescriptorHandle handle);
    void FreeSrvDescriptor(D3D12DescriptorHandle handle);

    // For ImGui_ImplDX12_InitInfo callback form.
    void AllocateSrvDescriptor(
        D3D12_CPU_DESCRIPTOR_HANDLE* outCpuHandle,
        D3D12_GPU_DESCRIPTOR_HANDLE* outGpuHandle);
    void FreeSrvDescriptor(
        D3D12_CPU_DESCRIPTOR_HANDLE cpuHandle,
        D3D12_GPU_DESCRIPTOR_HANDLE gpuHandle);

    ID3D12Device* GetDevice() const { return md3dDevice.Get(); }
    ID3D12CommandQueue* GetCommandQueue() const { return mCommandQueue.Get(); }
    ID3D12GraphicsCommandList* GetCommandList() const { return mCommandList.Get(); }

    ID3D12DescriptorHeap* GetRtvHeap() const { return mRtvHeap.Get(); }
    ID3D12DescriptorHeap* GetDsvHeap() const { return mDsvHeap.Get(); }
    ID3D12DescriptorHeap* GetSrvHeap() const { return mSrvHeap.Get(); }

    UINT GetRtvDescriptorSize() const { return mRtvDescriptorSize; }
    UINT GetDsvDescriptorSize() const { return mDsvDescriptorSize; }
    UINT GetCbvSrvUavDescriptorSize() const { return mCbvSrvUavDescriptorSize; }

    DXGI_FORMAT GetBackBufferFormat() const { return mDesc.BackBufferFormat; }
    DXGI_FORMAT GetDepthStencilFormat() const { return mDesc.DepthStencilFormat; }

    const D3D12_VIEWPORT& GetScreenViewport() const { return mScreenViewport; }
    const D3D12_RECT& GetScissorRect() const { return mScissorRect; }

    D3D12_CPU_DESCRIPTOR_HANDLE GetCurrentBackBufferRTV() const;
    UINT GetCurrentBackBufferIndex() const { return mCurrentBackBufferIndex; }

private:
    void CreateDevice();
    void CreateDescriptorHeaps();
    void CreateCommandObjects();
    void CreateSwapChain();
    void CreateBackBufferRTVs();

    void BeginBackBufferRenderPass(const float clearColor[4]);

    D3D12FrameContext* WaitForNextFrameContext();

    void LogAdapters();
    void LogAdapterOutputs(IDXGIAdapter* adapter);
    void LogOutputDisplayModes(IDXGIOutput* output, DXGI_FORMAT format);

    D3D12DescriptorHandle AllocateCpuDescriptor(
        ID3D12DescriptorHeap* heap,
        std::vector<UINT>& freeIndices,
        UINT descriptorSize,
        bool shaderVisible);

    void FreeCpuDescriptor(
        D3D12DescriptorHandle handle,
        std::vector<UINT>& freeIndices,
        UINT descriptorCount);

    UINT GetSrvDescriptorIndex(D3D12_CPU_DESCRIPTOR_HANDLE cpuHandle) const;

private:
    HWND mhWnd = nullptr;
    int mClientWidth = 1;
    int mClientHeight = 1;

    D3D12ContextDesc mDesc{};

    Microsoft::WRL::ComPtr<IDXGIFactory5> mdxgiFactory;
    Microsoft::WRL::ComPtr<ID3D12Device> md3dDevice;
    Microsoft::WRL::ComPtr<IDXGISwapChain3> mSwapChain;
    Microsoft::WRL::ComPtr<ID3D12Fence> mFence;

    Microsoft::WRL::ComPtr<ID3D12CommandQueue> mCommandQueue;
    Microsoft::WRL::ComPtr<ID3D12GraphicsCommandList> mCommandList;

    Microsoft::WRL::ComPtr<ID3D12Resource> mSwapChainBuffer[RenderConfig::SwapChainBufferCount];
    Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mRtvHeap;
    Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mDsvHeap;
    Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mSrvHeap;

    std::vector<std::unique_ptr<D3D12FrameContext>> mFrameContexts;
    D3D12FrameContext* mCurrentFrameContext = nullptr;

    WinHandle mFenceEvent;
    UINT64 mCurrentFence = 0;

    UINT mRtvDescriptorSize = 0;
    UINT mDsvDescriptorSize = 0;
    UINT mCbvSrvUavDescriptorSize = 0;

    UINT mFrameIndex = 0;
    UINT mCurrentBackBufferIndex = 0;
    
    bool mTearingSupported = false;
    bool mSwapChainOccluded = false;
    bool mFrameStarted = false;
    bool mBackBufferInRenderTargetState = false;

    HANDLE mSwapChainWaitableObject = nullptr;

    std::vector<UINT> mRtvFreeIndices;
    std::vector<UINT> mDsvFreeIndices;
    std::vector<UINT> mSrvFreeIndices;

    D3D12_VIEWPORT mScreenViewport = {};
    D3D12_RECT mScissorRect = {};

    MsaaOption mMsaaOption{ 2 };
};