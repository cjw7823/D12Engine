#pragma once

#include <wrl.h>
#include "EngineCore/WinHandle.h"
#include "Renderer/Assets/TextureDesc.h"

struct Texture;

class TextureLoader_Blocking
{
public:
	TextureLoader_Blocking(
		ID3D12Device* device,
		ID3D12CommandQueue* graphicsQueue);
	~TextureLoader_Blocking() {};

	TextureLoader_Blocking(const TextureLoader_Blocking&) = delete;
	TextureLoader_Blocking& operator=(const TextureLoader_Blocking&) = delete;

	//반환 시점에 outTex.Resource는 "즉시 SRV로 사용 가능" 상태를 보장.
	HRESULT LoadDDS(Texture& outTex);
	HRESULT LoadDDS(UINT NumTextures, Texture* const* ppTextures);

private:
	void FlushCommandQueue();

private:
	Microsoft::WRL::ComPtr<ID3D12Device> mDevice;
	Microsoft::WRL::ComPtr<ID3D12CommandQueue> mQueue;
	Microsoft::WRL::ComPtr<ID3D12Fence> mFence;
	UINT64 mFenceValue = 0;
	WinHandle mFenceEvent;

	//로딩 전용
	Microsoft::WRL::ComPtr<ID3D12CommandAllocator> mCmdAlloc;
	Microsoft::WRL::ComPtr<ID3D12GraphicsCommandList> mCmdList;
};