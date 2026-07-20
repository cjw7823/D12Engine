#include "pch.h"
#include "D3D12RenderTarget.h"
#include "Renderer/DirectX12/MACRO.h"

using namespace Microsoft::WRL;

void D3D12RenderTarget::Create(D3D12Context& context, DXGI_FORMAT colorFormat, DXGI_FORMAT depthFormat)
{
    mColorFormat = colorFormat;
    mDepthFormat = depthFormat;

    if (!mRtv.IsValid())
        mRtv = context.AllocateRtvDescriptor();

    if (!mDsv.IsValid())
        mDsv = context.AllocateDsvDescriptor();

    if (!mSrv.IsValid())
        mSrv = context.AllocateSrvUavDescriptor();

    if (!mSceneViewSrv.IsValid())
        mSceneViewSrv = context.AllocateSrvUavDescriptor();

    if (!mMsaaDescriptorHandle.IsValid())
        mMsaaDescriptorHandle = context.AllocateRtvDescriptor();

    CreateResources(context);
    CreateViews(context);

    if (context.mMsaaOption.IsEnable())
        CreateMsaaRenderTarget(context);
}

void D3D12RenderTarget::Resize(D3D12Context& context, int width, int height)
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
    mMsaaRenderTarget.Reset();

    CreateResources(context);
    CreateViews(context);
    if (context.mMsaaOption.IsEnable())
        CreateMsaaRenderTarget(context);
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
        context.FreeSrvUavDescriptor(mSrv);
        mSrv = {};
    }
}

void D3D12RenderTarget::CreateResources(D3D12Context& context)
{
    ID3D12Device* device = context.GetDevice();

    D3D12_CLEAR_VALUE colorClearValue = {};
    colorClearValue.Format = mColorFormat;
    colorClearValue.Color[0] = mClearColor[0];
    colorClearValue.Color[1] = mClearColor[1];
    colorClearValue.Color[2] = mClearColor[2];
    colorClearValue.Color[3] = mClearColor[3];

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
    depthDesc.SampleDesc.Count = context.mMsaaOption.SampleCount();
    depthDesc.SampleDesc.Quality = context.mMsaaOption.Quality();
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

    // 원본 RGBA SRV
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

    // ImGui Scene View 표시용 SRV
    // RGB는 원본, Alpha는 항상 1.0
    srvDesc.Shader4ComponentMapping =
        D3D12_ENCODE_SHADER_4_COMPONENT_MAPPING(
            D3D12_SHADER_COMPONENT_MAPPING_FROM_MEMORY_COMPONENT_0,
            D3D12_SHADER_COMPONENT_MAPPING_FROM_MEMORY_COMPONENT_1,
            D3D12_SHADER_COMPONENT_MAPPING_FROM_MEMORY_COMPONENT_2,
            D3D12_SHADER_COMPONENT_MAPPING_FORCE_VALUE_1);

    device->CreateShaderResourceView(
        mColorBuffer.Get(),
        &srvDesc,
        mSceneViewSrv.Cpu);

    D3D12_DEPTH_STENCIL_VIEW_DESC dsvDesc = {};
    dsvDesc.Format = mDepthFormat;
    dsvDesc.Flags = D3D12_DSV_FLAG_NONE;
    if (context.mMsaaOption.IsEnable())
        dsvDesc.ViewDimension = D3D12_DSV_DIMENSION_TEXTURE2DMS;
    else
    {
        dsvDesc.ViewDimension = D3D12_DSV_DIMENSION_TEXTURE2D;
        dsvDesc.Texture2D.MipSlice = 0;
    }

    device->CreateDepthStencilView(
        mDepthBuffer.Get(),
        &dsvDesc,
        mDsv.Cpu);
}

