#include "InitAppD3D.h"
#include <windowsX.h>

using namespace Microsoft::WRL;

LRESULT CALLBACK MainWndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lparam)
{
	return InitAppD3D::GetApp()->MsgProc(hWnd, msg, wParam, lparam);
}

InitAppD3D::InitAppD3D(HINSTANCE hInstance) : mhInstance(hInstance)
{
	assert(mApp == nullptr);
	mApp = this;
}

InitAppD3D::~InitAppD3D()
{
	if (md3dDevice != nullptr)
		FlushCommandQueue();
}

int InitAppD3D::Run()
{
	MSG msg = { 0 };

	mTimer.Reset();

	while (msg.message != WM_QUIT)
	{
		if (PeekMessage(&msg, 0, 0, 0, PM_REMOVE))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		else
		{
			mTimer.Tick();
			//if (!mAppPaused)
			if(true)
			{
				CalculateFrameStats();
				Update(mTimer);
				Draw(mTimer);
			}
			else
				Sleep(100); //앱이 일시 정지된 경우 CPU 점유율 낮춤.
		}
	}

	return static_cast<int>(msg.wParam);
}

bool InitAppD3D::Initialize()
{
	if(!InitMainWindow())
		return false;
	if(!InitDirect3D())
		return false;

	OnResize();

	return true;
}

