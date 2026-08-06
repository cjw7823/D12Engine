#pragma once

#include <string>
#include <cstdint>
#include <memory>
#include <utility>

#include "Renderer/DirectX12/Components/IComponent.h"
#include "Renderer/DirectX12/Components/TransformComponent.h"
#include "Renderer/DirectX12/Components/StaticMeshComponent.h"
#include "Renderer/Resources/RenderData.h"
#include "Renderer/Resources/TextureDesc.h"

enum SceneObjectFlags
{
    None = 0,
    HideInHierarchy = 1 << 0,
    NotSelectable = 1 << 1,
    EditorOnly = 1 << 2,

    Transient = 1 << 3, // 저장되지 않고 씬 활성화 시 다시 생성
};

using SceneObjectId = std::uint64_t;
class SceneObject
{
public:
    template<typename T, typename... Args>
    T& AddComponent(Args&&... args)
    {
        static_assert(std::is_base_of_v<IComponent, T>,
            "T must derive from IComponent.");

        auto component = std::make_unique<T>(std::forward<Args>(args)...);
        T& result = *component;
        mComponents.push_back(std::move(component));

        return result;
    }

    template<typename T>
    T* GetComponent()
    {
        static_assert(std::is_base_of_v<IComponent, T>,
            "T must derive from IComponent.");

        for (auto& component : mComponents)
        {
            if (auto* result = dynamic_cast<T*>(component.get()))
                return result;
        }

        return nullptr;
    }

    template<typename T>
    const T* GetComponent() const
    {
        static_assert(std::is_base_of_v<IComponent, T>,
            "T must derive from IComponent.");

        for (const auto& component : mComponents)
        {
            if (const auto* result =
                dynamic_cast<const T*>(component.get()))
            {
                return result;
            }
        }

        return nullptr;
    }

    bool HasFlag(SceneObjectFlags flag) const
    {
        return (mObjectFlags & flag) != SceneObjectFlags::None;
    }

public:
	SceneObjectId Id = 0;
	std::wstring Name = L"오브젝트";

    //유일한 Transform원본이어야 함.
    TransformComponent Transform;

    //계층 구조
    SceneObjectId ParentId = 0;
    std::vector<SceneObjectId> Children;

    bool Visible = true;
    bool FrustumVisible = true;

    SceneObjectFlags mObjectFlags = SceneObjectFlags::None;

private:
    //하나의 객체가 여러 서브메시를 가질 수 있음.
    std::vector<std::unique_ptr<IComponent>> mComponents;

    //Skinned 객체일 때만 소유.
    //std::unique_ptr<SkinnedModelInstance> SkinnedInstance;
};