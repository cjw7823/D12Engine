#pragma once

#include "EditorInputRouter.h"

class GlobalInputHandler final : public IEditorInputHandler
{
public:
    GlobalInputHandler();

    virtual void ProcessMouseInput(
        const InputSystem& input,
        const EditorPanelInputState& viewport) override {}

    virtual void ProcessKeyboardInput(const InputSystem& input) override {}
    virtual void ProcessGlobalShortcuts(const InputSystem& input) override;

private:
};