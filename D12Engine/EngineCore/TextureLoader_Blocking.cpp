#include "pch.h"
#include "TextureLoader_Blocking.h"
#include "RenderData.h"
#include "Renderer/DirectX12/MACRO.h"

using Microsoft::WRL::ComPtr;

TextureLoader_Blocking::TextureLoader_Blocking(ID3D12Device* device, ID3D12CommandQueue* graphicsQueue)
{
	mDevice = device;
	mQueue = graphicsQueue;

	ThrowIfFailed(mDevice->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(mFence.GetAddressOf())));

	mFenceEvent.Set(CreateEventEx(nullptr, nullptr, false, EVENT_ALL_ACCESS));
	if (!mFenceEvent.Get())
		ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));

	ThrowIfFailed(mDevice->CreateCommandAllocator(
		D3D12_COMMAND_LIST_TYPE_DIRECT, IID_PPV_ARGS(mCmdAlloc.GetAddressOf())));
	ThrowIfFailed(mDevice->CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, mCmdAlloc.Get(), nullptr, IID_PPV_ARGS(mCmdList.GetAddressOf())));

	mCmdList->Close();
}

HRESULT TextureLoader_Blocking::LoadDDS(Texture& outTex)
{
	assert(mDevice);
	assert(mQueue);
	assert(mFence);
	if (outTex.FilePath.empty()) return E_INVALIDARG;
	outTex.Resource.Reset();

	ThrowIfFailed(mCmdAlloc->Reset());
	ThrowIfFailed(mCmdList->Reset(mCmdAlloc.Get(), nullptr));

	//DDS 파싱 + DEFUALT heap 텍스처 생성 + subresource 정보 생성
	std::unique_ptr<uint8_t[]> ddsData;
	std::vector<D3D12_SUBRESOURCE_DATA> subresources;

	//outTex.Resource를 Default Heap에 만듦.
	//만들어진 텍스처는 D3D12_RESOURCE_STATE_COMMON 상태.
	HRESULT hr = DirectX::LoadDDSTextureFromFile(
		mDevice.Get(),
		outTex.FilePath.c_str(),
		outTex.Resource.GetAddressOf(),
		ddsData,
		subresources);

	if (FAILED(hr)) return hr;

	//업로드 힙 생성
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

	//ddsData->upload heap 복사.
	//upload heap -> default heap 복사 명령을 list에 기록
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

	//ddsData/subresources/uploadBuffer 안전하게 폐기
	mCmdList->Close();
	ID3D12CommandList* lists[] = { mCmdList.Get() };
	mQueue->ExecuteCommandLists(1, lists);

	FlushCommandQueue();

	return S_OK;
}

HRESULT TextureLoader_Blocking::LoadDDS(UINT NumTextures, Texture* const* ppTextures)
{
	assert(mDevice);
	assert(mQueue);
	assert(mFence);

	ThrowIfFailed(mCmdAlloc->Reset());
	ThrowIfFailed(mCmdList->Reset(mCmdAlloc.Get(), nullptr));

	for (UINT i = 0; i < NumTextures; i++)
	{
		Texture& tex = *ppTextures[i];
		if (tex.FilePath.empty()) return E_INVALIDARG;
		tex.Resource.Reset();

		std::unique_ptr<uint8_t[]> ddsData;
		std::vector<D3D12_SUBRESOURCE_DATA> subresources;

		HRESULT hr = DirectX::LoadDDSTextureFromFile(
			mDevice.Get(),
			tex.FilePath.c_str(),
			tex.Resource.GetAddressOf(),
			ddsData,
			subresources);

		if (FAILED(hr)) return hr;

		const UINT numSubs = (UINT)subresources.size();
		const UINT64 uploadBytes = GetRequiredIntermediateSize(tex.Resource.Get(), 0, numSubs);

		CD3DX12_HEAP_PROPERTIES heapProps(D3D12_HEAP_TYPE_UPLOAD);
		CD3DX12_RESOURCE_DESC resDesc = CD3DX12_RESOURCE_DESC::Buffer(uploadBytes);
		ThrowIfFailed(mDevice->CreateCommittedResource(
			&heapProps,
			D3D12_HEAP_FLAG_NONE,
			&resDesc,
			D3D12_RESOURCE_STATE_GENERIC_READ,
			nullptr,
			IID_PPV_ARGS(tex.UploadHeap.GetAddressOf())));

		CD3DX12_RESOURCE_BARRIER barrier1 = CD3DX12_RESOURCE_BARRIER::Transition(
			tex.Resource.Get(),
			D3D12_RESOURCE_STATE_COMMON,
			D3D12_RESOURCE_STATE_COPY_DEST);
		mCmdList->ResourceBarrier(1, &barrier1);

		UpdateSubresources(
			mCmdList.Get(),
			tex.Resource.Get(),
			tex.UploadHeap.Get(),
			0, 0, numSubs,
			subresources.data());

		CD3DX12_RESOURCE_BARRIER barrier2 = CD3DX12_RESOURCE_BARRIER::Transition(
			tex.Resource.Get(),
			D3D12_RESOURCE_STATE_COPY_DEST,
			D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE);
		mCmdList->ResourceBarrier(1, &barrier2);
	}

	mCmdList->Close();
	ID3D12CommandList* lists[] = { mCmdList.Get() };
	mQueue->ExecuteCommandLists(1, lists);

	FlushCommandQueue();

	for (UINT i = 0; i < NumTextures; i++)
		ppTextures[i]->UploadHeap.Reset();

	return S_OK;
}

void TextureLoader_Blocking::FlushCommandQueue()
{
	mFenceValue++;
	//실패시 회복 불가능한 os레벨 작업.
	ThrowIfFailed(mQueue->Signal(mFence.Get(), mFenceValue));

	if (mFence->GetCompletedValue() < mFenceValue)
	{
		ThrowIfFailed(mFence->SetEventOnCompletion(mFenceValue, mFenceEvent.Get()));
		WaitForSingleObject(mFenceEvent.Get(), INFINITE);
	}
}
