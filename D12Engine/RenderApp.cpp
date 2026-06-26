#include "pch.h"
#include "RenderApp.h"
#include "MathHelper.h"
#include "RenderData.h"

using namespace DirectX;
using namespace Microsoft::WRL;

RenderApp::~RenderApp()
{
    if (md3dDevice != nullptr && mCommandQueue != nullptr)
        FlushCommandQueue();

    if (mImGuiInitialized)
    {
        ImGui_ImplDX12_Shutdown();
        ImGui_ImplWin32_Shutdown();
        ImGui::DestroyContext();

        mImGuiInitialized = false;
    }
}

bool RenderApp::Initialize()
{
    if (!Dx12App::Initialize()) return false;

    ThrowIfFailed(mCommandAlloc->Reset());
    ThrowIfFailed(mCommandList->Reset(mCommandAlloc.Get(), nullptr));

	mWaves = std::make_unique<GpuWaves>(
		md3dDevice.Get(),
		mCommandList.Get(),
		256, 256, 0.25f, 0.03f, 2.0f, 0.2f);

	mBlurFilter = std::make_unique<BlurFilter>(
		md3dDevice.Get(),
		mClientWidth, mClientHeight,
		DXGI_FORMAT_R8G8B8A8_UNORM);

	mSobelFilter = std::make_unique<SobelFilter>(
		md3dDevice.Get(),
		mClientWidth, mClientHeight,
		mBackBufferFormat);

    LoadTextures();
    BuildDescriptorHeaps();
    BuildRootSignature();
	BuildShadersAndInputLayout();

	BuildWavesRootSignature();
	BuildWavesGeometry();

	BuildShapeGeometry();
	BuildLandGeometry();
	BuildTreeBillboardGeometry();
	BuildCylinderWithoutTopGeometry();
	BuildBrickWallGeometry();

	BuildMaterials();
	BuildRenderItems();
	BuildFrameResources();
	BuildPSOs();

	SetDebugColorCB();
	InitImGui();

	ThrowIfFailed(mCommandList->Close());
	std::vector<ID3D12CommandList*> cmdLists = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(static_cast<UINT>(cmdLists.size()), cmdLists.data());

	FlushCommandQueue();

    return true;
}

void RenderApp::NextMsaaOoption()
{
	Dx12App::NextMsaaOoption();
	BuildPSOs();
}

void RenderApp::SetMsaaOption(UINT value)
{
	Dx12App::SetMsaaOption(value);
	BuildPSOs();
}

void RenderApp::NextBlurCount()
{
	static const std::array<UINT, 4> counts = { 1, 2, 4, 8 };
	static UINT index = 0;

	index = (index + 1) % counts.size();
	mBlurCount = counts[index];

	if (mBlurCount == 1) is_Blur = false;
	else is_Blur = true;
}

void RenderApp::OnResize()
{
	Dx12App::OnResize();

	XMMATRIX P = XMMatrixPerspectiveFovLH(0.25f * DirectX::XM_PI, AspectRatio(), 1.0f, 200.0f);
	XMStoreFloat4x4(&mProj, P);

	if (mBlurFilter != nullptr) mBlurFilter->OnResize(mClientWidth, mClientHeight);
	if (mSobelFilter != nullptr) mSobelFilter->OnResize(mClientWidth, mClientHeight);

	if(mSrvHeap != nullptr) BuildBackbufferSRV();
}

void RenderApp::Update(const GameTimer& gt)
{
	OnKeyboardInput(gt);
	UpdateCamera(gt);

	mCurrFrameResourceIndex = (mCurrFrameResourceIndex + 1) % gNumFrameResources;
	mCurrFrameResource = mFrameResources[mCurrFrameResourceIndex].get();

	if (mCurrFrameResource->Fence != 0 && mFence->GetCompletedValue() < mCurrFrameResource->Fence)
	{
		ThrowIfFailed(mFence->SetEventOnCompletion(mCurrFrameResource->Fence, mFenceEvent.Get()));
		WaitForSingleObject(mFenceEvent.Get(), INFINITE);
	}

	AnimateMaterials(gt);
	UpdateShadowTransform();
	UpdateObjectCBs(gt);
	UpdateMainPassCB(gt);
	UpdateReflectedPassCB(gt);
	UpdateMaterialCBs(gt);

	//이동 로직. 회전과 연동 안됨.
	float dt = gt.DeltaTime();
	if (isMoving)
	{
		float speed = 30.0f;//units/sec
		float forward = 0;
		float right = 0;
		float up = 0;

		if (md == 1) forward = +1;      // W
		else if (md == 2) forward = -1; // S
		else if (md == 3) right = -1; // A
		else if (md == 4) right = +1; // D
		else if (md == 5) up = -1; // Q
		else if (md == 6) up = +1; // E

		float moveZ = forward * speed * dt;
		float moveX = right * speed * dt;
		float moveY = up * speed * dt;

		XMMATRIX cam = XMLoadFloat4x4(&mCamPos);
		XMMATRIX delta = XMMatrixTranslation(-moveX, -moveY, -moveZ);
		cam *= delta;
		XMStoreFloat4x4(&mCamPos, cam);
	}
}

