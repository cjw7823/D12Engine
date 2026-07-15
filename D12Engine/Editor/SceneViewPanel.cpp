#include "pch.h"
#include "SceneViewPanel.h"

void SceneViewPanel::OnImGuiRender()
{
    bool visible = ImGui::Begin("Scene View");
    if (!visible)
    {
        ImGui::End();
        return;
    }

    UpdateInputState();

    ImVec2 availableSize = ImGui::GetContentRegionAvail();
    if (availableSize.x < 1.0f || availableSize.y < 1.0f)
    {
        ImGui::TextDisabled("Scene View size is invalid.");
        ImGui::End();
        return;
    }

    mViewportSize = availableSize;

    if (mTextureId != 0)
    {
        ImGui::Image(mTextureId, availableSize);
    }
    else
    {
        ImVec2 pos = ImGui::GetCursorScreenPos();
        ImVec2 end = ImVec2(pos.x + availableSize.x, pos.y + availableSize.y);

        ImDrawList* drawList = ImGui::GetWindowDrawList();
        drawList->AddRectFilled(pos, end, IM_COL32(35, 35, 35, 255));
        drawList->AddText(
            ImVec2(pos.x + 10.0f, pos.y + 10.0f),
            IM_COL32(220, 220, 220, 255),
            "Scene render target is not ready."
        );
    }

    ImGui::End();
}

void SceneViewPanel::UpdateInputState()
{
    mInputState.IsHovered = ImGui::IsWindowHovered(ImGuiHoveredFlags_RootAndChildWindows);

    mInputState.IsFocused = ImGui::IsWindowFocused(ImGuiFocusedFlags_RootAndChildWindows);

    const ImVec2 windowPosition = ImGui::GetWindowPos();
    const ImVec2 contentMin = ImGui::GetWindowContentRegionMin();
    const ImVec2 contentMax = ImGui::GetWindowContentRegionMax();

    mInputState.Min =
    {
        windowPosition.x + contentMin.x,
        windowPosition.y + contentMin.y
    };

    mInputState.Max =
    {
        windowPosition.x + contentMax.x,
        windowPosition.y + contentMax.y
    };
}
