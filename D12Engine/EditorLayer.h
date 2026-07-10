#pragma once

#include <filesystem>

class EditorLayer
{
public:
    void Initialize();
    void OnImGuiRender();

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

    bool mShowSceneView = true;
    bool mShowContentBrowser = true;
    bool mShowHierarchy = true;
    bool mShowInspector = true;
    bool mShowConsole = true;
    bool mShowDemoWindow = false;
};