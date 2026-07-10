#pragma once

#include <wrl.h>
#include <d3d12.h>
#include "D3D12Context.h"

class D3D12RenderTarget
{
public:
    D3D12RenderTarget() = default;
    D3D12RenderTarget(const D3D12RenderTarget&) = delete;
    D3D12RenderTarget& operator=(const D3D12RenderTarget&) = delete;

    void Create(
        D3D12Context& context,
        int width,
        int height,
        DXGI_FORMAT colorFormat,
        DXGI_FORMAT depthFormat);

    void Resize(
        D3D12Context& context,
        int width,
        int height);

    void Shutdown(D3D12Context& context);

    void Clear(
        D3D12Context& context,
        const float clearColor[4]);

    bool IsValid() const { return mColorBuffer != nullptr; }

    int GetWidth() const { return mWidth; }
    int GetHeight() const { return mHeight; }

    D3D12_CPU_DESCRIPTOR_HANDLE GetRTV() const { return mRtv.Cpu; }
    D3D12_CPU_DESCRIPTOR_HANDLE GetDSV() const { return mDsv.Cpu; }
    D3D12_GPU_DESCRIPTOR_HANDLE GetSRVGpu() const { return mSrv.Gpu; }

private:
    void CreateResources(D3D12Context& context);
    void CreateViews(D3D12Context& context);

private:
    int mWidth = 1;
    int mHeight = 1;

    DXGI_FORMAT mColorFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
    DXGI_FORMAT mDepthFormat = DXGI_FORMAT_D24_UNORM_S8_UINT;

    Microsoft::WRL::ComPtr<ID3D12Resource> mColorBuffer;
    Microsoft::WRL::ComPtr<ID3D12Resource> mDepthBuffer;

    D3D12DescriptorHandle mRtv{};
    D3D12DescriptorHandle mDsv{};
    D3D12DescriptorHandle mSrv{};

    D3D12_RESOURCE_STATES mColorState = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;

    D3D12_VIEWPORT mViewport{};
    D3D12_RECT mScissorRect{};
};