void RenderApp::Draw(const GameTimer& gt)
{
	auto& cmdListAlloc = mCurrFrameResource->cmdListAlloc;
	ThrowIfFailed(cmdListAlloc->Reset());
	ThrowIfFailed(mCommandList->Reset(cmdListAlloc.Get(), nullptr));

	mCommandList->RSSetViewports(1, &mScreenViewport);
	mCommandList->RSSetScissorRects(1, &mScissorRect);

	auto barrier1 = CD3DX12_RESOURCE_BARRIER::Transition(
		CurrentBackBuffer(),
		D3D12_RESOURCE_STATE_PRESENT,
		mMsaaOption.IsEnable() ? D3D12_RESOURCE_STATE_RESOLVE_DEST : D3D12_RESOURCE_STATE_RENDER_TARGET);
	mCommandList->ResourceBarrier(1, &barrier1);

	auto rtvHandle = mMsaaOption.IsEnable() ? MsaaRenderTargetView() : CurrentBackBufferView();
	auto dsvHandle = DepthStencilView();
	mCommandList->ClearRenderTargetView(
		rtvHandle,
		(float*)&mMainPassCB.gFogColor,
		0, nullptr);
	mCommandList->ClearDepthStencilView(
		dsvHandle,
		D3D12_CLEAR_FLAG_DEPTH | D3D12_CLEAR_FLAG_STENCIL,
		1.0f,
		0,
		0, nullptr);
	mCommandList->OMSetRenderTargets(1, &rtvHandle, true, &dsvHandle);

	std::vector<ID3D12DescriptorHeap*> descriptorHeap = { mSrvHeap.Get() };
	mCommandList->SetDescriptorHeaps(static_cast<UINT>(descriptorHeap.size()), descriptorHeap.data());
	mCommandList->SetGraphicsRootSignature(mRootSignature.Get());

	UpdateWavesGPU(gt);
	mCommandList->SetGraphicsRootDescriptorTable(5, mWaves->DisplacementMap());	//시뮬한 높이 값 바인딩

	auto passCB = mCurrFrameResource->PassCB->Resource();
	UINT passCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(PassConstants));
	for (int layer = 0; layer < (int)RenderLayer::Count; layer++)
	{
		mCommandList->OMSetStencilRef(0);
		mCommandList->SetGraphicsRootConstantBufferView(4, passCB->GetGPUVirtualAddress());
		switch (layer)
		{
		case (int)RenderLayer::Opaque:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["opaque_wireframe"].Get() : mPSOs["opaque"].Get());
			break;
		case (int)RenderLayer::TessLand:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["tessLand_wireframe"].Get() : mPSOs["tessLand"].Get());
			break;
		case (int)RenderLayer::MultiTextureBlend:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["opaque_wireframe"].Get() : mPSOs["multiTextureBlend"].Get());
			CD3DX12_GPU_DESCRIPTOR_HANDLE hTable(mSrvHeap->GetGPUDescriptorHandleForHeapStart());
			hTable.Offset(mTextures["swirlingMaskTex"]->SrvHeapIndex, mCbvSrvUavDescriptorSize);
			mCommandList->SetGraphicsRootDescriptorTable(1, hTable);
			break;
		case (int)RenderLayer::AlphaTestOpaque:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["opaque_wireframe"].Get() : mPSOs["alphaTest"].Get());
			break;
		case (int)RenderLayer::A2C_TreeBillboard:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["treeBillboard_wireframe"].Get() : mPSOs["treeBillboard"].Get());
			break;
		case (int)RenderLayer::GeoSphereLOD:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["geoSphereLOD_wireframe"].Get() : mPSOs["geoSphereLOD"].Get());
			break;
		case (int)RenderLayer::GeoExplode:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["geoExplode_wireframe"].Get() : mPSOs["geoExplode"].Get());
			break;
		case (int)RenderLayer::LineToCylinder:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["lineToCylinder_wireframe"].Get() : mPSOs["lineToCylinder"].Get());
			break;
		case (int)RenderLayer::Waves:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["opaque_wireframe"].Get() : mPSOs["wavesRender"].Get());
			break;
		case (int)RenderLayer::MirrorStencil:
			mCommandList->OMSetStencilRef(1);
			mCommandList->SetPipelineState(mPSOs["mirrorStencil"].Get());
			break;
		//case (int)RenderLayer::MirrorWall:
		//	mCommandList->OMSetStencilRef(1);
		//	mCommandList->SetPipelineState(mIsWireframe ? mPSOs["opaque_wireframe"].Get() : mPSOs["mirrorWall"].Get());
		//	break;
		case (int)RenderLayer::TessWall:
			mCommandList->OMSetStencilRef(1);
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["tessWall_wireframe"].Get() : mPSOs["tessWall"].Get());
			break;
		case (int)RenderLayer::MirrorBaseFill:
			mCommandList->OMSetStencilRef(1);
			mCommandList->SetPipelineState(mPSOs["mirrorBaseFill"].Get());
			break;
		case (int)RenderLayer::Reflected:
			//반전된 광원을 포함한 별도의 매 패스 상수 버퍼를 제공.
			mCommandList->OMSetStencilRef(1);
			mCommandList->SetGraphicsRootConstantBufferView(4, passCB->GetGPUVirtualAddress() + passCBByteSize);
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["opaque_wireframe"].Get() : mPSOs["mirrorReflected"].Get());
			break;
		case (int)RenderLayer::Shadow:
			mCommandList->SetPipelineState(mPSOs["shadow"].Get());
			break;
		case (int)RenderLayer::Transparent:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["opaque_wireframe"].Get() : mPSOs["transparent"].Get());
			break;
		default:
			mCommandList->SetPipelineState(mIsWireframe ? mPSOs["opaque_wireframe"].Get() : mPSOs["opaque"].Get());
			break;
		}

		if (mIsDepthComplexityDebug)
		{
			switch (layer)
			{
			case (int)RenderLayer::A2C_TreeBillboard:
				mCommandList->SetPipelineState(mPSOs["treeBillboard_depthCount"].Get());
				break;
			case (int)RenderLayer::LineToCylinder:
				mCommandList->SetPipelineState(mPSOs["lineToCylinder_depthCount"].Get());
				break;
			case (int)RenderLayer::GeoSphereLOD:
				mCommandList->SetPipelineState(mPSOs["geoSphereLOD_depthCount"].Get());
				break;
			default:
				mCommandList->SetPipelineState(mPSOs["depthCount"].Get());
				break;
			}
		}

		DrawRenderItems(mCommandList.Get(), mRenderItemLayer[layer]);

		if (mIsVertexNormalDebug)
		{
			mCommandList->SetPipelineState(mPSOs["vertexNormalDebug"].Get());
			DrawRenderItems_VertexNormalDebug(mCommandList.Get(), mRenderItemLayer[layer]);
		}
	}

	if (mIsDepthComplexityDebug)
	{
		mCommandList->SetGraphicsRootSignature(mRootSignature_debug.Get());
		mCommandList->SetPipelineState(mPSOs["depthDebug"].Get());
		DrawDebugColorTriangle(mCommandList.Get());
	}

	if (mMsaaOption.IsEnable())
		ResolveMsaaToBackBuffer();

	if (is_Sobel)
	{
		CD3DX12_RESOURCE_BARRIER barrier = CD3DX12_RESOURCE_BARRIER::Transition(CurrentBackBuffer(),
			D3D12_RESOURCE_STATE_RENDER_TARGET,
			D3D12_RESOURCE_STATE_GENERIC_READ);
		mCommandList->ResourceBarrier(1, &barrier);

		mSobelFilter->Excute(mCommandList.Get(), mPostProcessRootSignature.Get(), mPSOs["sobel"].Get(), CurrentBackBufferSRV());

		mSobelFilter->Composite(mCommandList.Get(), mPostProcessRootSignature.Get(), mPSOs["composite"].Get(), CurrentBackBufferSRV(), mSobelFilter->SobelOutputSrv());

		barrier = CD3DX12_RESOURCE_BARRIER::Transition(CurrentBackBuffer(),
			D3D12_RESOURCE_STATE_GENERIC_READ,
			D3D12_RESOURCE_STATE_COPY_DEST);
		mCommandList->ResourceBarrier(1, &barrier);

		mCommandList->CopyResource(CurrentBackBuffer(), mSobelFilter->CompositeOutput());

		barrier = CD3DX12_RESOURCE_BARRIER::Transition(CurrentBackBuffer(),
			D3D12_RESOURCE_STATE_COPY_DEST,
			D3D12_RESOURCE_STATE_RENDER_TARGET);
		mCommandList->ResourceBarrier(1, &barrier);
	}

	if (is_Blur)
	{
		mBlurFilter->Excute(mCommandList.Get(), mPostProcessRootSignature.Get(),
			mPSOs["blurH"].Get(), mPSOs["blurV"].Get(),
			CurrentBackBuffer(), mBlurCount);

		CD3DX12_RESOURCE_BARRIER backbufferBarrier = CD3DX12_RESOURCE_BARRIER::Transition(CurrentBackBuffer(),
			D3D12_RESOURCE_STATE_COPY_SOURCE, D3D12_RESOURCE_STATE_COPY_DEST);
		mCommandList->ResourceBarrier(1, &backbufferBarrier);

		mCommandList->CopyResource(CurrentBackBuffer(), mBlurFilter->SobelOutput());

		backbufferBarrier = CD3DX12_RESOURCE_BARRIER::Transition(CurrentBackBuffer(),
			D3D12_RESOURCE_STATE_COPY_DEST, D3D12_RESOURCE_STATE_RENDER_TARGET);
		mCommandList->ResourceBarrier(1, &backbufferBarrier);
	}

	RenderImGui();

	auto barrier2 = CD3DX12_RESOURCE_BARRIER::Transition(
		CurrentBackBuffer(),
		D3D12_RESOURCE_STATE_RENDER_TARGET,
		D3D12_RESOURCE_STATE_PRESENT);
	mCommandList->ResourceBarrier(1, &barrier2);

	ThrowIfFailed(mCommandList->Close());

	std::vector<ID3D12CommandList*> cmdLists = { mCommandList.Get() };
	mCommandQueue->ExecuteCommandLists(static_cast<UINT>(cmdLists.size()), cmdLists.data());

	ThrowIfFailed(mSwapChain->Present(0, 0));
	mCurrBackBuffer = (mCurrBackBuffer + 1) % SwapChainBufferCount;

	mCurrFrameResource->Fence = ++mCurrentFence;
	mCommandQueue->Signal(mFence.Get(), mCurrentFence);
}

