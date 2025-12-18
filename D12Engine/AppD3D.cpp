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
	if (md3dDevice != nullptr)
		FlushCommandQueue();
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
	WNDCLASSEX wcex = {};
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
	msQualityLevels.Format = mBackBufferFormat; // 검사 대상 포맷
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
	// 생성된 mdxgiFactory로 adapter, output 출력.
	PrintAdapters();
	LogAdapters();
#endif

	CreateCommandObjects();
	CreateSwapChain();
	CreateRtvDsvDescriptorHeaps();

	return true;
}

void AppD3D::CreateCommandObjects()
{
	D3D12_COMMAND_QUEUE_DESC queueDesc = {};
	queueDesc.Type = D3D12_COMMAND_LIST_TYPE_DIRECT;
	queueDesc.Flags = D3D12_COMMAND_QUEUE_FLAG_NONE;
	//Command Queue 생성
	ThrowIfFailed(md3dDevice->CreateCommandQueue(&queueDesc, IID_PPV_ARGS(&mCommandQueue)));

	//Command Allocator 생성
	ThrowIfFailed(md3dDevice->CreateCommandAllocator(
		D3D12_COMMAND_LIST_TYPE_DIRECT,
		IID_PPV_ARGS(mDirectCmdListAlloc.GetAddressOf())));

	//Command List 생성
	ThrowIfFailed(md3dDevice->CreateCommandList(
		0, //노드 마스크. 첫번째 GPU 사용.
		D3D12_COMMAND_LIST_TYPE_DIRECT,
		mDirectCmdListAlloc.Get(),// 연결할 Allocator 지정
		nullptr,
		IID_PPV_ARGS(mCommandList.GetAddressOf())));

	//아직 아무것도 기록하지 않았지만 프레임 루프가 Reset을 호출하며 시작하기 때문에 닫아줘야 함.
	mCommandList->Close();
}

void AppD3D::CreateSwapChain()
{
	//백버퍼 여러장을 돌려가며 Present(제시) 하는 구조
	mSwapChain.Reset();

	DXGI_SWAP_CHAIN_DESC sd;
	sd.BufferDesc.Height = mClientHeight;
	sd.BufferDesc.Width = mClientWidth;
	sd.BufferDesc.RefreshRate.Numerator = 60;
	sd.BufferDesc.RefreshRate.Denominator = 1;
	sd.BufferDesc.Format = mBackBufferFormat;
	sd.BufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED; //요즘은 대부분 UNSPECIFIED로 설정...
	sd.BufferDesc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;
	sd.SampleDesc.Count = m4xMsaaState ? 4 : 1;
	sd.SampleDesc.Quality = m4xMsaaState ? (m4xMsaaQuality - 1) : 0; //지원하는 품질 레벨 중 가장 높은 값.
	sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	sd.BufferCount = SwapChainBufferCount;
	sd.OutputWindow = mhMainWnd;
	sd.Windowed = true;
	//DISCARD 는 Present 후 버퍼 내용이 보존되지 않아도 된다는 의미.
	//어짜피 매 프레인 전체를 다시 그리므로 상관없음.
	sd.SwapEffect = DXGI_SWAP_EFFECT_FLIP_DISCARD;
	sd.Flags = DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;//전체 화면 전환 시 디스플레이 모드 스위치를 허용.

	//Present와 관련하여 GPU동기화 문제가 있으므로 사용하는 Command Queue 가 필요함.
	ThrowIfFailed(mdxgiFactory->CreateSwapChain(
		mCommandQueue.Get(),
		&sd,
		mSwapChain.GetAddressOf()));
}

// RTV/DSV 디스크립터 힙 생성.
// 리소스 자체가 아니라, 리소스를 렌더링 파이프라인에 바인딩할 때 사용할
// RTV/DSV 디스크립터(뷰)를 저장하는 힙이다.
// 실제 RTV/DSV 디스크립터는 백버퍼/깊이버퍼 리소스를 만든 뒤 Create*View로 힙에 기록한다.
void AppD3D::CreateRtvDsvDescriptorHeaps()
{
	D3D12_DESCRIPTOR_HEAP_DESC rtvHeapDesc;
	rtvHeapDesc.NumDescriptors = SwapChainBufferCount;
	rtvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
	rtvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
	rtvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(
		&rtvHeapDesc,
		IID_PPV_ARGS(mRtvHeap.GetAddressOf())));

	D3D12_DESCRIPTOR_HEAP_DESC dsvHeapDesc;
	dsvHeapDesc.NumDescriptors = 1;
	dsvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_DSV;
	dsvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
	dsvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(
		&dsvHeapDesc,
		IID_PPV_ARGS(mDsvHeap.GetAddressOf())));
}