LRESULT InitAppD3D::MsgProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	switch (msg)
	{
	case WM_ACTIVATE:
		if (LOWORD(wParam) == WA_INACTIVE)
		{
			mAppPaused = true;
			//mTimer.Stop();
		}
		else
		{
			mAppPaused = false;
			mTimer.Start();
		}
		return 0;

	case WM_SIZE:
		mClientWidth = LOWORD(lParam);
		mClientHeight = HIWORD(lParam);
		if (md3dDevice)
		{
			if (wParam == SIZE_MINIMIZED)
			{
				mAppPaused = true;
				mMinimized = true;
				mMaximized = false;
			}
			else if (wParam == SIZE_MAXIMIZED)
			{
				mAppPaused = false;
				mMinimized = false;
				mMaximized = true;
				OnResize();
			}
			else if (wParam == SIZE_RESTORED)
			{
				if (mMinimized)
				{
					mAppPaused = false;
					mMinimized = false;
					OnResize();
				}
				else if (mMaximized)
				{
					mAppPaused = false;
					mMaximized = false;
					OnResize();
				}
				else if (mResizing)
				{
					//드래그 중 계속해서 WM_SIZE 메시지가 오기 때문에
					//여기서는 OnResize를 호출하지 않는다.
				}
				else // SetWindowPos 또는 mSwapChain->SetFullscreenState와 같은 API 호출
				{
					OnResize();
				}
			}
		}
		return 0;

	case WM_ENTERSIZEMOVE:
		mAppPaused = true;
		mResizing = true;
		//mTimer.Stop();
		return 0;

	case WM_EXITSIZEMOVE:
		mAppPaused = false;
		mResizing = false;
		mTimer.Start();
		return 0;

	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;

	case WM_MENUCHAR:  // 메뉴가 활성화된 상태에서 사용자가 니모닉 키나 가속기 키에 해당하지 않는 키를 누를 때 전송됩니다.
		return MAKELRESULT(0, MNC_CLOSE); //삐 소리 방지.

	case WM_GETMINMAXINFO:
		reinterpret_cast<MINMAXINFO*>(lParam)->ptMinTrackSize.x = 200;
		reinterpret_cast<MINMAXINFO*>(lParam)->ptMinTrackSize.y = 200;
		return 0;

	case WM_LBUTTONDOWN:
	case WM_MBUTTONDOWN:
	case WM_RBUTTONDOWN:
		OnMouseDown(wParam, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
		return 0;

	case WM_LBUTTONUP:
	case WM_MBUTTONUP:
	case WM_RBUTTONUP:
		OnMouseUp(wParam, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
		return 0;

	case WM_MOUSEMOVE:
		OnMouseMove(wParam, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
		return 0;

	case WM_MOUSEWHEEL:
		OnMouseWheel(GET_WHEEL_DELTA_WPARAM(wParam), GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
		return 0;

	case WM_KEYUP:
		if (wParam == VK_ESCAPE)
			PostQuitMessage(0);
		else if (static_cast<int>(wParam) == VK_F2)
			Set4xMsaaState(!m4xMsaaState);
		else
			OnKeyUp(wParam);
		return 0;

	case WM_KEYDOWN:
		OnKeyDown(wParam);
		return 0;
	}

	return DefWindowProc(hwnd, msg, wParam, lParam);
}

void InitAppD3D::Set4xMsaaState(bool value)
{
	if (m4xMsaaState != value)
	{
		m4xMsaaState = value;

		std::wstring debug = std::wstring(L"MSAA : ") + (value ? L"True" : L"False") + L"\n";
		OutputDebugString(debug.c_str());

		FlushCommandQueue();
		CreateSwapChain(); //테스트 필요.
		OnResize();
	}
}

float InitAppD3D::AspectRatio() const
{
	return static_cast<float>(mClientWidth) / mClientHeight;
}

/*
	창 크기 변경 시 렌더링에 필요한 리소스들을 새 해상도에 맞게 재생성한다.
	1. 스왑체인 ResizeBuffers() 호출
		→ 백버퍼(Color buffer)는 DXGI가 자동으로 새 크기로 재생성함.
	2. Depth-Stencil 리소스는 스왑체인이 관리하지 않으므로
		→ 새 크기에 맞게 직접 CreateCommittedResource()로 재생성
		→ DSV 디스크립터도 다시 생성
	Color는 DXGI가 관리, Depth는 앱이 직접 관리한다.
*/
void InitAppD3D::OnResize()
{
	assert(md3dDevice);
	assert(mSwapChain);
	assert(mCommandAlloc);

	FlushCommandQueue();

	ThrowIfFailed(mCommandAlloc->Reset());
	ThrowIfFailed(mCommandList->Reset(mCommandAlloc.Get(), nullptr));
	for (auto& buffer : mSwapChainBuffer)
		buffer.Reset();
	mDepthStencilBuffer.Reset();

	ThrowIfFailed(mSwapChain->ResizeBuffers(
		SwapChainBufferCount,
		mClientWidth, mClientHeight,
		mBackBufferFormat,
		0));
	mCurrBackBuffer = 0;

	CD3DX12_CPU_DESCRIPTOR_HANDLE rtvHeapHandle(mRtvHeap->GetCPUDescriptorHandleForHeapStart());
	for (int i = 0; i < SwapChainBufferCount; i++)
	{
		//스왑체인->백버퍼는 텍스쳐 리소스.
		ThrowIfFailed(mSwapChain->GetBuffer(i, IID_PPV_ARGS(mSwapChainBuffer[i].GetAddressOf())));
		//디스크립터가 nullptr -> 백퍼버는 RTV의 기본형에 속하므로 기본형으로 만들라는 의미.
		md3dDevice->CreateRenderTargetView(mSwapChainBuffer[i].Get(), nullptr, rtvHeapHandle);
		rtvHeapHandle.Offset(1, mRtvDescriptorSize);
	}

	/*
	* ID3D12Resource (Depth Texture) (DXGI_FORMAT_R24G8_TYPELESS)
		├─ DSV(DXGI_FORMAT_D24_UNORM_S8_UINT)		→ OM 단계에서 깊이 테스트
		└─ SRV(DXGI_FORMAT_R24_UNORM_X8_TYPELESS)	→ Pixel / Compute Shader에서 depth 읽기

	  CreateCommittedResource에서의 Format은
	  "이 텍스처 메모리가 어떤 규칙으로 저장된다"를 결정한다.
	  이것이 정해져야
	   -메모리 크기 계산
	   -row pitch
	   -subresource layout
	   -허용 가능한 view의 범위 제한
	   이 가능해진다.
	*/
	D3D12_RESOURCE_DESC depthStencilDesc;
	depthStencilDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
	depthStencilDesc.Alignment = 0;
	depthStencilDesc.Width = mClientWidth;
	depthStencilDesc.Height = mClientHeight;
	depthStencilDesc.DepthOrArraySize = 1;
	depthStencilDesc.MipLevels = 1; //0은 가능한 모든 밉맵을 자동 생성한다는 의미.
	depthStencilDesc.Format = DXGI_FORMAT_R24G8_TYPELESS;
	depthStencilDesc.SampleDesc.Count = m4xMsaaState ? 4 : 1;
	depthStencilDesc.SampleDesc.Quality = m4xMsaaState ? (m4xMsaaQuality - 1) : 0;
	depthStencilDesc.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
	depthStencilDesc.Flags = D3D12_RESOURCE_FLAG_ALLOW_DEPTH_STENCIL;

	D3D12_CLEAR_VALUE optClear;
	optClear.Format = mdepthStencilFormat;
	optClear.DepthStencil.Depth = 1.f;
	optClear.DepthStencil.Stencil = 0;
	
	CD3DX12_HEAP_PROPERTIES heapProps(D3D12_HEAP_TYPE_DEFAULT);

	ThrowIfFailed(md3dDevice->CreateCommittedResource(
		&heapProps,
		D3D12_HEAP_FLAG_NONE,
		&depthStencilDesc,
		D3D12_RESOURCE_STATE_COMMON, // 실제 사용 직전에 필요한 상태로 전환.
		&optClear,
		IID_PPV_ARGS(mDepthStencilBuffer.GetAddressOf())));
	 
	//추후 해당 리소스를 DSV로써 사용할 때 사용.(SRV로써 사용할 수도 있음)
	D3D12_DEPTH_STENCIL_VIEW_DESC dsvDesc;
	dsvDesc.Flags = D3D12_DSV_FLAG_NONE;
	dsvDesc.ViewDimension = D3D12_DSV_DIMENSION_TEXTURE2D;
	dsvDesc.Format = mdepthStencilFormat;
	dsvDesc.Texture2D.MipSlice = 0;

	md3dDevice->CreateDepthStencilView(mDepthStencilBuffer.Get(), &dsvDesc, mDsvHeap->GetCPUDescriptorHandleForHeapStart());

	auto depthBarrier = CD3DX12_RESOURCE_BARRIER::Transition(
		mDepthStencilBuffer.Get(),
		D3D12_RESOURCE_STATE_COMMON,
		D3D12_RESOURCE_STATE_DEPTH_WRITE);
	mCommandList->ResourceBarrier(1, &depthBarrier);
	ThrowIfFailed(mCommandList->Close());

	ID3D12CommandList* cmdLists[] = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(_countof(cmdLists), cmdLists);

	FlushCommandQueue();

	mScreenViewport.TopLeftX = 0;
	mScreenViewport.TopLeftY = 0;
	mScreenViewport.Width = static_cast<float>(mClientWidth);
	mScreenViewport.Height = static_cast<float>(mClientHeight);
	mScreenViewport.MinDepth = 0.f;
	mScreenViewport.MaxDepth = 1.f;

	mScissorRect = { 0,0,mClientWidth,mClientHeight };
}

void InitAppD3D::CreateRtvDsvDescriptorHeaps()
{
	D3D12_DESCRIPTOR_HEAP_DESC rtvHeapDesc;
	rtvHeapDesc.NumDescriptors = SwapChainBufferCount;
	rtvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
	rtvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
	rtvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&rtvHeapDesc, IID_PPV_ARGS(mRtvHeap.GetAddressOf())));

	D3D12_DESCRIPTOR_HEAP_DESC dsvHeapDesc;
	dsvHeapDesc.NumDescriptors = 1;
	dsvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_DSV;
	dsvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
	dsvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&dsvHeapDesc, IID_PPV_ARGS(mDsvHeap.GetAddressOf())));
}

