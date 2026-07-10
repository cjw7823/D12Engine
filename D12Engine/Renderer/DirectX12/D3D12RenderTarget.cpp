#include "pch.h"
#include "D3D12RenderTarget.h"
#include "Renderer/DirectX12/MACRO.h"

using namespace Microsoft::WRL;

void D3D12RenderTarget::Create(
    D3D12Context& context,
    int width,
    int height,
    DXGI_FORMAT colorFormat,
    DXGI_FORMAT depthFormat)
{
    mWidth = std::max(1, width);
    mHeight = std::max(1, height);
    mColorFormat = colorFormat;
    mDepthFormat = depthFormat;

    if (!mRtv.IsValid())
        mRtv = context.AllocateRtvDescriptor();

    if (!mDsv.IsValid())
        mDsv = context.AllocateDsvDescriptor();

    if (!mSrv.IsValid())
        mSrv = context.AllocateSrvDescriptor();

    CreateResources(context);
    CreateViews(context);
}

void D3D12RenderTarget::Resize(
    D3D12Context& context,
    int width,
    int height)
{
    width = std::max(1, width);
    height = std::max(1, height);

    if (mWidth == width && mHeight == height)
        return;

    mWidth = width;
    mHeight = height;

    context.FlushCommandQueue();

    mColorBuffer.Reset();
    mDepthBuffer.Reset();

    CreateResources(context);
    CreateViews(context);
}

void D3D12RenderTarget::Shutdown(D3D12Context& context)
{
    context.FlushCommandQueue();

    mColorBuffer.Reset();
    mDepthBuffer.Reset();

    if (mRtv.IsValid())
    {
        context.FreeRtvDescriptor(mRtv);
        mRtv = {};
    }

    if (mDsv.IsValid())
    {
        context.FreeDsvDescriptor(mDsv);
        mDsv = {};
    }

    if (mSrv.IsValid())
    {
        context.FreeSrvDescriptor(mSrv);
        mSrv = {};
    }
}

void D3D12RenderTarget::CreateResources(D3D12Context& context)
{
    ID3D12Device* device = context.GetDevice();

    D3D12_CLEAR_VALUE colorClearValue = {};
    colorClearValue.Format = mColorFormat;
    colorClearValue.Color[0] = 0.12f;
    colorClearValue.Color[1] = 0.16f;
    colorClearValue.Color[2] = 0.22f;
    colorClearValue.Color[3] = 1.0f;

    D3D12_RESOURCE_DESC colorDesc = {};
    colorDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
    colorDesc.Alignment = 0;
    colorDesc.Width = static_cast<UINT64>(mWidth);
    colorDesc.Height = static_cast<UINT>(mHeight);
    colorDesc.DepthOrArraySize = 1;
    colorDesc.MipLevels = 1;
    colorDesc.Format = mColorFormat;
    colorDesc.SampleDesc.Count = 1;
    colorDesc.SampleDesc.Quality = 0;
    colorDesc.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
    colorDesc.Flags = D3D12_RESOURCE_FLAG_ALLOW_RENDER_TARGET;

    CD3DX12_HEAP_PROPERTIES defaultHeap(D3D12_HEAP_TYPE_DEFAULT);

    mColorState = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;

    ThrowIfFailed(device->CreateCommittedResource(
        &defaultHeap,
        D3D12_HEAP_FLAG_NONE,
        &colorDesc,
        mColorState,
        &colorClearValue,
        IID_PPV_ARGS(mColorBuffer.GetAddressOf())));

    D3D12_CLEAR_VALUE depthClearValue = {};
    depthClearValue.Format = mDepthFormat;
    depthClearValue.DepthStencil.Depth = 1.0f;
    depthClearValue.DepthStencil.Stencil = 0;

    D3D12_RESOURCE_DESC depthDesc = {};
    depthDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
    depthDesc.Alignment = 0;
    depthDesc.Width = static_cast<UINT64>(mWidth);
    depthDesc.Height = static_cast<UINT>(mHeight);
    depthDesc.DepthOrArraySize = 1;
    depthDesc.MipLevels = 1;
    depthDesc.Format = mDepthFormat;
    depthDesc.SampleDesc.Count = 1;
    depthDesc.SampleDesc.Quality = 0;
    depthDesc.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
    depthDesc.Flags = D3D12_RESOURCE_FLAG_ALLOW_DEPTH_STENCIL;

    ThrowIfFailed(device->CreateCommittedResource(
        &defaultHeap,
        D3D12_HEAP_FLAG_NONE,
        &depthDesc,
        D3D12_RESOURCE_STATE_DEPTH_WRITE,
        &depthClearValue,
        IID_PPV_ARGS(mDepthBuffer.GetAddressOf())));

    mViewport.TopLeftX = 0.0f;
    mViewport.TopLeftY = 0.0f;
    mViewport.Width = static_cast<float>(mWidth);
    mViewport.Height = static_cast<float>(mHeight);
    mViewport.MinDepth = 0.0f;
    mViewport.MaxDepth = 1.0f;

    mScissorRect = { 0, 0, mWidth, mHeight };
}

