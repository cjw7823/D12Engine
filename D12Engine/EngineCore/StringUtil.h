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

inline std::wstring Utf8ToWide(const std::string& value)
{
	if (value.empty())
		return {};

	const int requiredSize = MultiByteToWideChar(
		CP_UTF8,
		MB_ERR_INVALID_CHARS,
		value.data(),
		static_cast<int>(value.size()),
		nullptr,
		0);

	if (requiredSize <= 0)
		throw std::runtime_error("Failed to convert UTF-8 to wide string.");

	std::wstring result(requiredSize, L'\0');

	const int convertedSize = MultiByteToWideChar(
		CP_UTF8,
		MB_ERR_INVALID_CHARS,
		value.data(),
		static_cast<int>(value.size()),
		result.data(),
		requiredSize);

	if (convertedSize != requiredSize)
		throw std::runtime_error("Failed to convert UTF-8 to wide string.");

	return result;
}