void RenderApp::SetDebugColorCB()
{
	std::array<DebugColorConstants, FrameResource::debugColorNum> colors =
	{
		XMFLOAT4{1.0f, 0.0f, 0.0f, 1.0f},   // 1 빨강
		XMFLOAT4{1.0f, 0.5f, 0.0f, 1.0f},   // 2 주황
		XMFLOAT4{1.0f, 1.0f, 0.0f, 1.0f},   // 3 노랑
		XMFLOAT4{0.0f, 1.0f, 0.0f, 1.0f},   // 4 초록
		XMFLOAT4{0.0f, 0.0f, 1.0f, 1.0f},   // 5 파랑
		XMFLOAT4{0.0f, 1.0f, 1.0f, 1.0f},   // 6 청록
		XMFLOAT4{1.0f, 0.0f, 1.0f, 1.0f},   // 7 자홍
		XMFLOAT4{0.5f, 0.0f, 1.0f, 1.0f},   // 8 보라
		XMFLOAT4{1.0f, 1.0f, 1.0f, 1.0f},   // 9 흰색
		XMFLOAT4{0.4f, 0.4f, 0.4f, 1.0f}    // 10 회색
	};

	for (auto& f : mFrameResources)
	{
		for (UINT i = 0; i < FrameResource::debugColorNum; i++)
			f->debugColorCB->CopyData(i, colors[i]);
	}
}

