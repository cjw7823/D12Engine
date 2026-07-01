#include "pch.h"
#include "RenderApp.h"
#include "PipelineStateFactory.h"

using namespace Microsoft::WRL;

void RenderApp::BuildRootSignature()
{
	CD3DX12_DESCRIPTOR_RANGE diffuseMapTable;
	diffuseMapTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, (UINT)mTextures.size() + SwapChainBufferCount, 0); //t0
	CD3DX12_DESCRIPTOR_RANGE displacementMapTable;
	displacementMapTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0, 2); //t0, space2
	CD3DX12_DESCRIPTOR_RANGE treeArrayTable;
	treeArrayTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0, 3); //t0, space3

	std::array<CD3DX12_ROOT_PARAMETER, 7> slotRootParameter{};
	slotRootParameter[0].InitAsConstantBufferView(0);	// (b0) pass CB
	slotRootParameter[1].InitAsConstants(1, 1, 0 , D3D12_SHADER_VISIBILITY_VERTEX);			// (b1) Start Instance Location
	slotRootParameter[2].InitAsDescriptorTable(1, &diffuseMapTable, D3D12_SHADER_VISIBILITY_PIXEL);	// (t0) textures
	slotRootParameter[3].InitAsShaderResourceView(0, 1);							// (t0, space1) materials + tex index
	slotRootParameter[4].InitAsShaderResourceView(1, 1);							// (t1, space1) instances + mat index
	slotRootParameter[5].InitAsDescriptorTable(1, &displacementMapTable);			// (t0, space2) wave height map
	slotRootParameter[6].InitAsDescriptorTable(1, &treeArrayTable, D3D12_SHADER_VISIBILITY_PIXEL);	// (t0, space3) tree billboard

	auto staticSamplers = GetStaticSamplers();

	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(
		(UINT)slotRootParameter.size(),
		slotRootParameter.data(),
		(UINT)staticSamplers.size(),
		staticSamplers.data(),
		D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

	//루트 시그니처는 보통 DESC -> Serialize(Blob) ->Create
	//직렬화 단계에서 문법/제약/버전 관점에서 유효성 검사
	//캐싱/저장에 활용.
	ComPtr<ID3DBlob> serializedRootsig = nullptr;
	ComPtr<ID3DBlob> errorBlob = nullptr;
	ThrowIfFailed(D3D12SerializeRootSignature(
		&rootSigDesc,
		D3D_ROOT_SIGNATURE_VERSION_1,
		serializedRootsig.GetAddressOf(),
		errorBlob.GetAddressOf()));

	if (errorBlob != nullptr)
		::OutputDebugStringA((char*)errorBlob->GetBufferPointer());

	ThrowIfFailed(md3dDevice->CreateRootSignature(
		0,
		serializedRootsig->GetBufferPointer(),
		serializedRootsig->GetBufferSize(),
		IID_PPV_ARGS(mRootSignature.GetAddressOf())));

	//DepthComplexity.hlsl 용
	{
		std::array<CD3DX12_ROOT_PARAMETER, 1> slotRootParameter;
		slotRootParameter[0].InitAsConstantBufferView(0); //debugColor

		CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(
			(UINT)slotRootParameter.size(),
			slotRootParameter.data(),
			0, nullptr,
			D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

		ComPtr<ID3DBlob> serializedRootsig = nullptr;
		ComPtr<ID3DBlob> errorBlob = nullptr;
		ThrowIfFailed(D3D12SerializeRootSignature(
			&rootSigDesc,
			D3D_ROOT_SIGNATURE_VERSION_1,
			serializedRootsig.GetAddressOf(),
			errorBlob.GetAddressOf()));

		if (errorBlob != nullptr)
			::OutputDebugStringA((char*)errorBlob->GetBufferPointer());

		ThrowIfFailed(md3dDevice->CreateRootSignature(
			0,
			serializedRootsig->GetBufferPointer(),
			serializedRootsig->GetBufferSize(),
			IID_PPV_ARGS(mRootSignature_debug.GetAddressOf())));
	}

	//Post Process
	{
		CD3DX12_DESCRIPTOR_RANGE srvTable;
		srvTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0);

		CD3DX12_DESCRIPTOR_RANGE srvTable1;
		srvTable1.Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 1);

		CD3DX12_DESCRIPTOR_RANGE uavTable;
		uavTable.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 0);

		std::array<CD3DX12_ROOT_PARAMETER, 4> slotRootParameter;
		slotRootParameter[0].InitAsConstants(12, 0);
		slotRootParameter[1].InitAsDescriptorTable(1, &srvTable);
		slotRootParameter[2].InitAsDescriptorTable(1, &srvTable1);
		slotRootParameter[3].InitAsDescriptorTable(1, &uavTable);

		CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc(
			(UINT)slotRootParameter.size(),
			slotRootParameter.data(),
			(UINT)staticSamplers.size(),
			staticSamplers.data(),
			D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

		ComPtr<ID3DBlob> serializedRootSig = nullptr;
		ComPtr<ID3DBlob> errorBlob = nullptr;

		ThrowIfFailed(D3D12SerializeRootSignature(&rootSigDesc, D3D_ROOT_SIGNATURE_VERSION_1,
			serializedRootSig.GetAddressOf(), errorBlob.GetAddressOf()));

		if (errorBlob != nullptr)
			::OutputDebugStringA((char*)errorBlob->GetBufferPointer());

		ThrowIfFailed(md3dDevice->CreateRootSignature(
			0,
			serializedRootSig->GetBufferPointer(),
			serializedRootSig->GetBufferSize(),
			IID_PPV_ARGS(mPostProcessRootSignature.GetAddressOf())));
	}
}

