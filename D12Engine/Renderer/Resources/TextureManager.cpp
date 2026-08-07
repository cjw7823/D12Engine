#include "pch.h"
#include "TextureManager.h"
#include "Renderer/DirectX12/MACRO.h"

#include <algorithm>
#include <cwctype>
#include <unordered_set>

namespace
{
	bool IsDDSFile(const std::filesystem::path& path)
	{
		std::wstring extension = path.extension().wstring();

		std::transform(extension.begin(), extension.end(), extension.begin(), [](wchar_t value)
			{
				return static_cast<wchar_t>(std::towlower(value));
			});

		return extension == L".dds";
	}

	bool IsDDSMemory(const std::uint8_t* data, std::size_t size)
	{
		constexpr std::uint8_t DdsMagic[] =
		{
			'D', 'D', 'S', ' '
		};

		return data != nullptr && size >= sizeof(DdsMagic) &&
			std::equal(std::begin(DdsMagic), std::end(DdsMagic), data);
	}
}

void TextureManager::Initialize(D3D12Context& ctx)
{
	if (isInitialized) return;

	mContext = &ctx;
	mDevice = ctx.GetDevice();
	mCommandQueue = ctx.GetCommandQueue();

	ThrowIfFailed(mDevice->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(mFence.GetAddressOf())));

	mFenceEvent.Set(CreateEventEx(nullptr, nullptr, false, EVENT_ALL_ACCESS));
	if (!mFenceEvent.Get())
		ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));

	ThrowIfFailed(mDevice->CreateCommandAllocator(
		D3D12_COMMAND_LIST_TYPE_DIRECT, IID_PPV_ARGS(mCmdAlloc.GetAddressOf())));
	ThrowIfFailed(mDevice->CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, mCmdAlloc.Get(), nullptr, IID_PPV_ARGS(mCmdList.GetAddressOf())));

	ThrowIfFailed(mCmdList->Close());
	isInitialized = true;
}

HRESULT TextureManager::LoadFromFile(const std::vector<TextureFileRequest>& requests, std::vector<TextureHandle>& outHandles)
{
	if (!isInitialized) return E_UNEXPECTED;

	outHandles.assign(requests.size(), InvalidTextureHandle);

	std::vector<PendingTexture> pendingTextures;
	pendingTextures.reserve(requests.size());

	std::unordered_set<std::string> pendingKeys;
	pendingKeys.reserve(requests.size());

	HRESULT hr = S_OK;
	for (std::size_t i = 0; i < requests.size(); ++i)
	{
		const auto& [key, filePath, loadDesc] = requests[i];

		if (key.empty() || filePath.empty())
			return E_INVALIDARG;

		const TextureHandle existingHandle = FindHandle(key);
		if (existingHandle.IsValid())
		{
			outHandles[i] = existingHandle;
			continue;
		}

		// 현재 배치 안에서 동일 key가 두 번 요청된 경우
		if (!pendingKeys.emplace(key).second) return E_INVALIDARG;

		PendingTexture pending;
		pending.Key = key;
		pending.TextureData = std::make_unique<Texture>();
		pending.TextureData->Desc = loadDesc;

		if (IsDDSFile(filePath))
		{
			//만들어진 텍스처는 D3D12_RESOURCE_STATE_COMMON 상태.
			hr = DirectX::LoadDDSTextureFromFile(
				mDevice.Get(),
				filePath.c_str(),
				pending.TextureData->Resource.GetAddressOf(),
				pending.DecodedData,
				pending.Subresources);
		}
		else
		{
			D3D12_SUBRESOURCE_DATA subresource{};

			hr = DirectX::LoadWICTextureFromFile(
				mDevice.Get(),
				filePath.c_str(),
				pending.TextureData->Resource.GetAddressOf(),
				pending.DecodedData,
				subresource);

			if (SUCCEEDED(hr))
				pending.Subresources.push_back(subresource);
		}
		if (FAILED(hr)) return hr;

		pendingTextures.push_back(std::move(pending));
	}

	if (!pendingTextures.empty())
	{
		hr = SubmitPendingTextures(pendingTextures);
		if (FAILED(hr)) return hr;
	}

	for (int i = 0; i < requests.size(); i++)
	{
		if (outHandles[i].IsValid()) continue;
		outHandles[i] = FindHandle(requests[i].Key);

		if (!outHandles[i].IsValid()) return E_FAIL;
	}
	return S_OK;
}

