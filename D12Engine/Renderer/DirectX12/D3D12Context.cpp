#include "pch.h"
#include "D3D12Context.h"
#include "MACRO.h"

using namespace Microsoft::WRL;

D3D12Context::D3D12Context()
{
	mFrameContexts.clear();
	for (int i = 0; i < RenderConfig::NumFrameResources; i++)
		mFrameContexts.push_back(std::make_unique<D3D12FrameContext>());
}

D3D12Context::~D3D12Context()
{
	Shutdown();
}

bool D3D12Context::Initialize(HWND hwnd, int width, int height, D3D12ContextDesc desc)
{
	mhWnd = hwnd;
	mClientWidth = std::max(1, width);
	mClientHeight = std::max(1, height);
	mDesc = desc;

	mDesc.RtvDescriptorCount = std::max<UINT>(mDesc.RtvDescriptorCount, RenderConfig::SwapChainBufferCount);
	mDesc.DsvDescriptorCount = std::max<UINT>(mDesc.DsvDescriptorCount, 1);
	mDesc.CbvSrvUavDescriptorMaxCount = std::max<UINT>(mDesc.CbvSrvUavDescriptorMaxCount, 1);

	CreateDevice();

	ThrowIfFailed(md3dDevice->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(mFence.GetAddressOf())));

	//GPU 드라이버 구현에 따라 달라지므로 초기화 시 디바이스에서 조회.
	mRtvDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
	mDsvDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_DSV);
	mCbvSrvUavDescriptorSize = md3dDevice->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

	std::wstring msg = L"MSAA 지원 목록\nMsaa Level 1\n";
	for (UINT i = 0; i < MsaaOption::kMsaaSampleCandidates.size(); i++)
	{
		D3D12_FEATURE_DATA_MULTISAMPLE_QUALITY_LEVELS msQualityLevels{};
		msQualityLevels.Format = mDesc.BackBufferFormat;
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

#ifdef DX12_ENABLE_DEBUG_LAYER
	LogAdapters();
#endif

	CreateDescriptorHeaps();
	CreateCommandObjects();
	CreateSwapChain();
	CreateBackBufferRTVs();

	mFenceEvent.Set(CreateEventEx(nullptr, nullptr, false, EVENT_ALL_ACCESS));
	//Win32 API 실패 원인을 HRESULT 오류 흐름으로 변환
	if (!mFenceEvent.Get())
		ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));

	return true;
}

void D3D12Context::Shutdown()
{
	FlushCommandQueue();

	//comptr들이지만 명시적 해제.

	for (auto& buffer : mSwapChainBuffer)
		buffer.Reset();

	mCommandList.Reset();
	for (auto& frameContext : mFrameContexts)
		frameContext->CommandAllocator.Reset();

	mCommandQueue.Reset();
	mSwapChain.Reset();
	mFence.Reset();

	mRtvHeap.Reset();
	mDsvHeap.Reset();
	mSrvHeap.Reset();

	md3dDevice.Reset();
	mdxgiFactory.Reset();

	mSwapChainWaitableObject = nullptr;
	mCurrentFrameContext = nullptr;
	mFrameStarted = false;
	mBackBufferInRenderTargetState = false;
}

//따로 명령을 기록하지 않기 때문에 allocator 초기화 필요 없음.
void D3D12Context::ResizeSwapChain(int width, int height)
{
	assert(md3dDevice);
	assert(mSwapChain);

	width = std::max(1, width);
	height = std::max(1, height);

	if (mClientWidth == width && mClientHeight == height)
		return;

	mClientWidth = width;
	mClientHeight = height;

	// 기존 back buffer를 GPU가 더 이상 사용하지 않게 대기
	FlushCommandQueue();

	// ResizeBuffers 전에 기존 back buffer 참조 해제
	for (auto& buffer : mSwapChainBuffer)
		buffer.Reset();

	DXGI_SWAP_CHAIN_DESC1 desc = {};
	ThrowIfFailed(mSwapChain->GetDesc1(&desc));
	ThrowIfFailed(mSwapChain->ResizeBuffers(RenderConfig::SwapChainBufferCount,
		mClientWidth, mClientHeight,
		mDesc.BackBufferFormat,
		desc.Flags));

	CreateBackBufferRTVs();
}