void RenderApp::BuildWavesRootSignature()
{
	CD3DX12_DESCRIPTOR_RANGE prevSolInputUAV;
	prevSolInputUAV.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 0);	//u0
	CD3DX12_DESCRIPTOR_RANGE CurrSolInputUAV;
	CurrSolInputUAV.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 1);	//u1
	CD3DX12_DESCRIPTOR_RANGE outputUAV;
	outputUAV.Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 2);			//u2

	// Perfomance TIP:
	// 루트 파라미터를 갱신 빈도(커맨드 리스트에서 Set되는 빈도) 순으로 배치 (자주 바뀌는 것 → 덜 바뀌는 것)
	// 드라이버 구현에 따라 효과는 다르지만 일반적으로 권장되는 패턴
	std::array<CD3DX12_ROOT_PARAMETER, 4> slotRootParameter;
	slotRootParameter[0].InitAsConstants(6, 0);
	slotRootParameter[1].InitAsDescriptorTable(1, &prevSolInputUAV);
	slotRootParameter[2].InitAsDescriptorTable(1, &CurrSolInputUAV);
	slotRootParameter[3].InitAsDescriptorTable(1, &outputUAV);

	CD3DX12_ROOT_SIGNATURE_DESC rootSigDesc((UINT)slotRootParameter.size(), slotRootParameter.data());

	ComPtr<ID3DBlob> serializedRootSig = nullptr;
	ComPtr<ID3DBlob> errorBlob = nullptr;
	ThrowIfFailed(D3D12SerializeRootSignature(&rootSigDesc, D3D_ROOT_SIGNATURE_VERSION_1, serializedRootSig.GetAddressOf(), errorBlob.GetAddressOf()));

	if (errorBlob != nullptr)
		::OutputDebugStringA((char*)errorBlob->GetBufferPointer());

	ThrowIfFailed(md3dDevice->CreateRootSignature(
		0,
		serializedRootSig->GetBufferPointer(),
		serializedRootSig->GetBufferSize(),
		IID_PPV_ARGS(mWavesRootSignature.GetAddressOf())));
}

