#pragma once

#include "imgui.h"

class SceneViewPanel
{
public:
    void OnImGuiRender();

    void SetTexture(ImTextureID textureId)
    {
        mTextureId = textureId;
    }

    int GetWidth() const
    {
        return static_cast<int>(mViewportSize.x);
    }

    int GetHeight() const
    {
        return static_cast<int>(mViewportSize.y);
    }

private:
    ImTextureID mTextureId = NULL;
    ImVec2 mViewportSize = ImVec2(1.0f, 1.0f);
};