void RenderApp::ResolveMsaaToBackBuffer()
{
	auto msaaBarrier = CD3DX12_RESOURCE_BARRIER::Transition(
		mMsaaRenderTarget.Get(),
		D3D12_RESOURCE_STATE_RENDER_TARGET,
		D3D12_RESOURCE_STATE_RESOLVE_SOURCE);
	mCommandList->ResourceBarrier(1, &msaaBarrier);

	mCommandList->ResolveSubresource(
		CurrentBackBuffer(),
		0,
		mMsaaRenderTarget.Get(),
		0,
		mBackBufferFormat);

	std::array<CD3DX12_RESOURCE_BARRIER, 2> barriers{
		CD3DX12_RESOURCE_BARRIER::Transition(
			mMsaaRenderTarget.Get(),
			D3D12_RESOURCE_STATE_RESOLVE_SOURCE,
			D3D12_RESOURCE_STATE_RENDER_TARGET),

		CD3DX12_RESOURCE_BARRIER::Transition(
			CurrentBackBuffer(),
			D3D12_RESOURCE_STATE_RESOLVE_DEST,
			D3D12_RESOURCE_STATE_RENDER_TARGET)	};
	mCommandList->ResourceBarrier((UINT)barriers.size(), barriers.data());
	
	auto rtv = CurrentBackBufferView();
	mCommandList->OMSetRenderTargets(1, &rtv, true, nullptr);
}

