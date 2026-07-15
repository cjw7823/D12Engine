#pragma once

#include "imgui.h"
#include "EngineCore/InputSystem/EditorInputRouter.h"

class SceneViewPanel
{
public:
    void OnImGuiRender();

    void SetTexture(ImTextureID textureId) { mTextureId = textureId; }

    bool HasValidSize() const { return mInputState.HasValidSize(); }
    int GetWidth() const { return static_cast<int>(mViewportSize.x); }
    int GetHeight() const { return static_cast<int>(mViewportSize.y); }
    const EditorPanelInputState& GetInputState() const noexcept { return mInputState; }

private:
    void UpdateInputState();

private:
    ImTextureID mTextureId = NULL;
    ImVec2 mViewportSize = ImVec2(0.0f, 0.0f);
    EditorPanelInputState mInputState;
};