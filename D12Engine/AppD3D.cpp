#include "AppD3D.h"
#include <WindowsX.h> // For GET_X_LPARAM, GET_Y_LPARAM, #include <Window.h> 선행 필수.
#include <iostream>

LRESULT CALLBACK
MainWndProc2(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	return AppD3D::GetApp()->MsgProc(hwnd, msg, wParam, lParam);
}


AppD3D::AppD3D(HINSTANCE hInstance) : mhAppInst(hInstance)
{
	assert(mApp == nullptr);// 디버그용. expr가 거짓이면 강제 종료.
	mApp = this;
}

AppD3D::~AppD3D()
{
}

int AppD3D::Run()
{
	MSG msg = { 0 };

	while (msg.message != WM_QUIT)
	{
		//윈도우 메시지 처리.
		if (PeekMessage(&msg, 0, 0, 0, PM_REMOVE))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		else
		{
			Update(mTimer);
			Draw(mTimer);
		}
	}

	return (int)msg.wParam;
}

bool AppD3D::Initialize()
{
	if (!InitMainWindow())
		return false;
	if (!InitDirect3D())
		return false;

	OnResize();

	return true;
}

LRESULT AppD3D::MsgProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	switch (msg)
	{
	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;
	}
	return DefWindowProc(hwnd, msg, wParam, lParam);
}

bool AppD3D::InitMainWindow()
{
	//윈도우 객체의 공통 속성 정의서.
	WNDCLASSEX wcex;
	wcex.cbSize = sizeof(WNDCLASSEX); // 구조체 크기.
	wcex.style = CS_HREDRAW | CS_VREDRAW; // 가로/세로 크기 변경 시 전체를 다시 그리도록 설정.
	wcex.lpfnWndProc = MainWndProc2;
	//win16과 호환 가능성을 위해 예약된 필드.
	wcex.cbClsExtra = 0; // 클래스 메모리 추가 할당 없음. 
	wcex.cbWndExtra = 0; // 윈도우 메모리 추가 할당 없음.
	wcex.hInstance = mhAppInst;
	wcex.hIcon = LoadIcon(0, IDI_APPLICATION);
	wcex.hCursor = LoadCursor(0, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)GetStockObject(NULL_BRUSH);	//windows가 배경을 자동으로 칠하지 않음.
															// dx가 직접 백버퍼를 그림.
															// flickering 방지
	wcex.lpszMenuName = 0; // 메뉴 없음.
	wcex.lpszClassName = L"메인 윈도우"; // 윈도우 클래스 식별자. 윈도우 title이 아님.

	wcex.hIconSm = LoadIcon(0, IDI_APPLICATION); // 작은 아이콘.

	// 윈도우 설계도 등록. CreateWindow 함수 호출 전에 반드시 필요.
	if (!RegisterClassEx(&wcex))
	{
		MessageBox(0, L"RegisterClass  실패.", 0, 0);
		return false;
	}

	RECT R = { 0, 0, mClientWidth, mClientHeight };
	AdjustWindowRect(&R, WS_OVERLAPPEDWINDOW, false);
	int width = R.right - R.left;
	int height = R.bottom - R.top;

	mhMainWnd = CreateWindow(L"메인 윈도우", // 등록한 윈도우 클래스 이름.
		mMainWndCaption.c_str(), // 윈도우 타이틀 바에 표시될 문자열.
		WS_OVERLAPPEDWINDOW, // 윈도우 스타일.
		CW_USEDEFAULT, // x 위치
		CW_USEDEFAULT, // y 위치
		width, // 가로 크기
		height, // 세로 크기
		0, // 부모 윈도우 핸들.
		0, // 메뉴 핸들.
		mhAppInst, // 애플리케이션 인스턴스 핸들.
		0); // 추가 매개변수.

	if( !mhMainWnd )
	{
		MessageBox(0, L"CreateWindow  실패.", 0, 0);
		return false;
	}

	ShowWindow(mhMainWnd, SW_SHOW);
	UpdateWindow(mhMainWnd);

	return true;
}

