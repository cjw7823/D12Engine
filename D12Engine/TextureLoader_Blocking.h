#pragma once

#include "pch.h"

struct Texture;

class TextureLoader_Blocking
{
public:
    TextureLoader_Blocking(
        ID3D12Device* device,
        ID3D12CommandQueue* graphicsQueue,
        ID3D12Fence* fence);

    ~TextureLoader_Blocking();

    TextureLoader_Blocking(const TextureLoader_Blocking&) = delete;
    TextureLoader_Blocking& operator=(const TextureLoader_Blocking&) = delete;

    // 반환 시점에 outTex.Resource는 "즉시 SRV로 사용 가능" 상태를 보장 (업로드 완료 + 상태 전이 완료)
    HRESULT LoadDDS(Texture& outTex, UINT64& fence);

private:
    void FlushCommandQueue(UINT64& fence);

private:
    Microsoft::WRL::ComPtr<ID3D12Device> mDevice;
    Microsoft::WRL::ComPtr<ID3D12CommandQueue> mQueue;
    Microsoft::WRL::ComPtr<ID3D12Fence> mFence;

    HANDLE mFenceEvent = nullptr;

    // 로딩 전용
    Microsoft::WRL::ComPtr<ID3D12CommandAllocator> mCmdAlloc;
    Microsoft::WRL::ComPtr<ID3D12GraphicsCommandList> mCmdList;
};