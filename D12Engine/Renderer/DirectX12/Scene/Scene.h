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

	void SelectObject(SceneObjectId id);
	void ClearSelection();

	SceneObject* GetSelectedObject();
	const SceneObject* GetSelectedObject() const;

	SceneObjectId GetSelectedObjectID() const { return mSelectedObjectId; }

private:
	SceneObjectId GenerateObjectId();

private:
	std::vector<std::unique_ptr<SceneObject>> mObjects;
	SceneObjectId mNextObjectId = 1;
    SceneObjectId mSelectedObjectId = 0;
};