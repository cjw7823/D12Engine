#include "pch.h"
#include "InputSystem.h"

#include "EngineCore/Logger/Logger.h"

#include <algorithm>

void InputSystem::BeginFrame()
{
    mKeyPressed.fill(false);
    mKeyReleased.fill(false);

    mMousePressed.fill(false);
    mMouseReleased.fill(false);

    mMouseDelta = {};
    mMouseWheelDelta = 0;
}

void InputSystem::Reset()
{
    mKeyDown.fill(false);
    mKeyPressed.fill(false);
    mKeyReleased.fill(false);

    mMouseDown.fill(false);
    mMousePressed.fill(false);
    mMouseReleased.fill(false);

    mMouseDelta = {};
    mMouseWheelDelta = 0;
    mHasMousePosition = false;
}

void InputSystem::ResetMouseMotion()
{
    mMouseDelta = {};
    mHasMousePosition = false;
}

void InputSystem::OnKeyDown(WPARAM key)
{
    if (!IsValidKey(key))
        return;

    const std::size_t index = static_cast<std::size_t>(key);

    // 자동 반복 WM_KEYDOWN은 Pressed로 다시 처리하지 않는다.
    if (!mKeyDown[index])
    {
#ifdef _DEBUG
        std::wstring s(1, static_cast<wchar_t>(key));
        s = L"Key Pressed : " + s + L"\n";
        Logger::Info(s);
#endif
        mKeyPressed[index] = true;
    }

    mKeyDown[index] = true;
}

void InputSystem::OnKeyUp(WPARAM key)
{
    if (!IsValidKey(key))
        return;

    const std::size_t index = static_cast<std::size_t>(key);

    if (mKeyDown[index])
        mKeyReleased[index] = true;

    mKeyDown[index] = false;
}

void InputSystem::OnMouseButtonDown(MouseButton button)
{
    const std::size_t index = ToIndex(button);

    if (!mMouseDown[index])
        mMousePressed[index] = true;

    mMouseDown[index] = true;
}

void InputSystem::OnMouseButtonUp(MouseButton button)
{
    const std::size_t index = ToIndex(button);

    if (mMouseDown[index])
        mMouseReleased[index] = true;

    mMouseDown[index] = false;
}

void InputSystem::OnMouseMove(int x, int y)
{
    const POINT newPosition{ x, y };

    if (!mHasMousePosition)
    {
        mMousePosition = newPosition;
        mHasMousePosition = true;
        return;
    }

    // 한 프레임에 여러 WM_MOUSEMOVE가 들어올 수 있으므로 누적한다.
    mMouseDelta.x += newPosition.x - mMousePosition.x;
    mMouseDelta.y += newPosition.y - mMousePosition.y;

    mMousePosition = newPosition;
}

void InputSystem::OnMouseDelta(int x, int y)
{
    mMouseDelta.x += x;
    mMouseDelta.y += y;
}

void InputSystem::OnMouseWheel(int delta)
{
    mMouseWheelDelta += delta;
}

bool InputSystem::IsKeyDown(int key) const
{
    if (key < 0 || key >= static_cast<int>(KeyCount))
        return false;

    return mKeyDown[static_cast<std::size_t>(key)];
}

bool InputSystem::IsKeyPressed(int key) const
{
    if (key < 0 || key >= static_cast<int>(KeyCount))
        return false;

    return mKeyPressed[static_cast<std::size_t>(key)];
}

bool InputSystem::IsKeyReleased(int key) const
{
    if (key < 0 || key >= static_cast<int>(KeyCount))
        return false;

    return mKeyReleased[static_cast<std::size_t>(key)];
}

bool InputSystem::IsMouseDown(MouseButton button) const
{
    return mMouseDown[ToIndex(button)];
}

bool InputSystem::IsMousePressed(MouseButton button) const
{
    return mMousePressed[ToIndex(button)];
}

bool InputSystem::IsMouseReleased(MouseButton button) const
{
    return mMouseReleased[ToIndex(button)];
}

bool InputSystem::IsCtrlDown() const
{
    return IsKeyDown(VK_CONTROL);
}

bool InputSystem::IsShiftDown() const
{
    return IsKeyDown(VK_SHIFT);
}

bool InputSystem::IsAltDown() const
{
    return IsKeyDown(VK_MENU);
}

POINT InputSystem::GetMousePosition() const
{
    return mMousePosition;
}

POINT InputSystem::GetMouseDelta() const
{
    return mMouseDelta;
}

int InputSystem::GetMouseWheelDelta() const
{
    return mMouseWheelDelta;
}

bool InputSystem::IsValidKey(WPARAM key)
{
    return key < KeyCount;
}

std::size_t InputSystem::ToIndex(MouseButton button)
{
    return static_cast<std::size_t>(button);
}