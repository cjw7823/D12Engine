#pragma once

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

	int SrvHeapIndex = -1;

	TextureLoadDesc desc;
};