void AppD3D::OnResize()
{
	assert(md3dDevice);
	assert(mSwapChain);
	assert(mDirectCmdListAlloc);

	FlushCommandQueue();

	//이전 리소스 해제 루틴.
	ThrowIfFailed(mCommandList->Reset(mDirectCmdListAlloc.Get(), nullptr));
	for(int i=0; i<SwapChainBufferCount; i++)
		mSwapChainBuffer[i].Reset();
	mDepthStencilBuffer.Reset();

	//스왑체인 버퍼 크기 조정.(재사용)
	ThrowIfFailed(mSwapChain->ResizeBuffers(
		SwapChainBufferCount,
		mClientWidth, mClientHeight,
		mBackBufferFormat,
		DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH));
	mCurrBackBuffer = 0;

	//모든 Render Target들의 view가 한개의 디스크립터 힙에 담기지만
	//0~SwapChainBufferCount는 스왑체인 버퍼용 RTV 디스크립터로 예약됨.
	//혹은 힙을 여러개 두기도 함.
	CD3DX12_CPU_DESCRIPTOR_HANDLE rtvHeapHandle(mRtvHeap->GetCPUDescriptorHandleForHeapStart());
	for (int i = 0; i < SwapChainBufferCount; i++)
	{
		ThrowIfFailed(mSwapChain->GetBuffer(i, IID_PPV_ARGS(&mSwapChainBuffer[i])));
		// 핸들이 가리키는 메모리 주소(디스크립터 슬롯)에 RTV 디스크립터 생성.
		md3dDevice->CreateRenderTargetView(mSwapChainBuffer[i].Get(), nullptr, rtvHeapHandle);
		rtvHeapHandle.Offset(1, mRtvDescriptorSize);
	}

	D3D12_RESOURCE_DESC depthStencilDesc;
	depthStencilDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
	depthStencilDesc.Alignment = 0;
	depthStencilDesc.Width = mClientWidth;
	depthStencilDesc.Height = mClientHeight;
	depthStencilDesc.DepthOrArraySize = 1;
}

void AppD3D::FlushCommandQueue()
{
	//다음 프레임에서 사용할 펜스 값 계산.
	mCurrentFence++;
	//커맨드 큐에 펜스 신호 보내기. 실패시 회복 불가능한 os레벨 작업이므로 ThrowIfFailed 사용.
	ThrowIfFailed(mCommandQueue->Signal(mFence.Get(), mCurrentFence));
	//펜스 값이 GPU에 도달했는지 확인.
	if (mFence->GetCompletedValue() < mCurrentFence)
	{
		//도달하지 않았으면 이벤트 생성.
		HANDLE eventHandle = CreateEventEx(nullptr, nullptr, false, EVENT_ALL_ACCESS);
		//펜스가 특정 값에 도달하면 이벤트를 신호 상태로 설정하도록 설정.
		ThrowIfFailed(mFence->SetEventOnCompletion(mCurrentFence, eventHandle));
		//이벤트가 신호 상태가 될 때까지 대기.
		WaitForSingleObject(eventHandle, INFINITE);
		CloseHandle(eventHandle);
	}
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

void AppD3D::LogAdapters()
{
	UINT i = 0;
	IDXGIAdapter* adapter = nullptr;
	std::vector<IDXGIAdapter*> adapterList;
	while (mdxgiFactory->EnumAdapters(i, &adapter) != DXGI_ERROR_NOT_FOUND)
	{
		DXGI_ADAPTER_DESC desc;
		adapter->GetDesc(&desc);

		std::wstring text = L"***Adapter: ";
		text += desc.Description;
		text += L"\n";

		OutputDebugString(text.c_str());

		adapterList.push_back(adapter);

		++i;
	}

	for (size_t i = 0; i < adapterList.size(); ++i)
	{
		LogAdapterOutputs(adapterList[i]);
		ReleaseCom(adapterList[i]);
	}
}

void AppD3D::LogAdapterOutputs(IDXGIAdapter* adapter)
{
	UINT i = 0;
	IDXGIOutput* output = nullptr;
	while (adapter->EnumOutputs(i, &output) != DXGI_ERROR_NOT_FOUND)
	{
		DXGI_OUTPUT_DESC desc;
		output->GetDesc(&desc);

		std::wstring text = L"***Output: ";
		text += desc.DeviceName;
		text += L"\n";
		OutputDebugString(text.c_str());

		LogOutputDisplayModes(output, mBackBufferFormat);

		ReleaseCom(output);

		++i;
	}
}

void AppD3D::LogOutputDisplayModes(IDXGIOutput* output, DXGI_FORMAT format)
{
	UINT count = 0;
	UINT flags = 0;

	// Call with nullptr to get list count.
	output->GetDisplayModeList(format, flags, &count, nullptr);

	std::vector<DXGI_MODE_DESC> modeList(count);
	output->GetDisplayModeList(format, flags, &count, &modeList[0]);

	for (auto& x : modeList)
	{
		UINT n = x.RefreshRate.Numerator;
		UINT d = x.RefreshRate.Denominator;
		std::wstring text =
			L"Width = " + std::to_wstring(x.Width) + L" " +
			L"Height = " + std::to_wstring(x.Height) + L" " +
			L"Refresh = " + std::to_wstring(n) + L"/" + std::to_wstring(d) +
			L"\n";

		::OutputDebugString(text.c_str());
	}
}