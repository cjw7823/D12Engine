#pragma once

#include <Windows.h>
#include <string>
#include <comdef.h>
#include "StringUtil.h"

class DxException
{
public:
	DxException() = default;
	DxException(HRESULT hr, const std::wstring& functionName, const std::wstring& filename, int lineNumber) : ErrorCode(hr), FunctionName(functionName), FileName(filename), LineNumber(lineNumber) {};

	inline std::wstring ToString() const
	{
		_com_error err(ErrorCode);
		std::wstring msg = err.ErrorMessage();
		return FunctionName + L" failed in " + FileName + L";\nline " + std::to_wstring(LineNumber) + L";\nerror: " + msg;
	}

	HRESULT ErrorCode = S_OK;
	std::wstring FunctionName;
	std::wstring FileName;
	int LineNumber = -1;
};