#pragma once

#include <string>
#include <Windows.h>
#include <filesystem>

inline std::string WideToUtf8(const std::wstring& wstr)
{
	if (wstr.empty())
		return {};

	int size = WideCharToMultiByte(
		CP_UTF8,
		0,
		wstr.c_str(),
		-1,
		nullptr,
		0,
		nullptr,
		nullptr
	);

	std::string result(size - 1, 0);

	WideCharToMultiByte(
		CP_UTF8,
		0,
		wstr.c_str(),
		-1,
		result.data(),
		size,
		nullptr,
		nullptr
	);

	return result;
}

inline std::string PathToUtf8(const std::filesystem::path& path)
{
	return WideToUtf8(path.wstring());
}

inline std::wstring AnsiToWString(const std::string& str)
{
	WCHAR buffer[512];
	MultiByteToWideChar(CP_ACP, 0, str.c_str(), -1, buffer, 512);
	return std::wstring(buffer);
}