void D3D12RenderTarget::CreateMsaaRenderTarget(D3D12Context& context)
{
    D3D12_RESOURCE_DESC texDesc = {};
    texDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
    texDesc.Width = mWidth;
    texDesc.Height = mHeight;
    texDesc.DepthOrArraySize = 1;
    texDesc.MipLevels = 1;
    texDesc.Format = mColorFormat;
    texDesc.SampleDesc.Count = context.mMsaaOption.SampleCount();
    texDesc.SampleDesc.Quality = context.mMsaaOption.Quality();
    texDesc.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
    texDesc.Flags = D3D12_RESOURCE_FLAG_ALLOW_RENDER_TARGET;

    D3D12_CLEAR_VALUE clearValue = {};
    clearValue.Format = mColorFormat;
    clearValue.Color[0] = mClearColor[0];
    clearValue.Color[1] = mClearColor[1];
    clearValue.Color[2] = mClearColor[2];
    clearValue.Color[3] = mClearColor[3];

    mMsaaState = D3D12_RESOURCE_STATE_RENDER_TARGET;

    CD3DX12_HEAP_PROPERTIES heapProps(D3D12_HEAP_TYPE_DEFAULT);
    ThrowIfFailed(context.GetDevice()->CreateCommittedResource(
        &heapProps,
        D3D12_HEAP_FLAG_NONE,
        &texDesc,
        mMsaaState,
        &clearValue,
        IID_PPV_ARGS(mMsaaRenderTarget.GetAddressOf())));

    context.GetDevice()->CreateRenderTargetView(
        mMsaaRenderTarget.Get(),
        nullptr,
        mMsaaDescriptorHandle.Cpu);
}

void D3D12RenderTarget::Clear(D3D12Context& context, const float clearColor[4])
{
    assert(mColorBuffer);
    assert(mDepthBuffer);

    ID3D12GraphicsCommandList* cmdList = context.GetCommandList();

    D3D12_RESOURCE_STATES newState = context.mMsaaOption.IsEnable() ? D3D12_RESOURCE_STATE_RESOLVE_DEST : D3D12_RESOURCE_STATE_RENDER_TARGET;

    TransitionIfNeeded(context.GetCommandList(), mColorBuffer.Get(), mColorState, newState);
    if(context.mMsaaOption.IsEnable())
        TransitionIfNeeded(context.GetCommandList(), mMsaaRenderTarget.Get(), mMsaaState, D3D12_RESOURCE_STATE_RENDER_TARGET);

    cmdList->RSSetViewports(1, &mViewport);
    cmdList->RSSetScissorRects(1, &mScissorRect);

    auto rtvHandle = context.mMsaaOption.IsEnable() ? mMsaaDescriptorHandle.Cpu : mRtv.Cpu;
    cmdList->ClearRenderTargetView(rtvHandle, clearColor, 0, nullptr);

    cmdList->ClearDepthStencilView(
        mDsv.Cpu,
        D3D12_CLEAR_FLAG_DEPTH | D3D12_CLEAR_FLAG_STENCIL,
        1.0f, 0, 0, nullptr);

    cmdList->OMSetRenderTargets(1, &rtvHandle, true, &mDsv.Cpu);
}

void D3D12RenderTarget::TransitionIfNeeded(ID3D12GraphicsCommandList* cmdList, ID3D12Resource* resource, D3D12_RESOURCE_STATES& currState, D3D12_RESOURCE_STATES newState)
{
    assert(cmdList);
    assert(resource);

    if (currState != newState)
    {
        auto barrier = CD3DX12_RESOURCE_BARRIER::Transition(resource, currState, newState);
        cmdList->ResourceBarrier(1, &barrier);
        currState = newState;
    }
}

void D3D12RenderTarget::ResolveMsaaToColorBuffer(ID3D12GraphicsCommandList* commandList)
{
    TransitionIfNeeded(commandList, mMsaaRenderTarget.Get(), mMsaaState, D3D12_RESOURCE_STATE_RESOLVE_SOURCE);

    commandList->ResolveSubresource(
        mColorBuffer.Get(),
        0,
        mMsaaRenderTarget.Get(),
        0,
        mColorFormat);

    TransitionIfNeeded(commandList, mMsaaRenderTarget.Get(), mMsaaState, D3D12_RESOURCE_STATE_RENDER_TARGET);

    TransitionIfNeeded(commandList, mColorBuffer.Get(), mColorState, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE);

    commandList->OMSetRenderTargets(1, &mRtv.Cpu, true, nullptr);
}

void D3D12RenderTarget::PrepareForSampling(ID3D12GraphicsCommandList* commandList)
{
    TransitionIfNeeded(
        commandList,
        mColorBuffer.Get(),
        mColorState,
        D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE);

    commandList->OMSetRenderTargets(1, &mRtv.Cpu, true, nullptr);
}