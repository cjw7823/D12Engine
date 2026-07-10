#pragma once

#if defined(DEBUG) || defined(_DEBUG)
#define DX12_ENABLE_DEBUG_LAYER
#endif

#include <Windows.h>
#include <filesystem>

#include "Renderer/DirectX12/D3D12Context.h"
#include "EditorLayer.h"

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
	void Tick();

	bool InitImGui();

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
	EditorLayer mEditorLayer;
};