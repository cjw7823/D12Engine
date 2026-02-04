#include "InitAppD3D.h"
#include <iostream>
#include <WindowsX.h> // For GET_X_LPARAM, GET_Y_LPARAM, #include <Window.h> 선행 필수.

using namespace Microsoft::WRL;

LRESULT CALLBACK MainWndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	return InitAppD3D::GetApp()->MsgProc(hWnd, msg, wParam, lParam);
}

InitAppD3D::InitAppD3D(HINSTANCE hInstance) : mhAppInst(hInstance)
{
	assert(mApp == nullptr); //프로그램 당 하나의 인스턴스만 허용
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
			//키보드 이벤트의 경우 WM_CHAR 또는 WM_SYSCHAR 를 메시지 큐에 추가
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		else
		{
			mTimer.Tick();

			if (!mAppPaused)
			{
				CalculateFrameStats();
				Update(mTimer);
				Draw(mTimer);
			}
			else
				Sleep(100); //앱이 일시정지 상태면 CPU점유율 낮춤.
		}
	}

	return static_cast<int>(msg.wParam);
}

bool InitAppD3D::Initialize()
{
	if (!InitMainWindow())
		return false;
	if (!InitDirect3D())
		return false;

	OnResize(); //SwapChain과 관련된 자원들을 초기화
	
	return true;
}

LRESULT InitAppD3D::MsgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	switch (msg)
	{
	case WM_ACTIVATE:	//윈도우 포커스가 변경되었을 경우
		if (LOWORD(wParam) == WA_INACTIVE)
		{
			mAppPaused = true;
			mTimer.Stop();
		}
		else
		{
			mAppPaused = false;
			mTimer.Start();
		}
		return 0;

	case WM_SIZE:		//윈도우 크기가 변경될 경우
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
			else if (wParam == SIZE_RESTORED)//정상 크기 상태로 복귀/변경
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
		mTimer.Stop();
		return 0;

	case WM_EXITSIZEMOVE:
		mAppPaused = false;
		mResizing = false;
		mTimer.Start();
		OnResize();
		return 0;

	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;

	case WM_MENUCHAR: // 메뉴가 활성화된 상태에서 사용자가 니모닉 키나 가속기 키에 해당하지 않는 키를 누를 때 전송됩니다.
		return MAKELRESULT(0, MNC_CLOSE); //삐 소리 방지.

	case WM_GETMINMAXINFO: //윈도우가 크기를 바꾸기 전에 최소/최대 크기 제약.
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

	return DefWindowProc(hWnd, msg, wParam, lParam);
}

void InitAppD3D::Set4xMsaaState(bool value)
{
	if (m4xMsaaState != value)
	{
		m4xMsaaState = value;

		std::wstring debug = std::wstring(L"MSAA : ") + (value ? L"True" : L"False") + std::wstring(L"MSAA : ") + L"\n";
		OutputDebugString(debug.c_str());

		FlushCommandQueue();
		CreateSwapChain(); //테스트 필요. msaa설정에 스왑체인 재설정 필요 없음.
		OnResize();
	}
}

float InitAppD3D::AspectRatio() const
{
	return static_cast<float>(mClientWidth) / mClientHeight;
}

