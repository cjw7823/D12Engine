#include "pch.h"
#include "Scene.h"

#include <algorithm>

SceneObject& Scene::CreateObject(const std::wstring& name)
{
    SceneObject object{};
    object.Id = GenerateObjectId();
    object.Name = name;

    mObjects.push_back(object);
    return mObjects.back();
}

void Scene::DestroyObject(SceneObjectID id)
{
    auto iter = std::remove_if(mObjects.begin(), mObjects.end(), [id](const SceneObject& object){
        return object.Id == id;
    });
}

SceneObject* Scene::FindObject(SceneObjectID id)
{
    for (auto& object : mObjects) {
        if (object.Id == id)
            return &object;
    }

    return nullptr;
}

SceneObjectID Scene::GenerateObjectId()
{
    return mNextObjectId++;
}
