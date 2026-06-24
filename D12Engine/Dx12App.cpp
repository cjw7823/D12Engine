#include "pch.h"
#include "Dx12App.h"
#include <windowsX.h> // GET_X_LPARAM(), GET_Y_LPARAM()
#include "d3dUtil.h"

using namespace Microsoft::WRL;

extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

LRESULT CALLBACK MainWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	return Dx12App::GetApp()->MsgProc(hwnd, msg, wParam, lParam);
}

Dx12App::Dx12App(HINSTANCE hInstance)
{
	assert(mApp == nullptr);
	mApp = this;
}

Dx12App::~Dx12App()
{
	if(md3dDevice != nullptr && mCommandQueue != nullptr)
		FlushCommandQueue();
}

int Dx12App::Run()
{
	MSG msg = { 0 };

	mTimer.Reset();

	while(msg.message != WM_QUIT)
	{
		if(PeekMessage(&msg, 0, 0, 0, PM_REMOVE))
		{
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
				Sleep(100); //앱이 일시 정지된 경우 CPU 사용량을 낮춤
		}
	}

	return static_cast<int>(msg.wParam);
}

bool Dx12App::Initialize()
{
	if (!InitMainWindow())
		return false;
	if (!InitDirect3D())
		return false;

	OnResize();

	return true;
}

LRESULT Dx12App::MsgProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	if (ImGui_ImplWin32_WndProcHandler(hwnd, msg, wParam, lParam)) return 0;

	switch (msg)
	{
	case WM_ACTIVATE:
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

	case WM_SIZE:
		mClientHeight = HIWORD(lParam);
		mClientWidth = LOWORD(lParam);
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
					//드래그 중 계속해서 WM_SIZE 메시지가 오기 때문에 OnResize를 호출하지 않는다.
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
		return 0;

	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;

	case WM_MENUCHAR:// 메뉴가 활성화된 상태에서 사용자가 니모닉 키나 가속기 키에 해당하지 않는 키를 누를 때 전송되는 메시지
		return MAKELRESULT(0, MNC_CLOSE); // Alt+Enter이 눌렸을 때 시스템이 비프음을 내지 않도록 한다.

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
		else OnKeyUp(wParam);
		return 0;

	case WM_KEYDOWN:
		OnKeyDown(wParam);
		return 0;
	}

	return DefWindowProc(hwnd, msg, wParam, lParam);
}

void Dx12App::NextMsaaOoption()
{
	mMsaaOption.Next();
	std::wstring debug = L"MSAA Level : " + std::to_wstring(mMsaaOption.SampleCount()) + L"\n";
	OutputDebugString(debug.c_str());

	FlushCommandQueue();
	OnResize();
}

void Dx12App::SetMsaaOption(UINT value)
{
	if (mMsaaOption.GetState() != value)
	{
		mMsaaOption(value);

		std::wstring debug = L"MSAA" + std::to_wstring(value) + L" : " + (value ? L"True" : L"False") + L"\n";
		OutputDebugString(debug.c_str());

		FlushCommandQueue();
		OnResize();
	}
}

float Dx12App::AspectRatio() const
{
	return static_cast<float>(mClientWidth) / mClientHeight;
}