void D3D12Context::BeginFrame()
{
	assert(!mFrameStarted);

	mCurrentFrameContext = WaitForNextFrameContext();

	ThrowIfFailed(mCurrentFrameContext->CommandAllocator->Reset());
	ThrowIfFailed(mCommandList->Reset(mCurrentFrameContext->CommandAllocator.Get(), nullptr));

	mCurrentBackBufferIndex = mSwapChain->GetCurrentBackBufferIndex();
	mFrameStarted = true;
	mBackBufferInRenderTargetState = false;
}

void D3D12Context::EndFrame()
{
	assert(mFrameStarted);

	if (mBackBufferInRenderTargetState)
	{
		auto barrier = CD3DX12_RESOURCE_BARRIER::Transition(
			mSwapChainBuffer[mCurrentBackBufferIndex].Get(),
			D3D12_RESOURCE_STATE_RENDER_TARGET,
			D3D12_RESOURCE_STATE_PRESENT);

		mCommandList->ResourceBarrier(1, &barrier);
		mBackBufferInRenderTargetState = false;
	}

	ThrowIfFailed(mCommandList->Close());

	ID3D12CommandList* commandLists[] = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(_countof(commandLists), commandLists);

	mCurrentFrameContext->FenceValue = ++mCurrentFence;
	ThrowIfFailed(mCommandQueue->Signal(mFence.Get(), mCurrentFence));

	UINT presentFlags = 0;
	UINT syncInterval = mDesc.EnableVSync ? 1 : 0;

	if (!mDesc.EnableVSync && mTearingSupported)
		presentFlags |= DXGI_PRESENT_ALLOW_TEARING;

	HRESULT hr = mSwapChain->Present(syncInterval, presentFlags);
	ThrowIfFailed(hr);

	mSwapChainOccluded = (hr == DXGI_STATUS_OCCLUDED);
	if ((mSwapChainOccluded && mSwapChain->Present(0, DXGI_PRESENT_TEST) == DXGI_STATUS_OCCLUDED) || ::IsIconic(mhWnd))
	{
		::Sleep(10);
	}
	else
	{
		mSwapChainOccluded = false;
	}

	mCurrentFrameContext = nullptr;
	mFrameStarted = false;
}

void D3D12Context::FlushCommandQueue()
{
	mCurrentFence++;
	ThrowIfFailed(mCommandQueue->Signal(mFence.Get(), mCurrentFence));

	if (mFence->GetCompletedValue() < mCurrentFence)
	{
		ThrowIfFailed(mFence->SetEventOnCompletion(mCurrentFence, mFenceEvent.Get()));
		WaitForSingleObject(mFenceEvent.Get(), INFINITE);
	}
}

D3D12DescriptorHandle D3D12Context::AllocateRtvDescriptor()
{
	return AllocateCpuDescriptor(mRtvHeap.Get(), mRtvFreeIndices, mRtvDescriptorSize, false);
}

D3D12DescriptorHandle D3D12Context::AllocateDsvDescriptor()
{
	return AllocateCpuDescriptor(mDsvHeap.Get(), mDsvFreeIndices, mDsvDescriptorSize, false);
}

D3D12DescriptorHandle D3D12Context::AllocateSrvDescriptor()
{
	return AllocateCpuDescriptor(mSrvHeap.Get(), mSrvFreeIndices, mCbvSrvUavDescriptorSize, true);
}

void D3D12Context::FreeRtvDescriptor(D3D12DescriptorHandle handle)
{
	FreeCpuDescriptor(handle, mRtvFreeIndices, mDesc.RtvDescriptorCount);
}

void D3D12Context::FreeDsvDescriptor(D3D12DescriptorHandle handle)
{
	FreeCpuDescriptor(handle, mDsvFreeIndices, mDesc.DsvDescriptorCount);
}

void D3D12Context::FreeSrvDescriptor(D3D12DescriptorHandle handle)
{
	FreeCpuDescriptor(handle, mSrvFreeIndices, mDesc.CbvSrvUavDescriptorMaxCount);
}

void D3D12Context::AllocateSrvDescriptor(D3D12_CPU_DESCRIPTOR_HANDLE* outCpuHandle, D3D12_GPU_DESCRIPTOR_HANDLE* outGpuHandle)
{
	D3D12DescriptorHandle handle = AllocateSrvDescriptor();
	*outCpuHandle = handle.Cpu;
	*outGpuHandle = handle.Gpu;
}

void D3D12Context::FreeSrvDescriptor(D3D12_CPU_DESCRIPTOR_HANDLE cpuHandle, D3D12_GPU_DESCRIPTOR_HANDLE gpuHandle)
{
	D3D12DescriptorHandle handle{};
	handle.Cpu = cpuHandle;
	handle.Gpu = gpuHandle;
	handle.Index = GetSrvDescriptorIndex(cpuHandle);

	FreeSrvDescriptor(handle);
}

