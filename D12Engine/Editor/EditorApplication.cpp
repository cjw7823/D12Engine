#include "pch.h"
#include "EditorApplication.h"
#include "Renderer/Resources/TextureManager.h"
#include "Renderer/DirectX12/Scene/SceneSerializer.h"

#include <array>
#include <optional>
#include <system_error>
#include <commdlg.h>

#pragma comment(lib, "Comdlg32.lib")

using namespace Microsoft::WRL;

namespace
{
	constexpr wchar_t SceneFileFilter[] =
		L"D12 Scene (*.d12scene)\0*.d12scene\0"
		L"All Files (*.*)\0*.*\0\0";

	std::optional<std::filesystem::path> ShowSceneFileDialog(
		HWND owner,
		const std::filesystem::path& currentPath,
		bool saveDialog)
	{
		std::array<wchar_t, 32768> fileBuffer{};

		std::wstring initialFileName = currentPath.filename().wstring();
		if (initialFileName.empty())
			initialFileName = L"Main.d12scene";

		wcsncpy_s(
			fileBuffer.data(),
			fileBuffer.size(),
			initialFileName.c_str(),
			_TRUNCATE);

		std::wstring initialDirectory;

		if (!currentPath.parent_path().empty())
		{
			std::error_code error;
			const std::filesystem::path absoluteDirectory =
				std::filesystem::absolute(currentPath.parent_path(), error);

			initialDirectory = error
				? currentPath.parent_path().wstring()
				: absoluteDirectory.wstring();
		}

		OPENFILENAMEW dialog{};
		dialog.lStructSize = sizeof(dialog);
		dialog.hwndOwner = owner;
		dialog.lpstrFilter = SceneFileFilter;
		dialog.lpstrFile = fileBuffer.data();
		dialog.nMaxFile = static_cast<DWORD>(fileBuffer.size());
		dialog.lpstrInitialDir = initialDirectory.empty() ? nullptr : initialDirectory.c_str();
		dialog.lpstrDefExt = L"d12scene";
		dialog.Flags =
			OFN_EXPLORER |
			OFN_NOCHANGEDIR |
			OFN_PATHMUSTEXIST |
			OFN_HIDEREADONLY;

		if (saveDialog)
			dialog.Flags |= OFN_OVERWRITEPROMPT;
		else
			dialog.Flags |= OFN_FILEMUSTEXIST;

		const BOOL accepted = saveDialog
			? GetSaveFileNameW(&dialog)
			: GetOpenFileNameW(&dialog);

		if (!accepted)
			return std::nullopt;

		return std::filesystem::path(fileBuffer.data());
	}
}

// Win32 메시지 핸들러
// io.WantCaptureMouse 및 io.WantCaptureKeyboard 플래그를 확인하여 Dear ImGui가 현재 입력을 사용하려는지 파악할 수 있습니다.
// - io.WantCaptureMouse가 true인 경우, 마우스 입력 데이터를 메인 애플리케이션으로 전달하지 않거나, 애플리케이션 측의 마우스 데이터 사본을 지우거나 덮어쓰십시오.
// - io.WantCaptureKeyboard가 true인 경우, 키보드 입력 데이터를 메인 애플리케이션으로 전달하지 않거나, 애플리케이션 측의 키보드 데이터 사본을 지우거나 덮어쓰십시오.
// 일반적으로 모든 입력을 Dear ImGui에 전달하되, 이 두 플래그를 기준으로 애플리케이션에는 해당 입력을 전달하지 않도록(숨기도록) 처리할 수 있습니다.
LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	return EditorApplication::GetApp()->MsgProc(hWnd, msg, wParam, lParam);
}

EditorApplication::EditorApplication(HINSTANCE hInstance) :
	mActiveScene(),
	mSceneRenderer(mActiveScene),
	mSceneViewInputHandler(mSceneRenderer),
	mEditorLayer(mActiveScene, mSceneRenderer)
{
	assert(mApp == nullptr);
	mApp = this;

	mEditorInputRouter.SetGlobalHandler(&mGlobalInputHandler);
	mEditorInputRouter.SetSceneViewHandler(&mSceneViewInputHandler);
}

EditorApplication::~EditorApplication()
{
}

