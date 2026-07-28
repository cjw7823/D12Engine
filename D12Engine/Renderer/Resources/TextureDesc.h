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
