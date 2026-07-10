#pragma once

#include <Windows.h>
#include "EngineCore/StringUtil.h"
#include "EngineCore/DxException.h"

#ifndef ReleaseCom
#define ReleaseCom(x) { if(x) { x->Release(); x = 0; } }
#endif // !ReleaseCom

#ifndef ThrowIfFailed
#define ThrowIfFailed(x)                                            \
{                                                                   \
	HRESULT hr__ = (x);												\
	if(FAILED(hr__))												\
	{																\
		std::wstring wfn = AnsiToWString(__FILE__);					\
		throw DxException(hr__, L#x, wfn, __LINE__);				\
	}																\
}
#endif // !ThrowIfFailed