#pragma once

#include "EditorInputRouter.h"
#include <functional>

class SceneRenderer;
class Scene;

class SceneViewInputHandler final : public IEditorInputHandler
{
public:
    using ChangeMsaaOptionCallback = std::function<void()>;

    explicit SceneViewInputHandler(SceneRenderer& sceneRenderer);

    void SetScene(Scene* scene) { mScene = scene; }

    void RegistCallback_ChangeMsaaOption(ChangeMsaaOptionCallback func)
    {
        mChangeMsaaOptionCallback = std::move(func);
    }

    virtual void ProcessMouseInput(
        const InputSystem& input,
        const EditorPanelInputState& viewport) override;

    virtual void ProcessKeyboardInput(const InputSystem& input) override;

private:
    SceneRenderer& mSceneRenderer;
    Scene* mScene = nullptr;
    ChangeMsaaOptionCallback mChangeMsaaOptionCallback;
};