HRESULT TextureManager::LoadFromMemory(const std::vector<TextureMemoryRequest>& requests, std::vector<TextureHandle>& outHandles)
{
	if (!isInitialized) return E_UNEXPECTED;

	outHandles.assign(requests.size(), InvalidTextureHandle);

	std::vector<PendingTexture> pendingTextures;
	pendingTextures.reserve(requests.size());

	std::unordered_set<std::string> pendingKeys;
	pendingKeys.reserve(requests.size());

	HRESULT hr = S_OK;
	for (std::size_t i = 0; i < requests.size(); ++i)
	{
		const auto& [key, data, size, loadDesc] = requests[i];

		if (key.empty() || data == nullptr || size == 0)
			return E_INVALIDARG;

		const TextureHandle existingHandle = FindHandle(key);
		if (existingHandle.IsValid())
		{
			outHandles[i] = existingHandle;
			continue;
		}

		// 현재 배치 안에서 동일 key가 두 번 요청된 경우
		if (!pendingKeys.emplace(key).second) return E_INVALIDARG;

		PendingTexture pending;
		pending.Key = key;
		pending.TextureData = std::make_unique<Texture>();
		pending.TextureData->Desc = loadDesc;

		if (IsDDSMemory(data, size))
		{
			hr = DirectX::LoadDDSTextureFromMemory(
				mDevice.Get(),
				data,
				size,
				pending.TextureData->Resource.GetAddressOf(),
				pending.Subresources);
		}
		else
		{
			D3D12_SUBRESOURCE_DATA subresource{};

			hr = DirectX::LoadWICTextureFromMemory(
				mDevice.Get(),
				data,
				size,
				pending.TextureData->Resource.GetAddressOf(),
				pending.DecodedData,
				subresource);

			if (SUCCEEDED(hr))
				pending.Subresources.push_back(subresource);
		}
		if (FAILED(hr)) return hr;

		pendingTextures.push_back(std::move(pending));
	}

	if (!pendingTextures.empty())
	{
		hr = SubmitPendingTextures(pendingTextures);
		if (FAILED(hr)) return hr;
	}

	for (int i = 0; i < requests.size(); i++)
	{
		if (outHandles[i].IsValid()) continue;
		outHandles[i] = FindHandle(requests[i].Key);

		if (!outHandles[i].IsValid()) return E_FAIL;
	}
	return S_OK;
}

TextureHandle TextureManager::FindHandle(const std::string& key) const
{
	const auto it = mHandlesByKey.find(key);
	if (it == mHandlesByKey.end())
		return InvalidTextureHandle;

	return it->second;
}

Texture* TextureManager::Get(TextureHandle handle)
{
	if (!handle || handle.Index >= mTextures.size())
		return nullptr;

	return mTextures[handle.Index].get();
}

const Texture* TextureManager::Get(TextureHandle handle) const
{
	if (!handle || handle.Index >= mTextures.size())
		return nullptr;

	return mTextures[handle.Index].get();
}

