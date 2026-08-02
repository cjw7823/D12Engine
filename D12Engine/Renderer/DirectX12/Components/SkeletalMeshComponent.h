#pragma once

#include "Renderer/DirectX12/Components/MeshComponent.h"
#include "Renderer/Resources/SkeletalMeshAsset.h"

#include <cassert>
#include <cstdint>
#include <unordered_map>

struct SkeletalMeshComponent : public MeshComponent
{
	const SkeletalMeshAsset* Asset = nullptr;
};