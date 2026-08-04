#pragma once

#include <string>
#include <filesystem>
#include <DirectXMath.h>

#include "EngineCore/GlobalConfig.h"
#include "EngineCore/Math/MathHelper.h"

#include "Renderer/Resources/TextureDesc.h"

inline constexpr std::uint32_t InvalidMaterialBufferIndex = (std::numeric_limits<std::uint32_t>::max)();

//실제 엔진에서는 Material 클래스 계층 구조로 존재할 수 있다.
struct Material
{
	std::string Name;

	std::uint32_t MatBufferIndex = InvalidMaterialBufferIndex;
	TextureHandle DiffuseTextureHandle = InvalidTextureHandle;
	TextureHandle NormalTextureHandle = InvalidTextureHandle;

	int NumFramesDirty = GlobalConfig::NumFrameResources;

	DirectX::XMFLOAT4 DiffuseAlbedo = { 1.0f, 1.0f, 1.0f, 1.0f };
	DirectX::XMFLOAT3 FresnelR0 = { 0.01f, 0.01f, 0.01f };
	float Roughness = 0.25f;
	DirectX::XMFLOAT4X4 MatTransform = MathHelper::Identity4x4();
};