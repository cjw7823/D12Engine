#pragma once

#if defined(DEBUG) || defined(_DEBUG)
#define DX12_ENABLE_DEBUG_LAYER
#endif

#include <Windows.h>
#include <filesystem>

#include "EditorLayer.h"
#include "ImGuiLayer.h"

#include "Renderer/DirectX12/D3D12Context.h"
#include "Renderer/DirectX12/SceneRenderer.h"
#include "Renderer/DirectX12/D3D12RenderTarget.h"

#include "EngineCore/Scene.h"
#include "EngineCore/GameTimer.h"

/*
	EditorApplication
	 ├─ D3D12Context        // DX12 실행 환경 1개
	 ├─ ImGuiLayer          // UI 렌더링
	 ├─ EditorLayer         // 에디터 패널
	 ├─ SceneRenderer       // 3D 씬 렌더링
	 └─ D3D12RenderTarget   // SceneView 출력 대상
*/
class EditorApplication
{
public:
	EditorApplication(HINSTANCE hInstance);
	EditorApplication(const EditorApplication& rhs) = delete;
	EditorApplication& operator=(const EditorApplication& rhs) = delete;
	virtual ~EditorApplication();

	static EditorApplication* GetApp() { return mApp; }
	bool Initialize();
	int Run();

	LRESULT MsgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

protected:
	bool InitMainWindow();
	void Tick(const GameTimer& gt);

private:
	inline static EditorApplication* mApp = nullptr;

	HINSTANCE mhInstance = nullptr;
	HWND mhMainWnd = nullptr;

	std::wstring mMainWndCaption = L"Direct3D 12 App";
	std::wstring mWndClassName = L"MainWnd";
	int mClientWidth = 1200;
	int mClientHeight = 900;
	bool mResizing = false;

	D3D12Context mD3D12Context;
	ImGuiLayer mImGuiLayer;
	EditorLayer mEditorLayer;

	Scene mActiveScene;
	SceneRenderer mSceneRenderer;

	D3D12RenderTarget mSceneRenderTarget;

	GameTimer mTimer;
};