void RenderApp::DrawDebugColorTriangle(ID3D12GraphicsCommandList* cmdList)
{
	UINT debugColorCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(DebugColorConstants));

	cmdList->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

	for (UINT i = 0; i < mCurrFrameResource->debugColorNum; i++)
	{
		cmdList->OMSetStencilRef(i + 1);
		cmdList->SetGraphicsRootConstantBufferView(
			0,
			mCurrFrameResource->debugColorCB->Resource()->GetGPUVirtualAddress() + i * debugColorCBByteSize);
		cmdList->DrawInstanced(3, 1, 0, 0);
	}
}

DirectX::XMVECTOR RenderApp::GetMirrorPlane()
{
	XMMATRIX W = XMLoadFloat4x4(&mMirror->World);

	XMVECTOR pLocal = XMVectorSet(0.0f, 0.0f, 0.0f, 1.0f);	// 점 벡터
	XMVECTOR nLocal = XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f);	// grid가 XZ Plane일 때

	XMVECTOR pWorld = XMVector3TransformCoord(pLocal, W);

	XMMATRIX invTransW = MathHelper::InverseTranspose(W);
	XMVECTOR nWorld = XMVector3TransformNormal(nLocal, invTransW);
	nWorld = XMVector3Normalize(nWorld);

	float d = -XMVectorGetX(XMVector3Dot(nWorld, pWorld));

	return XMVectorSetW(nWorld, d);
}

void RenderApp::UpdateCamera(const GameTimer& gt)
{
	XMVECTOR pos = MathHelper::SphericalToCatesian(mRadius, mTheta, mPhi);
	XMStoreFloat3(&mEyePos, pos);

	XMVECTOR target = XMVectorZero();
	XMVECTOR up = XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f);

	//좌수 좌표계 행렬 생성.
	XMMATRIX view = XMMatrixLookAtLH(pos, target, up);
	XMStoreFloat4x4(&mView, view);
}

void RenderApp::UpdateObjectCBs(const GameTimer& gt)
{
	auto currObjectCB = mCurrFrameResource->ObjectCB.get();
	for (auto& e : mAllRenderItems)
	{
		if (e->NumFramesDirty > 0)
		{
			XMMATRIX world = XMLoadFloat4x4(&e->World);
			XMMATRIX texTransform = XMLoadFloat4x4(&e->TexTransform);

			ObjectConstants objConstants;
			XMStoreFloat4x4(&objConstants.World, XMMatrixTranspose(world));
			XMStoreFloat4x4(&objConstants.TexTransform, XMMatrixTranspose(texTransform));
			objConstants.DisplacementMapTexelSize = e->DisplacementMapTexelSize;
			objConstants.GridSpatialStep = e->GridSpatialStep;

			currObjectCB->CopyData(e->ObjCBIndex, objConstants);
			e->NumFramesDirty--;
		}
	}
}

