#pragma once

#include "Renderer/DirectX12/D3D12Context.h"
#include "EngineCore/Math/MathHelper.h"
#include <cstdint>
#include <limits>
#include <filesystem>

struct TextureHandle
{
    static constexpr std::uint32_t InvalidIndex = (std::numeric_limits<std::uint32_t>::max)();

    std::uint32_t Index = InvalidIndex;

    [[nodiscard]]
    bool IsValid() const noexcept
    {
        return Index != InvalidIndex;
    }

    explicit operator bool() const noexcept
    {
        return IsValid();
    }

    friend bool operator==(TextureHandle lhs, TextureHandle rhs) noexcept
    {
        return lhs.Index == rhs.Index;
    }

    friend bool operator!=(TextureHandle lhs, TextureHandle rhs) noexcept
    {
        return !(lhs == rhs);
    }
};

inline constexpr TextureHandle InvalidTextureHandle{};

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

    //현재 TextureManager는 없는 mip을 생성하지 않는다.
	bool GenerateMips = false;
};

struct Texture
{
	Microsoft::WRL::ComPtr<ID3D12Resource> Resource = nullptr;

	D3D12DescriptorHandle Srv;

	TextureLoadDesc Desc;
};
