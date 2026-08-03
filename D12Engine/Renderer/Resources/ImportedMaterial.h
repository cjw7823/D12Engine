#pragma once

#include <filesystem>
#include <optional>
#include <DirectXMath.h>
#include <vector>

struct Vertex;

using ImportedMaterialIndex = std::uint32_t;
inline constexpr ImportedMaterialIndex InvalidMaterialIndex = (std::numeric_limits<ImportedMaterialIndex>::max)();

struct ImportedTextureInfo
{
	std::filesystem::path FilePath;
};

struct ImportedMaterial
{
	std::string Name;

	DirectX::XMFLOAT4 BaseColor =
	{
		1.0f, 1.0f, 1.0f, 1.0f
	};

	float Metallic = 0.0f;
	float Roughness = 1.0f;

	std::optional<ImportedTextureInfo> BaseColorTexture;
	std::optional<ImportedTextureInfo> NormalTexture;
	std::optional<ImportedTextureInfo> MetallicTexture;
	std::optional<ImportedTextureInfo> RoughnessTexture;
	std::optional<ImportedTextureInfo> EmissiveTexture;
};

struct StaticSubmeshData
{
	std::string Name;

	std::vector<Vertex> Vertices;
	std::vector<std::uint32_t> Indices;

	std::uint32_t ImportedMaterialIndex = InvalidMaterialIndex;
};

struct StaticMeshImportResult
{
	std::vector<StaticSubmeshData> Submeshes;
	std::vector<ImportedMaterial> Materials;
};