bool InitAppD3D::InitMainWindow()
{
	WNDCLASSEX wc = {};
	wc.cbSize = sizeof(WNDCLASSEX);
	wc.style = CS_HREDRAW | CS_VREDRAW;	//가로,세로 크기 변경 시 전체 ReDraw
	wc.lpfnWndProc = MainWndProc;

	//win16과의 호환 가능성을 위해 예약된 필드.
	wc.cbClsExtra = 0;					//클래스 메모리 추가 할당 없음.
	wc.cbWndExtra = 0;					//윈도우 메모리 추가 할당 없음.

	wc.hInstance = mhInstance;
	wc.hIcon = LoadIcon(0, IDI_APPLICATION);
	wc.hIconSm = LoadIcon(0, IDI_APPLICATION);
	wc.hCursor = LoadCursor(0, IDC_ARROW);
	//os가 배경을 칠하지 않음. dx가 직접 백버퍼 그림. flickering방지.
	wc.hbrBackground = (HBRUSH)GetStockObject(NULL_BRUSH);
	wc.lpszClassName = L"MainWindowClass";
	wc.lpszMenuName = 0; //메뉴 없음.

	//윈도우 설계도 등록. CreateWindow 호출 전 반드시 필요.
	if (!RegisterClassEx(&wc))
	{
		MessageBox(0, L"RegisterClass 실패", 0, 0);
		return false;
	}

	RECT R = { 0,0,mClientWidth, mClientHeight };
	AdjustWindowRect(&R, WS_OVERLAPPEDWINDOW, false);
	int width = R.right - R.left;
	int height = R.bottom - R.top;
	mhMainWnd = CreateWindow(L"MainWindowClass",	//등록한 윈도우 클래스 이름
		mMainWndCaption.c_str(),			//윈도우 타이틀 바 텍스트
		WS_OVERLAPPEDWINDOW,				//윈도우 스타일
		CW_USEDEFAULT,						//윈도우 초기 X 위치
		CW_USEDEFAULT,						//윈도우 초기 Y 위치
		width,								//윈도우 폭
		height,								//윈도우 높이
		0,									//부모 윈도우 핸들
		0,									//메뉴 핸들
		mhInstance,							//애플리케이션 인스턴스 핸들
		0);

	if (!mhMainWnd)
	{
		MessageBox(0, L"CreateWindow 실패", 0, 0);
		return false;
	}

	ShowWindow(mhMainWnd, SW_SHOW);
	UpdateWindow(mhMainWnd);

	return true;
}

