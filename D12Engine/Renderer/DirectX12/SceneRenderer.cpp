#include "pch.h"
#include "SceneRenderer.h"

#include "D3D12Context.h"
#include "EngineCore/Scene.h"
#include "Renderer/DirectX12/MACRO.h"

bool SceneRenderer::Initialize(D3D12Context& context)
{
	if (mInitialized) return true;

	LoadTextures();

	BuildDescriptorHeaps(context);
	BuildRootSignature(context);
	BuildShadersAndInputLayout(context);

	BuildGeometry(context);

	BuildMaterials(context);
	BuildRenderItems(context);
	BuildFrameResources(context);
	BuildPSOs(context);

	mInitialized = true;

	return true;
}

void SceneRenderer::Shutdown()
{
	if (!mInitialized) return;

	//추후 해제로직
	
	mInitialized = false;
}

void SceneRenderer::OnResize(int width, int height)
{
	mViewportWidth = std::max(1, width);
	mViewportHeight = std::max(1, height);

	//카메라 등 반영 예정.
}

void SceneRenderer::Update(const Scene& scene, float deltaTime)
{
	if (!mInitialized) return;


}

void SceneRenderer::Render(D3D12Context& context, const Scene& scene)
{
	if (!mInitialized) return;

	ID3D12GraphicsCommandList* cmdList = context.GetCommandList();


}

void SceneRenderer::LoadTextures()
{
}

void SceneRenderer::BuildDescriptorHeaps(D3D12Context& context)
{
	/*
		0 ~ SwapChainBufferCount	: 백버퍼의 SRV
		~ N							: 기존 텍스처
		~ 1							: ImGui Font
		~ M							: ImGui용 추가 슬롯(optional)
		~ M+6						: mWaves의 DiscriptorCount개수 6개.
		~ M+10						: mBlurFilter의 DescriptorCount 개수 4개.
		~ M+14						: mSobelFilter의 DescriptorCount 개수 4개.
	*/
	//D3D12_DESCRIPTOR_HEAP_DESC srvHeapDesc = {};
	//const UINT textureCount = (UINT)mTextures.size();
	//const UINT imguiReservedCount = 1; //폰트만
	//srvHeapDesc.NumDescriptors = RenderConfig::SwapChainBufferCount
	//	+ textureCount + imguiReservedCount
	//	+ mWaves->DescriptorCount()
	//	+ mBlurFilter->DescriptorCount()
	//	+ mSobelFilter->DescriptorCount();
	//srvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
	//srvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
	//ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&srvHeapDesc, IID_PPV_ARGS(mSrvHeap.GetAddressOf())));

	//BuildBackbufferSRV();

	//CD3DX12_CPU_DESCRIPTOR_HANDLE hDescriptor(mSrvHeap->GetCPUDescriptorHandleForHeapStart());
	//hDescriptor.Offset(RenderConfig::SwapChainBufferCount, mCbvSrvUavDescriptorSize);

	//int i = RenderConfig::SwapChainBufferCount;
	//for (auto& tex : mTextures)
	//{
	//	auto resource = tex.second->Resource;
	//	auto desc = resource->GetDesc();
	//	D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc = {};
	//	srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
	//	srvDesc.Format = desc.Format;
	//	srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
	//	srvDesc.Texture2D.MostDetailedMip = 0;
	//	srvDesc.Texture2D.MipLevels = desc.MipLevels;
	//	srvDesc.Texture2D.ResourceMinLODClamp = 0.0f;

	//	md3dDevice->CreateShaderResourceView(resource.Get(), &srvDesc, hDescriptor);
	//	hDescriptor.Offset(1, mCbvSrvUavDescriptorSize);

	//	tex.second->SrvHeapIndex = i;
	//	i++;
}

void SceneRenderer::BuildMaterials(D3D12Context& context)
{
}

void SceneRenderer::BuildRootSignature(D3D12Context& context)
{
}

void SceneRenderer::BuildRootSignature_Waves(D3D12Context& context)
{
}

void SceneRenderer::BuildShadersAndInputLayout(D3D12Context& context)
{
}

void SceneRenderer::BuildBackbufferSRV()
{
}

void SceneRenderer::BuildGeometry(D3D12Context& context)
{
}

void SceneRenderer::BuildShapeGeometry(D3D12Context& context)
{
}

void SceneRenderer::BuildLandGeometry()
{
}

void SceneRenderer::BuildWavesGeometry()
{
}

void SceneRenderer::BuildTreeBillboardGeometry()
{
}

void SceneRenderer::BuildCylinderWithoutTopGeometry()
{
}

void SceneRenderer::BuildBrickWallGeometry()
{
}

void SceneRenderer::BuildRenderItems(D3D12Context& context)
{
}

void SceneRenderer::BuildRenderItems_Common(unsigned short& InstanceBufferIndex)
{
}

void SceneRenderer::BuildRenderItems_InMirror(unsigned short& InstanceBufferIndex)
{
}

void SceneRenderer::BuildRenderItems_Gizmo(unsigned short& InstanceBufferIndex)
{
}

void SceneRenderer::BuildRenderItems_SkinnedModel(unsigned short& IinstanceBufferIndex)
{
}

void SceneRenderer::BuildFrameResources(D3D12Context& context)
{
}

void SceneRenderer::BuildPSOs(D3D12Context& context)
{
}


