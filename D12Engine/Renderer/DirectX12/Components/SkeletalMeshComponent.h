#pragma once

#include "Renderer/DirectX12/Components/MeshComponent.h"
#include "Renderer/Resources/SkeletalMeshAsset.h"

#include <cassert>
#include <cstdint>
#include <unordered_map>
#include <memory>

struct SkeletalMeshComponent : public MeshComponent
{
	const SkeletalMeshAsset* Asset = nullptr;

	std::unique_ptr<SkinnedModelInstance> mSkinnedModelInstance;

	// mCurrFrameResource::SkinnedDataBuffer 시작 행렬 인덱스
	std::vector<UINT> SkinnedBufferIndices;
};