#pragma once

#include "Renderer/DirectX12/D3D12Context.h"
#include "EngineCore/Math/MathHelper.h"
#include <cstdint>
#include <limits>
#include <filesystem>

enum class TextureColorSpace
{
	Linear,
	SRGB
};

enum class TextureLifetime
{
	Persistent,
	Editor,
	Scene
};

struct TextureLoadDesc
{
	TextureColorSpace ColorSpace = TextureColorSpace::SRGB;
	TextureLifetime Lifetime = TextureLifetime::Scene;

	bool GenerateMips = true;
};

struct Texture
{
	Microsoft::WRL::ComPtr<ID3D12Resource> Resource = nullptr;

	D3D12DescriptorHandle Srv;

	TextureLoadDesc desc;
};

//실제 엔진에서는 Material 클래스 계층 구조로 존재할 수 있다.
struct Material
{
	std::string Name;

	int MatBufferIndex = -1;
	std::filesystem::path DiffuseTexturePath;
	std::filesystem::path NormalTexturePath;

	int NumFramesDirty = RenderConfig::NumFrameResources;

	DirectX::XMFLOAT4 DiffuseAlbedo = { 1.0f, 1.0f, 1.0f, 1.0f };
	DirectX::XMFLOAT3 FresnelR0 = { 0.01f, 0.01f, 0.01f };
	float Roughness = 0.25f;
	DirectX::XMFLOAT4X4 MatTransform = MathHelper::Identity4x4();
};