/*
	창 크기 변경 시 렌더링에 필요한 리소스들을 새 해상도에 맞게 재생성.
	1. 스왑체인 ResizeBuffers() 호출
		-> 백버퍼(Color buffer)는 DXGI가 자동으로 새 크기로 재생성함.
	2. Depth-Stencil 리소스는 스왑체인이 관리하지 않으므로
		-> 새 크기에 맞게 직접 CreateCommittedResource() 호출하여 재생성
		-> DSV 디스크립터도 다시 생성
*/
void Dx12App::OnResize()
{
	assert(md3dDevice);
	assert(mSwapChain);
	assert(mCommandAlloc);

	FlushCommandQueue();

	ThrowIfFailed(mCommandAlloc->Reset());
	ThrowIfFailed(mCommandList->Reset(mCommandAlloc.Get(), nullptr));
	for (auto& buffer : mSwapChainBuffer)//ComPtr 초기화
		buffer.Reset();
	mDepthStencilBuffer.Reset();
	mMsaaRenderTarget.Reset();

	ThrowIfFailed(mSwapChain->ResizeBuffers(SwapChainBufferCount,
		mClientWidth, mClientHeight,
		mBackBufferFormat,
		0));
	mCurrBackBuffer = 0;

	CD3DX12_CPU_DESCRIPTOR_HANDLE rtvHeapHandle(mRtvHeap->GetCPUDescriptorHandleForHeapStart());

	for (int i = 0; i < SwapChainBufferCount; i++)
	{
		// 스왑체인의 i번째 백버퍼를 ID3D12Resource로 가져온다.
		// 백버퍼도 결국 렌더 타겟으로 사용할 Texture2D 리소스다.
		ThrowIfFailed(mSwapChain->GetBuffer(
			i,
			IID_PPV_ARGS(mSwapChainBuffer[i].GetAddressOf())));

		// RTV_DESC를 nullptr로 넘기면 리소스 포맷/차원 정보를 기반으로
		// 기본 Render Target View를 생성한다.
		md3dDevice->CreateRenderTargetView(
			mSwapChainBuffer[i].Get(),
			nullptr,
			rtvHeapHandle);

		// 다음 RTV 디스크립터 슬롯으로 이동한다.
		rtvHeapHandle.Offset(1, mRtvDescriptorSize);
	}

	/*
		ID3D12Resource (Depth Texture) (DXGI_ForMAT_R24G8_TYPELESS)
		-> DSV (DXGI_FORMAT_D24_UNORM_S8_UINT) : OM 단계에서 깊이 테스트
		-> SRV (DXGI_FORMAT_R24_UNORM_X8_TYPELESS) : 픽셀 셰이더에서 깊이 텍스처로 접근

		CreateCommittedResource에서의 Format은
		"이 텍스처 메모리가 어떤 규칙으로 저장된다"를 결정한다.
		이것이 정해져야
		- 메모리 크기 계산
		- row pitch 계산
		- subresource layout 계산
		- 허용 가능한 view의 범위 제한
		이 가능해진다.
	*/
	D3D12_RESOURCE_DESC depthStencilDesc;
	depthStencilDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
	depthStencilDesc.Alignment = 0;
	depthStencilDesc.Width = mClientWidth;
	depthStencilDesc.Height = mClientHeight;
	depthStencilDesc.DepthOrArraySize = 1;
	depthStencilDesc.MipLevels = 1; //0이 아니다. 0으로 하면 모든 mipmap level이 생성되는데, depth-stencil 버퍼는 mipmap이 필요없다.
	depthStencilDesc.Format = DXGI_FORMAT_R24G8_TYPELESS;
	depthStencilDesc.SampleDesc.Count = mMsaaOption.SampleCount();
	depthStencilDesc.SampleDesc.Quality = mMsaaOption.Quality();
	depthStencilDesc.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
	depthStencilDesc.Flags = D3D12_RESOURCE_FLAG_ALLOW_DEPTH_STENCIL;

	D3D12_CLEAR_VALUE optClear;
	optClear.Format = mDepthStencilFormat;
	optClear.DepthStencil.Depth = 1.0f;
	optClear.DepthStencil.Stencil = 0;

	CD3DX12_HEAP_PROPERTIES heapProps(D3D12_HEAP_TYPE_DEFAULT);

	ThrowIfFailed(md3dDevice->CreateCommittedResource(
		&heapProps,
		D3D12_HEAP_FLAG_NONE,
		&depthStencilDesc,
		D3D12_RESOURCE_STATE_DEPTH_WRITE,
		&optClear,
		IID_PPV_ARGS(mDepthStencilBuffer.GetAddressOf())));

	//추후 해당 리소스를 DSV로써 사용할 때 사용.(SRV로써 사용할 수도 있음)
	D3D12_DEPTH_STENCIL_VIEW_DESC dsvDesc = {};
	dsvDesc.Flags = D3D12_DSV_FLAG_NONE;
	dsvDesc.Format = mDepthStencilFormat;

	if (mMsaaOption.IsEnable())
		dsvDesc.ViewDimension = D3D12_DSV_DIMENSION_TEXTURE2DMS;
	else
	{
		dsvDesc.ViewDimension = D3D12_DSV_DIMENSION_TEXTURE2D;
		dsvDesc.Texture2D.MipSlice = 0;
	}

	md3dDevice->CreateDepthStencilView(mDepthStencilBuffer.Get(), &dsvDesc, mDsvHeap->GetCPUDescriptorHandleForHeapStart());

	// MSAA 렌더 타겟도 새 크기에 맞게 재생성한다.	
	if (mMsaaOption.IsEnable())
	{
		D3D12_RESOURCE_DESC texDesc = {};
		texDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
		texDesc.Width = mClientWidth;
		texDesc.Height = mClientHeight;
		texDesc.DepthOrArraySize = 1;
		texDesc.MipLevels = 1;
		texDesc.Format = mBackBufferFormat;
		texDesc.SampleDesc.Count = mMsaaOption.SampleCount();
		texDesc.SampleDesc.Quality = mMsaaOption.Quality();
		texDesc.Layout = D3D12_TEXTURE_LAYOUT_UNKNOWN;
		texDesc.Flags = D3D12_RESOURCE_FLAG_ALLOW_RENDER_TARGET;

		D3D12_CLEAR_VALUE clearValue = {};
		clearValue.Format = mBackBufferFormat;
		clearValue.Color[0] = 0.7f;
		clearValue.Color[1] = 0.7f;
		clearValue.Color[2] = 0.7f;
		clearValue.Color[3] = 1.0f;

		CD3DX12_HEAP_PROPERTIES heapProps(D3D12_HEAP_TYPE_DEFAULT);
		ThrowIfFailed(md3dDevice->CreateCommittedResource(
			&heapProps,
			D3D12_HEAP_FLAG_NONE,
			&texDesc,
			D3D12_RESOURCE_STATE_RENDER_TARGET,
			&clearValue,
			IID_PPV_ARGS(mMsaaRenderTarget.GetAddressOf())));

		md3dDevice->CreateRenderTargetView(
			mMsaaRenderTarget.Get(),
			nullptr,
			MsaaRenderTargetView());
	}
	
	ThrowIfFailed(mCommandList->Close());
	
	std::vector<ID3D12CommandList*> cmdLists = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(static_cast<UINT>(cmdLists.size()), cmdLists.data());

	FlushCommandQueue();

	mScreenViewport.TopLeftX = 0;
	mScreenViewport.TopLeftY = 0;
	mScreenViewport.Width = static_cast<float>(mClientWidth);
	mScreenViewport.Height = static_cast<float>(mClientHeight);
	mScreenViewport.MinDepth = 0.0f;
	mScreenViewport.MaxDepth = 1.0f;

	mScissorRect = { 0, 0, mClientWidth, mClientHeight };
}

