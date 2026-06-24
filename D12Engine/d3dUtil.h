#pragma once

#include <string>
#include <sstream>
#include <wrl.h>
#include "DirectX-Headers\d3dx12.h"

class DxException
{
public:
	DxException() = default;
	DxException(HRESULT hr, const std::wstring& functionName, const std::wstring& filename, int lineNumber) : ErrorCode(hr), FunctionName(functionName), FileName(filename), LineNumber(lineNumber) {};

	std::wstring ToString() const;
	HRESULT ErrorCode = S_OK;
	std::wstring FunctionName;
	std::wstring FileName;
	int LineNumber = -1;
};

inline std::wstring AnsiToWString(const std::string& str)
{
	WCHAR buffer[512];
	MultiByteToWideChar(CP_ACP, 0, str.c_str(), -1, buffer, 512);
	return std::wstring(buffer);
}

#ifndef ReleaseCom
#define ReleaseCom(x) { if(x) { x->Release(); x = 0; } }
#endif // !ReleaseCom

#ifndef ThrowIfFailed
#define ThrowIfFailed(x)                                            \
{                                                                   \
	HRESULT hr__ = (x);												\
	if(FAILED(hr__))												\
	{																\
		std::wstring wfn = AnsiToWString(__FILE__);					\
		throw DxException(hr__, L#x, wfn, __LINE__);				\
	}																\
}
#endif // !ThrowIfFailed

class d3dUtil
{
public:
	static bool IsKeyDown(int vkeyCode);
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

struct WinHandle
{
	WinHandle() = default;
	explicit WinHandle(HANDLE handle) : h(handle) {}

	WinHandle(const WinHandle& rhs) = delete;
	WinHandle& operator=(const WinHandle& rhs) = delete;

	WinHandle(WinHandle&& other) noexcept :h(other.h) { other.h = nullptr; }
	WinHandle& operator=(WinHandle&& other) noexcept
	{
		if (this != &other)
		{
			Reset();
			h = other.h;
			other.h = nullptr;
		}
		return *this;
	}

	~WinHandle() { Reset(); }

	void Reset()
	{
		if (h && h != INVALID_HANDLE_VALUE)
		{
			CloseHandle(h);
			h = nullptr;
		}
	}

	HANDLE Get() const { return h; }
	void Set(HANDLE handle) { h = handle; }
private:
	HANDLE h = nullptr;
};