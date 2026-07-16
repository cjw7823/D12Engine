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
    const POINT mousePosition = input.GetMousePosition();
    const POINT mouseDelta = input.GetMouseDelta();

    const int localX = mousePosition.x - static_cast<int>(viewport.Min.x);
    const int localY = mousePosition.y - static_cast<int>(viewport.Min.y);

    if (input.IsMousePressed(MouseButton::Left))
    {
        //mSceneRenderer.Pick(
        //    mScene,
        //    localX,
        //    localY,
        //    viewport.GetWidth(),
        //    viewport.GetHeight());
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
        mSceneRenderer.mRenderSettings.Mode = SceneRenderMode::Lit;
    if (input.IsKeyPressed('2'))
        mSceneRenderer.mRenderSettings.Mode = SceneRenderMode::Wireframe;
    if (input.IsKeyPressed('3'))
        mSceneRenderer.mRenderSettings.Mode = SceneRenderMode::DepthComplexity;
    if (input.IsKeyPressed('4'))
        mSceneRenderer.mRenderSettings.Mode = SceneRenderMode::VertexNormal;
    if (input.IsKeyPressed('5'))
        mSceneRenderer.mRenderSettings.SobelEnabled = !mSceneRenderer.mRenderSettings.SobelEnabled;
    if (input.IsKeyPressed('6'))
        mSceneRenderer.mRenderSettings.NextBlurCount();
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