bool InitAppD3D::InitDirect3D()
{
//디버그 레이어 활성화. CreateDevice 호출 전에 해야 함.
#if defined(DEBUG) || defined(_DEBUG)
	{
		ComPtr<ID3D12Debug> debugController1;
		ThrowIfFailed(D3D12GetDebugInterface(IID_PPV_ARGS(debugController1.GetAddressOf())));
		// D3D12 Debug Layer 활성화: API 사용 오류, 리소스 상태 전이/바인딩 규칙 위반 등을 런타임에 검출.
		debugController1->EnableDebugLayer();

		ComPtr<ID3D12Debug1> debugController2;
		ThrowIfFailed(debugController1.As(&debugController2));

		// GPU-Based Validation(GBV) 활성화: 디스크립터/리소스 바인딩 유효성(범위, 타입, 접근 규칙 등)을 GPU 실행 관점에서 추가 검증.
		// 성능 오버헤드가 매우 큼(디버그 전용 권장).
		debugController2->SetEnableGPUBasedValidation(TRUE);

		// Synchronized Command Queue Validation 활성화: 커맨드 큐/동기화 관련 검증을 더 동기적으로 수행해 오류 위치 리포팅을 개선.
		// 오버헤드 증가 가능. GPU hang/타임아웃 원인 추적에 도움이 될 수 있음.
		debugController2->SetEnableSynchronizedCommandQueueValidation(TRUE);
	}
#endif

	/*
	* DXGI Factory 생성
	* - GPU(Adapter) 및 출력(Output) 열거
	* - 스왑체인 생성 인터페이스 제공
	* - 전체화면 전환 및 디스플레이 관련 관리
	*/
	ThrowIfFailed(CreateDXGIFactory1(IID_PPV_ARGS(mdxgiFactory.GetAddressOf())));

	HRESULT hardwareResult = D3D12CreateDevice(nullptr, D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(md3dDevice.GetAddressOf()));
	if (FAILED(hardwareResult))
	{
		//WARP는 CPU로 동작하는 Direct3D 12용 소프트웨어 GPU
		ComPtr<IDXGIAdapter> pWarpAdapter;
		ThrowIfFailed(mdxgiFactory->EnumWarpAdapter(IID_PPV_ARGS(pWarpAdapter.GetAddressOf())));
		ThrowIfFailed(D3D12CreateDevice(pWarpAdapter.Get(), D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(md3dDevice.GetAddressOf())));
	}

	ThrowIfFailed(md3dDevice->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(mFence.GetAddressOf())));

	//GPU(드라이버) 구현에 따라 달라지므로 초기화 시 디바이스에서 조회.
	mRtvDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
	mDsvDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_DSV);
	mCbvSrvUavDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

	D3D12_FEATURE_DATA_MULTISAMPLE_QUALITY_LEVELS msQualityLevels;
	msQualityLevels.Format = mBackBufferFormat;
	msQualityLevels.SampleCount = 4;
	msQualityLevels.Flags = D3D12_MULTISAMPLE_QUALITY_LEVELS_FLAG_NONE;
	msQualityLevels.NumQualityLevels = 0;
	ThrowIfFailed(md3dDevice->CheckFeatureSupport(D3D12_FEATURE_MULTISAMPLE_QUALITY_LEVELS, &msQualityLevels, sizeof(msQualityLevels)));

	m4xMsaaQuality = msQualityLevels.NumQualityLevels;
	assert(m4xMsaaQuality > 0 && "MSAA 미지원");

