#include "pch.h"
#include "Scene.h"

#include <algorithm>
#include <cassert>

SceneObject& Scene::CreateObject(const std::wstring& name)
{
    auto object = std::make_unique<SceneObject>();
    object->Id = GenerateObjectId();
    object->Name = name;

    SceneObject& result = *object;
    mObjects.push_back(std::move(object));
    return result;
}

SceneObject& Scene::CreateObjectWithId(SceneObjectId id, const std::wstring& name)
{
    assert(id != 0);
    assert(FindObject(id) == nullptr);

    auto object = std::make_unique<SceneObject>();

    object->Id = id;
    object->Name = name;

    SceneObject& result = *object;

    mObjects.push_back(std::move(object));

    mNextObjectId = std::max(mNextObjectId, id + 1);

    return result;
}

void Scene::Clear()
{
    mObjects.clear();
    mSelectedObjectIds.clear();
    mNextObjectId = 1;
}

void Scene::DestroyObject(SceneObjectId id)
{
    for (auto selectedId : mSelectedObjectIds)
    {
        if (selectedId == id)
        {
            ClearSelection();
            break;
        }
    }

    const auto newEnd = std::remove_if(
        mObjects.begin(),
        mObjects.end(),
        [id](const std::unique_ptr<SceneObject>& object)
        {
            return object && object->Id == id;
        });

    mObjects.erase(newEnd, mObjects.end());
}

SceneObject* Scene::FindObject(SceneObjectId id)
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

const SceneObject* Scene::FindObject(SceneObjectId id) const
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

void Scene::SelectObject(std::vector<SceneObjectId> ids)
{
    ClearSelection();

    for (auto id : ids)
    {
        if (FindObject(id) != nullptr)
        {
            mSelectedObjectIds.push_back(id);
        }
    }
}

void Scene::ClearSelection()
{
    mSelectedObjectIds.clear();
}

SceneObject* Scene::GetSelectedObject(SceneObjectId index)
{
    return FindObject(mSelectedObjectIds[index]);
}

const SceneObject* Scene::GetSelectedObject(SceneObjectId index) const
{
    return FindObject(mSelectedObjectIds[index]);
}

void Scene::Swap(Scene& other) noexcept
{
    using std::swap;

    swap(mObjects, other.mObjects);
    swap(mNextObjectId, other.mNextObjectId);
    swap(mSelectedObjectIds, other.mSelectedObjectIds);
}

SceneObjectId Scene::GenerateObjectId()
{
    return mNextObjectId++;
}