void Dx12App::CreateRtvDsvDescriptorHeaps()
{
	D3D12_DESCRIPTOR_HEAP_DESC rtvHeapDesc = {};
	rtvHeapDesc.NumDescriptors = SwapChainBufferCount + 1; //백버퍼 + MSAA 렌더 타겟
	rtvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
	rtvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
	rtvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&rtvHeapDesc, IID_PPV_ARGS(mRtvHeap.GetAddressOf())));

	D3D12_DESCRIPTOR_HEAP_DESC dsvHeapDesc = {};
	dsvHeapDesc.NumDescriptors = 1;
	dsvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_DSV;
	dsvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
	dsvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&dsvHeapDesc, IID_PPV_ARGS(mDsvHeap.GetAddressOf())));
}

bool Dx12App::InitMainWindow()
{
	WNDCLASSEX wc = {};
	wc.cbSize = sizeof(WNDCLASSEX);
	wc.style = CS_HREDRAW | CS_VREDRAW; //가로, 세로 크기 변경 시 전체 ReDraw
	wc.lpfnWndProc = MainWndProc;

	wc.cbClsExtra = 0; // 윈도우 클래스마다 추가로 확보할 바이트 수
	wc.cbWndExtra = 0; // 각 윈도우 인스턴스마다 추가로 확보할 바이트 수

	wc.hInstance = mhInstance;
	wc.hIcon = LoadIcon(0, IDI_APPLICATION);
	wc.hIconSm = LoadIcon(0, IDI_APPLICATION);
	wc.hCursor = LoadCursor(0, IDC_ARROW);
	wc.hbrBackground = (HBRUSH)GetStockObject(NULL_BRUSH); //윈도우 배경 설정하지 않음. dx12로 직접 백버퍼를 그릴 것이기 때문.
	wc.lpszClassName = L"MainWnd";
	wc.lpszMenuName = 0; //메뉴 없음.

	if (!RegisterClassEx(&wc))
	{
		MessageBox(0, L"RegisterClass 실패.", 0, 0);
		return false;
	}

	RECT R = { 0,0, mClientWidth, mClientHeight };
	AdjustWindowRect(&R, WS_OVERLAPPEDWINDOW, false);
	int width = R.right - R.left;
	int height = R.bottom - R.top;
	mhMainWnd = CreateWindow(
		wc.lpszClassName,
		mMainWndCaption.c_str(),
		WS_OVERLAPPEDWINDOW,			//윈도우 스타일
		CW_USEDEFAULT, CW_USEDEFAULT,	//윈도우 초기 위치
		width, height,					//윈도우 크기
		0, 0, mhInstance, 0);

	if (!mhMainWnd)
	{
		MessageBox(0, L"CreateWindow 실패.", 0, 0);
		return false;
	}

	ShowWindow(mhMainWnd, SW_SHOW);
	UpdateWindow(mhMainWnd);

	return true;
}

