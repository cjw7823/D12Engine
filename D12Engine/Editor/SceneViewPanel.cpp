#include "pch.h"
#include "SceneViewPanel.h"

void SceneViewPanel::OnImGuiRender()
{
    bool visible = ImGui::Begin("Scene View");
    if (!visible)
    {
        mInputState.IsHovered = false;
        mInputState.IsFocused = false;
        ImGui::End();
        return;
    }

    ImVec2 availableSize = ImGui::GetContentRegionAvail();
    if (availableSize.x < 1.0f || availableSize.y < 1.0f)
    {
        mInputState.IsHovered = false;
        mInputState.IsFocused = ImGui::IsWindowFocused(ImGuiFocusedFlags_RootAndChildWindows);
        ImGui::TextDisabled("Scene View size is invalid.");
        ImGui::End();
        return;
    }

    mViewportSize = availableSize;

    if (mTextureId != 0)
    {
        // Image가 하나의 ImGui Item으로 등록
        ImGui::Image(mTextureId, availableSize);
    }
    else
    {
        // 텍스처가 없어도 Scene View 영역을 ImGui Item으로 등록한다.
        ImGui::Dummy(availableSize);

        const ImVec2 min = ImGui::GetItemRectMin();
        const ImVec2 max = ImGui::GetItemRectMax();

        ImDrawList* drawList = ImGui::GetWindowDrawList();
        drawList->AddRectFilled(min, max, IM_COL32(35, 35, 35, 255));
        drawList->AddText(
            ImVec2(min.x + 10.0f, min.y + 10.0f),
            IM_COL32(220, 220, 220, 255),
            "Scene render target is not ready.");
    }

    // 반드시 Image 또는 Dummy 호출 이후 실행
    UpdateInputState();

    ImGui::End();
}

void SceneViewPanel::UpdateInputState()
{
    // 현재 마지막으로 그린 Item, 즉 Image 또는 Dummy의 실제 영역
    mInputState.Min = ImGui::GetItemRectMin();
    mInputState.Max = ImGui::GetItemRectMax();

    // 전체 Scene View 윈도우가 아니라 실제 이미지 영역만 검사
    mInputState.IsHovered = ImGui::IsItemHovered();

    mInputState.IsFocused =
        ImGui::IsWindowFocused(ImGuiFocusedFlags_RootAndChildWindows);

    const ImVec2 mousePosition = ImGui::GetMousePos();

    mInputState.MouseLocal =
    {
        mousePosition.x - mInputState.Min.x,
        mousePosition.y - mInputState.Min.y
    };
}
