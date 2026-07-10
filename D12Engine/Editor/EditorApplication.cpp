#include "pch.h"
#include "EditorApplication.h"

using namespace Microsoft::WRL;

// Forward declare message handler from imgui_impl_win32.cpp
extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

// Win32 메시지 핸들러
// io.WantCaptureMouse 및 io.WantCaptureKeyboard 플래그를 확인하여 Dear ImGui가 현재 입력을 사용하려는지 파악할 수 있습니다.
// - io.WantCaptureMouse가 true인 경우, 마우스 입력 데이터를 메인 애플리케이션으로 전달하지 않거나, 애플리케이션 측의 마우스 데이터 사본을 지우거나 덮어쓰십시오.
// - io.WantCaptureKeyboard가 true인 경우, 키보드 입력 데이터를 메인 애플리케이션으로 전달하지 않거나, 애플리케이션 측의 키보드 데이터 사본을 지우거나 덮어쓰십시오.
// 일반적으로 모든 입력을 Dear ImGui에 전달하되, 이 두 플래그를 기준으로 애플리케이션에는 해당 입력을 전달하지 않도록(숨기도록) 처리할 수 있습니다.
LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	//ImGui가 OS 입력을 자동 후킹하는 구조는 아님.
	//WndProc에서 ImGui_ImplWin32_WndProcHandler()로 메시지를 전달함.
	//ImGui는 그 메시지로 내부 입력 상태를 갱신함.
	//io.WantCaptureMouse / io.WantCaptureKeyboard는 "ImGui가 이 입력을 쓰고 싶다"는 상태 플래그임.
	//그 플래그를 보고 네 앱 입력 처리를 막는 것은 네가 직접 해야 함.
	//또한 모든 메시지를 처리하지 않고 일부 메시지는 직접 처리해야 함. ex)WM_SIZE

	if (ImGui_ImplWin32_WndProcHandler(hWnd, msg, wParam, lParam))
		return true;

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

	if (!mD3D12Context.Initialize(mhMainWnd, mClientWidth, mClientHeight))
	{
		::UnregisterClassW(mWndClassName.c_str(), mhInstance);
		return false;
	}

	if (!InitImGui())
		return false;

	mEditorLayer.Initialize();

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

void EditorApplication::Tick()
{
	mD3D12Context.BeginFrame();

	ImGui_ImplDX12_NewFrame();
	ImGui_ImplWin32_NewFrame();
	ImGui::NewFrame();

	mEditorLayer.OnImGuiRender();

	ImGui::Render();

	mD3D12Context.RenderImGuiDrawData(ImGui::GetDrawData());

	mD3D12Context.EndFrame();
}