void RenderApp::UpdateMainPassCB(const GameTimer& gt)
{
	XMMATRIX cam = XMLoadFloat4x4(&mCamPos);

	XMMATRIX view = XMLoadFloat4x4(&mView) * cam;
	XMMATRIX proj = XMLoadFloat4x4(&mProj);
	XMMATRIX viewProj = XMMatrixMultiply(view, proj);

	XMVECTOR viewDet = XMMatrixDeterminant(view);
	XMVECTOR projDet = XMMatrixDeterminant(proj);
	XMVECTOR viewProjDet = XMMatrixDeterminant(viewProj);

	XMMATRIX invView = XMMatrixInverse(&viewDet, view);
	XMMATRIX invProj= XMMatrixInverse(&projDet, proj);
	XMMATRIX invViewProj = XMMatrixInverse(&viewProjDet, viewProj);

	XMStoreFloat4x4(&mMainPassCB.View, XMMatrixTranspose(view));
	XMStoreFloat4x4(&mMainPassCB.InvView, XMMatrixTranspose(invView));
	XMStoreFloat4x4(&mMainPassCB.Proj, XMMatrixTranspose(proj));
	XMStoreFloat4x4(&mMainPassCB.InvProj, XMMatrixTranspose(invProj));
	XMStoreFloat4x4(&mMainPassCB.ViewProj, XMMatrixTranspose(viewProj));
	XMStoreFloat4x4(&mMainPassCB.InvViewProj, XMMatrixTranspose(invViewProj));

	mMainPassCB.EyePosW = mEyePos;
	mMainPassCB.RenderTargetSize = XMFLOAT2((float)mClientWidth, (float)mClientHeight);
	mMainPassCB.InvRenderTargetSize = XMFLOAT2(1.0f / mClientWidth, 1.0f / mClientHeight);
	mMainPassCB.NearZ = 1.0f;
	mMainPassCB.FarZ = 1000.0f;
	mMainPassCB.TotalTime = (float)gt.TotalTime();
	mMainPassCB.DeltaTime = (float)gt.DeltaTime();
	mMainPassCB.AmbientLight = { 0.25f, 0.25f, 0.35f, 1.0f };
	mMainPassCB.Lights[0].Direction = { 0.57735f, -0.57735f, 0.57735f };
	mMainPassCB.Lights[0].Strength = { 0.6f, 0.6f, 0.6f };
	mMainPassCB.Lights[1].Direction = { -0.57735f, -0.57735f, 0.57735f };
	mMainPassCB.Lights[1].Strength = { 0.3f, 0.3f, 0.3f };
	mMainPassCB.Lights[2].Direction = { 0.0f, -0.707f, -0.707f };
	mMainPassCB.Lights[2].Strength = { 0.15f, 0.15f, 0.15f };

	mMainPassCB.gFogColor = { 0.7f, 0.7f, 0.7f, 1.0f };
	mMainPassCB.gFogStart = 5.f;
	mMainPassCB.gFogRange = 200.f;

	XMVECTOR lightDir = -MathHelper::SphericalToCatesian(1.0f, mSunTheta, mSunPhi);
	XMStoreFloat3(&mMainPassCB.Lights[0].Direction, lightDir);

	mCurrFrameResource->PassCB->CopyData(0, mMainPassCB);
}

void RenderApp::UpdateReflectedPassCB(const GameTimer& gt)
{
	mReflectedPassCB = mMainPassCB;

	XMVECTOR mirrorPlane = GetMirrorPlane(); // x = -10 plane
	XMMATRIX R = XMMatrixReflect(mirrorPlane);

	for (int i = 0; i < MaxLights; i++)
	{
		XMVECTOR lightDir = XMLoadFloat3(&mMainPassCB.Lights[i].Direction);
		XMVECTOR reflectedLightDir = XMVector3TransformNormal(lightDir, R);
		XMStoreFloat3(&mReflectedPassCB.Lights[i].Direction, reflectedLightDir);
	}

	mCurrFrameResource->PassCB->CopyData(1, mReflectedPassCB);
}

void RenderApp::UpdateMaterialCBs(const GameTimer& gt)
{
	auto currMaterialCB = mCurrFrameResource->MaterialCB.get();
	for (auto& e : mMaterials)
	{
		Material* mat = e.second.get();
		if (mat->NumFramesDirty > 0)
		{
			XMMATRIX matTransform = XMLoadFloat4x4(&mat->MatTransform);

			MaterialConstants matConstants;
			matConstants.DiffuseAlbedo = mat->DiffuseAlbedo;
			matConstants.FresnelR0 = mat->FresnelR0;
			matConstants.Roughness = mat->Roughness;
			XMStoreFloat4x4(&matConstants.MatTransform, XMMatrixTranspose(matTransform));

			currMaterialCB->CopyData(mat->MatCBIndex, matConstants);
			mat->NumFramesDirty--;
		}
	}
}

void RenderApp::UpdateWavesGPU(const GameTimer& gt)
{
	static float t_base = 0.0f;
	if ((mTimer.TotalTime() - t_base) >= 0.25f)
	{
		t_base += 0.25f;

		int i = MathHelper::Rand(4, mWaves->RowCount() - 5);
		int j = MathHelper::Rand(4, mWaves->ColumnCount() - 5);
		float r = MathHelper::RandF(0.5f, 1.0f);

		mWaves->Disturb(mCommandList.Get(), mWavesRootSignature.Get(), mPSOs["wavesSimDisturb"].Get(), i, j, r);
	}

	mWaves->Update(gt, mCommandList.Get(), mWavesRootSignature.Get(), mPSOs["wavesSimUpdate"].Get());
	mWaves->PrepareDraw(mCommandList.Get());
}

