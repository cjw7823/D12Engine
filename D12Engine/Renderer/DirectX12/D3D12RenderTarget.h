#pragma once

#include <wrl.h>
#include "DirectX-Headers\d3dx12.h"
#include "D3D12Context.h"

class D3D12RenderTarget
{
public:
    D3D12RenderTarget() = default;
    D3D12RenderTarget(const D3D12RenderTarget&) = delete;
    D3D12RenderTarget& operator=(const D3D12RenderTarget&) = delete;

    void Create(D3D12Context& context, DXGI_FORMAT colorFormat, DXGI_FORMAT depthFormat);
    void Resize(D3D12Context& context, int width, int height);
    void Shutdown(D3D12Context& context);
    void Clear(D3D12Context& context, const float clearColor[4] = mClearColor);
    void TransitionIfNeeded(ID3D12GraphicsCommandList* cmdList, ID3D12Resource* resource, D3D12_RESOURCE_STATES& currState, D3D12_RESOURCE_STATES newState);
    void ResolveMsaaToColorBuffer(ID3D12GraphicsCommandList* commandList);
    void PrepareForSampling(ID3D12GraphicsCommandList* commandList);

    bool IsValid() const { return mColorBuffer != nullptr; }

    int GetWidth() const noexcept { return mWidth; }
    int GetHeight() const noexcept { return mHeight; }
    D3D12_CPU_DESCRIPTOR_HANDLE GetRTV() const noexcept { return mRtv.Cpu; }
    D3D12_CPU_DESCRIPTOR_HANDLE GetDSV() const noexcept { return mDsv.Cpu; }
    D3D12_GPU_DESCRIPTOR_HANDLE GetSRVGpu() const noexcept { return mSrv.Gpu; }
    DXGI_FORMAT GetColorFormat() const noexcept { return mColorFormat; }
    DXGI_FORMAT GetDepthFormat() const noexcept { return mDepthFormat; }
    const D3D12_VIEWPORT& GetViewport() const noexcept { return mViewport; }
    const D3D12_RECT& GetScissorRect() const noexcept { return mScissorRect; }
    ID3D12Resource* GetColorResource() const noexcept { return mColorBuffer.Get(); }
    ID3D12Resource* GetDepthResource() const noexcept { return mDepthBuffer.Get(); }
    D3D12_RESOURCE_STATES& GetColorState() { return mColorState; }

private:
    void CreateResources(D3D12Context& context);
    void CreateViews(D3D12Context& context);
    void CreateMsaaRenderTarget(D3D12Context& context);

private:
    int mWidth = 1;
    int mHeight = 1;

    DXGI_FORMAT mColorFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
    DXGI_FORMAT mDepthFormat = DXGI_FORMAT_D24_UNORM_S8_UINT;

    Microsoft::WRL::ComPtr<ID3D12Resource> mColorBuffer = nullptr;
    Microsoft::WRL::ComPtr<ID3D12Resource> mDepthBuffer = nullptr;
    Microsoft::WRL::ComPtr<ID3D12Resource> mMsaaRenderTarget = nullptr;

    D3D12DescriptorHandle mMsaaDescriptorHandle{};
    D3D12DescriptorHandle mRtv{};
    D3D12DescriptorHandle mDsv{};
    D3D12DescriptorHandle mSrv{};

    D3D12_RESOURCE_STATES mColorState = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;
    D3D12_RESOURCE_STATES mMsaaState = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;

    D3D12_VIEWPORT mViewport{};
    D3D12_RECT mScissorRect{};

    inline static const float mClearColor[4] = { 0.12f, 0.16f, 0.22f, 1.0f };
};