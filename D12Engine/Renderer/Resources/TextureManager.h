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
	struct TextureFileRequest
	{
		std::string Key;
		std::filesystem::path FilePath;
		TextureLoadDesc Desc{};
	};

	struct TextureMemoryRequest
	{
		std::string Key;

		const std::uint8_t* Data = nullptr;
		std::size_t Size = 0;

		TextureLoadDesc Desc{};
	};

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
	//Srv 생성까지 담당.
	HRESULT LoadFromFile(const std::vector<TextureFileRequest>& requests, std::vector<TextureHandle>& outHandles);

	HRESULT LoadFromMemory(const std::vector<TextureMemoryRequest>& requests, std::vector<TextureHandle>& outHandles);

	[[nodiscard]]
	TextureHandle FindHandle(const std::string& key) const;

	[[nodiscard]]
	Texture* Get(TextureHandle handle);
	[[nodiscard]]
	const Texture* Get(TextureHandle handle) const;

	static UINT GetNumTexture() { return (UINT)GetInstance().mTextures.size(); }

private:
	struct PendingTexture
	{
		std::string Key;

		std::unique_ptr<Texture> TextureData;

		// DDS 파일 원본 또는 WIC 디코딩 데이터의 수명을 GPU 복사가 끝날 때까지 유지한다.
		std::unique_ptr<std::uint8_t[]> DecodedData;

		std::vector<D3D12_SUBRESOURCE_DATA> Subresources;
		Microsoft::WRL::ComPtr<ID3D12Resource> UploadHeap;
	};

private:
	TextureManager() = default;
	~TextureManager() = default;

	HRESULT SubmitPendingTextures(std::vector<PendingTexture>& pendingTextures);
	HRESULT FlushCommandQueue();
	void CreateSRV(Texture& texture);

private:
	bool isInitialized = false;

	D3D12Context* mContext = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Device> mDevice;
	Microsoft::WRL::ComPtr<ID3D12CommandQueue> mCommandQueue;

	//로딩 전용
	Microsoft::WRL::ComPtr<ID3D12CommandAllocator> mCmdAlloc;
	Microsoft::WRL::ComPtr<ID3D12GraphicsCommandList> mCmdList;
	Microsoft::WRL::ComPtr<ID3D12Fence> mFence;
	UINT64 mFenceValue = 0;
	WinHandle mFenceEvent;

	// TextureHandle::Index로 직접 접근한다.
	std::vector<std::unique_ptr<Texture>> mTextures;

	// 외부 경로 또는 에셋별 런타임 키를 Handle로 변환한다.
	std::unordered_map<std::string, TextureHandle> mHandlesByKey;
};