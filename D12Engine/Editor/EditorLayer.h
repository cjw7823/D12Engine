#pragma once

#include <filesystem>
#include "Editor/SceneViewPanel.h"

//ImGui로 에디터 화면을 그린다.
//ImGui의 생명주기와 백엔드 연결은 ImGuiLayer에서 담당한다.
class EditorLayer
{
public:
    void Initialize();
    void OnImGuiRender();

    SceneViewPanel& GetSceneViewPanel()
    {
        return mSceneViewPanel;
    }

    void SetSceneViewTexture(ImTextureID textureID)
    {
        mSceneViewPanel.SetTexture(textureID);
    }

private:
    void DrawEditorUI();
    void DrawMainDockSpace();
    void DrawMainMenuBar();

    void DrawSceneView();
    void DrawContentBrowser();
    void DrawHierarchy();
    void DrawInspector();
    void DrawConsole();

private:
    std::filesystem::path mProjectRoot = std::filesystem::current_path();
    std::filesystem::path mCurrentDirectory = mProjectRoot;
    std::filesystem::path mSelectedAssetPath;

    SceneViewPanel mSceneViewPanel;

    bool mShowSceneView = true;
    bool mShowContentBrowser = true;
    bool mShowHierarchy = true;
    bool mShowInspector = true;
    bool mShowConsole = true;
    bool mShowDemoWindow = false;
};