HRESULT TextureManager::SubmitPendingTextures(std::vector<PendingTexture>& pendingTextures)
{
	if (pendingTextures.empty()) return S_OK;

	for (PendingTexture& pending : pendingTextures)
	{
		const UINT64 uploadBytes = GetRequiredIntermediateSize(pending.TextureData->Resource.Get(), 0, (UINT)pending.Subresources.size());

		const CD3DX12_HEAP_PROPERTIES uploadHeapProps(D3D12_HEAP_TYPE_UPLOAD);
		const auto uploadBufferDescription = CD3DX12_RESOURCE_DESC::Buffer(uploadBytes);

		const HRESULT hr = mDevice->CreateCommittedResource(
				&uploadHeapProps,
				D3D12_HEAP_FLAG_NONE,
				&uploadBufferDescription,
				D3D12_RESOURCE_STATE_GENERIC_READ,
				nullptr,
				IID_PPV_ARGS(pending.UploadHeap.GetAddressOf()));

		if (FAILED(hr)) return hr;
	}

	HRESULT hr = mCmdAlloc->Reset();
	if (FAILED(hr)) return hr;
	hr = mCmdList->Reset(mCmdAlloc.Get(), nullptr);
	if (FAILED(hr)) return hr;

	for (PendingTexture& pending : pendingTextures)
	{
		ID3D12Resource* textureResource = pending.TextureData->Resource.Get();
		const UINT subresourceCount = (UINT)pending.Subresources.size();

		auto barrier = CD3DX12_RESOURCE_BARRIER::Transition(
			textureResource,
			D3D12_RESOURCE_STATE_COMMON,
			D3D12_RESOURCE_STATE_COPY_DEST);
		mCmdList->ResourceBarrier(1, &barrier);

		UpdateSubresources(
			mCmdList.Get(),
			textureResource,
			pending.UploadHeap.Get(),
			0,
			0,
			subresourceCount,
			pending.Subresources.data());

		barrier = CD3DX12_RESOURCE_BARRIER::Transition(
			textureResource,
			D3D12_RESOURCE_STATE_COPY_DEST,
			D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE);
		mCmdList->ResourceBarrier(1, &barrier);
	}

	hr = mCmdList->Close();
	if (FAILED(hr)) return hr;
	ID3D12CommandList* commandLists[] = { mCmdList.Get() };
	mCommandQueue->ExecuteCommandLists(1, commandLists);

	hr = FlushCommandQueue();
	if (FAILED(hr)) return hr;

	// GPU 업로드가 모두 끝난 후에만 Manager에 등록한다.
	for (PendingTexture& pending : pendingTextures)
	{
		if (mTextures.size() >= TextureHandle::InvalidIndex)
			return HRESULT_FROM_WIN32(ERROR_ARITHMETIC_OVERFLOW);

		CreateSRV(*pending.TextureData);

		TextureHandle handle;
		handle.Index = (uint32_t)mTextures.size();

		mTextures.push_back(std::move(pending.TextureData));
		mHandlesByKey.emplace(std::move(pending.Key), handle);
	}

	return S_OK;
}

HRESULT TextureManager::FlushCommandQueue()
{
	mFenceValue++;
	//실패시 회복 불가능한 os레벨 작업.
	HRESULT hr = mCommandQueue->Signal(mFence.Get(), mFenceValue);
	if (FAILED(hr)) return hr;

	if (mFence->GetCompletedValue() < mFenceValue)
	{
		hr = mFence->SetEventOnCompletion(mFenceValue, mFenceEvent.Get());
		if (FAILED(hr)) return hr;
		WaitForSingleObject(mFenceEvent.Get(), INFINITE);
	}

	return S_OK;
}

void TextureManager::CreateSRV(Texture& texture)
{
	if (!mContext) return;

	texture.Srv = mContext->AllocateSrvUavDescriptor();

	auto& resource = texture.Resource;
	auto resourceDesc = resource->GetDesc();
	if (resourceDesc.Dimension != D3D12_RESOURCE_DIMENSION_TEXTURE2D)
	{
		throw DxException(
			E_NOTIMPL,
			L"Only 2D textures are currently supported.",
			AnsiToWide(__FILE__),
			__LINE__);
	}

	D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc = {};
	srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
	srvDesc.Format = resourceDesc.Format;
	if (resourceDesc.DepthOrArraySize > 1)
	{
		srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2DARRAY;
		srvDesc.Texture2DArray.MostDetailedMip = 0;
		srvDesc.Texture2DArray.MipLevels = resourceDesc.MipLevels;
		srvDesc.Texture2DArray.FirstArraySlice = 0;
		srvDesc.Texture2DArray.ArraySize = resourceDesc.DepthOrArraySize;
		srvDesc.Texture2DArray.PlaneSlice = 0;
		srvDesc.Texture2DArray.ResourceMinLODClamp = 0.0f;
	}
	else
	{
		srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
		srvDesc.Texture2D.MostDetailedMip = 0;
		srvDesc.Texture2D.MipLevels = resourceDesc.MipLevels;
		srvDesc.Texture2D.PlaneSlice = 0;
		srvDesc.Texture2D.ResourceMinLODClamp = 0.0f;
	}

	mDevice->CreateShaderResourceView(resource.Get(), &srvDesc, texture.Srv.Cpu);
}
