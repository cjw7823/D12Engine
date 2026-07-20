#pragma once

#include "EditorInputRouter.h"
#include <functional>

class SceneRenderer;
class Scene;

class SceneViewInputHandler final : public IEditorInputHandler
{
public:
    using ChangeMsaaOptionCallback = std::function<void()>;
    using BeginRelativeMouseCallback =
        std::function<void(const EditorPanelInputState&)>;
    using EndRelativeMouseCallback =
        std::function<void()>;

    explicit SceneViewInputHandler(SceneRenderer& sceneRenderer);

    void SetScene(Scene* scene) { mScene = scene; }

    void RegistCallback_ChangeMsaaOption(ChangeMsaaOptionCallback func)
    {
        mChangeMsaaOptionCallback = std::move(func);
    }

    void RegisterRelativeMouseCallbacks(
        BeginRelativeMouseCallback beginCallback,
        EndRelativeMouseCallback endCallback)
    {
        mBeginRelativeMouseCallback = std::move(beginCallback);
        mEndRelativeMouseCallback = std::move(endCallback);
    }

    virtual void ProcessMouseInput(
        const InputSystem& input,
        const EditorPanelInputState& viewport) override;

    virtual void ProcessKeyboardInput(const InputSystem& input) override;

private:
    SceneRenderer& mSceneRenderer;
    Scene* mScene = nullptr;
    ChangeMsaaOptionCallback mChangeMsaaOptionCallback;
    BeginRelativeMouseCallback mBeginRelativeMouseCallback;
    EndRelativeMouseCallback mEndRelativeMouseCallback;

    bool mCameraDragging = false;
};