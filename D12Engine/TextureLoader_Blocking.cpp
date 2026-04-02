#include "pch.h"
#include "TextureLoader_Blocking.h"

using Microsoft::WRL::ComPtr;

static inline HRESULT HrIf(bool cond, HRESULT hr) { return cond ? hr : S_OK; }

TextureLoader_Blocking::TextureLoader_Blocking(
    ID3D12Device* device,
    ID3D12CommandQueue* graphicsQueue,
    ID3D12Fence* fence)
{
    mDevice = device;
    mQueue = graphicsQueue;
    mFence = fence;

    mFenceEvent = CreateEvent(nullptr, FALSE, FALSE, nullptr);
    if (!mFenceEvent)
        ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));

    // 로딩 전용 allocator/list 생성
    ThrowIfFailed(mDevice->CreateCommandAllocator(
        D3D12_COMMAND_LIST_TYPE_DIRECT, IID_PPV_ARGS(mCmdAlloc.GetAddressOf())));
    
    ThrowIfFailed(mDevice->CreateCommandList(
        0, D3D12_COMMAND_LIST_TYPE_DIRECT, mCmdAlloc.Get(), nullptr,
        IID_PPV_ARGS(mCmdList.GetAddressOf())));

    mCmdList->Close();
}

TextureLoader_Blocking::~TextureLoader_Blocking()
{
    if (mFenceEvent)
    {
        CloseHandle(mFenceEvent);
        mFenceEvent = nullptr;
    }
}

void TextureLoader_Blocking::FlushCommandQueue(UINT64& fence)
{
    fence++;
    //실패시 회복 불가능한 os레벨 작업.
    ThrowIfFailed(mQueue->Signal(mFence.Get(), fence));

    if (mFence->GetCompletedValue() < fence)
    {
        ThrowIfFailed(mFence->SetEventOnCompletion(fence, mFenceEvent));
        WaitForSingleObject(mFenceEvent, INFINITE);
    }
}

HRESULT TextureLoader_Blocking::LoadDDS(Texture& outTex, UINT64& fence)
{
    //입력 검증
    if (!mDevice || !mQueue || !mFence) return E_POINTER;
    if (outTex.Filename.empty())        return E_INVALIDARG;
    outTex.Resource.Reset();

    ThrowIfFailed(mCmdAlloc->Reset());
    ThrowIfFailed(mCmdList->Reset(mCmdAlloc.Get(), nullptr));

    //DDS 파싱 + DEFAULT heap 텍스처 생성 + subresource 정보 생성
    std::unique_ptr<uint8_t[]> ddsData;
    std::vector<D3D12_SUBRESOURCE_DATA> subresources;

    //만들어진 텍스처는 D3D12_RESOURCE_STATE_COMMON 상태.
    HRESULT hr =  DirectX::LoadDDSTextureFromFile(
        mDevice.Get(),
        outTex.Filename.c_str(),
        outTex.Resource.GetAddressOf(),
        ddsData,
        subresources,
        0,          // maxsize=0(제한 없음)
        nullptr,
        nullptr);

    if (hr != S_OK)
        return hr;

    //업로드 버퍼(UPLOAD heap buffer) 생성
    const UINT numSubs = (UINT)subresources.size();
    const UINT64 uploadBytes = GetRequiredIntermediateSize(outTex.Resource.Get(), 0, numSubs);

    ComPtr<ID3D12Resource> uploadBuffer;
    CD3DX12_HEAP_PROPERTIES heapProps(D3D12_HEAP_TYPE_UPLOAD);
    CD3DX12_RESOURCE_DESC resDesc = CD3DX12_RESOURCE_DESC::Buffer(uploadBytes);
    ThrowIfFailed(mDevice->CreateCommittedResource(
        &heapProps,
        D3D12_HEAP_FLAG_NONE,
        &resDesc,
        D3D12_RESOURCE_STATE_GENERIC_READ,
        nullptr,
        IID_PPV_ARGS(uploadBuffer.GetAddressOf())));

    CD3DX12_RESOURCE_BARRIER barrier1 = CD3DX12_RESOURCE_BARRIER::Transition(
        outTex.Resource.Get(),
        D3D12_RESOURCE_STATE_COMMON,
        D3D12_RESOURCE_STATE_COPY_DEST);
    mCmdList->ResourceBarrier(1, &barrier1);

    UpdateSubresources(
        mCmdList.Get(),
        outTex.Resource.Get(),
        uploadBuffer.Get(),
        0, 0, numSubs,
        subresources.data());

    CD3DX12_RESOURCE_BARRIER barrier2 = CD3DX12_RESOURCE_BARRIER::Transition(
        outTex.Resource.Get(),
        D3D12_RESOURCE_STATE_COPY_DEST,
        D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE);
    mCmdList->ResourceBarrier(1, &barrier2);

    //제출 + 완료 대기(ddsData/subresources/uploadBuffer 안전하게 폐기)
    mCmdList->Close();
    ID3D12CommandList* lists[] = { mCmdList.Get() };
    mQueue->ExecuteCommandLists(1, lists);

    FlushCommandQueue(fence);

    return S_OK;
}