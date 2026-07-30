#pragma once

#include <vector>
#include <string>
#include <cstdint>
#include <memory>

#include "SceneObject.h"

class Scene
{
public:
	SceneObject& CreateObject(const std::wstring& name = L"오브젝트");

	void DestroyObject(SceneObjectId id);

	std::vector<std::unique_ptr<SceneObject>>& GetObjects() { return mObjects; }
	const std::vector<std::unique_ptr<SceneObject>>& GetObjects() const { return mObjects; }

	SceneObject* FindObject(SceneObjectId id);	
	const SceneObject* FindObject(SceneObjectId id) const;

	void SelectObject(std::vector<SceneObjectId> ids);
	void ClearSelection();

	SceneObject* GetSelectedObject(SceneObjectId index);
	const SceneObject* GetSelectedObject(SceneObjectId index) const;

	std::vector<SceneObjectId> GetSelectedObjectIds() const { return mSelectedObjectIds; }

private:
	SceneObjectId GenerateObjectId();

private:
	std::vector<std::unique_ptr<SceneObject>> mObjects;
	SceneObjectId mNextObjectId = 1;
    std::vector<SceneObjectId> mSelectedObjectIds;
};