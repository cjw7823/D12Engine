#pragma once

#include <Windows.h>

class D3D12Context;

//Dear ImGui 자체의 생명주기와 백엔드 연결을 담당한다.
class ImGuiLayer
{
public:
    bool Initialize(HWND hwnd, D3D12Context& context);
    void Shutdown();

    void BeginFrame();
    void EndFrame();

    void RenderDrawData(D3D12Context& context);

    LRESULT WndProcHandler(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
};