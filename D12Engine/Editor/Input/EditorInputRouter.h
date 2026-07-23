#pragma once

#pragma once

#include "EngineCore/Input/InputSystem.h"

struct EditorPanelInputState
{
    bool IsHovered = false;
    bool IsFocused = false;

    ImVec2 Min{};
    ImVec2 Max{};
    
    ImVec2 MouseLocal{}; // 실제 Scene 이미지 내부 로컬 좌표

    int GetWidth() const noexcept
    {
        return static_cast<int>(Max.x - Min.x);
    }

    int GetHeight() const noexcept
    {
        return static_cast<int>(Max.y - Min.y);
    }

    bool HasValidSize() const noexcept
    {
        return GetWidth() > 0 && GetHeight() > 0;
    }
};

struct ImGuiInputCaptureState
{
    bool WantsMouse = false;
    bool WantsKeyboard = false;
    bool WantsTextInput = false;
};

class IEditorInputHandler
{
public:
    virtual ~IEditorInputHandler() = default;

    virtual void ProcessMouseInput(
        const InputSystem& input,
        const EditorPanelInputState& viewport) = 0;

    virtual void ProcessKeyboardInput(const InputSystem& input) = 0;

    virtual void ProcessGlobalShortcuts(const InputSystem& input) {}
};

class EditorInputRouter
{
public:
    void SetGlobalHandler(IEditorInputHandler* handler);
    void SetSceneViewHandler(IEditorInputHandler* handler);
    void SetGameViewHandler(IEditorInputHandler* handler);

    void Route(
        const InputSystem& input,
        const EditorPanelInputState& sceneView,
        const EditorPanelInputState& gameView,
        const ImGuiInputCaptureState& imguiCapture,
        bool isPlayMode);

private:
    IEditorInputHandler* mGlobalHandler = nullptr;
    IEditorInputHandler* mSceneViewHandler = nullptr;
    IEditorInputHandler* mGameViewHandler = nullptr;
};