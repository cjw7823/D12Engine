#include "pch.h"
#include "Gizmo.h"

InstanceData* Gizmo::GetPrimarySelectedInstance(std::vector<SelectedInstance> instances)
{
	if (instances.empty())
		return nullptr;

	auto& selected = instances[0];

	if (selected.renderItem == nullptr)
		return nullptr;

	if (selected.instanceIndex == UINT_MAX)
		return nullptr;

	if (selected.instanceIndex >= selected.renderItem->Instances.size())
		return nullptr;

	return &selected.renderItem->Instances[selected.instanceIndex];
}