void RenderApp::UpdateShadowTransform()
{
	//빛 전환에 따른 해골 그림자 변환.
	XMVECTOR shadowPlane = XMVectorSet(0.0f, 1.0f, 0.0f, 0.0f); //xz plane
	XMVECTOR toMainLight = -XMLoadFloat3(&mMainPassCB.Lights[0].Direction);
	XMVECTOR toReflectedLight = -XMLoadFloat3(&mReflectedPassCB.Lights[0].Direction);
	XMMATRIX s = XMMatrixShadow(shadowPlane, toMainLight);
	XMMATRIX s2 = XMMatrixShadow(shadowPlane, toReflectedLight);
	XMMATRIX shadowOffsetY = XMMatrixTranslation(0.0f, 0.001f, 0.0f);
	XMMATRIX skullWorld = XMLoadFloat4x4(&mSkull->World);
	XMMATRIX mirrorSkullWorld = XMLoadFloat4x4(&mSkullMirror->World);
	XMStoreFloat4x4(&mSkullShadow->World, skullWorld * s * shadowOffsetY);
	XMStoreFloat4x4(&mSkullShadowMirror->World, mirrorSkullWorld * s2 * shadowOffsetY);
	mSkullShadow->NumFramesDirty = gNumFrameResources;
	mSkullShadowMirror->NumFramesDirty = gNumFrameResources;
}

void RenderApp::AnimateMaterials(const GameTimer& gt)
{
	auto waterMat = mMaterials["water0"].get();

	float& tu = waterMat->MatTransform(3, 0);
	float& tv = waterMat->MatTransform(3, 1);

	tu += 0.1f * gt.DeltaTime();
	tv += 0.02f * gt.DeltaTime();
	
	if (tu >= 1.0f) tu -= 1.0f;
	if (tv >= 1.0f) tv -= 1.0f;

	waterMat->NumFramesDirty = gNumFrameResources;


	//Blend Texture Box Animation
	//uv 중심에서 회전하기 위해 이동행렬 필요.
	auto swirlingMat = mMaterials["swirling"].get();
	XMMATRIX R = XMMatrixRotationZ(1.5f * (float)gt.TotalTime());
	XMMATRIX T0 = XMMatrixTranslation(-0.5f, -0.5f, 0.0f);
	XMMATRIX T1 = XMMatrixTranslation(0.5f, 0.5f, 0.0f);
	XMMATRIX M = T0 * R * T1;
	XMStoreFloat4x4(&swirlingMat->MatTransform, M);
	swirlingMat->NumFramesDirty = gNumFrameResources;
}

void RenderApp::DrawRenderItems(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers)
{
	UINT objCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(ObjectConstants));
	UINT matCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(MaterialConstants));

	auto objectCB = mCurrFrameResource->ObjectCB->Resource();
	auto matCB = mCurrFrameResource->MaterialCB->Resource();

	for (auto& ri : renderLayers)
	{
		auto vbv = ri->Geo->VertexBufferView();
		auto ibv = ri->Geo->IndexBufferView();

		cmdList->IASetVertexBuffers(0, 1, &vbv);
		cmdList->IASetIndexBuffer(&ibv);
		cmdList->IASetPrimitiveTopology(ri->PrimitiveType);

		CD3DX12_GPU_DESCRIPTOR_HANDLE tex(mSrvHeap->GetGPUDescriptorHandleForHeapStart());
		tex.Offset(ri->Mat->DiffuseSrvHeapIndex, mCbvSrvUavDescriptorSize);
		D3D12_GPU_VIRTUAL_ADDRESS objCBAddress = objectCB->GetGPUVirtualAddress();
		objCBAddress += ri->ObjCBIndex * objCBByteSize;
		D3D12_GPU_VIRTUAL_ADDRESS matCBAddress = matCB->GetGPUVirtualAddress();
		matCBAddress += ri->Mat->MatCBIndex * matCBByteSize;

		cmdList->SetGraphicsRootDescriptorTable(0, tex);
		cmdList->SetGraphicsRootConstantBufferView(2, objCBAddress);
		cmdList->SetGraphicsRootConstantBufferView(3, matCBAddress);

		cmdList->DrawIndexedInstanced(ri->IndexCount, 1, ri->StartIndexLocation, ri->BaseVertexLocation, 0);
	}
}