void D3D12RenderTarget::CreateViews(D3D12Context& context)
{
    ID3D12Device* device = context.GetDevice();

    device->CreateRenderTargetView(
        mColorBuffer.Get(),
        nullptr,
        mRtv.Cpu);

    D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc = {};
    srvDesc.Format = mColorFormat;
    srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
    srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
    srvDesc.Texture2D.MostDetailedMip = 0;
    srvDesc.Texture2D.MipLevels = 1;
    srvDesc.Texture2D.ResourceMinLODClamp = 0.0f;

    device->CreateShaderResourceView(
        mColorBuffer.Get(),
        &srvDesc,
        mSrv.Cpu);

    D3D12_DEPTH_STENCIL_VIEW_DESC dsvDesc = {};
    dsvDesc.Format = mDepthFormat;
    dsvDesc.ViewDimension = D3D12_DSV_DIMENSION_TEXTURE2D;
    dsvDesc.Flags = D3D12_DSV_FLAG_NONE;
    dsvDesc.Texture2D.MipSlice = 0;

    device->CreateDepthStencilView(
        mDepthBuffer.Get(),
        &dsvDesc,
        mDsv.Cpu);
}

void D3D12RenderTarget::Clear(
    D3D12Context& context,
    const float clearColor[4])
{
    assert(mColorBuffer);
    assert(mDepthBuffer);

    ID3D12GraphicsCommandList* cmdList = context.GetCommandList();

    if (mColorState != D3D12_RESOURCE_STATE_RENDER_TARGET)
    {
        auto barrier = CD3DX12_RESOURCE_BARRIER::Transition(
            mColorBuffer.Get(),
            mColorState,
            D3D12_RESOURCE_STATE_RENDER_TARGET);

        cmdList->ResourceBarrier(1, &barrier);
        mColorState = D3D12_RESOURCE_STATE_RENDER_TARGET;
    }

    cmdList->RSSetViewports(1, &mViewport);
    cmdList->RSSetScissorRects(1, &mScissorRect);

    cmdList->ClearRenderTargetView(
        mRtv.Cpu,
        clearColor,
        0,
        nullptr);

    cmdList->ClearDepthStencilView(
        mDsv.Cpu,
        D3D12_CLEAR_FLAG_DEPTH | D3D12_CLEAR_FLAG_STENCIL,
        1.0f,
        0,
        0,
        nullptr);

    cmdList->OMSetRenderTargets(
        1,
        &mRtv.Cpu,
        false,
        &mDsv.Cpu);

    auto barrier = CD3DX12_RESOURCE_BARRIER::Transition(
        mColorBuffer.Get(),
        D3D12_RESOURCE_STATE_RENDER_TARGET,
        D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE);

    cmdList->ResourceBarrier(1, &barrier);
    mColorState = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;
}