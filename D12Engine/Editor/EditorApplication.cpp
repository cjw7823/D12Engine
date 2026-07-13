#include "pch.h"
#include "EditorApplication.h"
#include "Renderer/Assets/TextureManager.h"

using namespace Microsoft::WRL;

// Win32 메시지 핸들러
// io.WantCaptureMouse 및 io.WantCaptureKeyboard 플래그를 확인하여 Dear ImGui가 현재 입력을 사용하려는지 파악할 수 있습니다.
// - io.WantCaptureMouse가 true인 경우, 마우스 입력 데이터를 메인 애플리케이션으로 전달하지 않거나, 애플리케이션 측의 마우스 데이터 사본을 지우거나 덮어쓰십시오.
// - io.WantCaptureKeyboard가 true인 경우, 키보드 입력 데이터를 메인 애플리케이션으로 전달하지 않거나, 애플리케이션 측의 키보드 데이터 사본을 지우거나 덮어쓰십시오.
// 일반적으로 모든 입력을 Dear ImGui에 전달하되, 이 두 플래그를 기준으로 애플리케이션에는 해당 입력을 전달하지 않도록(숨기도록) 처리할 수 있습니다.
LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	return EditorApplication::GetApp()->MsgProc(hWnd, msg, wParam, lParam);
}

EditorApplication::EditorApplication(HINSTANCE hInstance)
{
	assert(mApp == nullptr);
	mApp = this;
}

EditorApplication::~EditorApplication()
{
}

bool EditorApplication::Initialize()
{
	if (!InitMainWindow())
		return false;

	D3D12ContextDesc ctx{};
	if (!mD3D12Context.Initialize(mhMainWnd, mClientWidth, mClientHeight, ctx))
	{
		::UnregisterClassW(mWndClassName.c_str(), mhInstance);
		return false;
	}

	TextureManager::GetInstance().Initialize(mD3D12Context);

	if (!mImGuiLayer.Initialize(mhMainWnd, mD3D12Context))
		return false;

	mEditorLayer.Initialize();

	mSceneRenderTarget.Create(
		mD3D12Context,
		DXGI_FORMAT_R8G8B8A8_UNORM,
		DXGI_FORMAT_D24_UNORM_S8_UINT);

	if (!mSceneRenderer.Initialize(mD3D12Context))
		return false;

	return true;
}

bool EditorApplication::InitMainWindow()
{
	// 프로세스를 DPI 인식(DPI-aware) 상태로 설정.
	//이 프로그램은 모니터 배율 100%, 125%, 150%, 200% 같은 DPI scaling을 직접 고려할 수 있다. Windows가 강제로 흐릿하게 확대하지 않아도 된다.
	ImGui_ImplWin32_EnableDpiAwareness();

	WNDCLASSEXW wc = {};
	wc.cbSize = sizeof(WNDCLASSEXW);
	wc.style = CS_HREDRAW | CS_VREDRAW; //가로, 세로 크기 변경 시 전체 ReDraw
	wc.lpfnWndProc = WndProc;

	wc.cbClsExtra = 0L; // 윈도우 클래스마다 추가로 확보할 바이트 수
	wc.cbWndExtra = 0L; // 각 윈도우 인스턴스마다 추가로 확보할 바이트 수

	wc.hInstance = mhInstance;
	wc.hIcon = LoadIcon(0, IDI_APPLICATION);
	wc.hIconSm = LoadIcon(0, IDI_APPLICATION);
	wc.hCursor = LoadCursor(0, IDC_ARROW);
	wc.hbrBackground = (HBRUSH)GetStockObject(NULL_BRUSH); //윈도우 배경 설정하지 않음. dx12로 직접 백버퍼를 그릴 것이기 때문.
	wc.lpszClassName = mWndClassName.c_str();
	wc.lpszMenuName = nullptr; //메뉴 없음.

	if (!RegisterClassExW(&wc))
	{
		MessageBox(0, L"RegisterClass 실패.", 0, 0);
		return false;
	}

	RECT R = { 0,0, mClientWidth, mClientHeight };
	AdjustWindowRect(&R, WS_OVERLAPPEDWINDOW, false);
	int width = R.right - R.left;
	int height = R.bottom - R.top;
	mhMainWnd = CreateWindowW(
		wc.lpszClassName,
		mMainWndCaption.c_str(),
		WS_OVERLAPPEDWINDOW,			//윈도우 스타일
		CW_USEDEFAULT, CW_USEDEFAULT,	//윈도우 초기 위치
		width, height,					//윈도우 크기
		nullptr, nullptr, mhInstance, nullptr);

	if (!mhMainWnd)
	{
		MessageBoxW(0, L"CreateWindow 실패.", 0, 0);
		return false;
	}

	ShowWindow(mhMainWnd, SW_SHOWDEFAULT);
	UpdateWindow(mhMainWnd);

	return true;
}

