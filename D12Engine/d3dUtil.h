#pragma once

#include "../DirectX-Headers-main/d3dx12.h"
#include <windows.h> // For HWND and other Windows types
#include <wrl.h> // For Microsoft::WRL::ComPtr
#include <dxgi1_4.h> // For DXGI interfaces
#include <d3d12.h> // For Direct3D 12 interfaces
#include <D3Dcompiler.h> // For D3DCompile. used in shader compilation
#include <DirectXMath.h> // For DirectX Math library
#include <DirectXPackedVector.h> // For Packed Vector types
#include <DirectXColors.h> // For predefined colors
#include <DirectXCollision.h> // For collision detection
#include <memory> // For std::unique_ptr and std::shared_ptr
#include <algorithm>
#include <string>
#include <vector>
#include <array>
#include <unordered_map>
#include <cstdint> // For standard integer types
#include <fstream>
#include <sstream>
#include <cassert> // For assert

#include "MathHelper.h"
#include "DDSTextureLoader.h"

extern const int gNumFrameResources;

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
#define ThrowIfFailed(x)												\
{																		\
	HRESULT hr__ = (x);													\
	std::wstring wfn = AnsiToWString(__FILE__);							\
	if(FAILED(hr__)) { throw DxException(hr__, L#x, wfn, __LINE__); }	\
}
#endif // !ThrowIfFailed

class d3dUtil
{
public:
	static bool IsKeyDown(int vkeyCode)
	{
		return (GetAsyncKeyState(vkeyCode) & 0x8000) != 0;
	}

	static std::string ToString(HRESULT hr);
	static UINT CalcConstantBufferByteSize(UINT byteSize)
	{
		//상수 버퍼는 최소 하드웨어 할당 크기(256바이트)의 배수여야 함.
		return (byteSize + 255) & ~255;
	}

	static Microsoft::WRL::ComPtr<ID3DBlob> CompileShader(
		const std::wstring& filename,
		const D3D_SHADER_MACRO* defines,
		const std::string& entrypoint,
		const std::string& target);

	static Microsoft::WRL::ComPtr<ID3D12Resource> CreateDefaultBuffer(
		ID3D12Device* device,
		ID3D12GraphicsCommandList* cmdList,
		const void* initData,
		UINT64 byteSize,
		Microsoft::WRL::ComPtr<ID3D12Resource>& uploadBuffer);
};

struct SubmeshGeometry
{
	UINT IndexCount = 0;
	UINT StartIndexLocation = 0;
	INT BaseVertexLocation = 0;

	// 이 서브메시로 정의된 기하 도형의 경계 상자.
	// 나중에 공부예정...
	DirectX::BoundingBox Bounds;
};

struct MeshGeometry
{
	std::string Name;	//이름 검색용

	//시스템 메모리 복사본. 정점/인덱스 형식을 일반화할 수 있으므로 Blob을 사용.
	// 적절한 형변환은 클라이언트의 책임.
	Microsoft::WRL::ComPtr<ID3DBlob> VertexBufferCPU;
	Microsoft::WRL::ComPtr<ID3DBlob> IndexBufferCPU = nullptr;

	Microsoft::WRL::ComPtr<ID3D12Resource> VertexBufferGPU;
	Microsoft::WRL::ComPtr<ID3D12Resource> IndexBufferGPU = nullptr;

	Microsoft::WRL::ComPtr<ID3D12Resource> VertexBufferUploader;
	Microsoft::WRL::ComPtr<ID3D12Resource> IndexBufferUploader = nullptr;

	UINT VertexByteStride;
	UINT VertexBufferByteSize;
	DXGI_FORMAT IndexFormat = DXGI_FORMAT_R16_UINT;
	UINT IndexBufferByteSize = 0;

	//MeshGeometry는 하나의 정점/인덱스 버퍼에 여러개의 지오메트리를 저장 가능.
	//서브메시 지오메트리를 정의하면 서브메시를 개별적으로 렌더링 가능.
	std::unordered_map<std::string, SubmeshGeometry> DrawArgs;

	D3D12_VERTEX_BUFFER_VIEW VertexBufferView() const
	{
		D3D12_VERTEX_BUFFER_VIEW vbv;
		vbv.BufferLocation = VertexBufferGPU->GetGPUVirtualAddress();
		vbv.StrideInBytes = VertexByteStride;
		vbv.SizeInBytes = VertexBufferByteSize;

		return vbv;
	}

	D3D12_INDEX_BUFFER_VIEW IndexBufferView() const
	{
		D3D12_INDEX_BUFFER_VIEW ibv;
		ibv.BufferLocation = IndexBufferGPU->GetGPUVirtualAddress();
		ibv.Format = IndexFormat;
		ibv.SizeInBytes = IndexBufferByteSize;

		return ibv;
	}

	//ComPtr은 RAII이므로 nullptr대입 시 리소스 해제.
	//GPU에 업로드가 완료되면 해제 가능.
	void DisposeUploaders()
	{
		VertexBufferUploader = nullptr;
		IndexBufferUploader = nullptr;
	}
};

struct Light
{
	DirectX::XMFLOAT3 Strength = { 0.5f, 0.5f, 0.5f };
	//point / spot
	float FalloffStart = 1.0f;
	//directional / spot
	DirectX::XMFLOAT3 Direction = { 0.f, -1.f, 0.f };
	//point / spot
	float FalloffEnd = 10.0f;
	//point / spot
	DirectX::XMFLOAT3 Position = { 0.0f, 0.0f, 0.0f };
	//spot
	float SpotPower = 64.0f;
};

#define MaxLights 16

// 실제 엔진에서는 Material 클래스 계층 구조로 존재할 수 있다.
struct Material
{
	std::string Name;
	int MatCBIndex = -1;
	//디퓨즈 텍스처에 대한 SRV 힙 인덱스.
	int DiffuseSrvHeapIndex = -1;
	//노멀 텍스처에 대한 SRV 힙 인덱스.
	int NormalSrvHeapIndex = -1;

	int NumFramesDirty = gNumFrameResources;

	//HLSL에서 사용되는 상수 버퍼에 대한 데이터.
	DirectX::XMFLOAT4 DiffuseAlbedo = { 1.0f, 1.0f , 1.0f , 1.0f };
	DirectX::XMFLOAT3 FresnelR0 = { 0.01f, 0.01f, 0.01f };
	float Roughness = 0.25f;
	DirectX::XMFLOAT4X4 MatTransform = MathHelper::Identity4x4();
};

struct MaterialConstants
{
	DirectX::XMFLOAT4 DiffuseAlbedo = { 1.0f, 1.0f , 1.0f , 1.0f };
	DirectX::XMFLOAT3 FresnelR0 = { 0.01f, 0.01f, 0.01f};
	float Roughness = 0.25f;

	//텍스쳐 매핑에 사용.
	DirectX::XMFLOAT4X4 MatTransform = MathHelper::Identity4x4();
};

struct Texture
{
	std::string Name;
	std::wstring Filename;
	Microsoft::WRL::ComPtr<ID3D12Resource> Resource = nullptr;
	Microsoft::WRL::ComPtr<ID3D12Resource> UploadHeap = nullptr;

	//srv 힙에서 텍스처에 대한 인덱스. 텍스처가 여러개일 경우 배열로 관리할 수 있다.
	int DiffuseSrvHeapIndex = -1;
};