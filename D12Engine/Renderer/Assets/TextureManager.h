#pragma once

#include <filesystem>
#include <memory>
#include <unordered_map>
#include <vector>

#include "TextureDesc.h"
#include "Renderer/DirectX12/D3D12Context.h"

class TextureManager
{
public:
	TextureManager(const TextureManager&) = delete;
	TextureManager& operator=(const TextureManager&) = delete;

	static TextureManager& GetInstance()
	{
		static TextureManager instance;
		return instance;
	}

	void Initialize(D3D12Context& ctx);

	//반환 시점에 outTex.Resource는 "즉시 SRV로 사용 가능" 상태를 보장.
	HRESULT LoadDDS(D3D12Context& ctx, const std::vector<std::filesystem::path>& paths);

private:
	TextureManager() = default;
	~TextureManager() = default;

	HRESULT FlushCommandQueue();

private:
	bool isInitialized = false;

	//로딩 전용
	Microsoft::WRL::ComPtr<ID3D12Device> mDevice;
	Microsoft::WRL::ComPtr<ID3D12CommandQueue> mCommandQueue;
	Microsoft::WRL::ComPtr<ID3D12CommandAllocator> mCmdAlloc;
	Microsoft::WRL::ComPtr<ID3D12GraphicsCommandList> mCmdList;
	Microsoft::WRL::ComPtr<ID3D12Fence> mFence;
	UINT64 mFenceValue = 0;
	WinHandle mFenceEvent;

	std::unordered_map<std::filesystem::path, std::unique_ptr<Texture>> mTextures;
};