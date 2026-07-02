#include "pch.h"
#include "PipelineStateFactory.h"
#include "d3dUtil.h"

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateOpaquePSO(ID3DBlob* vs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC opaqueDesc = BuildBaseGraphicsPsoDesc();
	opaqueDesc.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	opaqueDesc.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&opaqueDesc, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateTransparentPSO
(ID3DBlob* vs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_RENDER_TARGET_BLEND_DESC transparentBlendDesc{};
	transparentBlendDesc.BlendEnable = true;
	transparentBlendDesc.LogicOpEnable = false;
	transparentBlendDesc.SrcBlend = D3D12_BLEND_SRC_ALPHA;
	transparentBlendDesc.DestBlend = D3D12_BLEND_INV_SRC_ALPHA;
	transparentBlendDesc.BlendOp = D3D12_BLEND_OP_ADD;
	transparentBlendDesc.SrcBlendAlpha = D3D12_BLEND_ONE;
	transparentBlendDesc.DestBlendAlpha = D3D12_BLEND_ZERO;
	transparentBlendDesc.BlendOpAlpha = D3D12_BLEND_OP_ADD;
	transparentBlendDesc.LogicOp = D3D12_LOGIC_OP_NOOP;
	transparentBlendDesc.RenderTargetWriteMask = D3D12_COLOR_WRITE_ENABLE_ALL;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC transparentDesc = BuildBaseGraphicsPsoDesc();
	transparentDesc.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	transparentDesc.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	transparentDesc.BlendState.RenderTarget[0] = transparentBlendDesc;
	transparentDesc.RasterizerState.CullMode = D3D12_CULL_MODE_BACK;
	transparentDesc.DepthStencilState.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&transparentDesc, IID_PPV_ARGS(PSO.GetAddressOf())));
	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateComputePSO(ID3DBlob* cs)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_COMPUTE_PIPELINE_STATE_DESC computeDesc{};
	computeDesc.CS =
	{
		reinterpret_cast<BYTE*>(cs->GetBufferPointer()),
		cs->GetBufferSize()
	};
	computeDesc.Flags = D3D12_PIPELINE_STATE_FLAG_NONE;
	computeDesc.pRootSignature = mContext.RootSignature;

	ThrowIfFailed(mContext.Device->CreateComputePipelineState(&computeDesc, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateDepthCountPSO(ID3DBlob* vs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_DEPTH_STENCIL_DESC depthStencilDesc{};
	depthStencilDesc.DepthEnable = false;
	depthStencilDesc.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
	depthStencilDesc.DepthFunc = D3D12_COMPARISON_FUNC_ALWAYS;
	depthStencilDesc.StencilEnable = true;
	depthStencilDesc.StencilReadMask = 0xff;
	depthStencilDesc.StencilWriteMask = 0xff;

	depthStencilDesc.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_ALWAYS;
	depthStencilDesc.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	depthStencilDesc.FrontFace.StencilPassOp = D3D12_STENCIL_OP_INCR_SAT;
	depthStencilDesc.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_INCR_SAT;

	//D3D12_CULL_MODE_BACK이므로 설정 중요도 없음.
	depthStencilDesc.BackFace = depthStencilDesc.FrontFace;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC depthCountDesc = BuildBaseGraphicsPsoDesc();
	depthCountDesc.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	depthCountDesc.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	depthCountDesc.BlendState.RenderTarget[0].RenderTargetWriteMask = 0;
	depthCountDesc.DepthStencilState = depthStencilDesc;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&depthCountDesc, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateDepthCountPSO(ID3DBlob* vs, ID3DBlob* gs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_DEPTH_STENCIL_DESC depthStencilDesc{};
	depthStencilDesc.DepthEnable = false;
	depthStencilDesc.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
	depthStencilDesc.DepthFunc = D3D12_COMPARISON_FUNC_ALWAYS;
	depthStencilDesc.StencilEnable = true;
	depthStencilDesc.StencilReadMask = 0xff;
	depthStencilDesc.StencilWriteMask = 0xff;

	depthStencilDesc.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_ALWAYS;
	depthStencilDesc.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	depthStencilDesc.FrontFace.StencilPassOp = D3D12_STENCIL_OP_INCR_SAT;
	depthStencilDesc.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_INCR_SAT;

	//D3D12_CULL_MODE_BACK이므로 설정 중요도 없음.
	depthStencilDesc.BackFace = depthStencilDesc.FrontFace;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC depthCountDesc = BuildBaseGraphicsPsoDesc();
	depthCountDesc.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	depthCountDesc.GS =
	{
		reinterpret_cast<BYTE*>(gs->GetBufferPointer()),
		gs->GetBufferSize()
	};
	depthCountDesc.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	depthCountDesc.BlendState.RenderTarget[0].RenderTargetWriteMask = 0;
	depthCountDesc.DepthStencilState = depthStencilDesc;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&depthCountDesc, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateDepthCountPSO(ID3DBlob* vs, ID3DBlob* hs, ID3DBlob* ds, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_DEPTH_STENCIL_DESC depthStencilDesc{};
	depthStencilDesc.DepthEnable = false;
	depthStencilDesc.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
	depthStencilDesc.DepthFunc = D3D12_COMPARISON_FUNC_ALWAYS;
	depthStencilDesc.StencilEnable = true;
	depthStencilDesc.StencilReadMask = 0xff;
	depthStencilDesc.StencilWriteMask = 0xff;

	depthStencilDesc.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_ALWAYS;
	depthStencilDesc.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	depthStencilDesc.FrontFace.StencilPassOp = D3D12_STENCIL_OP_INCR_SAT;
	depthStencilDesc.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_INCR_SAT;

	//D3D12_CULL_MODE_BACK이므로 설정 중요도 없음.
	depthStencilDesc.BackFace = depthStencilDesc.FrontFace;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC depthCountDesc = BuildBaseGraphicsPsoDesc();
	depthCountDesc.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	depthCountDesc.HS =
	{
		reinterpret_cast<BYTE*>(hs->GetBufferPointer()),
		hs->GetBufferSize()
	};
	depthCountDesc.DS =
	{
		reinterpret_cast<BYTE*>(ds->GetBufferPointer()),
		ds->GetBufferSize()
	};
	depthCountDesc.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	depthCountDesc.BlendState.RenderTarget[0].RenderTargetWriteMask = 0;
	depthCountDesc.DepthStencilState = depthStencilDesc;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&depthCountDesc, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateDepthComplexityDebugPSO(ID3DBlob* vs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_DEPTH_STENCIL_DESC depthComplexityDesc{};
	depthComplexityDesc.DepthEnable = false;
	depthComplexityDesc.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
	depthComplexityDesc.DepthFunc = D3D12_COMPARISON_FUNC_ALWAYS;
	depthComplexityDesc.StencilEnable = true;
	depthComplexityDesc.StencilReadMask = 0xff;
	depthComplexityDesc.StencilWriteMask = 0x00;

	depthComplexityDesc.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_EQUAL;
	depthComplexityDesc.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	depthComplexityDesc.FrontFace.StencilPassOp = D3D12_STENCIL_OP_KEEP;
	depthComplexityDesc.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;

	//D3D12_CULL_MODE_BACK이므로 설정 중요도 없음.
	depthComplexityDesc.BackFace = depthComplexityDesc.FrontFace;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC depthComplexityPsoDesc = BuildBaseGraphicsPsoDesc();
	depthComplexityPsoDesc.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	depthComplexityPsoDesc.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	depthComplexityPsoDesc.DepthStencilState = depthComplexityDesc;
	depthComplexityPsoDesc.InputLayout = { nullptr, 0 };

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&depthComplexityPsoDesc, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateMirrorStencilPSO(ID3DBlob* vs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;
	CD3DX12_BLEND_DESC mirrorBlendState(D3D12_DEFAULT);
	mirrorBlendState.RenderTarget[0].RenderTargetWriteMask = 0;

	D3D12_DEPTH_STENCIL_DESC mirrorDSD;
	mirrorDSD.DepthEnable = true;
	mirrorDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
	mirrorDSD.DepthFunc = D3D12_COMPARISON_FUNC_LESS;
	mirrorDSD.StencilEnable = true;
	mirrorDSD.StencilReadMask = 0xff;
	mirrorDSD.StencilWriteMask = 0xff;

	mirrorDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_ALWAYS;
	mirrorDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_REPLACE;
	mirrorDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;

	mirrorDSD.BackFace = mirrorDSD.FrontFace;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	state.BlendState = mirrorBlendState;
	state.DepthStencilState = mirrorDSD;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateMirrorWallPSO(ID3DBlob* vs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_DEPTH_STENCIL_DESC mirrorDSD{};
	mirrorDSD.DepthEnable = true;
	mirrorDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ALL;
	mirrorDSD.DepthFunc = D3D12_COMPARISON_FUNC_LESS;
	mirrorDSD.StencilEnable = true;
	mirrorDSD.StencilReadMask = 0xff;
	mirrorDSD.StencilWriteMask = 0xff;

	mirrorDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_NOT_EQUAL;
	mirrorDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;

	mirrorDSD.BackFace.StencilFunc = D3D12_COMPARISON_FUNC_ALWAYS;
	mirrorDSD.BackFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.BackFace.StencilPassOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.BackFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	state.DepthStencilState = mirrorDSD;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateMirrorReflectedPSO(ID3DBlob* vs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_DEPTH_STENCIL_DESC mirrorDSD;
	mirrorDSD.DepthEnable = true;
	mirrorDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ALL;
	mirrorDSD.DepthFunc = D3D12_COMPARISON_FUNC_LESS;
	mirrorDSD.StencilEnable = true;
	mirrorDSD.StencilReadMask = 0xff;
	mirrorDSD.StencilWriteMask = 0x00;

	mirrorDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_EQUAL;
	mirrorDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;

	mirrorDSD.BackFace = mirrorDSD.FrontFace;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	state.DepthStencilState = mirrorDSD;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateMirrorBaseFillPSO(ID3DBlob* vs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_DEPTH_STENCIL_DESC mirrorDSD;
	mirrorDSD.DepthEnable = false;
	mirrorDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
	mirrorDSD.DepthFunc = D3D12_COMPARISON_FUNC_ALWAYS;
	mirrorDSD.StencilEnable = true;
	mirrorDSD.StencilReadMask = 0xff;
	mirrorDSD.StencilWriteMask = 0x00;

	mirrorDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_EQUAL;
	mirrorDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;

	mirrorDSD.BackFace = mirrorDSD.FrontFace;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	state.DepthStencilState = mirrorDSD;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateShadowPSO(ID3DBlob* vs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_DEPTH_STENCIL_DESC shadowDSD{};
	shadowDSD.DepthEnable = true;
	shadowDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ALL;
	shadowDSD.DepthFunc = D3D12_COMPARISON_FUNC_LESS;
	shadowDSD.StencilEnable = true;
	shadowDSD.StencilReadMask = 0xff;
	shadowDSD.StencilWriteMask = 0xff;

	shadowDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_EQUAL;
	shadowDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	shadowDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_INCR_SAT;
	shadowDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;

	shadowDSD.BackFace = shadowDSD.FrontFace;

	D3D12_RENDER_TARGET_BLEND_DESC blendDesc{};
	blendDesc.BlendEnable = true;
	blendDesc.LogicOpEnable = false;
	blendDesc.SrcBlend = D3D12_BLEND_SRC_ALPHA;
	blendDesc.DestBlend = D3D12_BLEND_INV_SRC_ALPHA;
	blendDesc.BlendOp = D3D12_BLEND_OP_ADD;
	blendDesc.SrcBlendAlpha = D3D12_BLEND_ONE;
	blendDesc.DestBlendAlpha = D3D12_BLEND_ZERO;
	blendDesc.BlendOpAlpha = D3D12_BLEND_OP_ADD;
	blendDesc.LogicOp = D3D12_LOGIC_OP_NOOP;
	blendDesc.RenderTargetWriteMask = D3D12_COLOR_WRITE_ENABLE_ALL;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	state.DepthStencilState = shadowDSD;
	state.BlendState.RenderTarget[0] = blendDesc;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateTreeBillboardPSO(ID3DBlob* vs, ID3DBlob* gs, ID3DBlob* ps, bool a2c)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.GS =
	{
		reinterpret_cast<BYTE*>(gs->GetBufferPointer()),
		gs->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	state.BlendState.AlphaToCoverageEnable = a2c;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateLineToCylinderPSO(ID3DBlob* vs, ID3DBlob* gs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.GS =
	{
		reinterpret_cast<BYTE*>(gs->GetBufferPointer()),
		gs->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateExplodePSO(ID3DBlob* vs, ID3DBlob* gs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.GS =
	{
		reinterpret_cast<BYTE*>(gs->GetBufferPointer()),
		gs->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateTessellationPSO(ID3DBlob* vs, ID3DBlob* hs, ID3DBlob* ds, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.HS =
	{
		reinterpret_cast<BYTE*>(hs->GetBufferPointer()),
		hs->GetBufferSize()
	};
	state.DS =
	{
		reinterpret_cast<BYTE*>(ds->GetBufferPointer()),
		ds->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateTessellateMirrorWallPSO(ID3DBlob* vs, ID3DBlob* hs, ID3DBlob* ds, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_DEPTH_STENCIL_DESC mirrorDSD{};
	mirrorDSD.DepthEnable = true;
	mirrorDSD.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ALL;
	mirrorDSD.DepthFunc = D3D12_COMPARISON_FUNC_LESS;
	mirrorDSD.StencilEnable = true;
	mirrorDSD.StencilReadMask = 0xff;
	mirrorDSD.StencilWriteMask = 0x00;

	mirrorDSD.FrontFace.StencilFunc = D3D12_COMPARISON_FUNC_NOT_EQUAL;
	mirrorDSD.FrontFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.FrontFace.StencilPassOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.FrontFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;

	mirrorDSD.BackFace.StencilFunc = D3D12_COMPARISON_FUNC_NOT_EQUAL;
	mirrorDSD.BackFace.StencilFailOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.BackFace.StencilPassOp = D3D12_STENCIL_OP_KEEP;
	mirrorDSD.BackFace.StencilDepthFailOp = D3D12_STENCIL_OP_KEEP;

	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.HS =
	{
		reinterpret_cast<BYTE*>(hs->GetBufferPointer()),
		hs->GetBufferSize()
	};
	state.DS =
	{
		reinterpret_cast<BYTE*>(ds->GetBufferPointer()),
		ds->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	state.DepthStencilState = mirrorDSD;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

Microsoft::WRL::ComPtr<ID3D12PipelineState> PipelineStateFactory::CreateSelectedPSO(ID3DBlob* vs, ID3DBlob* ps)
{
	Microsoft::WRL::ComPtr<ID3D12PipelineState> PSO;

	D3D12_RENDER_TARGET_BLEND_DESC selectedBlendDesc{};
	selectedBlendDesc.BlendEnable = true;
	selectedBlendDesc.LogicOpEnable = false;
	selectedBlendDesc.SrcBlend = D3D12_BLEND_SRC_ALPHA;
	selectedBlendDesc.DestBlend = D3D12_BLEND_INV_SRC_ALPHA;
	selectedBlendDesc.BlendOp = D3D12_BLEND_OP_ADD;
	selectedBlendDesc.SrcBlendAlpha = D3D12_BLEND_ONE;
	selectedBlendDesc.DestBlendAlpha = D3D12_BLEND_ZERO;
	selectedBlendDesc.BlendOpAlpha = D3D12_BLEND_OP_ADD;
	selectedBlendDesc.LogicOp = D3D12_LOGIC_OP_NOOP;
	selectedBlendDesc.RenderTargetWriteMask = D3D12_COLOR_WRITE_ENABLE_ALL;


	D3D12_GRAPHICS_PIPELINE_STATE_DESC state = BuildBaseGraphicsPsoDesc();
	state.VS =
	{
		reinterpret_cast<BYTE*>(vs->GetBufferPointer()),
		vs->GetBufferSize()
	};
	state.PS =
	{
		reinterpret_cast<BYTE*>(ps->GetBufferPointer()),
		ps->GetBufferSize()
	};
	state.DepthStencilState.DepthFunc = D3D12_COMPARISON_FUNC_LESS_EQUAL;
	state.DepthStencilState.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
	state.BlendState.RenderTarget[0] = selectedBlendDesc;

	ThrowIfFailed(mContext.Device->CreateGraphicsPipelineState(&state, IID_PPV_ARGS(PSO.GetAddressOf())));

	return PSO;
}

D3D12_GRAPHICS_PIPELINE_STATE_DESC PipelineStateFactory::BuildBaseGraphicsPsoDesc() const
{
	D3D12_GRAPHICS_PIPELINE_STATE_DESC basePsoDesc{};
	basePsoDesc.InputLayout = { mContext.InputLayout->data(), (UINT)mContext.InputLayout->size() };
	basePsoDesc.pRootSignature = mContext.RootSignature;
	basePsoDesc.RasterizerState = CD3DX12_RASTERIZER_DESC(D3D12_DEFAULT);
	basePsoDesc.RasterizerState.FillMode = mContext.IsWireframe ? D3D12_FILL_MODE_WIREFRAME : D3D12_FILL_MODE_SOLID;
	basePsoDesc.RasterizerState.CullMode = mContext.CullMode;
	basePsoDesc.RasterizerState.FrontCounterClockwise = mContext.Clockwise;
	basePsoDesc.BlendState = CD3DX12_BLEND_DESC(D3D12_DEFAULT);
	basePsoDesc.DepthStencilState = CD3DX12_DEPTH_STENCIL_DESC(D3D12_DEFAULT);
	basePsoDesc.SampleMask = UINT_MAX; //모든 샘플 사용.
	basePsoDesc.PrimitiveTopologyType = mContext.topologyType;
	basePsoDesc.NumRenderTargets = 1;
	basePsoDesc.RTVFormats[0] = mContext.BackBufferFormat;
	basePsoDesc.SampleDesc.Count = mContext.SampleCount;
	basePsoDesc.SampleDesc.Quality = mContext.SampleQuality;
	basePsoDesc.DSVFormat = mContext.DepthStencilFormat;

	return basePsoDesc;
}
