#pragma once

#include "d3dUtil.h"

template<typename T>
class UploadBuffer
{
public:
	UploadBuffer(ID3D12Device* device, UINT elementCount, bool isConstantBuffer) : mIsconstantBuffer(isConstantBuffer)
	{
		mElementByteSize = sizeof(T);

		// 상수 버퍼 요소는 256바이트의 배수여야 합니다.
		// 이는 하드웨어가 상수 데이터를 m * 256바이트 오프셋과 n * 256바이트 길이로만 볼 수 있기 때문입니다.
		if (isConstantBuffer)
			mElementByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(T));

		CD3DX12_HEAP_PROPERTIES heapProps(D3D12_HEAP_TYPE_UPLOAD);
		CD3DX12_RESOURCE_DESC resDesc = CD3DX12_RESOURCE_DESC::Buffer(mElementByteSize * elementCount);

		ThrowIfFailed(device->CreateCommittedResource(
			&heapProps,
			D3D12_HEAP_FLAG_NONE,				//힙(메모리) 정책. 예) 텍스처만.
			&resDesc,
			D3D12_RESOURCE_STATE_GENERIC_READ,	//리소스 정책. 예) RT 텍스처, DS 텍스처 등등..
			nullptr,
			IID_PPV_ARGS(&mUploadBuffer)));

		ThrowIfFailed(mUploadBuffer->Map(0, nullptr, reinterpret_cast<void**>(&mMappedData)));

		//리소스의 "사용"이 완료될 때까지 Unmap 하면 안됨.
		//GPU에서 리소스가 사용중인 동안에는 리소스에 쓰기 작업을 해선 안된다.(동기화 기술 사용)
	}

	UploadBuffer(const UploadBuffer& rhs) = delete;
	UploadBuffer& operator=(const UploadBuffer& rhs) = delete;
	
	~UploadBuffer()
	{
		if (mUploadBuffer != nullptr)
			mUploadBuffer->Unmap(0, nullptr);
		mMappedData = nullptr;
	}

	ID3D12Resource* Resource()const
	{
		return mUploadBuffer.Get();
	}

	void CopyData(int elementIndex, const T& data)
	{
		memcpy(&mMappedData[elementIndex * mElementByteSize], &data, sizeof(T));
	}

private:
	Microsoft::WRL::ComPtr<ID3D12Resource> mUploadBuffer;
	BYTE* mMappedData = nullptr;
	UINT mElementByteSize = 0;
	bool mIsconstantBuffer = false;
};