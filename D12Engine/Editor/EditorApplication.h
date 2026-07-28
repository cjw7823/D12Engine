#pragma once

#if defined(DEBUG) || defined(_DEBUG)
#define DX12_ENABLE_DEBUG_LAYER
#endif

#include <Windows.h>
#include <filesystem>

#include "Editor/EditorLayer.h"
#include "Editor/ImGuiLayer.h"
#include "Editor/Input/EditorInputRouter.h"
#include "Editor/Input/SceneViewInputHandler.h"

#include "Renderer/DirectX12/D3D12Context.h"
#include "Renderer/DirectX12/SceneRenderer.h"
#include "Renderer/DirectX12/D3D12RenderTarget.h"
#include "Renderer/DirectX12/Scene/Scene.h"

#include "EngineCore/Input/InputSystem.h"
#include "EngineCore/Input/GlobalInputHandler.h"

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
	bool IsActivate() const { return !mAppPaused; }
	bool Initialize();
	int Run();

	LRESULT MsgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

protected:
	bool InitMainWindow();
	void Tick();
	void RouteEditorInput();

	//For Input System
	void BeginRelativeMouseMode(const EditorPanelInputState& viewport);
	void EndRelativeMouseMode();

	void CalculateFrameStats();

private:

private:
	inline static EditorApplication* mApp = nullptr;
	HINSTANCE mhInstance = nullptr;
	HWND mhMainWnd = nullptr;

	std::wstring mMainWndCaption = L"Direct3D 12 App";
	std::wstring mWndClassName = L"MainWnd";
	int mApplicationWidth = 1600;
	int mApplicationHeight = 900;

	D3D12Context mD3D12Context;
	D3D12RenderTarget mSceneRenderTarget;
	ImGuiLayer mImGuiLayer;

	// 의존 대상이므로 가장 먼저 선언
	Scene mActiveScene;

	// mActiveScene을 참조
	SceneRenderer mSceneRenderer;

	// mSceneRenderer를 참조. For InputSystem
	SceneViewInputHandler mSceneViewInputHandler;

	// mActiveScene을 참조
	EditorLayer mEditorLayer;

	//For Massage Proc
	bool mAppPaused = false;

	//For InputSystem
	InputSystem mInputSystem;
	EditorInputRouter mEditorInputRouter;
	GlobalInputHandler mGlobalInputHandler;
	bool mRelativeMouseMode = false;
	POINT mSavedCursorPosition{};
	POINT mMouseAnchorScreen{};
};