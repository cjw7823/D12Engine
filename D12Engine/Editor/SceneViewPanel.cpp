#include "pch.h"
#include "SceneViewPanel.h"

void SceneViewPanel::OnImGuiRender()
{
    bool visible = ImGui::Begin("Scene View");

    mHasValidSize = false;

    if (!visible)
    {
        ImGui::End();
        return;
    }

    ImVec2 availableSize = ImGui::GetContentRegionAvail();
    if (availableSize.x < 1.0f || availableSize.y < 1.0f)
    {
        ImGui::TextDisabled("Scene View size is invalid.");
        ImGui::End();
        return;
    }

    mHasValidSize = true;
    mViewportSize = availableSize;

    if (mTextureId != NULL)
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

        //입력신호를 받기 위해.
        ImGui::InvisibleButton("SceneViewEmpty", availableSize);
    }

    ImGui::End();
}