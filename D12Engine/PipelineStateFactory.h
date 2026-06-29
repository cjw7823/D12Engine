#pragma once

#include <vector>
#include "DirectX-Headers/d3dx12.h"

struct PsoBuildContext
{
	ID3D12Device* Device = nullptr;
	ID3D12RootSignature* RootSignature = nullptr;

	const std::vector<D3D12_INPUT_ELEMENT_DESC>* InputLayout = nullptr;

	DXGI_FORMAT BackBufferFormat = DXGI_FORMAT_UNKNOWN;
	DXGI_FORMAT DepthStencilFormat = DXGI_FORMAT_UNKNOWN;

	UINT SampleCount = 1;
	UINT SampleQuality = 0;

	bool IsWireframe = false;

	D3D12_CULL_MODE CullMode = D3D12_CULL_MODE_BACK;
	BOOL Clockwise = false;

	D3D12_PRIMITIVE_TOPOLOGY_TYPE topologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
};

class PipelineStateFactory
{
public:
	explicit PipelineStateFactory(const PsoBuildContext& ctx) : mContext(ctx) {};

	void operator()(const PsoBuildContext& ctx) { mContext = ctx; }

	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateOpaquePSO(ID3DBlob* vs, ID3DBlob* ps);
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateTransparentPSO(ID3DBlob* vs, ID3DBlob* ps);

	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateComputePSO(ID3DBlob* cs);

	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateDepthCountPSO(ID3DBlob* vs, ID3DBlob* ps);
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateDepthCountPSO(ID3DBlob* vs, ID3DBlob* gs, ID3DBlob* ps);
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateDepthCountPSO(ID3DBlob* vs, ID3DBlob* hs, ID3DBlob* ds, ID3DBlob* ps);
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateDepthComplexityDebugPSO(ID3DBlob* vs, ID3DBlob* ps);

	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateMirrorStencilPSO(ID3DBlob* vs, ID3DBlob* ps);
	[[deprecated("Use CreateTessellateMirrorWallPSO instead.")]]
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateMirrorWallPSO(ID3DBlob* vs, ID3DBlob* ps);
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateMirrorReflectedPSO(ID3DBlob* vs, ID3DBlob* ps);
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateMirrorBaseFillPSO(ID3DBlob* vs, ID3DBlob* ps);

	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateShadowPSO(ID3DBlob* vs, ID3DBlob* ps);
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateTreeBillboardPSO(ID3DBlob* vs, ID3DBlob* gs, ID3DBlob* ps, bool a2c);
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateLineToCylinderPSO(ID3DBlob* vs, ID3DBlob* gs, ID3DBlob* ps);
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateExplodePSO(ID3DBlob* vs, ID3DBlob* gs, ID3DBlob* ps);

	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateTessellationPSO(ID3DBlob* vs, ID3DBlob* hs, ID3DBlob* ds, ID3DBlob* ps);
	Microsoft::WRL::ComPtr<ID3D12PipelineState> CreateTessellateMirrorWallPSO(ID3DBlob* vs, ID3DBlob* hs, ID3DBlob* ds, ID3DBlob* ps);

private:
	D3D12_GRAPHICS_PIPELINE_STATE_DESC BuildBaseGraphicsPsoDesc() const;

private:
	PsoBuildContext mContext;
};