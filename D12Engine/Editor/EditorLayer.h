#pragma once

#include <filesystem>
#include <functional>

#include "Editor/Panels/SceneViewPanel.h"
#include "Editor/Panels/ConsolePanel.h"

#include "Renderer/DirectX12/Scene/SceneRenderer.h"

//ImGui로 에디터 화면을 그린다.
//ImGui의 생명주기와 백엔드 연결은 ImGuiLayer에서 담당한다.
class EditorLayer
{
public:
    void RegisterSceneCommands(std::function<void(bool)> saveSceneCommand, std::function<void()> loadSceneCommand);
public:
    explicit EditorLayer(Scene& scene);

    void Initialize();
    void OnImGuiRender();

    SceneViewPanel& GetSceneViewPanel() noexcept { return mSceneViewPanel; }
    SceneViewPanel& GetGameViewPanel() noexcept { return mSceneViewPanel; }
    bool IsPlayMode() const noexcept { return mIsPlay; }

    void SetSceneViewTexture(ImTextureID textureID);
private:
    void DrawEditorUI();
    void DrawMainDockSpace();
    void DrawMainMenuBar();

    void DrawSceneView();
    void DrawContentBrowser();
    void DrawHierarchy();
    void DrawInspector();
    void DrawTransformInspector(SceneObject& object);
    void DrawMaterialInspector(SceneObject& object);

    void DrawHelper();

private:
    std::filesystem::path mResourcesRoot = std::filesystem::current_path() / "Resource";
    std::filesystem::path mCurrentDirectory = mResourcesRoot;
    std::filesystem::path mSelectedAssetPath;

    SceneViewPanel mSceneViewPanel;
    ConsolePanel mConsolePanel;

    bool mShowSceneView = true;
    bool mShowContentBrowser = true;
    bool mShowHierarchy = true;
    bool mShowInspector = true;
    bool mShowConsole = true;
    bool mHelpWindow = false;

    bool mIsPlay = false;
    bool mInitialFocusApplied = false;

    Scene& mScene;

    std::function<void(bool)> mSaveSceneCommand;
    std::function<void()> mLoadSceneCommand;
};