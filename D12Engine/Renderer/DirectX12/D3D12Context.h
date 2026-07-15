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
    // RTV 0 ~ SwapChainBufferCount - 1은 스왑 체인 백 버퍼용으로 예약.
    UINT RtvHeapCapacity = RenderConfig::SwapChainBufferCount + 32;
    UINT DsvHeapCapacity = 16;
    UINT CbvSrvUavHeapCapacity = 256;

    DXGI_FORMAT RenderTargetFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
    DXGI_FORMAT DepthStencilFormat = DXGI_FORMAT_D24_UNORM_S8_UINT;

    bool EnableVSync = true;
    bool EnableTearing = true;

    std::array<float, 4> BackBufferClearColor = { 0.45f, 0.55f, 0.60f, 1.0f };
};

/*
    [실행 / 제어 관련 객체]
    |
    ├─ Command Allocator
    │  └─ Command List가 기록한 GPU 명령 스트림 저장소
    │     CPU가 기록하고 GPU/드라이버가 실행 시 읽는다.
    │     ID3D12Resource가 아니며 실제 물리 위치는 드라이버/하드웨어 구현 의존.
    │
    ├─ Command List
    │  └─ GPU 명령을 기록하는 인터페이스
    │     Command Allocator를 backing storage로 사용
    │
    ├─ Descriptor Heap
    │  └─ CBV/SRV/UAV/RTV/DSV/Sampler descriptor 배열
    │     리소스 데이터 자체가 아니라 리소스를 어떻게 접근할지에 대한 View 정보 저장.
    │     Shader-visible heap은 CPU가 작성하고 GPU가 읽을 수 있는 descriptor storage.
    │     실제 물리 위치는 드라이버/하드웨어 구현 의존.
    │
    └─ Root Signature / PSO / 기타 객체
       └─ 드라이버가 내부 표현으로 관리
*/
class D3D12Context
{
public:
    D3D12Context();
    ~D3D12Context();
    D3D12Context(const D3D12Context&) = delete;
    D3D12Context& operator=(const D3D12Context&) = delete;

    bool Initialize(HWND hwnd, int width, int height, D3D12ContextDesc desc = {});
    void Shutdown();

    void ResizeSwapChain(int width, int height);

    void BeginFrame();
    void EndFrame();

    void FlushCommandQueue();

    D3D12DescriptorHandle AllocateRtvDescriptor();
    D3D12DescriptorHandle AllocateDsvDescriptor();
    D3D12DescriptorHandle AllocateSrvDescriptor();

    void FreeRtvDescriptor(D3D12DescriptorHandle handle);
    void FreeDsvDescriptor(D3D12DescriptorHandle handle);
    void FreeSrvDescriptor(D3D12DescriptorHandle handle);

    // 콜백 호환 디스크립터 할당 헬퍼.
    // raw CPU/GPU 디스크립터 핸들이 필요한 외부 시스템에서 사용됨.
    // ImGui, GpuWaves에서 사용
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

    DXGI_FORMAT GetBackBufferFormat() const { return mDesc.RenderTargetFormat; }
    DXGI_FORMAT GetDepthStencilFormat() const { return mDesc.DepthStencilFormat; }

    const D3D12_VIEWPORT& GetScreenViewport() const { return mScreenViewport; }
    const D3D12_RECT& GetScissorRect() const { return mScissorRect; }

    D3D12_CPU_DESCRIPTOR_HANDLE GetCurrentBackBufferRTV() const;
    const UINT GetCurrentBackBufferIndex() const noexcept { return mCurrentBackBufferIndex; }
    const UINT GetCurrentFrameIndex() const noexcept { return mFrameIndex; }

    void BeginBackBufferRenderPass(const float clearColor[4]);

private:
    void CreateDevice();
    void CreateDescriptorHeaps();
    void CreateCommandObjects();
    void CreateSwapChain();
    void CreateBackBufferRTVs();

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

public:
    MsaaOption mMsaaOption{ 2 };

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

    D3D12_VIEWPORT mScreenViewport{};
    D3D12_RECT mScissorRect{};
};