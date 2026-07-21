#include "pch.h"
#include "EditorInputRouter.h"
#include "EngineCore/Logger/Logger.h"

void EditorInputRouter::SetGlobalHandler(IEditorInputHandler* handler)
{
    mGlobalHandler = handler;
}

void EditorInputRouter::SetSceneViewHandler(IEditorInputHandler* handler)
{
    mSceneViewHandler = handler;
}

void EditorInputRouter::SetGameViewHandler(IEditorInputHandler* handler)
{
    mGameViewHandler = handler;
}

void EditorInputRouter::Route(
    const InputSystem& input,
    const EditorPanelInputState& sceneView,
    const EditorPanelInputState& gameView,
    const ImGuiInputCaptureState& imguiCapture,
    bool isPlayMode)
{
    /*
        전역 단축키

        Ctrl+S, Ctrl+Z 같은 입력을 처리한다.
        텍스트 입력 중에는 실행하지 않는다.
    */
    if (mGlobalHandler && !imguiCapture.WantsTextInput)
    {
        mGlobalHandler->ProcessGlobalShortcuts(input);
    }

    /*
        마우스 입력

        Scene/Game View는 ImGui Image로 표시되므로,
        WantCaptureMouse만 보고 차단하면 뷰포트 입력도 차단될 수 있다.
        따라서 뷰포트 Hover 상태를 우선 사용한다.
     */
    if (isPlayMode &&
        gameView.IsHovered &&
        mGameViewHandler)
    {
        mGameViewHandler->ProcessMouseInput(input, gameView);
    }
    else if (sceneView.IsFocused &&
        mSceneViewHandler)
    {
        mSceneViewHandler->ProcessMouseInput(input, sceneView);
    }

    /*
        키보드 입력

        ImGui 텍스트 입력 중이면 Scene/Game View로 전달하지 않는다.
    */
    if (imguiCapture.WantsTextInput) return;

    if (isPlayMode &&
        gameView.IsFocused &&
        mGameViewHandler)
    {
        mGameViewHandler->ProcessKeyboardInput(input);
    }
    else if (sceneView.IsFocused &&
        mSceneViewHandler)
    {
        mSceneViewHandler->ProcessKeyboardInput(input);
    }
}