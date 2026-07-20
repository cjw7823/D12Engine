#include "pch.h"
#include "SceneViewInputHandler.h"

#include "Renderer/DirectX12/SceneRenderer.h"
#include "EngineCore/Scene.h"

SceneViewInputHandler::SceneViewInputHandler(SceneRenderer& sceneRenderer) : mSceneRenderer(sceneRenderer)
{
}

void SceneViewInputHandler::ProcessMouseInput(
    const InputSystem& input,
    const EditorPanelInputState& viewport)
{
    if (!viewport.IsHovered) return;
    if (!viewport.IsFocused) return;

    const POINT mousePosition = input.GetMousePosition(); //클라이언트 좌표
    const POINT mouseDelta = input.GetMouseDelta();

    const int localX = (int)viewport.MouseLocal.x;
    const int localY = (int)viewport.MouseLocal.y;

    Gizmo& gizmo = mSceneRenderer.mGizmo;
    if (input.IsMousePressed(MouseButton::Left))
    {
        if (!gizmo.BeginGizmoDrag(localX, localY)) //내부에서 기즈모 클릭 검사.
        {
            mSceneRenderer.PickRenderItem(localX, localY);
        }
    }

    if (input.IsMouseReleased(MouseButton::Left))
    {
        if (gizmo.IsGizmoDragging()) gizmo.EndGizmoDrag();
    }

    if (input.IsMouseDown(MouseButton::Left))
    {
        if (gizmo.IsGizmoDragging()) gizmo.UpdateGizmoDrag(localX, localY);
    }

    if (input.IsMouseDown(MouseButton::Right))
    {
        mSceneRenderer.RotateCamera(mouseDelta);
    }

    const int wheelDelta = input.GetMouseWheelDelta();
    if (wheelDelta != 0)
    {
        mSceneRenderer.ZoomCamera(wheelDelta);
    }
}

void SceneViewInputHandler::ProcessKeyboardInput(
    const InputSystem& input)
{
    //change render mode
    if (input.IsKeyPressed('1'))
        mSceneRenderer.SetRenderSetting(SceneRenderMode::Lit);
    if (input.IsKeyPressed('2'))
        mSceneRenderer.SetRenderSetting(SceneRenderMode::Wireframe);
    if (input.IsKeyPressed('3'))
        mSceneRenderer.SetRenderSetting(SceneRenderMode::DepthComplexity);
    if (input.IsKeyPressed('4'))
        mSceneRenderer.SetRenderSetting(SceneRenderMode::VertexNormal);
    if (input.IsKeyPressed('5'))
        mSceneRenderer.ToggleSobel();
    if (input.IsKeyPressed('6'))
        mSceneRenderer.NextBlurCount();
    if (input.IsKeyPressed('7') && mChangeMsaaOptionCallback)
        mChangeMsaaOptionCallback();

    //camera move
    const float camMoveSpeed = 10.0f;
    if (input.IsKeyDown('W'))
        mSceneRenderer.MoveCameraForward(camMoveSpeed);
    if (input.IsKeyDown('S'))
        mSceneRenderer.MoveCameraForward(-camMoveSpeed);
    if (input.IsKeyDown('A'))
        mSceneRenderer.MoveCameraRight(-camMoveSpeed);
    if (input.IsKeyDown('D'))
        mSceneRenderer.MoveCameraRight(camMoveSpeed);
    if (input.IsKeyDown('Q'))
        mSceneRenderer.MoveCameraUp(-camMoveSpeed);
    if (input.IsKeyDown('E'))
        mSceneRenderer.MoveCameraUp(camMoveSpeed);

    //sun move
    if (input.IsKeyDown(VK_LEFT))
        mSceneRenderer.MoveSun(-1.0f, 0.0f);
    if (input.IsKeyDown(VK_RIGHT))
        mSceneRenderer.MoveSun(1.0f, 0.0f);
    if (input.IsKeyDown(VK_UP))
        mSceneRenderer.MoveSun(0.0f, -1.0f);
    if (input.IsKeyDown(VK_DOWN))
        mSceneRenderer.MoveSun(0.0f, 1.0f);
}