bool Dx12App::InitDirect3D()
{
	//CreateDevice 호출 전에 해야 함.
#if defined(DEBUG) || defined(_DEBUG)
	{
		ComPtr<ID3D12Debug1> debugController;
		ThrowIfFailed(D3D12GetDebugInterface(IID_PPV_ARGS(debugController.GetAddressOf())));
		// D3D12 Debug Layer 활성화: API 사용 오류, 리소스 상태 전이/바인딩 규칙 위반 등을 런타임에 검출.
		debugController->EnableDebugLayer();

		// GPU-Based Validation(GBV) 활성화: 디스크립터/리소스 바인딩 유효성(범위, 타입, 접근 규칙 등)을 GPU 실행 관점에서 추가 검증.
		// 성능 오버헤드가 매우 큼(디버그 전용 권장).
		debugController->SetEnableGPUBasedValidation(TRUE);

		// Synchronized Command Queue Validation 활성화: 커맨드 큐/동기화 관련 검증을 더 동기적으로 수행해 오류 위치 리포팅을 개선.
		// 오버헤드 증가 가능. GPU hang/타임아웃 원인 추적에 도움이 될 수 있음.
		debugController->SetEnableSynchronizedCommandQueueValidation(TRUE);
	}
#endif
	/*
		DXGI 팩토리 생성
		- GPU 어댑터, Output(모니터) 열거
		- 스왑체인 생성
		- 전체 화면 전환 및 디스플레이 관련 관리	
	*/
	ThrowIfFailed(CreateDXGIFactory1(IID_PPV_ARGS(mdxgiFactory.GetAddressOf())));

	HRESULT hardwareResult = D3D12CreateDevice(nullptr, D3D_FEATURE_LEVEL_12_2, IID_PPV_ARGS(md3dDevice.GetAddressOf()));
	if (FAILED(hardwareResult))
	{
		MessageBox(0, L"하드웨어 디바이스 생성 실패. WARP 디바이스로 시도합니다.", 0, 0);
		ComPtr<IDXGIAdapter> pWarpAdapter;
		ThrowIfFailed(mdxgiFactory->EnumWarpAdapter(IID_PPV_ARGS(pWarpAdapter.GetAddressOf())));
		ThrowIfFailed(D3D12CreateDevice(pWarpAdapter.Get(), D3D_FEATURE_LEVEL_12_2, IID_PPV_ARGS(md3dDevice.GetAddressOf())));
	}

	ThrowIfFailed(md3dDevice->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(mFence.GetAddressOf())));

	//GPU 드라이버 구현에 따라 달라지므로 초기화 시 디바이스에서 조회.
	mRtvDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
	mDsvDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_DSV);
	mCbvSrvUavDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

	std::wstring msg = L"MSAA 지원 목록\nMsaa Level 1\n";
	for (UINT i = 0; i < MsaaOption::kMsaaSampleCandidates.size(); i++)
	{
		D3D12_FEATURE_DATA_MULTISAMPLE_QUALITY_LEVELS msQualityLevels;
		msQualityLevels.Format = mBackBufferFormat;
		msQualityLevels.SampleCount = MsaaOption::kMsaaSampleCandidates[i];
		msQualityLevels.Flags = D3D12_MULTISAMPLE_QUALITY_LEVELS_FLAG_NONE;
		msQualityLevels.NumQualityLevels = 0;

		ThrowIfFailed(md3dDevice->CheckFeatureSupport(
			D3D12_FEATURE_MULTISAMPLE_QUALITY_LEVELS,
			&msQualityLevels,
			sizeof(msQualityLevels)));

		if (msQualityLevels.NumQualityLevels > 0)
		{
			mMsaaOption.UsableSamples.push_back({ MsaaOption::kMsaaSampleCandidates[i], msQualityLevels.NumQualityLevels });
			msg += L"Msaa Level " + std::to_wstring(MsaaOption::kMsaaSampleCandidates[i]) + L"\n";
		}
	}

	OutputDebugStringW(msg.c_str());

