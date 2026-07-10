#pragma once

#include <vector>
#include <string>
#include <cstdint>

#include "SceneObject.h"

class Scene
{
public:
	SceneObject& CreateObject(const std::wstring& name = L"오브젝트");

	void DestroyObject(SceneObjectID id);

	std::vector<SceneObject>& GetObjects() { return mObjects; }
	const std::vector<SceneObject>& GetObjects() const { return mObjects; }

	SceneObject* FindObject(SceneObjectID id);	

private:
	SceneObjectID GenerateObjectId();

private:
	std::vector<SceneObject> mObjects;
	SceneObjectID mNextObjectId = 1;
};