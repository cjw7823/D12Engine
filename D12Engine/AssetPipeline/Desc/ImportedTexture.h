#pragma once

#include <cstdint>
#include <filesystem>
#include <limits>
#include <string>
#include <vector>

using ImportedTextureIndex = std::uint32_t;
inline constexpr ImportedTextureIndex InvalidTextureIndex = (std::numeric_limits<ImportedTextureIndex>::max)();

enum class ImportedTextureSource
{
    ExternalFile,
    Embedded,
	NotTextureFile, // FBX에서 Shader/Layered Texture 등 실제 이미지 데이터가 아닌 경우
};

struct ImportedTexture
{
    std::string Name;

    // 확장자 및 디버깅 정보 보존용
    std::filesystem::path OriginalFileName;

    ImportedTextureSource Source = ImportedTextureSource::ExternalFile;

    // ExternalFile일 때 사용
    std::filesystem::path FilePath;

    // Embedded일 때 사용
    // PNG/JPG/DDS 등의 인코딩된 원본 이미지 데이터
    std::vector<std::uint8_t> EncodedData;
};