void RenderApp::BuildShadersAndInputLayout()
{
	const D3D_SHADER_MACRO wavesDefines[] =
	{
		"DISPLACEMENT_MAP", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO textureBlendDefines[] =
	{
		"FOG", "1",
		"TEXTURE_BLEND", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO alphaTestDefines[] =
	{
		"FOG", "1",
		"ALPHA_TEST", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO fogDefines[] =
	{
		"FOG", "1",
		NULL, NULL
	};

	const D3D_SHADER_MACRO tessWallDefines[] =
	{
		"WALL", "1",
		NULL, NULL
	};

	double start = mTimer.TotalTime();

#define USE_COMPILED_SHADER
#ifndef USE_COMPILED_SHADER
	mShaders["standardVS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Default.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["opaquePS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Default.hlsl", fogDefines, "PS", "ps_5_1");
	mShaders["mirrorBaseFillPS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Default.hlsl", nullptr, "PS_MirrorBaseFill", "ps_5_1");
	mShaders["multiTextureBlendPS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Default.hlsl", textureBlendDefines, "PS", "ps_5_1");
	mShaders["alphaTestPS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Default.hlsl", alphaTestDefines, "PS", "ps_5_1");
	mShaders["wavesVS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Default.hlsl", wavesDefines, "VS", "vs_5_1");
	mShaders["wavesSimUpdate"] = d3dUtil::CompileShader(L"Resource\\Shaders\\WaveSim.hlsl", nullptr, "UpdateWavesCS", "cs_5_1");
	mShaders["wavesSimDisturb"] = d3dUtil::CompileShader(L"Resource\\Shaders\\WaveSim.hlsl", nullptr, "DisturbWavesCS", "cs_5_1");

	mShaders["depthDebugVS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\DepthComplexity.hlsl", nullptr, "FullscreenVS", "vs_5_1");
	mShaders["depthDebugPS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\DepthComplexity.hlsl", nullptr, "FullscreenPS", "ps_5_1");

	mShaders["treeBillboardVS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\TreeBillboard.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["treeBillboardGS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\TreeBillboard.hlsl", nullptr, "GS", "gs_5_1");
	mShaders["treeBillboardPS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\TreeBillboard.hlsl", alphaTestDefines, "PS", "ps_5_1");
	mShaders["treeBillboardPS_Wireframe"] = d3dUtil::CompileShader(L"Resource\\Shaders\\TreeBillboard.hlsl", nullptr, "PS_Wireframe", "ps_5_1");

	mShaders["lineToCylinderVS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["lineToCylinderGS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", nullptr, "GS", "gs_5_1");
	mShaders["lineToCylinderPS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", alphaTestDefines, "PS", "ps_5_1");

	mShaders["explodeGS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", alphaTestDefines, "GS_Explode", "gs_5_1");

	mShaders["LOD_GS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", nullptr, "GS_LOD", "gs_5_1");

	mShaders["vertexDebugGS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", nullptr, "GS_Debugging", "gs_5_1");
	mShaders["vertexDebugPS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Task_GS.hlsl", nullptr, "PS_VertexNormal", "ps_5_1");

	mShaders["blurH"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Blur.hlsl", nullptr, "HorzBlurCS", "cs_5_1");
	mShaders["blurV"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Blur.hlsl", nullptr, "VertBlurCS", "cs_5_1");

	mShaders["sobelCS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Sobel.hlsl", nullptr, "SobelCS", "cs_5_1");
	mShaders["CompositeCS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Sobel.hlsl", nullptr, "CompositeCS", "cs_5_1");

	mShaders["tessVS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Tessellation.hlsl", nullptr, "VS", "vs_5_1");
	mShaders["tessHS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Tessellation.hlsl", nullptr, "HS", "hs_5_1");
	mShaders["tessDS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Tessellation.hlsl", nullptr, "DS", "ds_5_1");
	mShaders["tessDS_Wall"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Tessellation.hlsl", tessWallDefines, "DS", "ds_5_1");
	mShaders["tessPS"] = d3dUtil::CompileShader(L"Resource\\Shaders\\Tessellation.hlsl", fogDefines, "PS", "ps_5_1");

#else
	mShaders["standardVS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\Default_vs.cso");
	mShaders["opaquePS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\Default_ps.cso");
	mShaders["mirrorBaseFillPS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\MirrorBaseFill.cso");
	mShaders["multiTextureBlendPS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\Default_ps_TextureBlend.cso");
	mShaders["alphaTestPS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\Default_ps_AlphaTest.cso");
	mShaders["wavesVS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\Default_vs_Waves.cso");
	mShaders["wavesSimUpdate"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\WaveSim_cs_Update.cso");
	mShaders["wavesSimDisturb"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\WaveSim_cs_Disturb.cso");

	mShaders["depthDebugVS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\DepthComplexity_vs.cso");
	mShaders["depthDebugPS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\DepthComplexity_ps.cso");

	mShaders["treeBillboardVS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\TreeBillboardVS.cso");
	mShaders["treeBillboardGS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\TreeBillboardGS.cso");
	mShaders["treeBillboardPS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\TreeBillboardPS.cso");
	mShaders["treeBillboardPS_Wireframe"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\TreeBillboardPS_Wireframe.cso");

	mShaders["lineToCylinderVS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\LineToCylinderVS.cso");
	mShaders["lineToCylinderGS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\LineToCylinderGS.cso");
	mShaders["lineToCylinderPS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\LineToCylinderPS.cso");

	mShaders["explodeGS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\ExplodeGS.cso");

	mShaders["LOD_GS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\LOD_GS.cso");

	mShaders["vertexDebugGS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\VertexDebugGS.cso");
	mShaders["vertexDebugPS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\VertexDebugPS.cso");

	mShaders["blurH"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\HorzBlurCS.cso");
	mShaders["blurV"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\VertBlurCS.cso");

	mShaders["sobelCS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\SobelCS.cso");
	mShaders["CompositeCS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\CompositeCS.cso");

	mShaders["tessVS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\tessVS.cso");
	mShaders["tessHS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\tessHS.cso");
	mShaders["tessDS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\tessDS.cso");
	mShaders["tessDS_Wall"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\tessDS_Wall.cso");
	mShaders["tessPS"] = d3dUtil::LoadBinary(L"Resource\\Shaders\\Compiled\\tessPS.cso");

#endif

	double elapsedMs = (mTimer.TotalTime() - start) * 1000.0;

#ifdef USE_COMPILED_SHADER
	std::wstring s = L"Shader Load elapsed : ";
#else
	std::wstring s = L"Shader Compile elapsed : ";
#endif
	s += std::to_wstring(elapsedMs) + L" ms\n";

	OutputDebugString(s.c_str());

	mInputLayout =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0,  D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
		{ "NORMAL",   0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
		{ "TANGENT",  0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 24, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
		{ "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT,    0, 36, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
	};

	mTreeBillboardInputLayout =
	{
		{"POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
		{"SIZE", 0, DXGI_FORMAT_R32G32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0},
	};
}

void RenderApp::BuildBackbufferSRV()
{
	CD3DX12_CPU_DESCRIPTOR_HANDLE hDescriptor(mSrvHeap->GetCPUDescriptorHandleForHeapStart());
	for (int i = 0; i < SwapChainBufferCount; i++)
	{
		D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc = {};
		srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
		srvDesc.Format = mBackBufferFormat;
		srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
		srvDesc.Texture2D.MostDetailedMip = 0;
		srvDesc.Texture2D.MipLevels = 1;
		srvDesc.Texture2D.ResourceMinLODClamp = 0.0f;

		md3dDevice->CreateShaderResourceView(mSwapChainBuffer[i].Get(), &srvDesc, hDescriptor);
		hDescriptor.Offset(1, mCbvSrvUavDescriptorSize);
	}
}

void RenderApp::BuildPSOs()
{
	PsoBuildContext ctx{};
	ctx.Device = md3dDevice.Get();
	ctx.InputLayout = &mInputLayout;
	ctx.RootSignature = mRootSignature.Get();
	ctx.BackBufferFormat = mBackBufferFormat;
	ctx.DepthStencilFormat = mDepthStencilFormat;
	ctx.SampleCount = mMsaaOption.SampleCount();
	ctx.SampleQuality = mMsaaOption.Quality();
	ctx.IsWireframe = false;
	ctx.CullMode = D3D12_CULL_MODE_BACK;
	ctx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;

	PsoBuildContext opaqueCtx = ctx;
	PipelineStateFactory factory(opaqueCtx);
	mPSOs["opaque"] = factory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
	mPSOs["transparent"] = factory.CreateTransparentPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
	mPSOs["wavesRender"] = factory.CreateTransparentPSO(mShaders["wavesVS"].Get(), mShaders["opaquePS"].Get());
	mPSOs["multiTextureBlend"] = factory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["multiTextureBlendPS"].Get());
	opaqueCtx.IsWireframe = true;
	factory(opaqueCtx);
	mPSOs["opaque_wireframe"] = factory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());

	//alpha test
	PsoBuildContext alphaTestCtx = ctx;
	alphaTestCtx.CullMode = D3D12_CULL_MODE_NONE;
	PipelineStateFactory alphaTestFactory(alphaTestCtx);
	mPSOs["alphaTest"] = alphaTestFactory.CreateOpaquePSO(mShaders["standardVS"].Get(), mShaders["alphaTestPS"].Get());

	//waves
	PsoBuildContext waveCtx = ctx;
	waveCtx.RootSignature = mWavesRootSignature.Get();
	PipelineStateFactory waveFactory(waveCtx);
	mPSOs["wavesSimUpdate"] = waveFactory.CreateComputePSO(mShaders["wavesSimUpdate"].Get());
	mPSOs["wavesSimDisturb"] = waveFactory.CreateComputePSO(mShaders["wavesSimDisturb"].Get());

	//depth complexity
	PsoBuildContext depthCtx = ctx;
	PipelineStateFactory depthFactory(depthCtx);
	mPSOs["depthCount"] = depthFactory.CreateDepthCountPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
	depthCtx.RootSignature = mRootSignature_debug.Get();
	depthFactory(depthCtx);
	mPSOs["depthDebug"] = depthFactory.CreateDepthComplexityDebugPSO(mShaders["depthDebugVS"].Get(), mShaders["depthDebugPS"].Get());

	//mirror
	PsoBuildContext mirrorCtx = ctx;
	PipelineStateFactory mirrorFactory(mirrorCtx);

	PsoBuildContext mirrorCtx2 = mirrorCtx;
	mirrorCtx2.CullMode = D3D12_CULL_MODE_NONE;
	PipelineStateFactory mirrorFactory2(mirrorCtx2);

	mPSOs["mirrorStencil"] = mirrorFactory.CreateMirrorStencilPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());
	//mPSOs["mirrorWall"] = mirrorFactory2.CreateMirrorWallPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());

	PsoBuildContext mirrorCtx3 = ctx;
	mirrorCtx3.Clockwise = true;
	mirrorCtx3.CullMode = D3D12_CULL_MODE_NONE;
	PipelineStateFactory mirrorFactory3(mirrorCtx3);
	mPSOs["mirrorReflected"] = mirrorFactory3.CreateMirrorReflectedPSO(mShaders["standardVS"].Get(), mShaders["opaquePS"].Get());

	PsoBuildContext mirrorCtx4 = ctx;
	PipelineStateFactory mirrorFactory4(mirrorCtx4);
	mPSOs["mirrorBaseFill"] = mirrorFactory4.CreateMirrorBaseFillPSO(mShaders["standardVS"].Get(), mShaders["mirrorBaseFillPS"].Get());

	//shadow
	PsoBuildContext shadowCtx = ctx;
	PipelineStateFactory shadowFactory(shadowCtx);
	mPSOs["shadow"] = shadowFactory.CreateShadowPSO(mShaders["standardVS"].Get(), mShaders["alphaTestPS"].Get());

	//tree billboard
	PsoBuildContext treeCtx = ctx;
	treeCtx.InputLayout = &mTreeBillboardInputLayout;
	treeCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_POINT;
	PipelineStateFactory treeFactory(treeCtx);
	mPSOs["treeBillboard"] = treeFactory.CreateTreeBillboardPSO(mShaders["treeBillboardVS"].Get(), mShaders["treeBillboardGS"].Get(), mShaders["treeBillboardPS"].Get(), true);
	mPSOs["treeBillboard_depthCount"] = treeFactory.CreateDepthCountPSO(mShaders["treeBillboardVS"].Get(), mShaders["treeBillboardGS"].Get(), mShaders["treeBillboardPS"].Get());
	treeCtx.IsWireframe = true;
	treeFactory(treeCtx);
	mPSOs["treeBillboard_wireframe"] = treeFactory.CreateTreeBillboardPSO(mShaders["treeBillboardVS"].Get(), mShaders["treeBillboardGS"].Get(), mShaders["treeBillboardPS_Wireframe"].Get(), true);

	//extended Cylinder
	PsoBuildContext exCylCtx = ctx;
	exCylCtx.InputLayout = &mInputLayout;
	exCylCtx.CullMode = D3D12_CULL_MODE_NONE;
	exCylCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_LINE;
	PipelineStateFactory exCylFactory(exCylCtx);
	mPSOs["lineToCylinder"] = exCylFactory.CreateLineToCylinderPSO(mShaders["lineToCylinderVS"].Get(), mShaders["lineToCylinderGS"].Get(), mShaders["lineToCylinderPS"].Get());
	mPSOs["lineToCylinder_depthCount"] = exCylFactory.CreateDepthCountPSO(mShaders["lineToCylinderVS"].Get(), mShaders["lineToCylinderGS"].Get(), mShaders["lineToCylinderPS"].Get());
	exCylCtx.IsWireframe = true;
	exCylFactory(exCylCtx);
	mPSOs["lineToCylinder_wireframe"] = exCylFactory.CreateLineToCylinderPSO(mShaders["lineToCylinderVS"].Get(), mShaders["lineToCylinderGS"].Get(), mShaders["lineToCylinderPS"].Get());

	//explode
	PsoBuildContext explodeCtx = ctx;
	explodeCtx.CullMode = D3D12_CULL_MODE_NONE;
	PipelineStateFactory explodeFactory(explodeCtx);
	mPSOs["geoExplode"] = explodeFactory.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["explodeGS"].Get(), mShaders["lineToCylinderPS"].Get());
	mPSOs["geoExplode_depthCount"] = explodeFactory.CreateDepthCountPSO(mShaders["lineToCylinderVS"].Get(), mShaders["explodeGS"].Get(), mShaders["lineToCylinderPS"].Get());
	explodeCtx.IsWireframe = true;
	explodeFactory(explodeCtx);
	mPSOs["geoExplode_wireframe"] = explodeFactory.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["explodeGS"].Get(), mShaders["lineToCylinderPS"].Get());

	//geo LOD
	PsoBuildContext lodCtx = ctx;
	PipelineStateFactory lodFactory(lodCtx);
	mPSOs["geoSphereLOD"] = lodFactory.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["LOD_GS"].Get(), mShaders["lineToCylinderPS"].Get());
	mPSOs["geoSphereLOD_depthCount"] = lodFactory.CreateDepthCountPSO(mShaders["lineToCylinderVS"].Get(), mShaders["LOD_GS"].Get(), mShaders["lineToCylinderPS"].Get());
	lodCtx.IsWireframe = true;
	lodFactory(lodCtx);
	mPSOs["geoSphereLOD_wireframe"] = lodFactory.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["LOD_GS"].Get(), mShaders["lineToCylinderPS"].Get());

	//vertex normal debug
	PsoBuildContext normalDebugCtx = ctx;
	normalDebugCtx.CullMode = D3D12_CULL_MODE_NONE;
	normalDebugCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_POINT;
	PipelineStateFactory normalDebugFactory(normalDebugCtx);
	mPSOs["vertexNormalDebug"] = normalDebugFactory.CreateExplodePSO(mShaders["lineToCylinderVS"].Get(), mShaders["vertexDebugGS"].Get(), mShaders["vertexDebugPS"].Get());

	//blur
	PsoBuildContext blurCtx = ctx;
	blurCtx.RootSignature = mPostProcessRootSignature.Get();
	PipelineStateFactory blurFactory(blurCtx);
	mPSOs["blurH"] = blurFactory.CreateComputePSO(mShaders["blurH"].Get());
	mPSOs["blurV"] = blurFactory.CreateComputePSO(mShaders["blurV"].Get());

	//sobel
	PsoBuildContext sobelCtx = ctx;
	sobelCtx.RootSignature = mPostProcessRootSignature.Get();
	PipelineStateFactory sobelFactory(sobelCtx);
	mPSOs["sobel"] = sobelFactory.CreateComputePSO(mShaders["sobelCS"].Get());
	mPSOs["composite"] = sobelFactory.CreateComputePSO(mShaders["CompositeCS"].Get());

	//tessellation
	PsoBuildContext tessCtx = ctx;
	tessCtx.CullMode = D3D12_CULL_MODE_NONE;
	tessCtx.topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_PATCH;
	PipelineStateFactory tessFactory(tessCtx);
	mPSOs["tessLand"] = tessFactory.CreateTessellationPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS"].Get(), mShaders["tessPS"].Get());
	mPSOs["tessLand_depthCount"] = tessFactory.CreateDepthCountPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS"].Get(), mShaders["tessPS"].Get());
	mPSOs["tessWall"] = tessFactory.CreateTessellateMirrorWallPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS_Wall"].Get(), mShaders["tessPS"].Get());
	mPSOs["tessWall_depthCount"] = tessFactory.CreateDepthCountPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS_Wall"].Get(), mShaders["tessPS"].Get());
	tessCtx.IsWireframe = true;
	tessFactory(tessCtx);
	mPSOs["tessLand_wireframe"] = tessFactory.CreateTessellationPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS"].Get(), mShaders["tessPS"].Get());
	mPSOs["tessWall_wireframe"] = tessFactory.CreateTessellateMirrorWallPSO(mShaders["tessVS"].Get(), mShaders["tessHS"].Get(), mShaders["tessDS_Wall"].Get(), mShaders["tessPS"].Get());
}

std::array<const CD3DX12_STATIC_SAMPLER_DESC, 7> RenderApp::GetStaticSamplers()
{
	const CD3DX12_STATIC_SAMPLER_DESC pointWrap(
		0, // shaderRegister
		D3D12_FILTER_MIN_MAG_MIP_POINT, // filter
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,  // addressU
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,  // addressV
		D3D12_TEXTURE_ADDRESS_MODE_WRAP); // addressW

	const CD3DX12_STATIC_SAMPLER_DESC pointClamp(
		1,
		D3D12_FILTER_MIN_MAG_MIP_POINT,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP);

	const CD3DX12_STATIC_SAMPLER_DESC linearWrap(
		2,
		D3D12_FILTER_MIN_MAG_MIP_LINEAR,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP);

	const CD3DX12_STATIC_SAMPLER_DESC linearClamp(
		3,
		D3D12_FILTER_MIN_MAG_MIP_LINEAR,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP);

	const CD3DX12_STATIC_SAMPLER_DESC anisotropicWrap(
		4,
		D3D12_FILTER_ANISOTROPIC,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		D3D12_TEXTURE_ADDRESS_MODE_WRAP,
		0,
		8);

	const CD3DX12_STATIC_SAMPLER_DESC anisotropicClamp(
		5,
		D3D12_FILTER_ANISOTROPIC,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		0.0f,
		8);

	const CD3DX12_STATIC_SAMPLER_DESC testSampler(
		6,
		D3D12_FILTER_ANISOTROPIC,
		D3D12_TEXTURE_ADDRESS_MODE_MIRROR_ONCE,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
		0.0f,
		8);

	return { pointWrap, pointClamp, linearWrap, linearClamp, anisotropicWrap, anisotropicClamp, testSampler };
}
