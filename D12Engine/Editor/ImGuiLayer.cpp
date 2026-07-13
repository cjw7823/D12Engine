#include "pch.h"
#include "ImGuiLayer.h"

#include "Renderer/DirectX12/D3D12Context.h"
#include "EngineCore/RenderConfig.h"

#include "imgui.h"
#include "imgui_impl_win32.h"
#include "imgui_impl_dx12.h"

// Forward declare message handler from imgui_impl_win32.cpp
extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

bool ImGuiLayer::Initialize(HWND hwnd, D3D12Context& context)
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
    //ImGui::StyleColorsClassic();

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

    if (!ImGui_ImplWin32_Init(hwnd))
        return false;

    // 1.92부터는 새로운 기능을 사용하려면 SrvDescriptorAllocFn / SrvDescriptorFreeFn을 지정해야 한다.
    ImGui_ImplDX12_InitInfo initInfo{};
    initInfo.Device = context.GetDevice();
    initInfo.CommandQueue = context.GetCommandQueue();
    initInfo.NumFramesInFlight = RenderConfig::NumFrameResources;
    initInfo.RTVFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
    initInfo.DSVFormat = DXGI_FORMAT_UNKNOWN;
    initInfo.SrvDescriptorHeap = context.GetSrvHeap();
    initInfo.UserData = &context;

    // SRV 디스크립터(텍스처용) 할당은 애플리케이션의 책임이므로 콜백을 제공(현재 백엔드 버전은 디스크립터를 하나만 할당하며, 향후 버전에서는 더 많이 할당해야 합니다.)
    initInfo.SrvDescriptorAllocFn =
        [](ImGui_ImplDX12_InitInfo* initInfo,
            D3D12_CPU_DESCRIPTOR_HANDLE* outCpuHandle,
            D3D12_GPU_DESCRIPTOR_HANDLE* outGpuHandle)
        {
            auto context = static_cast<D3D12Context*>(initInfo->UserData);
            context->AllocateSrvDescriptor(outCpuHandle, outGpuHandle);
        };

    initInfo.SrvDescriptorFreeFn =
        [](ImGui_ImplDX12_InitInfo* initInfo,
            D3D12_CPU_DESCRIPTOR_HANDLE cpuHandle,
            D3D12_GPU_DESCRIPTOR_HANDLE gpuHandle)
        {
            auto context = static_cast<D3D12Context*>(initInfo->UserData);
            context->FreeSrvDescriptor(cpuHandle, gpuHandle);
        };

    if (!ImGui_ImplDX12_Init(&initInfo))
        return false;

    return true;
}

void ImGuiLayer::Shutdown()
{
    ImGui_ImplDX12_Shutdown();
    ImGui_ImplWin32_Shutdown();
    ImGui::DestroyContext();
}

void ImGuiLayer::BeginFrame()
{
    ImGui_ImplDX12_NewFrame();
    ImGui_ImplWin32_NewFrame();
    ImGui::NewFrame();
}

void ImGuiLayer::EndFrame()
{
    ImGui::Render();
}

void ImGuiLayer::RenderDrawData(D3D12Context& context)
{
    ID3D12DescriptorHeap* descriptorHeaps[] =
    {
        context.GetSrvHeap()
    };

    context.GetCommandList()->SetDescriptorHeaps(
        _countof(descriptorHeaps),
        descriptorHeaps
    );

    ImGui_ImplDX12_RenderDrawData(
        ImGui::GetDrawData(),
        context.GetCommandList()
    );

    ImGuiIO& io = ImGui::GetIO();

    if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
    {
        ImGui::UpdatePlatformWindows();
        ImGui::RenderPlatformWindowsDefault();
    }
}

LRESULT ImGuiLayer::WndProcHandler(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    //ImGui는 메시지로 내부 입력 상태를 갱신함.
    //io.WantCaptureMouse / io.WantCaptureKeyboard는 "ImGui가 이 입력을 쓰고 싶다"는 상태 플래그임.
    //그 플래그를 보고 네 앱 입력 처리를 막는 것은 네가 직접 해야 함.
    //또한 모든 메시지를 처리하지 않고 일부 메시지는 직접 처리해야 함. ex)WM_SIZE
    return ImGui_ImplWin32_WndProcHandler(hwnd, msg, wParam, lParam);
}