D3D12_CPU_DESCRIPTOR_HANDLE D3D12Context::GetCurrentBackBufferRTV() const
{
	CD3DX12_CPU_DESCRIPTOR_HANDLE rtvHandle(
		mRtvHeap->GetCPUDescriptorHandleForHeapStart(),
		mCurrentBackBufferIndex,
		mRtvDescriptorSize);

	return rtvHandle;
}

void D3D12Context::CreateDevice()
{
	/*
		D3D12 Debug Layer 활성화

		주의:
		- Debug Layer는 D3D12CreateDevice 호출 전에 활성화해야 한다.
		- 활성화하면 API 사용 오류, 잘못된 리소스 상태 전이, 잘못된 디스크립터 사용 등을
		  실행 중에 감지할 수 있다.
		- 디버그 빌드 전용으로 사용하는 것이 일반적이다.
	*/
#ifdef DX12_ENABLE_DEBUG_LAYER
	ComPtr<ID3D12Debug1> debugController;
	ThrowIfFailed(D3D12GetDebugInterface(IID_PPV_ARGS(debugController.GetAddressOf())));

	// D3D12 Debug Layer 활성화.
	// 잘못된 API 호출, 리소스 상태 전이 오류, 바인딩 규칙 위반 등을 런타임에 검출한다.
	debugController->EnableDebugLayer();

	// GPU-Based Validation 활성화.
	// CPU 측 검증만으로 잡기 어려운 디스크립터, 루트 시그니처, 리소스 접근 오류 등을
	// GPU 실행 관점에서 추가 검증한다.
	// 성능 오버헤드가 매우 크므로 디버그 빌드에서만 사용하는 것이 좋다.
	debugController->SetEnableGPUBasedValidation(TRUE);

	// Synchronized Command Queue Validation 활성화.
	// 커맨드 큐 실행과 검증을 더 동기적으로 맞춰 오류 위치를 더 정확히 보고하도록 돕는다.
	// 대신 성능 저하가 있을 수 있다.
	debugController->SetEnableSynchronizedCommandQueueValidation(TRUE);
#endif

	/*
		DXGI Factory 생성

		DXGI Factory의 주요 역할:
		- 그래픽 어댑터, 즉 GPU 열거
		- 출력 장치, 즉 모니터 열거
		- SwapChain 생성
		- 디스플레이 모드, tearing 지원 여부, 전체 화면 전환 관련 기능 제공

		D3D12 디바이스 자체는 D3D12CreateDevice로 만들지만,
		SwapChain과 어댑터 선택에는 DXGI Factory가 필요하다.
	*/
	ThrowIfFailed(CreateDXGIFactory1(IID_PPV_ARGS(mdxgiFactory.GetAddressOf())));

	/*
		하드웨어 D3D12 디바이스 생성

		nullptr를 어댑터로 넘기면 시스템 기본 하드웨어 어댑터를 사용한다.

		D3D_FEATURE_LEVEL_12_2:
		- 이 feature level을 지원하는 GPU에서만 성공한다.
		- 포트폴리오 또는 최신 기능 실험 목적이면 괜찮다.
		- 더 넓은 호환성을 원하면 12_1, 12_0, 11_0 순으로 fallback하는 구조가 더 안전하다.
	*/
	HRESULT hardwareResult = D3D12CreateDevice(
		nullptr,
		D3D_FEATURE_LEVEL_12_2,
		IID_PPV_ARGS(md3dDevice.GetAddressOf())
	);

	/*
		하드웨어 디바이스 생성 실패 시 WARP 디바이스로 fallback

		WARP:
		- Windows Advanced Rasterization Platform
		- GPU 대신 CPU 기반 소프트웨어 래스터라이저를 사용한다.
		- 성능은 낮지만 D3D12 기능 테스트, 디버깅, GPU 미지원 환경에서 유용하다.
	*/
	if (FAILED(hardwareResult))
	{
		MessageBox(
			nullptr,
			L"하드웨어 D3D12 디바이스 생성에 실패했습니다. WARP 디바이스로 다시 시도합니다.",
			L"D3D12 Device Creation Failed",
			MB_OK
		);

		ComPtr<IDXGIAdapter> warpAdapter;
		ThrowIfFailed(mdxgiFactory->EnumWarpAdapter(IID_PPV_ARGS(warpAdapter.GetAddressOf())));

		ThrowIfFailed(D3D12CreateDevice(
			warpAdapter.Get(),
			D3D_FEATURE_LEVEL_12_2,
			IID_PPV_ARGS(md3dDevice.GetAddressOf())
		));
	}

	/*
		D3D12 InfoQueue 설정

		InfoQueue:
		- D3D12 Debug Layer가 출력하는 메시지를 제어하는 인터페이스.
		- 특정 심각도 메시지에서 디버거 break를 걸 수 있다.
		- 특정 메시지를 필터링할 수도 있다.

		여기서는 ERROR, CORRUPTION, WARNING 메시지가 발생하면
		디버거에서 즉시 중단되도록 설정한다.
	*/
#ifdef DX12_ENABLE_DEBUG_LAYER
	ComPtr<ID3D12InfoQueue> infoQueue;

	if (SUCCEEDED(md3dDevice.As(&infoQueue)))
	{
		// 심각한 오류 발생 시 디버거 중단.
		infoQueue->SetBreakOnSeverity(D3D12_MESSAGE_SEVERITY_ERROR, true);

		// 메모리 손상, 잘못된 내부 상태 등 치명적 오류 발생 시 디버거 중단.
		infoQueue->SetBreakOnSeverity(D3D12_MESSAGE_SEVERITY_CORRUPTION, true);

		// 경고 발생 시에도 디버거 중단.
		// 개발 초기에는 유용하지만, 너무 자주 멈춘다면 false로 낮출 수 있다.
		infoQueue->SetBreakOnSeverity(D3D12_MESSAGE_SEVERITY_WARNING, true);

		/*
			특정 Debug Layer 메시지 필터링

			D3D12_MESSAGE_ID_FENCE_ZERO_WAIT는 SDK 버전에 따라
			d3d12sdklayers.h에 정의되어 있지 않을 수 있으므로 정수값으로 직접 정의한다.

			이 메시지는 일부 환경에서 불필요하게 발생할 수 있어 필터링한다.
			단, 실제 fence 사용 오류를 숨길 가능성도 있으므로 필요한 경우에만 유지한다.
		*/
		const int D3D12_MESSAGE_ID_FENCE_ZERO_WAIT_ = 1424;

		D3D12_MESSAGE_ID disabledMessages[] =
		{
			static_cast<D3D12_MESSAGE_ID>(D3D12_MESSAGE_ID_FENCE_ZERO_WAIT_)
		};

		D3D12_INFO_QUEUE_FILTER filter = {};
		filter.DenyList.NumIDs = _countof(disabledMessages);
		filter.DenyList.pIDList = disabledMessages;

		infoQueue->AddStorageFilterEntries(&filter);
	}
#endif
}