void RenderApp::DrawRenderItems_VertexNormalDebug(ID3D12GraphicsCommandList* cmdList, const std::vector<RenderItem*>& renderLayers)
{
	UINT objCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(ObjectConstants));
	UINT matCBByteSize = d3dUtil::CalcConstantBufferByteSize(sizeof(MaterialConstants));

	auto objectCB = mCurrFrameResource->ObjectCB->Resource();
	auto matCB = mCurrFrameResource->MaterialCB->Resource();

	for (auto& ri : renderLayers)
	{
		auto vbv = ri->Geo->VertexBufferView();
		auto ibv = ri->Geo->IndexBufferView();

		cmdList->IASetVertexBuffers(0, 1, &vbv);
		cmdList->IASetIndexBuffer(&ibv);
		cmdList->IASetPrimitiveTopology(D3D10_PRIMITIVE_TOPOLOGY_POINTLIST);

		CD3DX12_GPU_DESCRIPTOR_HANDLE tex(mSrvHeap->GetGPUDescriptorHandleForHeapStart());
		tex.Offset(ri->Mat->DiffuseSrvHeapIndex, mCbvSrvUavDescriptorSize);
		D3D12_GPU_VIRTUAL_ADDRESS objCBAddress = objectCB->GetGPUVirtualAddress();
		objCBAddress += ri->ObjCBIndex * objCBByteSize;
		D3D12_GPU_VIRTUAL_ADDRESS matCBAddress = matCB->GetGPUVirtualAddress();
		matCBAddress += ri->Mat->MatCBIndex * matCBByteSize;

		cmdList->SetGraphicsRootDescriptorTable(0, tex);
		cmdList->SetGraphicsRootConstantBufferView(2, objCBAddress);
		cmdList->SetGraphicsRootConstantBufferView(3, matCBAddress);

		cmdList->DrawIndexedInstanced(ri->IndexCount, 1, ri->StartIndexLocation, ri->BaseVertexLocation, 0);
	}
}

MeshData RenderApp::LoadModelFromFile(const std::wstring& path)
{
	std::ifstream file(path);
	if (!file)
	{
		std::wstring wfn = AnsiToWString(__FILE__);
		throw DxException(1, path, wfn, __LINE__);
	}

	std::vector<std::string> lines;
	std::string line;

	while (std::getline(file, line))
		lines.push_back(line);
	file.close();

	std::string label;
	int vertexCount = 0;
	int indexCount = 0;

	std::istringstream iss(lines[0]);
	iss >> label >> vertexCount;
	iss.str(lines[1]); iss.clear();
	iss >> label >> indexCount;

	//메시 생성
	MeshData md;
	for (int i = 4; i < 4 + vertexCount; i++)
	{
		iss.str(lines[i]); iss.clear();
		float v1, v2, v3, n1, n2, n3;
		iss >> v1 >> v2 >> v3 >> n1 >> n2 >> n3;
		
		Vertex v{};
		v.Position = { v1, v2, v3 };
		v.Normal = { n1, n2, n3 };
		v.TangentU = { 1.0f, 0.0f, 0.0f };
		v.TexC = { 0.0f, 0.0f };
		md.Vertices.push_back(v);
	}
	for (int i = 31083; i < 31083 + indexCount; i++)
	{
		iss.str(lines[i]); iss.clear();
		int i1, i2, i3;
		iss >> i1 >> i2 >> i3;

		md.Indices32.push_back(i1);
		md.Indices32.push_back(i2);
		md.Indices32.push_back(i3);
	}

	return md;
}

float RenderApp::GetHillsHeight(float x, float z) const
{
	return 0.3f * (z * sinf(0.05f * x) + x * cosf(0.1f * z));
}

DirectX::XMFLOAT3 RenderApp::GetHillsNormal(float x, float z) const
{
	// y = f(x, z)
	// normal = (-df/dx, 1, -df/dz)
	DirectX::XMFLOAT3 n(
		-0.015f * z * cosf(0.05f * x) - 0.3f * cosf(0.1f * z),
		1.0f,
		-0.3f * sinf(0.05f * x) + 0.03f * x * sinf(0.1f * z));

	DirectX::XMVECTOR unitNormal =
		DirectX::XMVector3Normalize(DirectX::XMLoadFloat3(&n));

	DirectX::XMStoreFloat3(&n, unitNormal);

	return n;
}

CD3DX12_GPU_DESCRIPTOR_HANDLE RenderApp::CurrentBackBufferSRV() const
{
	return CD3DX12_GPU_DESCRIPTOR_HANDLE(mSrvHeap->GetGPUDescriptorHandleForHeapStart(), mCurrBackBuffer, mCbvSrvUavDescriptorSize);
}