void InitAppD3D::OnResize()
{
	assert(md3dDevice);
	assert(mSwapChain);
	assert(mDirectCmdListAlloc);

	FlushCommandQueue();

	ThrowIfFailed(mCommandList->Reset(mDirectCmdListAlloc.Get(), nullptr));
	for (auto& buffer : mSwapChainBuffer)
		buffer.Reset();
	mDepthStencilBuffer.Reset();

	ThrowIfFailed(mSwapChain->ResizeBuffers(
		SwapChainBufferCount,
		mClientWidth, mClientHeight,
		mBackBufferFormat,
		DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH));
	mCurrBackBuffer = 0;

	//스왑체인의 백버퍼들은 실제로 GPU메모리의 텍스처 리소스.
	CD3DX12_CPU_DESCRIPTOR_HANDLE rtvHeapHandle(mRtvHeap->GetCPUDescriptorHandleForHeapStart());
	for (int i = 0; i < SwapChainBufferCount; i++)
	{
		//이를 별도로 mSwapChainBuffer에 관리.
		ThrowIfFailed(mSwapChain->GetBuffer(i, IID_PPV_ARGS(&mSwapChainBuffer[i])));
		//해당 리소스를 Desc에 맞게 해석해서 디스크립터 슬롯에 RTV를 만들어라.
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
	depthStencilDesc.MipLevels = 1; // 0은 가능한 모든 밉맵을 자동 생성한다는 의미.
	depthStencilDesc.Format = DXGI_FORMAT_R24G8_TYPELESS;
	depthStencilDesc.SampleDesc.Count = m4xMsaaState ? 4 : 1;
	depthStencilDesc.SampleDesc.Quality = m4xMsaaState ? (m4xMsaaQuality - 1) : 0;
	depthStencilDesc.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
	depthStencilDesc.Flags = D3D12_RESOURCE_FLAG_ALLOW_DEPTH_STENCIL;

	D3D12_CLEAR_VALUE optClear;
	optClear.Format = mDepthStencilFormat;
	optClear.DepthStencil.Depth = 1.0f;
	optClear.DepthStencil.Stencil = 0;
	//D3D12_HEAP_TYPE_DEFAULT는 GPU 전용 메모리(실제 VRAM 또는 드라이버가 관리하는 GPU-local)
	CD3DX12_HEAP_PROPERTIES heapProps(D3D12_HEAP_TYPE_DEFAULT);

	ThrowIfFailed(md3dDevice->CreateCommittedResource(
		&heapProps,
		D3D12_HEAP_FLAG_NONE,
		&depthStencilDesc,
		D3D12_RESOURCE_STATE_COMMON, //생성 시 보통 commom 상태. 사용 직전에 필요한 상태로 전환.
		&optClear,
		IID_PPV_ARGS(mDepthStencilBuffer.GetAddressOf())));

	//위에서는 리소스를 생성했고 그 리소스를 어떻게 사용할지에 대한 Desc 생성.
	//여기선 추후 해당 리소스를 DSV로써 사용할 때 사용.(SRV로써 사용할 수도 있기 때문)
	D3D12_DEPTH_STENCIL_VIEW_DESC dsvDesc;
	dsvDesc.Flags = D3D12_DSV_FLAG_NONE;
	dsvDesc.ViewDimension = D3D12_DSV_DIMENSION_TEXTURE2D;
	dsvDesc.Format = mDepthStencilFormat;
	dsvDesc.Texture2D.MipSlice = 0;

	md3dDevice->CreateDepthStencilView(mDepthStencilBuffer.Get(), &dsvDesc, mDsvHeap->GetCPUDescriptorHandleForHeapStart());

	auto depthBarrier = CD3DX12_RESOURCE_BARRIER::Transition(
		mDepthStencilBuffer.Get(),
		D3D12_RESOURCE_STATE_COMMON,
		D3D12_RESOURCE_STATE_DEPTH_WRITE);

	mCommandList->ResourceBarrier(1, &depthBarrier);
	ThrowIfFailed(mCommandList->Close());

	//여러 개의 커맨드 리스트 객체를 순서대로 GPU 큐에 제출.
	ID3D12CommandList* cmdLists[] = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(_countof(cmdLists), cmdLists);

	FlushCommandQueue();

	mScreenViewport.TopLeftX = 0;
	mScreenViewport.TopLeftY = 0;
	mScreenViewport.Width = static_cast<float>(mClientWidth);
	mScreenViewport.Height = static_cast<float>(mClientHeight);
	mScreenViewport.MinDepth = 0.0f;
	mScreenViewport.MaxDepth = 1.0f;

	mScissorRect = { 0, 0, mClientWidth, mClientHeight };
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
	WNDCLASSEX wc = {};					//윈도우 객체의 공통 속성 정의서.
	wc.cbSize = sizeof(WNDCLASSEX);
	wc.style = CS_HREDRAW | CS_VREDRAW; //가로/세로 크기 변경 시 전체 다시 그리기.
	wc.lpfnWndProc = MainWndProc;

	//win16과의 호환 가능성을 위해 예약된 필드.
	wc.cbClsExtra = 0;					//클래스 메모리 추가 할당 없음.
	wc.cbWndExtra = 0;					//윈도우 메모리 추가 할당 없음.

	wc.hInstance = mhAppInst;
	wc.hIcon = LoadIcon(0, IDI_APPLICATION);
	wc.hIconSm = LoadIcon(0, IDI_APPLICATION);
	wc.hCursor = LoadCursor(0, IDC_ARROW);
	//윈도우가 배경을 칠하지 않음. dx가 직접 백버퍼 그림. flickering방지.
	wc.hbrBackground = (HBRUSH)GetStockObject(NULL_BRUSH);
	wc.lpszClassName = L"MainWindowClass";
	wc.lpszMenuName = 0; //메뉴 없음.

	//윈도우 설계도 등록. CreateWindow 호출 전 반드시 필요.
	if(!RegisterClassEx(&wc))
	{
		MessageBox(0, L"RegisterClass 실패", 0, 0);
		return false;
	}

	RECT R = { 0, 0, mClientWidth, mClientHeight };
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
		mhAppInst,							//애플리케이션 인스턴스 핸들
		0);									//추가 생성 매개변수

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
		ComPtr<ID3D12Debug> debugController;
		ThrowIfFailed(D3D12GetDebugInterface(IID_PPV_ARGS(&debugController)));
		debugController->EnableDebugLayer();

		ComPtr<ID3D12Debug1> debugController1;
		ThrowIfFailed(debugController.As(&debugController1));

		// GPU가 실제로 명령 실행 중 발생하는 메모리 접근 오류 검출. (리소스 바인딩 등..)
		debugController1->SetEnableGPUBasedValidation(TRUE);
		// 커맨드 큐, 펜스 사용시 오류로 인한 크래시 분석. (GPU hang)
		debugController1->SetEnableSynchronizedCommandQueueValidation(TRUE);
	}