void D3D12Context::CreateDescriptorHeaps()
{
	D3D12_DESCRIPTOR_HEAP_DESC rtvHeapDesc = {};
	rtvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
	rtvHeapDesc.NumDescriptors = mDesc.RtvDescriptorCount;
	rtvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
	rtvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(
		&rtvHeapDesc,
		IID_PPV_ARGS(mRtvHeap.GetAddressOf())));

	D3D12_DESCRIPTOR_HEAP_DESC dsvHeapDesc = {};
	dsvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_DSV;
	dsvHeapDesc.NumDescriptors = mDesc.DsvDescriptorCount;
	dsvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
	dsvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(
		&dsvHeapDesc,
		IID_PPV_ARGS(mDsvHeap.GetAddressOf())));

	D3D12_DESCRIPTOR_HEAP_DESC srvHeapDesc = {};
	srvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
	srvHeapDesc.NumDescriptors = mDesc.CbvSrvUavDescriptorMaxCount;
	srvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
	srvHeapDesc.NodeMask = 0;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(
		&srvHeapDesc,
		IID_PPV_ARGS(mSrvHeap.GetAddressOf())));

	for (int i = (int)mDesc.RtvDescriptorCount - 1; i >= RenderConfig::SwapChainBufferCount; i--)
		mRtvFreeIndices.push_back(i);

	for (int i = (int)mDesc.DsvDescriptorCount - 1; i >= 0; i--)
		mDsvFreeIndices.push_back(i);

	for (int i = (int)mDesc.CbvSrvUavDescriptorMaxCount - 1; i >= 0; i--)
		mSrvFreeIndices.push_back(i);
}

