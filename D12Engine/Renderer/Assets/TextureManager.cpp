#include "pch.h"
#include "TextureManager.h"
#include "Renderer/DirectX12/MACRO.h"
#include <unordered_set>

void TextureManager::Initialize(D3D12Context& ctx)
{
	if (isInitialized) return;

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

HRESULT TextureManager::LoadDDS(D3D12Context& ctx, const std::vector<std::filesystem::path>& paths)
{
	if (!isInitialized) return E_UNEXPECTED;
	if (paths.empty()) return E_INVALIDARG;

	struct PendingTexture
	{
		std::filesystem::path Path;
		std::unique_ptr<Texture> TextureData;

		Microsoft::WRL::ComPtr<ID3D12Resource> UploadHeap;

		//DDS 파싱 + DEFUALT heap 텍스처 생성 + subresource 정보 생성
		std::unique_ptr<uint8_t[]> DdsData;
		std::vector<D3D12_SUBRESOURCE_DATA> Subresources;
	};

	std::vector<PendingTexture> pendingTextures;
	pendingTextures.reserve(paths.size());

	std::unordered_set<std::filesystem::path> pendingPaths;

	for (const auto& originPath : paths)
	{
		const auto filePath = originPath.lexically_normal();

		if (mTextures.find(filePath) != mTextures.end()) continue;
		if (!pendingPaths.insert(filePath).second) continue;

		PendingTexture pending;
		pending.Path = filePath;
		pending.TextureData = std::make_unique<Texture>();

		//만들어진 텍스처는 D3D12_RESOURCE_STATE_COMMON 상태.
		HRESULT hr = DirectX::LoadDDSTextureFromFile(
			mDevice.Get(),
			filePath.c_str(),
			pending.TextureData->Resource.GetAddressOf(),
			pending.DdsData,
			pending.Subresources);

		if (FAILED(hr)) return hr;

		const UINT numSubs = (UINT)pending.Subresources.size();
		const UINT64 uploadBytes = GetRequiredIntermediateSize(pending.TextureData->Resource.Get(), 0, numSubs);

		CD3DX12_HEAP_PROPERTIES heapProps(D3D12_HEAP_TYPE_UPLOAD);
		CD3DX12_RESOURCE_DESC resDesc = CD3DX12_RESOURCE_DESC::Buffer(uploadBytes);

		hr = mDevice->CreateCommittedResource(
			&heapProps,
			D3D12_HEAP_FLAG_NONE,
			&resDesc,
			D3D12_RESOURCE_STATE_GENERIC_READ,
			nullptr,
			IID_PPV_ARGS(pending.UploadHeap.GetAddressOf()));

		if (FAILED(hr)) return hr;

		pendingTextures.push_back(std::move(pending));
	}

	if (pendingTextures.empty()) return S_OK;

	HRESULT hr;
	hr = mCmdAlloc->Reset();
	if (FAILED(hr))return hr;
	hr = mCmdList->Reset(mCmdAlloc.Get(), nullptr);
	if (FAILED(hr))return hr;

	for (auto& pending : pendingTextures)
	{
		auto* textureResource =	pending.TextureData->Resource.Get();
		const UINT numSubs = (UINT)pending.Subresources.size();

		auto barrier =	CD3DX12_RESOURCE_BARRIER::Transition(
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
			numSubs,
			pending.Subresources.data());

		barrier = CD3DX12_RESOURCE_BARRIER::Transition(
				textureResource,
				D3D12_RESOURCE_STATE_COPY_DEST,
				D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE);
		mCmdList->ResourceBarrier(1, &barrier);
	}

	hr = mCmdList->Close();
	if (FAILED(hr))return hr;
	ID3D12CommandList* lists[] = { mCmdList.Get() };
	ctx.GetCommandQueue()->ExecuteCommandLists(1, lists);

	hr = FlushCommandQueue();
	if (FAILED(hr)) return hr;

	//완벽하게 업로드가 완료되면 캐시에 등록.
	for (auto& pending : pendingTextures)
	{
		mTextures.emplace(
			std::move(pending.Path),
			std::move(pending.TextureData));
	}

	CreateSRV(ctx);

	return S_OK;
}

Texture* TextureManager::Find(const std::wstring& path)
{
	return mTextures.find(path)->second.get();
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

void TextureManager::CreateSRV(D3D12Context& ctx)
{
	for (auto& p : mTextures)
	{
		auto& tex = p.second;
		tex->Srv = ctx.AllocateSrvUavDescriptor();

		auto resource = tex->Resource;
		auto desc = resource->GetDesc();
		D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc = {};
		srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
		srvDesc.Format = desc.Format;
		srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
		srvDesc.Texture2D.MostDetailedMip = 0;
		srvDesc.Texture2D.MipLevels = desc.MipLevels;
		srvDesc.Texture2D.ResourceMinLODClamp = 0.0f;

		ctx.GetDevice()->CreateShaderResourceView(resource.Get(), &srvDesc, tex->Srv.Cpu);
	}
}