#ifdef _DEBUG
	LogAdapters();
#endif // _DEBUG

	CreateCommandObjects();
	CreateSwapChain();
	CreateRtvDsvDescriptorHeaps();

	mFenceEvent.h = CreateEventEx(nullptr, nullptr, false, EVENT_ALL_ACCESS);
	//Win32 API 실패 원인을 HRESULT 오류 흐름으로 변환.
	if (!mFenceEvent.Get())
		ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));

	return true;
}

void InitAppD3D::CreateCommandObjects()
{
	D3D12_COMMAND_QUEUE_DESC queueDesc = {};
	queueDesc.Type = D3D12_COMMAND_LIST_TYPE_DIRECT;
	queueDesc.Flags = D3D12_COMMAND_QUEUE_FLAG_NONE;

	ThrowIfFailed(md3dDevice->CreateCommandQueue(&queueDesc, IID_PPV_ARGS(mCommandQueue.GetAddressOf())));

	ThrowIfFailed(md3dDevice->CreateCommandAllocator(queueDesc.Type, IID_PPV_ARGS(mCommandAlloc.GetAddressOf())));

	ThrowIfFailed(md3dDevice->CreateCommandList(
		0,	// 첫번째 GPU사용.
		queueDesc.Type,
		mCommandAlloc.Get(),
		nullptr,
		IID_PPV_ARGS(mCommandList.GetAddressOf())));

	mCommandList->Close();
}

void InitAppD3D::CreateSwapChain()
{
	/*
		스왑체인은 GPU 리소스를 포함하지만,
		윈도우·모니터·VSync 등 OS 그래픽 시스템과 직접 결합된 객체이기 때문에
		API 공통 계층인 DXGI Factory에서 생성
	*/
	mSwapChain.Reset();

	DXGI_SWAP_CHAIN_DESC sd;
	sd.BufferDesc.Height = mClientHeight;
	sd.BufferDesc.Width = mClientWidth;
	sd.BufferDesc.RefreshRate.Numerator = 60;
	sd.BufferDesc.RefreshRate.Denominator = 1;
	sd.BufferDesc.Format = mBackBufferFormat;
	sd.BufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED; //DXGI에 맞김. 해당 값 고정.
	sd.BufferDesc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;
	//이슈. 스왑체인의 샘플링 변경안에 대해서.
	sd.SampleDesc.Count = m4xMsaaState ? 4 : 1;
	sd.SampleDesc.Quality = m4xMsaaState ? (m4xMsaaQuality - 1) : 0;
	sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	sd.BufferCount = SwapChainBufferCount;
	sd.OutputWindow = mhMainWnd;
	sd.Windowed = true;
	//DISCARD 는 Present 후 버퍼 내용이 보존되지 않아도 된다는 의미.
	//어짜피 매 프레인 전체를 다시 그리므로 상관없음.
	sd.SwapEffect = DXGI_SWAP_EFFECT_FLIP_DISCARD;
	//전체 화면 전환 시 디스플레이 모드 스위치 허용 여부.
	//DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH -> Exclusive fullscreen
	sd.Flags = 0;

	ThrowIfFailed(mdxgiFactory->CreateSwapChain(mCommandQueue.Get(), &sd, mSwapChain.GetAddressOf()));
}