bool EditorApplication::InitImGui()
{
	IMGUI_CHECKVERSION();

	// 폰트 로드
	// - 폰트를 명시적으로 로드하지 않으면 Dear ImGui가 내장 폰트를 선택한다.
	//   선택되는 폰트는 AddFontDefaultVector() 또는 AddFontDefaultBitmap() 중 하나다.
	//   이 선택은 (style.FontSizeBase * style.FontScaleMain * style.FontScaleDpi) 값이
	//   작은 임계값에 도달하는지에 따라 결정된다.
	//
	// - 여러 폰트를 로드할 수 있으며,
	//   ImGui::PushFont() / ImGui::PopFont()를 사용해서 사용할 폰트를 선택할 수 있다.
	//
	// - 파일을 로드할 수 없으면 AddFont 계열 함수는 nullptr를 반환한다.
	//   이 경우 assert를 걸거나, 오류를 표시하고 종료하는 식으로 직접 처리해야 한다.
	//
	// - 더 자세한 설명은 docs/FONTS.md를 참고한다.
	//
	// - 더 높은 품질의 폰트 렌더링을 위해 FreeType을 사용하려면
	//   imconfig 파일에 #define IMGUI_ENABLE_FREETYPE 를 정의한다.
	//
	// - C/C++ 문자열 리터럴에서 백슬래시 '\'를 포함하려면
	//   '\\'처럼 백슬래시를 두 번 써야 한다.
	//
	// style.FontSizeBase = 20.0f;
	// io.Fonts->AddFontDefaultVector();
	// io.Fonts->AddFontDefaultBitmap();
	// io.Fonts->AddFontFromFileTTF("c:\\Windows\\Fonts\\segoeui.ttf");
	// io.Fonts->AddFontFromFileTTF("../../misc/fonts/DroidSans.ttf");
	// io.Fonts->AddFontFromFileTTF("../../misc/fonts/Roboto-Medium.ttf");
	// io.Fonts->AddFontFromFileTTF("../../misc/fonts/Cousine-Regular.ttf");
	// ImFont* font = io.Fonts->AddFontFromFileTTF("c:\\Windows\\Fonts\\ArialUni.ttf");
	// IM_ASSERT(font != nullptr);
	ImGui::CreateContext();
	ImGuiIO& io = ImGui::GetIO();
	io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;     // Enable Keyboard Controls
	io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad;      // Enable Gamepad Controls
	io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;         // Enable Docking
	io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;       // Enable Multi-Viewport / 
	io.Fonts->AddFontFromFileTTF(
		"C:\\Windows\\Fonts\\malgun.ttf",  // 맑은 고딕
		18.0f,
		nullptr,
		io.Fonts->GetGlyphRangesKorean()
	);
	//io.ConfigViewportsNoAutoMerge = true;
	//io.ConfigViewportsNoTaskBarIcon = true;

	// Setup Dear ImGui style
	ImGui::StyleColorsDark();
	//ImGui::StyleColorsLight();

	float main_scale = ImGui_ImplWin32_GetDpiScaleForMonitor(::MonitorFromPoint(POINT{ 0, 0 }, MONITOR_DEFAULTTOPRIMARY));

	// Setup scaling
	ImGuiStyle& style = ImGui::GetStyle();
	style.ScaleAllSizes(main_scale);        // Bake a fixed style scale. (until we have a solution for dynamic style scaling, changing this requires resetting Style + calling this again)
	style.FontScaleDpi = main_scale;        // Set initial font scale. (in docking branch: using io.ConfigDpiScaleFonts=true automatically overrides this for every window depending on the current monitor)
	io.ConfigDpiScaleFonts = true;          // [Experimental] Automatically overwrite style.FontScaleDpi in Begin() when Monitor DPI changes. This will scale fonts but _NOT_ scale sizes/padding for now.
	io.ConfigDpiScaleViewports = true;      // [Experimental] Scale Dear ImGui and Platform Windows when Monitor DPI changes.

	// 뷰포트가 활성화된 경우, 플랫폼 창이 일반 창과 동일하게 보이도록 WindowRounding과 WindowBg를 조정합니다.
	if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
	{
		style.WindowRounding = 0.0f;
		style.Colors[ImGuiCol_WindowBg].w = 1.0f;
	}

	ImGui_ImplWin32_Init(mhMainWnd);

	// 1.92부터는 새로운 기능을 사용하려면 SrvDescriptorAllocFn / SrvDescriptorFreeFn을 지정해야 한다.
	ImGui_ImplDX12_InitInfo init_info = {};
	init_info.Device = mD3D12Context.GetDevice();
	init_info.CommandQueue = mD3D12Context.GetCommandQueue();
	init_info.NumFramesInFlight = RenderConfig::NumFrameResources;
	init_info.RTVFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
	init_info.DSVFormat = DXGI_FORMAT_UNKNOWN;
	// SRV 디스크립터(텍스처용) 할당은 애플리케이션의 책임이므로 콜백을 제공(현재 백엔드 버전은 디스크립터를 하나만 할당하며, 향후 버전에서는 더 많이 할당해야 합니다.)
	init_info.SrvDescriptorHeap = mD3D12Context.GetSrvHeap();
	init_info.UserData = &mD3D12Context;
	init_info.SrvDescriptorAllocFn = 
		[](ImGui_ImplDX12_InitInfo* initInfo, 
			D3D12_CPU_DESCRIPTOR_HANDLE* out_cpu_handle,
			D3D12_GPU_DESCRIPTOR_HANDLE* out_gpu_handle)
		{ 
			auto context = static_cast<D3D12Context*>(initInfo->UserData);
			context->AllocateSrvDescriptor(out_cpu_handle, out_gpu_handle);
		};
	init_info.SrvDescriptorFreeFn = 
		[](ImGui_ImplDX12_InitInfo* initInfo,
			D3D12_CPU_DESCRIPTOR_HANDLE out_cpu_handle,
			D3D12_GPU_DESCRIPTOR_HANDLE out_gpu_handle)
		{
			auto context = static_cast<D3D12Context*>(initInfo->UserData);
			context->FreeSrvDescriptor(out_cpu_handle, out_gpu_handle);
		};
	ImGui_ImplDX12_Init(&init_info);

	return true;
}

int EditorApplication::Run()
{
	MSG msg{};

	while (msg.message != WM_QUIT)
	{
		if (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		else
		{
			Tick();
		}
	}

	mD3D12Context.FlushCommandQueue();

	::DestroyWindow(mhMainWnd);
	::UnregisterClassW(mWndClassName.c_str(), mhInstance);

	return static_cast<int>(msg.wParam);
}

LRESULT EditorApplication::MsgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	static bool mResizing = false;

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