bool AppD3D::InitDirect3D()
{
#if defined(DEBUG) || defined(_DEBUG)
//디버그 레이어 활성화. CreateDevice 호출 전에 해야 함.
{
	 Microsoft::WRL::ComPtr<ID3D12Debug> debugController;
	 ThrowIfFailed(D3D12GetDebugInterface(IID_PPV_ARGS(&debugController)));
	 debugController->EnableDebugLayer();
}
#endif
	/*
		DXGI 팩토리 생성.
		GPU 어댑터 열거, 모니터 출력 열거, 스왑체인 생성, 전체 화면 전환 관리 등.
	*/
	ThrowIfFailed(CreateDXGIFactory1(IID_PPV_ARGS(&mdxgiFactory)));

	/*
		Dx12 디바이스 생성.
		리소스 생성.
		커맨드 큐, 커맨드 알로케이터, 커맨드 리스트.
		파이프라인 상태 객체.
		Descriptor 힙.
	*/
	HRESULT hardwareResult = D3D12CreateDevice(
		nullptr,	// default adapter
		D3D_FEATURE_LEVEL_11_0,
		IID_PPV_ARGS(&md3dDevice));

	//하드웨어 디바이스 생성 시도 실패하면 WARP 디바이스 생성. 때문에 ThrowIfFailed 사용안함.
	if (FAILED(hardwareResult))
	{
		Microsoft::WRL::ComPtr<IDXGIAdapter> pWarpAdapter;
		ThrowIfFailed(mdxgiFactory->EnumWarpAdapter(IID_PPV_ARGS(&pWarpAdapter)));
		ThrowIfFailed(D3D12CreateDevice(
			pWarpAdapter.Get(),
			D3D_FEATURE_LEVEL_11_0,
			IID_PPV_ARGS(&md3dDevice)));
	}
	
	// CPU <-> GPU 동기화용 펜스 생성. 0으로 초기화.
	ThrowIfFailed(md3dDevice->CreateFence(0, D3D12_FENCE_FLAG_NONE,
		IID_PPV_ARGS(&mFence)));

	//디스크립터 힙 주소 산술을 위한 값 저장.
	mRtvDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
	mDsvDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_DSV);
	mCbvSrvUavDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

	//현재 GPU가 4X MSAA를 특정 백버퍼 포맷에서 지원하는지 확인.
	D3D12_FEATURE_DATA_MULTISAMPLE_QUALITY_LEVELS msQualityLevels;
	msQualityLevels.Format = mAbckBufferFormat; // 검사 대상 포맷
	msQualityLevels.SampleCount = 4;			// 4x MSAA 가능한지
	msQualityLevels.Flags = D3D12_MULTISAMPLE_QUALITY_LEVELS_FLAG_NONE; // 일반적으로 NONE
	msQualityLevels.NumQualityLevels = 0;		// 출력값.
	// 포맷 + 샘플 수 조합이 지원 시, 품질 레벨 개수 쿼리.
	ThrowIfFailed(md3dDevice->CheckFeatureSupport(
		D3D12_FEATURE_MULTISAMPLE_QUALITY_LEVELS,
		&msQualityLevels,
		sizeof(msQualityLevels)
	));

	m4xMsaaQuality = msQualityLevels.NumQualityLevels;
	assert(m4xMsaaQuality > 0 && "MSAA 미지원");

#ifdef _DEBUG
	PrintAdapters();
#endif

	return true;
}

void AppD3D::PrintAdapters()
{
	Microsoft::WRL::ComPtr<IDXGIAdapter1> adapter;
	UINT index = 0;

	while (mdxgiFactory->EnumAdapters1(index, &adapter) != DXGI_ERROR_NOT_FOUND)
	{
		DXGI_ADAPTER_DESC1 desc;
		adapter->GetDesc1(&desc);

		// 이름
		std::wstring name = desc.Description;

		// 메모리 정보
		SIZE_T vramMB = desc.DedicatedVideoMemory / (1024 * 1024);
		SIZE_T sharedMB = desc.SharedSystemMemory / (1024 * 1024);

		// 플래그
		bool isSoftware = desc.Flags & DXGI_ADAPTER_FLAG_SOFTWARE;

		std::wstring msg;
		msg += L"Adapter " + std::to_wstring(index) + L": " + name + L"\n";
		msg += L"  VRAM: " + std::to_wstring(vramMB) + L" MB\n";
		msg += L"  Shared: " + std::to_wstring(sharedMB) + L" MB\n";
		msg += L"  Software: ";
		msg += (isSoftware ? L"Yes" : L"No");
		msg += L"\n\n";

		OutputDebugString(msg.c_str());
		
		adapter.Reset(); // 명시적 해제. Release() + nullptr 대입과 동일.
		++index;
	}
}