void D3D12Context::CreateCommandObjects()
{
	D3D12_COMMAND_QUEUE_DESC queueDesc = {};
	queueDesc.Type = D3D12_COMMAND_LIST_TYPE_DIRECT;
	queueDesc.Flags = D3D12_COMMAND_QUEUE_FLAG_NONE;
	queueDesc.NodeMask = 0;

	ThrowIfFailed(md3dDevice->CreateCommandQueue(&queueDesc, IID_PPV_ARGS(mCommandQueue.GetAddressOf())));

	for (int i = 0; i < RenderConfig::NumFrameResources; i++)
	{
		ThrowIfFailed(md3dDevice->CreateCommandAllocator(
			queueDesc.Type,
			IID_PPV_ARGS(mFrameContexts[i]->CommandAllocator.GetAddressOf())));
	}

	ThrowIfFailed(md3dDevice->CreateCommandList(
		0,
		queueDesc.Type,
		mFrameContexts[0]->CommandAllocator.Get(),
		nullptr,
		IID_PPV_ARGS(mCommandList.GetAddressOf())));

	ThrowIfFailed(mCommandList->Close());
}

void D3D12Context::CreateSwapChain()
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

	DXGI_SWAP_CHAIN_DESC sd{};
	sd.BufferDesc.Width = mClientWidth;
	sd.BufferDesc.Height = mClientHeight;
	sd.BufferDesc.RefreshRate.Denominator = 1;
	sd.BufferDesc.RefreshRate.Numerator = 60;
	sd.BufferDesc.Format = mDesc.BackBufferFormat;
	sd.BufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED; //DXGI에 맞김. 해당 값 고정.
	sd.BufferDesc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;

	// flip model에서는 MSAA 불가능 -> 반드시 1로 고정
	sd.SampleDesc.Count = 1;
	sd.SampleDesc.Quality = 0;

	sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	sd.BufferCount = RenderConfig::SwapChainBufferCount;
	sd.OutputWindow = mhWnd;
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
	sd.Flags = DXGI_SWAP_CHAIN_FLAG_FRAME_LATENCY_WAITABLE_OBJECT;

	BOOL allow_tearing = FALSE;
	if (mDesc.EnableTearing)
	{
		mdxgiFactory->CheckFeatureSupport(
			DXGI_FEATURE_PRESENT_ALLOW_TEARING,
			&allow_tearing,
			sizeof(allow_tearing));
	}
	mTearingSupported = (allow_tearing == TRUE);
	if (mTearingSupported)
		sd.Flags |= DXGI_SWAP_CHAIN_FLAG_ALLOW_TEARING;

	ComPtr<IDXGISwapChain> swapChain;
	ThrowIfFailed(mdxgiFactory->CreateSwapChain(mCommandQueue.Get(), &sd, swapChain.GetAddressOf()));
	ThrowIfFailed(swapChain.As(&mSwapChain));

	if (mTearingSupported)
		mdxgiFactory->MakeWindowAssociation(mhWnd, DXGI_MWA_NO_ALT_ENTER);

	ThrowIfFailed(mSwapChain->SetMaximumFrameLatency(RenderConfig::SwapChainBufferCount));
	mSwapChainWaitableObject = mSwapChain->GetFrameLatencyWaitableObject();
}

void D3D12Context::CreateBackBufferRTVs()
{
	CD3DX12_CPU_DESCRIPTOR_HANDLE rtvHandle(mRtvHeap->GetCPUDescriptorHandleForHeapStart());

	for (int i = 0; i < RenderConfig::SwapChainBufferCount; ++i)
	{
		ThrowIfFailed(mSwapChain->GetBuffer(
			i,
			IID_PPV_ARGS(mSwapChainBuffer[i].GetAddressOf())));

		md3dDevice->CreateRenderTargetView(
			mSwapChainBuffer[i].Get(),
			nullptr,
			rtvHandle);

		rtvHandle.Offset(1, mRtvDescriptorSize);
	}

	mScreenViewport.TopLeftX = 0.0f;
	mScreenViewport.TopLeftY = 0.0f;
	mScreenViewport.Width = static_cast<float>(mClientWidth);
	mScreenViewport.Height = static_cast<float>(mClientHeight);
	mScreenViewport.MinDepth = 0.0f;
	mScreenViewport.MaxDepth = 1.0f;

	mScissorRect = { 0, 0, mClientWidth, mClientHeight };
}