#if defined(DEBUG) || defined(_DEBUG)
	LogAdapters();
#endif

	CreateCommandObjects();
	CreateSwapChain();
	CreateRtvDsvDescriptorHeaps();

	mFenceEvent.Set(CreateEventEx(nullptr, nullptr, false, EVENT_ALL_ACCESS));
	//Win32 API 실패 원인을 HRESULT 오류 흐름으로 변환
	if (!mFenceEvent.Get())
		ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));

	return true;
}

void Dx12App::CreateCommandObjects()
{
	D3D12_COMMAND_QUEUE_DESC queueDesc = {};
	queueDesc.Type = D3D12_COMMAND_LIST_TYPE_DIRECT;
	queueDesc.Flags = D3D12_COMMAND_QUEUE_FLAG_NONE;

	ThrowIfFailed(md3dDevice->CreateCommandQueue(&queueDesc, IID_PPV_ARGS(mCommandQueue.GetAddressOf())));

	ThrowIfFailed(md3dDevice->CreateCommandAllocator(queueDesc.Type, IID_PPV_ARGS(mCommandAlloc.GetAddressOf())));

	ThrowIfFailed(md3dDevice->CreateCommandList(
		0,
		queueDesc.Type,
		mCommandAlloc.Get(),
		nullptr,
		IID_PPV_ARGS(mCommandList.GetAddressOf())));

	mCommandList->Close();
}

void Dx12App::CreateSwapChain()
{
	/*
		스왑체인은 윈도우, 모니터, VSync 등 OS 그래픽 시스템과 직접 결합된 객체.
		->API 공통 계층인 DXGI Factory에서 생성한다.

		[중요 - MSAA 관련]
		D3D12에서는 Flip Model (FLIP_DISCARD / FLIP_SEQUENTIAL)만 지원.
		-> Flip Model에서는 MSAA가 지원되지 않음.
		-> 별도의 multisampled render target을 만들어 렌더링한 뒤 ResolveSubresource로 back buffer에 복사하여 MSAA 효과를 낸다.
	*/
	mSwapChain.Reset();

	DXGI_SWAP_CHAIN_DESC sd = {};
	sd.BufferDesc.Height = mClientHeight;
	sd.BufferDesc.Width = mClientWidth;
	sd.BufferDesc.RefreshRate.Denominator = 1;
	sd.BufferDesc.RefreshRate.Numerator = 60;
	sd.BufferDesc.Format = mBackBufferFormat;
	sd.BufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED; //DXGI에 맞김. 해당 값 고정.
	sd.BufferDesc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;

	// flip model에서는 MSAA 불가능 -> 반드시 1로 고정
	sd.SampleDesc.Count = 1;
	sd.SampleDesc.Quality = 0;

	sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	sd.BufferCount = SwapChainBufferCount;
	sd.OutputWindow = mhMainWnd;
	sd.Windowed = true;

	/*
		FLIP_DISCARD
		- 최신 Flip Model 방식. DX12 권장.
		- Present 이후 백버퍼 내용 보존 안함. (디스크립터/리소스 바인딩 규칙 위반 시 GPU가 자동으로 백버퍼 내용을 초기화하여 디버깅 지원)
		- 성능이 가장 좋음.
	*/
	sd.SwapEffect = DXGI_SWAP_EFFECT_FLIP_DISCARD;

	// 스왑체인 동작 옵션.
	// DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH를 설정하면
	// ResizeTarget 호출을 통해 전체화면 전환 시 출력 디스플레이 모드 변경을 허용한다.
	// 디스플레이 모드 변경->모니터 출력 설정 자체를 변경함.
	// 0이면 별도 모드 스위치 옵션을 사용하지 않는다.
	// 전체 화면 전환 시 모드 스위치를 허용하지 않으면, 창 크기를 화면 크기에 맞게 조절하는 방식으로 전체 화면이 된다.
	sd.Flags = 0;

	ThrowIfFailed(mdxgiFactory->CreateSwapChain(mCommandQueue.Get(), &sd, mSwapChain.GetAddressOf()));
}

