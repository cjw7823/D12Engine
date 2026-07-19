#pragma once

#include <Windows.h>
#include <wrl.h>
#include "DirectX-Headers/d3dx12.h"

#include <string>

class D3D12Util
{
public:
	static UINT CalcConstantBufferByteSize(UINT byteSize);
	static Microsoft::WRL::ComPtr<ID3DBlob> CompileShader(
		const std::wstring& filename,
		const D3D_SHADER_MACRO* defines,
		const std::string& entryPoint,
		const std::string& target);

	static Microsoft::WRL::ComPtr<ID3D12Resource> CreateDefaultBuffer(
		ID3D12Device* device,
		ID3D12GraphicsCommandList* cmdList,
		const void* initData,
		UINT64 byteSize,
		Microsoft::WRL::ComPtr<ID3D12Resource>& uploadBuffer);

	static Microsoft::WRL::ComPtr<ID3DBlob> LoadBinary(const std::wstring& path);
};