void EditorApplication::Tick(const GameTimer& gt)
{
	ImTextureID sceneTextureId = static_cast<ImTextureID>(mSceneRenderTarget.GetSRVGpu().ptr);
	mEditorLayer.SetSceneViewTexture(sceneTextureId);

	//에디터의 ImGui Frame 구성.
	mImGuiLayer.BeginFrame();
	mEditorLayer.OnImGuiRender();
	mImGuiLayer.EndFrame();

	SceneViewPanel& sceneViewPanel = mEditorLayer.GetSceneViewPanel();
	bool renderSceneView = sceneViewPanel.HasValidSize();
	if (renderSceneView)
	{
		int sceneWidth = sceneViewPanel.GetWidth();
		int sceneHeight = sceneViewPanel.GetHeight();

		if (mSceneRenderTarget.GetWidth() != sceneWidth ||
			mSceneRenderTarget.GetHeight() != sceneHeight)
		{
			mSceneRenderTarget.Resize(mD3D12Context, sceneWidth, sceneHeight);
		}
	}

	mD3D12Context.BeginFrame();

	if (renderSceneView)
	{
		mSceneRenderTarget.Clear(mD3D12Context);
		//mSceneRenderer.Render(mD3D12Context, mSceneRenderTarget, mActiveScene);
	}

	//렌더링
	const float clearColor[4] = { 0.1f, 0.1f, 0.1f, 1.0f };
	mD3D12Context.BeginBackBufferRenderPass(clearColor);
	mImGuiLayer.RenderDrawData(mD3D12Context);

	mD3D12Context.EndFrame();
}

int EditorApplication::Run()
{
	MSG msg{};

	mTimer.Reset();

	while (msg.message != WM_QUIT)
	{
		if (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		else
		{
			mTimer.Tick();
			Tick(mTimer);
		}
	}

	mD3D12Context.FlushCommandQueue();

	mSceneRenderTarget.Shutdown(mD3D12Context);

	mImGuiLayer.Shutdown();

	::DestroyWindow(mhMainWnd);
	::UnregisterClassW(mWndClassName.c_str(), mhInstance);

	return static_cast<int>(msg.wParam);
}

LRESULT EditorApplication::MsgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	static bool mResizing = false;

	if (mImGuiLayer.WndProcHandler(hWnd, msg, wParam, lParam))
		return true;

	switch (msg)
	{
	case WM_SIZE:
		mClientWidth = LOWORD(lParam);
		mClientHeight = HIWORD(lParam);
		if (mD3D12Context.GetDevice() && wParam != SIZE_MINIMIZED && !mResizing)
			mD3D12Context.ResizeSwapChain(mClientWidth, mClientHeight);
		return 0;
	case WM_ENTERSIZEMOVE:
		mResizing = true;
		return 0;
	case WM_EXITSIZEMOVE:
		mResizing = false;
		mD3D12Context.ResizeSwapChain(mClientWidth, mClientHeight);
		return 0;
	case WM_SYSCOMMAND:
		if ((wParam & 0xfff0) == SC_KEYMENU) // Disable ALT application menu
			return 0;
		break;
	case WM_DESTROY:
		::PostQuitMessage(0);
		return 0;
	}
	return ::DefWindowProcW(hWnd, msg, wParam, lParam);
}