void D3D12Context::BeginBackBufferRenderPass(const float clearColor[4])
{
	assert(mFrameStarted);

	if (!mBackBufferInRenderTargetState)
	{
		auto barrier = CD3DX12_RESOURCE_BARRIER::Transition(
			mSwapChainBuffer[mCurrentBackBufferIndex].Get(),
			D3D12_RESOURCE_STATE_PRESENT,
			D3D12_RESOURCE_STATE_RENDER_TARGET);

		mCommandList->ResourceBarrier(1, &barrier);
		mBackBufferInRenderTargetState = true;
	}

	D3D12_CPU_DESCRIPTOR_HANDLE rtvHandle = GetCurrentBackBufferRTV();

	mCommandList->RSSetViewports(1, &mScreenViewport);
	mCommandList->RSSetScissorRects(1, &mScissorRect);
	mCommandList->ClearRenderTargetView(rtvHandle, clearColor, 0, nullptr);
	mCommandList->OMSetRenderTargets(1, &rtvHandle, FALSE, nullptr);
}

D3D12FrameContext* D3D12Context::WaitForNextFrameContext()
{
	mFrameIndex = (mFrameIndex + 1) % RenderConfig::NumFrameResources;
	D3D12FrameContext* frameContext = mFrameContexts[mFrameIndex].get();

	if (frameContext->FenceValue != 0 && mFence->GetCompletedValue() < frameContext->FenceValue)
	{
		ThrowIfFailed(mFence->SetEventOnCompletion(frameContext->FenceValue, mFenceEvent.Get()));
		HANDLE waitableObjects[] = { mSwapChainWaitableObject, mFenceEvent.Get() };
		::WaitForMultipleObjects(2, waitableObjects, TRUE, INFINITE);
	}
	else
		::WaitForSingleObject(mSwapChainWaitableObject, INFINITE);

	return frameContext;
}

void D3D12Context::LogAdapters()
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

void D3D12Context::LogAdapterOutputs(IDXGIAdapter* adapter)
{
	UINT i = 0;
	IDXGIOutput* output = nullptr;
	while (adapter->EnumOutputs(i, &output) != DXGI_ERROR_NOT_FOUND)
	{
		DXGI_OUTPUT_DESC desc;
		output->GetDesc(&desc);

		std::wstring text = L"---------------------SobelOutput---------------------";
		text += desc.DeviceName;
		text += L"\n\n";

		OutputDebugString(text.c_str());
		LogOutputDisplayModes(output, mDesc.BackBufferFormat);
		ReleaseCom(output);
		i++;
	}
}

void D3D12Context::LogOutputDisplayModes(IDXGIOutput* output, DXGI_FORMAT format)
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

D3D12DescriptorHandle D3D12Context::AllocateCpuDescriptor(ID3D12DescriptorHeap* heap, std::vector<UINT>& freeIndices, UINT descriptorSize, bool shaderVisible)
{
	assert(heap != nullptr);
	assert(!freeIndices.empty());

	D3D12DescriptorHandle handle{};
	handle.Index = freeIndices.back();
	freeIndices.pop_back();

	CD3DX12_CPU_DESCRIPTOR_HANDLE cpuHandle(
		heap->GetCPUDescriptorHandleForHeapStart(),
		handle.Index,
		descriptorSize);

	handle.Cpu = cpuHandle;

	if (shaderVisible)
	{
		CD3DX12_GPU_DESCRIPTOR_HANDLE gpuHandle(
			heap->GetGPUDescriptorHandleForHeapStart(),
			handle.Index,
			descriptorSize);

		handle.Gpu = gpuHandle;
	}

	return handle;
}

void D3D12Context::FreeCpuDescriptor(D3D12DescriptorHandle handle, std::vector<UINT>& freeIndices, UINT descriptorCount)
{
	if (!handle.IsValid())
		return;

	assert(handle.Index < descriptorCount);
	freeIndices.push_back(handle.Index);
}

UINT D3D12Context::GetSrvDescriptorIndex(D3D12_CPU_DESCRIPTOR_HANDLE cpuHandle) const
{
	CD3DX12_CPU_DESCRIPTOR_HANDLE cpuStart(mSrvHeap->GetCPUDescriptorHandleForHeapStart());

	assert(cpuHandle.ptr >= cpuStart.ptr);

	const UINT index = static_cast<UINT>((cpuHandle.ptr - cpuStart.ptr) / mCbvSrvUavDescriptorSize);

	assert(index < mDesc.CbvSrvUavDescriptorMaxCount);
	return index;
}
