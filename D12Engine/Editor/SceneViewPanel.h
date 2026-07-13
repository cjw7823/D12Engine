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

    bool HasValidSize() const
    {
        return mHasValidSize;
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
    bool mHasValidSize = false;
    ImVec2 mViewportSize = ImVec2(0.0f, 0.0f);
};