#pragma once

#include <Windows.h>

struct WinHandle
{
	WinHandle() = default;
	explicit WinHandle(HANDLE handle) : h(handle) {}

	WinHandle(const WinHandle& rhs) = delete;
	WinHandle& operator=(const WinHandle& rhs) = delete;

	WinHandle(WinHandle&& other) noexcept :h(other.h) { other.h = nullptr; }
	WinHandle& operator=(WinHandle&& other) noexcept
	{
		if (this != &other)
		{
			Reset();
			h = other.h;
			other.h = nullptr;
		}
		return *this;
	}

	~WinHandle() { Reset(); }

	void Reset()
	{
		if (h && h != INVALID_HANDLE_VALUE)
		{
			CloseHandle(h);
			h = nullptr;
		}
	}

	HANDLE Get() const { return h; }
	void Set(HANDLE handle) { h = handle; }
private:
	HANDLE h = nullptr;
};