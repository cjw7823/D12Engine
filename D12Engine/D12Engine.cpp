//C Runtime에 c/c++ 힙 할당을 추적.
//프로그램 종료 시 메모리 누수 보고서 출력.
#if defined(DEBUG) || defined(_DEBUG)
	#define DX12_ENABLE_DEBUG_LAYER
#endif

#include "Editor/EditorApplication.h"
#include "EngineCore/DxException.h"

#pragma comment(lib, "d3dcompiler.lib")
#pragma comment(lib, "d3d12.lib")
#pragma comment(lib, "dxgi.lib")

#ifdef DX12_ENABLE_DEBUG_LAYER
	#define _CRTDBG_MAP_ALLOC
	#include <crtdbg.h>
	#include <dxgidebug.h>
	#pragma comment(lib, "dxguid.lib")
#endif

int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
	_In_opt_ HINSTANCE hPrevInstance,
	_In_ LPWSTR lpCmdLine,
	_In_ int nCmdShow)
{
#if defined(DEBUG) || defined(_DEBUG)
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);
#endif
	try {
		EditorApplication app(hInstance);
		if (!app.Initialize())
			return 0;

		return app.Run();
	}
	catch(DxException& e)
	{
		MessageBox(nullptr, e.ToString().c_str(), L"HR Failed", MB_OK);
		return 0;
	}
}