void InitAppD3D::FlushCommandQueue()
{
	mCurrentFence++;
	//실패시 회복 불가능한 os레벨 작업.
	ThrowIfFailed(mCommandQueue->Signal(mFence.Get(), mCurrentFence));

	if (mFence->GetCompletedValue() < mCurrentFence)
	{
		ThrowIfFailed(mFence->SetEventOnCompletion(mCurrentFence, mFenceEvent.Get()));
		WaitForSingleObject(mFenceEvent.Get(), INFINITE);
	}
}

void InitAppD3D::CalculateFrameStats()
{
	static int frameCnt = 0;
	static double timeElapsed = mTimer.TotalTime();

	frameCnt++;

	if ((mTimer.TotalTime() - timeElapsed) >= 1.f)
	{
		float fps = (float)frameCnt;
		float mfps = 1000.f / fps;

		std::wstring fpsStr = std::to_wstring(fps);
		std::wstring mfpsStr = std::to_wstring(mfps);

		std::wstring windowText = mMainWndCaption + L"	fps: " + fpsStr + L"	mfps: " + mfpsStr;

		SetWindowText(mhMainWnd, windowText.c_str());

		frameCnt = 0;
		timeElapsed += mTimer.TotalTime();
	}
}

void InitAppD3D::LogAdapters()
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
		i++;
	}
	for (size_t i = 0; i < adapterList.size(); i++)
	{
		LogAdapterOutputs(adapterList[i]);
		ReleaseCom(adapterList[i]);
	}
}

void InitAppD3D::LogAdapterOutputs(IDXGIAdapter* adapter)
{
	UINT i = 0;
	IDXGIOutput* output = nullptr;
	while (adapter->EnumOutputs(i, &output) != DXGI_ERROR_NOT_FOUND)
	{
		DXGI_OUTPUT_DESC desc;
		output->GetDesc(&desc);

		std::wstring text = L"--------------------Output--------------------";
		text += desc.DeviceName;
		text += L"\n\n";

		OutputDebugString(text.c_str());
		LogOutputDisplayModes(output, mBackBufferFormat);

		ReleaseCom(output);
		i++;
	}
}

void InitAppD3D::LogOutputDisplayModes(IDXGIOutput* output, DXGI_FORMAT format)
{
	UINT count = 0;
	UINT flags = 0;

	output->GetDisplayModeList(format, flags, &count, nullptr); //nullptr로 개수만 조회.
	std::vector<DXGI_MODE_DESC> modeList(count);
	output->GetDisplayModeList(format, flags, &count, modeList.data());

	for (auto& x : modeList)
	{
		UINT n = x.RefreshRate.Numerator;
		UINT d = x.RefreshRate.Denominator;
		std::wstring text = L"Width: " + std::to_wstring(x.Width) +
			L" Height: " + std::to_wstring(x.Height) +
			L" Refresh Rate: " + std::to_wstring(n) + L"/" + std::to_wstring(d) + L"\n";

		OutputDebugString(text.c_str());
	}
}

ID3D12Resource* InitAppD3D::CurrentBackBuffer() const
{
	return mSwapChainBuffer[mCurrBackBuffer].Get();
}

D3D12_CPU_DESCRIPTOR_HANDLE InitAppD3D::CurrentBackBufferView() const
{
	return CD3DX12_CPU_DESCRIPTOR_HANDLE(mRtvHeap->GetCPUDescriptorHandleForHeapStart(), mCurrBackBuffer, mRtvDescriptorSize);
}

D3D12_CPU_DESCRIPTOR_HANDLE InitAppD3D::DepthStencilView() const
{
	return mDsvHeap->GetCPUDescriptorHandleForHeapStart();;
}
