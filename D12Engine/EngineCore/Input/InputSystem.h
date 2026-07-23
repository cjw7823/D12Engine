#pragma once

#include <array>
#include <cstddef>
#include <cstdint>

/*
    여러 입력들의 상태 저장.
    입력에 따른 수행은 IEditorInputHandler에서 실행.
    EditorInputRouter가 알맞은 핸들러로 Routing
*/

enum class MouseButton : std::uint8_t
{
    Left,
    Right,
    Middle,
    X1,
    X2,
    Count
};

class InputSystem
{
public:
    static constexpr std::size_t KeyCount = 256;
    static constexpr std::size_t MouseButtonCount =
        static_cast<std::size_t>(MouseButton::Count);

public:
    // 매 프레임 메시지 처리 전에 호출.
    void BeginFrame();

    // 포커스를 잃었을 때 입력 상태 초기화.
    void Reset();
    void ResetMouseMotion();

    void OnKeyDown(WPARAM key);
    void OnKeyUp(WPARAM key);

    void OnMouseButtonDown(MouseButton button);
    void OnMouseButtonUp(MouseButton button);

    void OnMouseMove(int x, int y);
    void OnMouseDelta(int x, int y);
    void OnMouseWheel(int delta);

    bool IsKeyDown(int key) const;
    bool IsKeyPressed(int key) const;
    bool IsKeyReleased(int key) const;

    bool IsMouseDown(MouseButton button) const;
    bool IsMousePressed(MouseButton button) const;
    bool IsMouseReleased(MouseButton button) const;

    bool IsCtrlDown() const;
    bool IsShiftDown() const;
    bool IsAltDown() const;

    POINT GetMousePosition() const;
    POINT GetMouseDelta() const;

    int GetMouseWheelDelta() const;

private:
    static bool IsValidKey(WPARAM key);
    static std::size_t ToIndex(MouseButton button);

private:
    std::array<bool, KeyCount> mKeyDown{};
    std::array<bool, KeyCount> mKeyPressed{};
    std::array<bool, KeyCount> mKeyReleased{};

    std::array<bool, MouseButtonCount> mMouseDown{};
    std::array<bool, MouseButtonCount> mMousePressed{};
    std::array<bool, MouseButtonCount> mMouseReleased{};

    POINT mMousePosition{};
    POINT mMouseDelta{};

    int mMouseWheelDelta = 0;
    bool mHasMousePosition = false;
};