bool EditorApplication::Initialize()
{
	if (!InitMainWindow())
		return false;

	D3D12ContextDesc ctx{};
	if (!mD3D12Context.Initialize(mhMainWnd, mApplicationWidth, mApplicationHeight, ctx))
	{
		::UnregisterClassW(mWndClassName.c_str(), mhInstance);
		return false;
	}

	TextureManager::GetInstance().Initialize(mD3D12Context);

	mSceneViewInputHandler.RegistCallback_ChangeMsaaOption(
		[this]()
		{
			mD3D12Context.mMsaaOption.Next();
			mSceneRenderTarget.Resize(mD3D12Context, mApplicationWidth, mApplicationHeight);
			mSceneRenderer.ChangeMsaa(mD3D12Context);
		});
	mSceneViewInputHandler.RegisterRelativeMouseCallbacks(
		[this](const EditorPanelInputState& viewport)
		{
			BeginRelativeMouseMode(viewport);
		},
		[this]()
		{
			EndRelativeMouseMode();
		});

	if (!mImGuiLayer.Initialize(mhMainWnd, mD3D12Context))
		return false;

	mEditorLayer.Initialize();
	mEditorLayer.RegisterSceneCommands(
		[this](bool AsDiffName)
		{
			SaveActiveScene(AsDiffName);
		},
		[this]()
		{
			LoadActiveScene();
		});
	mEditorLayer.RegisterAssetOpenCommand(
		[this](const std::filesystem::path& path)
		{
			OpenAsset(path);
		});

	mSceneRenderTarget.Create(
		mD3D12Context,
		DXGI_FORMAT_R8G8B8A8_UNORM,
		DXGI_FORMAT_D24_UNORM_S8_UINT);

	mD3D12Context.BeginFrame();
	if (!mSceneRenderer.Initialize(
			mD3D12Context, 
			mSceneRenderTarget.GetColorFormat(),
			mSceneRenderTarget.GetDepthFormat()))
		return false;

	mD3D12Context.EndFrame();

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

	RECT R = { 0,0, mApplicationWidth, mApplicationHeight };
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

void EditorApplication::Tick()
{
	CalculateFrameStats();

	ImTextureID sceneTextureId = static_cast<ImTextureID>(mSceneRenderTarget.GetSceneViewSRVGpu().ptr);
	mEditorLayer.SetSceneViewTexture(sceneTextureId);

	//에디터의 ImGui UI 렌더링
	mImGuiLayer.BeginFrame();
	mEditorLayer.OnImGuiRender();
	// OnImGuiRender에서 Scene View의 Hover/Focus/영역이 결정된 뒤 입력 분배
	RouteEditorInput();
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
			mSceneRenderer.OnResize(mD3D12Context, mSceneRenderTarget);
		}
	}

	if (mPendingFbxPath)
		mD3D12Context.FlushCommandQueue();

	mD3D12Context.BeginFrame();

	if (mPendingFbxPath)
	{
		mSceneRenderer.AddFbxToScene(mD3D12Context, *mPendingFbxPath);
		mPendingFbxPath.reset();
	}

	if (renderSceneView)
	{
		mSceneRenderTarget.Clear(mD3D12Context);
		mSceneRenderer.Tick(mD3D12Context, mSceneRenderTarget, mActiveScene);
	}

	//렌더링
	mD3D12Context.BeginBackBufferRenderPass();
	mImGuiLayer.RenderDrawData(mD3D12Context);

	mD3D12Context.EndFrame();
}

void EditorApplication::RouteEditorInput()
{
	const ImGuiIO& io = ImGui::GetIO();

	const ImGuiInputCaptureState capture
	{
		io.WantCaptureMouse,
		io.WantCaptureKeyboard,
		io.WantTextInput
	};

	mEditorInputRouter.Route(
		mInputSystem,
		mEditorLayer.GetSceneViewPanel().GetInputState(),
		mEditorLayer.GetGameViewPanel().GetInputState(),
		capture,
		mEditorLayer.IsPlayMode());
}

void EditorApplication::BeginRelativeMouseMode(const EditorPanelInputState& viewport)
{
	if (mRelativeMouseMode)
		return;

	mRelativeMouseMode = true;

	// 드래그 종료 시 복구할 위치
	::GetCursorPos(&mSavedCursorPosition);

	// 씬 뷰 중앙 기준.
	mMouseAnchorScreen =
	{
		static_cast<LONG>((viewport.Min.x + viewport.Max.x) * 0.5f),
		static_cast<LONG>((viewport.Min.y + viewport.Max.y) * 0.5f)
	};

	//마우스 커서가 창 밖으로 나가도 마우스 메시지 유지.
	::SetCapture(mhMainWnd);

	// ShowCursor는 내부 카운터 방식이므로 실제로 숨겨질 때까지 감소
	while (::ShowCursor(FALSE) >= 0)
	{
	}

	::SetCursorPos(mMouseAnchorScreen.x, mMouseAnchorScreen.y);

	mInputSystem.ResetMouseMotion();
}

