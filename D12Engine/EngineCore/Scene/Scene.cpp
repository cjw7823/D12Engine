#include "pch.h"
#include "Scene.h"

#include <algorithm>

SceneObject& Scene::CreateObject(const std::wstring& name)
{
    auto object = std::make_unique<SceneObject>();
    object->Id = GenerateObjectId();
    object->Name = name;

    SceneObject& result = *object;
    mObjects.push_back(std::move(object));
    return result;
}

void Scene::DestroyObject(SceneObjectID id)
{
    if (mSelectedObjectId == id)
        ClearSelection();

    const auto newEnd = std::remove_if(
        mObjects.begin(),
        mObjects.end(),
        [id](const std::unique_ptr<SceneObject>& object)
        {
            return object && object->Id == id;
        });

    mObjects.erase(newEnd, mObjects.end());
}

SceneObject* Scene::FindObject(SceneObjectID id)
{
    if (id == 0)
        return nullptr;

    for (const auto& object : mObjects)
    {
        if (object && object->Id == id)
            return object.get();
    }

    return nullptr;

}

const SceneObject* Scene::FindObject(SceneObjectID id) const
{
    if (id == 0)
        return nullptr;

    for (const auto& object : mObjects)
    {
        if (object && object->Id == id)
            return object.get();
    }

    return nullptr;

}

void Scene::SelectObject(SceneObjectID id)
{
    mSelectedObjectId = FindObject(id) ? id : 0;
}

void Scene::ClearSelection()
{
    mSelectedObjectId = 0;
}

SceneObject* Scene::GetSelectedObject()
{
    return FindObject(mSelectedObjectId);
}

const SceneObject* Scene::GetSelectedObject() const
{
    return FindObject(mSelectedObjectId);
}

SceneObjectID Scene::GenerateObjectId()
{
    return mNextObjectId++;
}
