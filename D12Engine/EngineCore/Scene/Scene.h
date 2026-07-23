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

	void DestroyObject(SceneObjectID id);

	std::vector<std::unique_ptr<SceneObject>>& GetObjects() { return mObjects; }
	const std::vector<std::unique_ptr<SceneObject>>& GetObjects() const { return mObjects; }

	SceneObject* FindObject(SceneObjectID id);	
	const SceneObject* FindObject(SceneObjectID id) const;

	void SelectObject(SceneObjectID id);
	void ClearSelection();

	SceneObject* GetSelectedObject();
	const SceneObject* GetSelectedObject() const;

	SceneObjectID GetSelectedObjectID() const { return mSelectedObjectId; }

private:
	SceneObjectID GenerateObjectId();

private:
	std::vector<std::unique_ptr<SceneObject>> mObjects;
	SceneObjectID mNextObjectId = 1;
    SceneObjectID mSelectedObjectId = 0;
};