void EditorApplication::EndRelativeMouseMode()
{
	if (!mRelativeMouseMode)
		return;

	mRelativeMouseMode = false;

	if (::GetCapture() == mhMainWnd)
		::ReleaseCapture();

	// 드래그 시작 전 위치로 복원
	::SetCursorPos(mSavedCursorPosition.x, mSavedCursorPosition.y);

	// 실제로 표시 상태가 될 때까지 카운터 증가
	while (::ShowCursor(TRUE) < 0)
	{
	}

	mInputSystem.ResetMouseMotion();
}

void EditorApplication::CalculateFrameStats()
{
	static int frameCount = 0;
	static double timeElapsed = 0.0;

	frameCount++;

	double currTime = mSceneRenderer.mTimer.TotalTime();
	double elapsedTime = currTime - timeElapsed;

	if (elapsedTime >= 1.0)
	{
		float fps = static_cast<float>(frameCount / elapsedTime);
		float mspf = 1000.0f / fps;

		std::wstring fpsStr = std::to_wstring(fps);
		std::wstring mspfStr = std::to_wstring(mspf);

		std::wstring windowText =
			mMainWndCaption +
			L" fps: " + fpsStr +
			L" mspf: " + mspfStr;

		SetWindowText(mhMainWnd, windowText.c_str());

		frameCount = 0;
		timeElapsed = currTime;
	}
}

void EditorApplication::OpenAsset(const std::filesystem::path& path)
{
	const auto ext = path.extension();

	if (ext == L".d12scene")
	{
		LoadScene(path);
	}
	else if (ext == L".fbx")
	{
		mPendingFbxPath = path;
	}
}

bool EditorApplication::SaveActiveScene(bool AsDiffName)
{
	std::optional<std::filesystem::path> selectedPath;
	if (AsDiffName)
	{
		selectedPath = ShowSceneFileDialog(mhMainWnd, mActiveScenePath, true);
		if (!selectedPath) return false;
	}
	else
		selectedPath = mActiveScenePath;

	const bool succeeded = SceneSerializer::Save(mActiveScene, *selectedPath);

	if (!succeeded)
	{
		MessageBoxW(mhMainWnd, L"Scene 파일 저장에 실패했습니다.", L"Save Scene", MB_OK | MB_ICONERROR);
		return false;
	}

	mActiveScenePath = *selectedPath;

	MessageBoxW(mhMainWnd, mActiveScenePath.c_str(), L"Scene 저장 완료", MB_OK | MB_ICONINFORMATION);
	return true;
}

bool EditorApplication::LoadActiveScene()
{
	const auto selectedPath = ShowSceneFileDialog(mhMainWnd, mActiveScenePath, false);
	if (!selectedPath) return false;

	return LoadScene(*selectedPath);
}

bool EditorApplication::LoadScene(const std::filesystem::path& path)
{
	Scene loadedScene;

	if (!SceneSerializer::Load(loadedScene, path))
	{
		MessageBoxW(mhMainWnd, L"Scene 파일을 읽지 못했습니다.", L"Load Scene", MB_OK | MB_ICONERROR);
		return false;
	}

	if (!mSceneRenderer.ResolveSceneResources(loadedScene))
	{
		MessageBoxW(mhMainWnd, L"Scene 리소스 연결에 실패했습니다.", L"Load Scene", MB_OK | MB_ICONERROR);
		return false;
	}

	mD3D12Context.FlushCommandQueue();

	mActiveScene.Swap(loadedScene);
	mSceneRenderer.RebuildSceneRuntime(mD3D12Context);

	mActiveScenePath = path;

	return true;
}