#endif

	/*
	* DXGI Factory 생성
	* - GPU(Adapter) 및 출력(Output) 열거
	* - 스왑체인 생성 인터페이스 제공
	* - 전체화면 전환 및 디스플레이 관련 관리
	*/
	ThrowIfFailed(CreateDXGIFactory1(IID_PPV_ARGS(&mdxgiFactory)));

	//GPU 자원 및 파이프라인 객체의 생성 주체
	HRESULT hardwareResult = D3D12CreateDevice(nullptr, D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(&md3dDevice));
	if (FAILED(hardwareResult))
	{
		//WARP는 CPU로 동작하는 Direct3D 12용 소프트웨어 GPU
		ComPtr<IDXGIAdapter> pWarpAdapter;
		ThrowIfFailed(mdxgiFactory->EnumWarpAdapter(IID_PPV_ARGS(&pWarpAdapter)));
		ThrowIfFailed(D3D12CreateDevice(pWarpAdapter.Get(), D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(&md3dDevice)));
	}

	ThrowIfFailed(md3dDevice->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(&mFence)));

	//GPU(드라이버) 구현에 따라 달라지므로 초기화 시 디바이스에서 조회.
	mRtvDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
	mDsvDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_DSV);
	mCbvSrvUavDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

	//현재 GPU가 mBackBufferFormat 포맷에서 4xMSAA를 지원하는지 확인.
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
#endif

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
	ThrowIfFailed(md3dDevice->CreateCommandQueue(&queueDesc, IID_PPV_ARGS(&mCommandQueue)));

	ThrowIfFailed(md3dDevice->CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, IID_PPV_ARGS(mDirectCmdListAlloc.GetAddressOf())));

	ThrowIfFailed(md3dDevice->CreateCommandList(
		0,	//노드 마스크. 첫번째 GPU사용.
		D3D12_COMMAND_LIST_TYPE_DIRECT,
		mDirectCmdListAlloc.Get(),
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
	sd.BufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED; //DXGI에 맞김. 그냥 확정적.
	sd.BufferDesc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;
	//SwapChain에서는 SampleDesc를 절대 토글하지 않는다.
	//항상 Count = 1, Quality = 0. MSAA는 "렌더 타깃 + 뎁스"에서만 처리한다.
	sd.SampleDesc.Count = m4xMsaaState ? 4 : 1;
	sd.SampleDesc.Quality = m4xMsaaState ? (m4xMsaaQuality - 1) : 0;
	//sd.SampleDesc.Count = 1;
	//sd.SampleDesc.Quality = 0;
	sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	sd.BufferCount = SwapChainBufferCount;
	sd.OutputWindow = mhMainWnd;
	sd.Windowed = true;
	//DISCARD 는 Present 후 버퍼 내용이 보존되지 않아도 된다는 의미.
	//어짜피 매 프레인 전체를 다시 그리므로 상관없음.
	sd.SwapEffect = DXGI_SWAP_EFFECT_FLIP_DISCARD;
	//전체 화면 전환 시 디스플레이 모드 스위치를 허용.
	sd.Flags = DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;

	ThrowIfFailed(mdxgiFactory->CreateSwapChain(mCommandQueue.Get(), &sd, mSwapChain.GetAddressOf()));
}

//매번 이벤트 생성/제거 로직 -> 이벤트핸들을 멤버변수로 만들어 개선
void InitAppD3D::FlushCommandQueue()
{
	mCurrentFence++;
	//실패시 회복 불가능한 os레벨 작업이므로 ThrowIfFailed 사용.
	ThrowIfFailed(mCommandQueue->Signal(mFence.Get(), mCurrentFence));

	if (mFence->GetCompletedValue() < mCurrentFence)
	{
		ThrowIfFailed(mFence->SetEventOnCompletion(mCurrentFence, mFenceEvent.Get()));
		::WaitForSingleObject(mFenceEvent.Get(), INFINITE);
	}
}

void InitAppD3D::CalculateFrameStats()
{
	static int frameCnt = 0;
	static double timeElapsed = 0.0f;

	frameCnt++;

	if ((mTimer.TotalTime() - timeElapsed) >= 1.0f)
	{
		float fps = static_cast<float>(frameCnt);
		float mfps = 1000.0f / fps;

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

		std::wstring text = L"------------- Output -------------";
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
	output->GetDisplayModeList(format, flags, &count, &modeList[0]);

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
