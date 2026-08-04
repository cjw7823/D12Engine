#pragma once

#include <filesystem>
#include <optional>
#include <DirectXMath.h>
#include <vector>

#include "ImportedTexture.h"

struct Vertex;

using ImportedMaterialIndex = std::uint32_t;
inline constexpr ImportedMaterialIndex InvalidMaterialIndex = (std::numeric_limits<ImportedMaterialIndex>::max)();

struct ImportedMaterial
{
	std::string Name;

	DirectX::XMFLOAT4 BaseColor =
	{
		1.0f, 1.0f, 1.0f, 1.0f
	};

	float Metallic = 0.0f;
	float Roughness = 1.0f;

	ImportedTextureIndex BaseColorTexture = InvalidTextureIndex;
	ImportedTextureIndex NormalTexture = InvalidTextureIndex;
	ImportedTextureIndex MetallicTexture = InvalidTextureIndex;
	ImportedTextureIndex RoughnessTexture = InvalidTextureIndex;
	ImportedTextureIndex EmissiveTexture = InvalidTextureIndex;
};

struct StaticSubmeshData
{
	std::string Name;

	std::vector<Vertex> Vertices;
	std::vector<std::uint32_t> Indices;

	ImportedMaterialIndex MaterialIndex = InvalidMaterialIndex;
};

struct StaticMeshImportResult
{
	std::vector<StaticSubmeshData> Submeshes;
	std::vector<ImportedTexture> Textures;
	std::vector<ImportedMaterial> Materials;
};