int EditorApplication::Run()
{
	MSG msg{};
	bool running = true;

	while (running)
	{
		mInputSystem.BeginFrame();

		while (::PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE))
		{
			if (msg.message == WM_QUIT)
			{
				running = false;
				break;
			}

			::TranslateMessage(&msg);
			::DispatchMessage(&msg);
		}

		if (!running) break;

		if (IsActivate()) Tick();
		else ::WaitMessage(); //Sleep(100);
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

	mImGuiLayer.WndProcHandler(hWnd, msg, wParam, lParam);

	switch (msg)
	{
	case WM_ACTIVATE:
		if (LOWORD(wParam) == WA_INACTIVE)
		{
			mAppPaused = true;
			mInputSystem.Reset();
			EndRelativeMouseMode();
		}
		else
			mAppPaused = false;
		return 0;

	case WM_SIZE:
		//드래그 중 WM_SIZE 메시지가 계속 발생. 체크 후 OnResize 호출방지.
		// SetWindowPos 등의 API호출로도 발생.
		mApplicationWidth = LOWORD(lParam);
		mApplicationHeight = HIWORD(lParam);
		if (mD3D12Context.IsInitialized() && wParam != SIZE_MINIMIZED && !mResizing)
			mD3D12Context.ResizeSwapChain(mApplicationWidth, mApplicationHeight);
		return 0;

	case WM_ENTERSIZEMOVE:
		mResizing = true;
		mAppPaused = true;
		return 0;
	case WM_EXITSIZEMOVE:
		mResizing = false;
		mAppPaused = false;
		if (mD3D12Context.IsInitialized())
			mD3D12Context.ResizeSwapChain(mApplicationWidth, mApplicationHeight);
		return 0;
	case WM_GETMINMAXINFO:
		reinterpret_cast<MINMAXINFO*>(lParam)->ptMinTrackSize.x = 200;
		reinterpret_cast<MINMAXINFO*>(lParam)->ptMinTrackSize.y = 200;
		return 0;

	case WM_MENUCHAR:
		// 유효하지 않은 메뉴 니모닉 입력 시 메뉴를 닫고 비프음을 방지한다.
		return MAKELRESULT(0, MNC_CLOSE);

	case WM_SYSCOMMAND:
		// Alt 또는 F10으로 Windows 메뉴 모드에 진입하는 것을 막는다.
		if ((wParam & 0xFFF0) == SC_KEYMENU)
			return 0;
		break;

	case WM_LBUTTONDOWN:
		mInputSystem.OnMouseButtonDown(MouseButton::Left);
		return 0;
	case WM_LBUTTONUP:
		mInputSystem.OnMouseButtonUp(MouseButton::Left);
		return 0;
	case WM_RBUTTONDOWN:
		mInputSystem.OnMouseButtonDown(MouseButton::Right);
		return 0;
	case WM_RBUTTONUP:
		mInputSystem.OnMouseButtonUp(MouseButton::Right);
		return 0;
	case WM_MBUTTONDOWN:
		mInputSystem.OnMouseButtonDown(MouseButton::Middle);
		return 0;
	case WM_MBUTTONUP:
		mInputSystem.OnMouseButtonUp(MouseButton::Middle);
		return 0;

	case WM_MOUSEMOVE:
	{
		//클라이언트 좌표
		const int x = GET_X_LPARAM(lParam);
		const int y = GET_Y_LPARAM(lParam);

		if (!mRelativeMouseMode)
		{
			mInputSystem.OnMouseMove(x, y);
			return 0;
		}

		POINT position{ x, y };
		::ClientToScreen(hWnd, &position);

		const int deltaX = position.x - mMouseAnchorScreen.x;
		const int deltaY = position.y - mMouseAnchorScreen.y;

		if (deltaX != 0 || deltaY != 0)
		{
			mInputSystem.OnMouseDelta(deltaX, deltaY);
			::SetCursorPos(mMouseAnchorScreen.x, mMouseAnchorScreen.y);
		}

		return 0;
	}

	case WM_MOUSEWHEEL:
	{
		//스크린 좌표 -> 클라이언트 좌표 변경
		POINT position
		{
			GET_X_LPARAM(lParam),
			GET_Y_LPARAM(lParam)
		};
		::ScreenToClient(hWnd, &position);
		mInputSystem.OnMouseMove(position.x, position.y);
		mInputSystem.OnMouseWheel(GET_WHEEL_DELTA_WPARAM(wParam));
		return 0;
	}

	case WM_KEYDOWN:
		mInputSystem.OnKeyDown(wParam);
		return 0;
	case WM_KEYUP:
		mInputSystem.OnKeyUp(wParam);
		return 0;

	case WM_DESTROY:
		::PostQuitMessage(0);
		return 0;
	}
	return ::DefWindowProcW(hWnd, msg, wParam, lParam);
}