void Dx12App::FlushCommandQueue()
{
	mCurrentFence++;
	ThrowIfFailed(mCommandQueue->Signal(mFence.Get(), mCurrentFence));

	if (mFence->GetCompletedValue() < mCurrentFence)
	{
		ThrowIfFailed(mFence->SetEventOnCompletion(mCurrentFence, mFenceEvent.Get()));
		WaitForSingleObject(mFenceEvent.Get(), INFINITE);
	}
}

void Dx12App::CalculateFrameStats()
{
	static int frameCount = 0;
	static double timeElapsed = 0.0;

	frameCount++;

	double currTime = mTimer.TotalTime();
	double elapsedTime = currTime - timeElapsed;

	if (elapsedTime >= 1.0)
	{
		float fps = static_cast<float>(frameCount / elapsedTime);
		float mspf = 1000.0f / fps;

		std::wstring fpsStr = std::to_wstring(fps);
		std::wstring mspfStr = std::to_wstring(mspf);

		std::wstring windowText =
			mMainWndCaption +
			L" fps: " + fpsStr +
			L" mspf: " + mspfStr;

		SetWindowText(mhMainWnd, windowText.c_str());

		frameCount = 0;
		timeElapsed = currTime;
	}
}

void Dx12App::LogAdapters()
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

	for (auto& adapter : adapterList)
	{
		LogAdapterOutputs(adapter);
		ReleaseCom(adapter);
	}
}

void Dx12App::LogAdapterOutputs(IDXGIAdapter* adapter)
{
	UINT i = 0;
	IDXGIOutput* output = nullptr;
	while (adapter->EnumOutputs(i, &output) != DXGI_ERROR_NOT_FOUND)
	{
		DXGI_OUTPUT_DESC desc;
		output->GetDesc(&desc);

		std::wstring text = L"---------------------Output---------------------";
		text += desc.DeviceName;
		text += L"\n\n";

		OutputDebugString(text.c_str());
		LogOutputDisplayModes(output, mBackBufferFormat);
		ReleaseCom(output);
		i++;
	}
}

void Dx12App::LogOutputDisplayModes(IDXGIOutput* output, DXGI_FORMAT format)
{
	UINT count = 0;
	UINT flags = 0;

	output->GetDisplayModeList(format, flags, &count, nullptr); //nullptr로 개수만 조회
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

ID3D12Resource* Dx12App::CurrentBackBuffer() const
{
	return mSwapChainBuffer[mCurrBackBuffer].Get();
}

D3D12_CPU_DESCRIPTOR_HANDLE Dx12App::CurrentBackBufferView() const
{
	return CD3DX12_CPU_DESCRIPTOR_HANDLE(mRtvHeap->GetCPUDescriptorHandleForHeapStart(), mCurrBackBuffer, mRtvDescriptorSize);
}

D3D12_CPU_DESCRIPTOR_HANDLE Dx12App::DepthStencilView() const
{
	return mDsvHeap->GetCPUDescriptorHandleForHeapStart();
}

D3D12_CPU_DESCRIPTOR_HANDLE Dx12App::MsaaRenderTargetView() const
{
	return CD3DX12_CPU_DESCRIPTOR_HANDLE(mRtvHeap->GetCPUDescriptorHandleForHeapStart(), SwapChainBufferCount, mRtvDescriptorSize);
}
