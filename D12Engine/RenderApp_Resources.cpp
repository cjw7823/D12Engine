#include "pch.h"
#include "RenderApp.h"
#include "RenderData.h"

using namespace DirectX;

void RenderApp::LoadTextures()
{
	double start = mTimer.TotalTime();

	if (!mTexLoader)
		mTexLoader = std::make_unique<TextureLoader_Blocking>(md3dDevice.Get(), mCommandQueue.Get());

	auto defaultTex = std::make_unique<Texture>();
	defaultTex->Name = "defaultTex";
	defaultTex->Filename = L"Resource/Textures/white1x1.dds";

	auto woodCrateTex = std::make_unique<Texture>();
	woodCrateTex->Name = "woodCrateTex";
	woodCrateTex->Filename = L"Resource/Textures/MipmapTest.dds";

	auto bricksTex0 = std::make_unique<Texture>();
	bricksTex0->Name = "bricksTex0";
	bricksTex0->Filename = L"Resource/Textures/bricks.dds";

	auto stoneTex = std::make_unique<Texture>();
	stoneTex->Name = "stoneTex";
	stoneTex->Filename = L"Resource/Textures/stone.dds";

	auto tileTex = std::make_unique<Texture>();
	tileTex->Name = "tileTex";
	tileTex->Filename = L"Resource/Textures/tile.dds";

	auto grassTex = std::make_unique<Texture>();
	grassTex->Name = "grassTex";
	grassTex->Filename = L"Resource/Textures/grass.dds";

	auto waterTex = std::make_unique<Texture>();
	waterTex->Name = "waterTex";
	waterTex->Filename = L"Resource/Textures/water1.dds";

	auto swirlingTex = std::make_unique<Texture>();
	swirlingTex->Name = "swirlingTex";
	swirlingTex->Filename = L"Resource/Textures/swirling.dds";

	auto swirlingMaskTex = std::make_unique<Texture>();
	swirlingMaskTex->Name = "swirlingMaskTex";
	swirlingMaskTex->Filename = L"Resource/Textures/swirling_Mask.dds";

	auto fenceTex = std::make_unique<Texture>();
	fenceTex->Name = "fenceTex";
	fenceTex->Filename = L"Resource/Textures/WireFence.dds";

	auto bricksTex1 = std::make_unique<Texture>();
	bricksTex1->Name = "bricksTex1";
	bricksTex1->Filename = L"Resource/Textures/bricks2.dds";

	auto checkboardTex = std::make_unique<Texture>();
	checkboardTex->Name = "checkboardTex";
	checkboardTex->Filename = L"Resource/Textures/checkboard.dds";

	auto iceTex = std::make_unique<Texture>();
	iceTex->Name = "iceTex";
	iceTex->Filename = L"Resource/Textures/ice.dds";

	auto helpTex = std::make_unique<Texture>();
	helpTex->Name = "helpTex";
	helpTex->Filename = L"Resource/Textures/help.dds";

	auto treeArrayTex = std::make_unique<Texture>();
	treeArrayTex->Name = "treeArrayTex";
	treeArrayTex->Filename = L"Resource/Textures/treearray2.dds";

	mTextures[defaultTex->Name] = std::move(defaultTex);
	mTextures[woodCrateTex->Name] = std::move(woodCrateTex);
	mTextures[bricksTex0->Name] = std::move(bricksTex0);
	mTextures[stoneTex->Name] = std::move(stoneTex);
	mTextures[tileTex->Name] = std::move(tileTex);
	mTextures[grassTex->Name] = std::move(grassTex);
	mTextures[waterTex->Name] = std::move(waterTex);
	mTextures[swirlingTex->Name] = std::move(swirlingTex);
	mTextures[swirlingMaskTex->Name] = std::move(swirlingMaskTex);
	mTextures[fenceTex->Name] = std::move(fenceTex);
	mTextures[bricksTex1->Name] = std::move(bricksTex1);
	mTextures[checkboardTex->Name] = std::move(checkboardTex);
	mTextures[iceTex->Name] = std::move(iceTex);
	mTextures[helpTex->Name] = std::move(helpTex);
	mTextures[treeArrayTex->Name] = std::move(treeArrayTex);

	//텍스처 15개 기준 3ms 단축.
	std::vector<Texture*> texturesToLoad;
	for (auto& tex : mTextures)
		texturesToLoad.push_back(tex.second.get());
	ThrowIfFailed(mTexLoader->LoadDDS((UINT)texturesToLoad.size(), texturesToLoad.data()));

	double elapsedMs = (mTimer.TotalTime() - start) * 1000.0;
	std::wstring s = L"Texture Load elapsed : "
		+ std::to_wstring(elapsedMs)
		+ L" ms\n";
	OutputDebugString(s.c_str());
}

void RenderApp::BuildDescriptorHeaps()
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
	D3D12_DESCRIPTOR_HEAP_DESC srvHeapDesc = {};
	const UINT textureCount = (UINT)mTextures.size();
	const UINT imguiReservedCount = 1; //폰트만
	srvHeapDesc.NumDescriptors = SwapChainBufferCount
		+ textureCount + imguiReservedCount
		+ mWaves->DescriptorCount()
		+ mBlurFilter->DescriptorCount()
		+ mSobelFilter->DescriptorCount();
	srvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
	srvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&srvHeapDesc, IID_PPV_ARGS(mSrvHeap.GetAddressOf())));

	BuildBackbufferSRV();

	CD3DX12_CPU_DESCRIPTOR_HANDLE hDescriptor(mSrvHeap->GetCPUDescriptorHandleForHeapStart());
	hDescriptor.Offset(SwapChainBufferCount, mCbvSrvUavDescriptorSize);

	int i = SwapChainBufferCount;
	for (auto& tex : mTextures)
	{
		auto resource = tex.second->Resource;
		auto desc = resource->GetDesc();
		D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc = {};
		srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
		srvDesc.Format = desc.Format;
		srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
		srvDesc.Texture2D.MostDetailedMip = 0;
		srvDesc.Texture2D.MipLevels = desc.MipLevels;
		srvDesc.Texture2D.ResourceMinLODClamp = 0.0f;

		md3dDevice->CreateShaderResourceView(resource.Get(), &srvDesc, hDescriptor);
		hDescriptor.Offset(1, mCbvSrvUavDescriptorSize);

		tex.second->SrvHeapIndex = i;
		i++;
	}

	const UINT wavesBaseIndex = SwapChainBufferCount + textureCount + imguiReservedCount;

	mWaves->BuildDescriptors(
		CD3DX12_CPU_DESCRIPTOR_HANDLE(
			mSrvHeap->GetCPUDescriptorHandleForHeapStart(),
			wavesBaseIndex,
			mCbvSrvUavDescriptorSize),
		CD3DX12_GPU_DESCRIPTOR_HANDLE(
			mSrvHeap->GetGPUDescriptorHandleForHeapStart(),
			wavesBaseIndex,
			mCbvSrvUavDescriptorSize),
		mCbvSrvUavDescriptorSize);
	
	const UINT blurBaseIndex = wavesBaseIndex + mWaves->DescriptorCount();

	mBlurFilter->BuildDescriptors(
		CD3DX12_CPU_DESCRIPTOR_HANDLE(
			mSrvHeap->GetCPUDescriptorHandleForHeapStart(),
			blurBaseIndex,
			mCbvSrvUavDescriptorSize),
		CD3DX12_GPU_DESCRIPTOR_HANDLE(
			mSrvHeap->GetGPUDescriptorHandleForHeapStart(),
			blurBaseIndex,
			mCbvSrvUavDescriptorSize),
		mCbvSrvUavDescriptorSize);


	const UINT sobelBaseIndex = blurBaseIndex + mBlurFilter->DescriptorCount();

	mSobelFilter->BuildDescriptors(
		CD3DX12_CPU_DESCRIPTOR_HANDLE(
			mSrvHeap->GetCPUDescriptorHandleForHeapStart(),
			sobelBaseIndex,
			mCbvSrvUavDescriptorSize),
		CD3DX12_GPU_DESCRIPTOR_HANDLE(
			mSrvHeap->GetGPUDescriptorHandleForHeapStart(),
			sobelBaseIndex,
			mCbvSrvUavDescriptorSize),
		mCbvSrvUavDescriptorSize);
}

void RenderApp::BuildMaterials()
{
	UINT index = 0;

	auto defaultMat = std::make_unique<Material>();
	defaultMat->Name = "defaultMat";
	defaultMat->MatBufferIndex = index++;
	defaultMat->DiffuseSrvHeapIndex = mTextures["defaultTex"]->SrvHeapIndex; //텍스처 없음.
	defaultMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	defaultMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	defaultMat->Roughness = 0.3f;

	auto tileMat = std::make_unique<Material>();
	tileMat->Name = "tile0";
	tileMat->MatBufferIndex = index++;
	tileMat->DiffuseSrvHeapIndex = mTextures["tileTex"]->SrvHeapIndex;
	tileMat->DiffuseAlbedo = XMFLOAT4(Colors::LightGray);
	tileMat->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	tileMat->Roughness = 0.2f;

	auto bricksMat0 = std::make_unique<Material>();
	bricksMat0->Name = "bricks0";
	bricksMat0->MatBufferIndex = index++;
	bricksMat0->DiffuseSrvHeapIndex = mTextures["bricksTex0"]->SrvHeapIndex;
	bricksMat0->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	bricksMat0->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	bricksMat0->Roughness = 0.1f;

	auto stoneMat = std::make_unique<Material>();
	stoneMat->Name = "stone0";
	stoneMat->MatBufferIndex = index++;
	stoneMat->DiffuseSrvHeapIndex = mTextures["stoneTex"]->SrvHeapIndex;
	stoneMat->DiffuseAlbedo = XMFLOAT4(Colors::LightSteelBlue);
	stoneMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	stoneMat->Roughness = 0.3f;

	auto grassMat = std::make_unique<Material>();
	grassMat->Name = "grass0";
	grassMat->MatBufferIndex = index++;
	grassMat->DiffuseSrvHeapIndex = mTextures["grassTex"]->SrvHeapIndex;
	grassMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	grassMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	grassMat->Roughness = 0.125f;

	auto waterMat = std::make_unique<Material>();
	waterMat->Name = "water0";
	waterMat->MatBufferIndex = index++;
	waterMat->DiffuseSrvHeapIndex = mTextures["waterTex"]->SrvHeapIndex;
	waterMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.5f);
	waterMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	waterMat->Roughness = 0.0f;

	auto woodCrateMat = std::make_unique<Material>();
	woodCrateMat->Name = "woodCrate";
	woodCrateMat->MatBufferIndex = index++;
	woodCrateMat->DiffuseSrvHeapIndex = mTextures["woodCrateTex"]->SrvHeapIndex;
	woodCrateMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	woodCrateMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	woodCrateMat->Roughness = 0.0f;

	auto swirlingMat = std::make_unique<Material>();
	swirlingMat->Name = "swirling";
	swirlingMat->MatBufferIndex = index++;
	swirlingMat->DiffuseSrvHeapIndex = mTextures["swirlingTex"]->SrvHeapIndex;
	swirlingMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMat->Roughness = 0.0f;

	auto swirlingMaskMat = std::make_unique<Material>();
	swirlingMaskMat->Name = "swirlingMask";
	swirlingMaskMat->MatBufferIndex = index++;
	swirlingMaskMat->DiffuseSrvHeapIndex = mTextures["swirlingMaskTex"]->SrvHeapIndex;
	swirlingMaskMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMaskMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMaskMat->Roughness = 0.0f;

	auto wireFence = std::make_unique<Material>();
	wireFence->Name = "wireFence";
	wireFence->MatBufferIndex = index++;
	wireFence->DiffuseSrvHeapIndex = mTextures["fenceTex"]->SrvHeapIndex;
	wireFence->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	wireFence->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	wireFence->Roughness = 0.25f;

	auto bricksMat1 = std::make_unique<Material>();
	bricksMat1->Name = "bricks1";
	bricksMat1->MatBufferIndex = index++;
	bricksMat1->DiffuseSrvHeapIndex = mTextures["bricksTex1"]->SrvHeapIndex;
	bricksMat1->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	bricksMat1->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	bricksMat1->Roughness = 0.25f;

	auto checkerTileMat = std::make_unique<Material>();
	checkerTileMat->Name = "checkerTileMat";
	checkerTileMat->MatBufferIndex = index++;
	checkerTileMat->DiffuseSrvHeapIndex = mTextures["checkboardTex"]->SrvHeapIndex;
	checkerTileMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	checkerTileMat->FresnelR0 = XMFLOAT3(0.07f, 0.07f, 0.07f);
	checkerTileMat->Roughness = 0.3f;

	auto iceMirrorMat = std::make_unique<Material>();
	iceMirrorMat->Name = "iceMirrorMat";
	iceMirrorMat->MatBufferIndex = index++;
	iceMirrorMat->DiffuseSrvHeapIndex = mTextures["iceTex"]->SrvHeapIndex;
	iceMirrorMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.3f);
	iceMirrorMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	iceMirrorMat->Roughness = 0.5f;

	auto shadowMat_skull = std::make_unique<Material>();
	shadowMat_skull->Name = "shadowMat_skull";
	shadowMat_skull->MatBufferIndex = index++;
	shadowMat_skull->DiffuseSrvHeapIndex = mTextures["defaultTex"]->SrvHeapIndex;
	shadowMat_skull->DiffuseAlbedo = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.5f);
	shadowMat_skull->FresnelR0 = XMFLOAT3(0.001f, 0.001f, 0.001f);
	shadowMat_skull->Roughness = 0.0f;

	auto treeBillboardMat = std::make_unique<Material>();
	treeBillboardMat->Name = "treeBillboardMat";
	treeBillboardMat->MatBufferIndex = index++;
	treeBillboardMat->DiffuseSrvHeapIndex = mTextures["treeArrayTex"]->SrvHeapIndex;
	treeBillboardMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	treeBillboardMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	treeBillboardMat->Roughness = 0.125f;

	auto mirrorBaseMat = std::make_unique<Material>();
	mirrorBaseMat->Name = "mirrorBaseMat";
	mirrorBaseMat->MatBufferIndex = index++;
	mirrorBaseMat->DiffuseSrvHeapIndex = mTextures["defaultTex"]->SrvHeapIndex;
	mirrorBaseMat->DiffuseAlbedo = mMainPassCB.gFogColor;
	mirrorBaseMat->FresnelR0 = XMFLOAT3(0.0f, 0.0f, 0.0f);
	mirrorBaseMat->Roughness = 1.0f;

	auto highlightMat = std::make_unique<Material>();
	highlightMat->Name = "highlightMat";
	highlightMat->MatBufferIndex = index++;
	highlightMat->DiffuseSrvHeapIndex = mTextures["defaultTex"]->SrvHeapIndex;
	highlightMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 0.0f, 0.6f);
	highlightMat->FresnelR0 = XMFLOAT3(0.06f, 0.06f, 0.06f);
	highlightMat->Roughness = 0.0f;

	mMaterials[defaultMat->Name] = std::move(defaultMat);
	mMaterials[tileMat->Name] = std::move(tileMat);
	mMaterials[bricksMat0->Name] = std::move(bricksMat0);
	mMaterials[stoneMat->Name] = std::move(stoneMat);
	mMaterials[grassMat->Name] = std::move(grassMat);
	mMaterials[waterMat->Name] = std::move(waterMat);
	mMaterials[woodCrateMat->Name] = std::move(woodCrateMat);
	mMaterials[swirlingMat->Name] = std::move(swirlingMat);
	mMaterials[swirlingMaskMat->Name] = std::move(swirlingMaskMat);
	mMaterials[wireFence->Name] = std::move(wireFence);
	mMaterials[bricksMat1->Name] = std::move(bricksMat1);
	mMaterials[checkerTileMat->Name] = std::move(checkerTileMat);
	mMaterials[iceMirrorMat->Name] = std::move(iceMirrorMat);
	mMaterials[shadowMat_skull->Name] = std::move(shadowMat_skull);
	mMaterials[treeBillboardMat->Name] = std::move(treeBillboardMat);
	mMaterials[mirrorBaseMat->Name] = std::move(mirrorBaseMat);
	mMaterials[highlightMat->Name] = std::move(highlightMat);
}

void RenderApp::BuildRenderItems()
{
	UINT StartInstanceLocation = 0;
	BuildRenderItems_Common(StartInstanceLocation);
	BuildRenderItems_InMirror(StartInstanceLocation);
	//BuildRenderItems_Selected(StartInstanceLocation);

	for (const auto& ri : mAllRenderItems)
		mInstanceCount += (UINT)ri->Instances.size();
}

void RenderApp::BuildRenderItems_Common(UINT& InstanceBufferIndex)
{
	{
		auto boxRI = std::make_unique<RenderItem>();
		boxRI->Geo = mGeometries["shapeGeo"].get();
		boxRI->IndexCount = boxRI->Geo->DrawArgs["box"].IndexCount;
		boxRI->StartIndexLocation = boxRI->Geo->DrawArgs["box"].StartIndexLocation;
		boxRI->BaseVertexLocation = boxRI->Geo->DrawArgs["box"].BaseVertexLocation;
		boxRI->Bounds = boxRI->Geo->DrawArgs["box"].Bounds;
		boxRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		boxRI->InMirror = true;
		{
			InstanceData instance;
			auto world = XMMatrixScaling(2.f, 2.f / 3.f, 2.f) * XMMatrixTranslation(0.f, 0.5f, -5.f);
			auto invTransposeWorld = MathHelper::InverseTranspose(world);
			XMStoreFloat4x4(&instance.World, world);
			XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
			instance.MaterialIndex = mMaterials["woodCrate"]->MatBufferIndex;
			boxRI->Instances.push_back(instance);
		}
		boxRI->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)boxRI->Instances.size();
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(boxRI.get());
		mAllRenderItems.push_back(std::move(boxRI));

		auto blendBoxRI = std::make_unique<RenderItem>();
		blendBoxRI->Geo = mGeometries["shapeGeo"].get();
		blendBoxRI->IndexCount = blendBoxRI->Geo->DrawArgs["box"].IndexCount;
		blendBoxRI->StartIndexLocation = blendBoxRI->Geo->DrawArgs["box"].StartIndexLocation;
		blendBoxRI->BaseVertexLocation = blendBoxRI->Geo->DrawArgs["box"].BaseVertexLocation;
		blendBoxRI->Bounds = blendBoxRI->Geo->DrawArgs["box"].Bounds;
		blendBoxRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		blendBoxRI->InMirror = true;
		{
			InstanceData instance;
			auto world = XMMatrixScaling(2.f, 2.f, 2.f) * XMMatrixTranslation(0.f, 2.f, 8.f);
			auto invTransposeWorld = MathHelper::InverseTranspose(world);
			XMStoreFloat4x4(&instance.World, world);
			XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
			instance.MaterialIndex = mMaterials["swirling"]->MatBufferIndex;
			blendBoxRI->Instances.push_back(instance);
		}
		blendBoxRI->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)blendBoxRI->Instances.size();
		mRenderItemLayer[(int)RenderLayer::MultiTextureBlend].push_back(blendBoxRI.get());
		mAllRenderItems.push_back(std::move(blendBoxRI));

		auto netBoxRI = std::make_unique<RenderItem>();
		netBoxRI->Geo = mGeometries["shapeGeo"].get();
		netBoxRI->IndexCount = netBoxRI->Geo->DrawArgs["box"].IndexCount;
		netBoxRI->StartIndexLocation = netBoxRI->Geo->DrawArgs["box"].StartIndexLocation;
		netBoxRI->BaseVertexLocation = netBoxRI->Geo->DrawArgs["box"].BaseVertexLocation;
		netBoxRI->Bounds = netBoxRI->Geo->DrawArgs["box"].Bounds;
		netBoxRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		netBoxRI->InMirror = true;
		{
			InstanceData instance;
			auto world = XMMatrixTranslation(0.f, 1.f, -10.f);
			auto invTransposeWorld = MathHelper::InverseTranspose(world);
			XMStoreFloat4x4(&instance.World, world);
			XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
			instance.MaterialIndex = mMaterials["wireFence"]->MatBufferIndex;
			netBoxRI->Instances.push_back(instance);
		}
		netBoxRI->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)netBoxRI->Instances.size();
		mRenderItemLayer[(int)RenderLayer::AlphaTestOpaque].push_back(netBoxRI.get());
		mAllRenderItems.push_back(std::move(netBoxRI));

		auto gridRI = std::make_unique<RenderItem>();
		gridRI->Geo = mGeometries["shapeGeo"].get();
		gridRI->IndexCount = gridRI->Geo->DrawArgs["grid"].IndexCount;
		gridRI->StartIndexLocation = gridRI->Geo->DrawArgs["grid"].StartIndexLocation;
		gridRI->BaseVertexLocation = gridRI->Geo->DrawArgs["grid"].BaseVertexLocation;
		gridRI->Bounds = gridRI->Geo->DrawArgs["grid"].Bounds;
		gridRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		gridRI->InMirror = true;
		{
			InstanceData instance;
			instance.MaterialIndex = mMaterials["tile0"]->MatBufferIndex;
			XMStoreFloat4x4(&instance.TexTransform, XMMatrixScaling(8.0f, 8.0f, 1.0f));
			gridRI->Instances.push_back(instance);
		}
		gridRI->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)gridRI->Instances.size();
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(gridRI.get());
		mAllRenderItems.push_back(std::move(gridRI));

		auto CylinderRI = std::make_unique<RenderItem>();
		CylinderRI->Geo = mGeometries["shapeGeo"].get();
		CylinderRI->IndexCount = CylinderRI->Geo->DrawArgs["cylinder"].IndexCount;
		CylinderRI->StartIndexLocation = CylinderRI->Geo->DrawArgs["cylinder"].StartIndexLocation;
		CylinderRI->BaseVertexLocation = CylinderRI->Geo->DrawArgs["cylinder"].BaseVertexLocation;
		CylinderRI->Bounds = CylinderRI->Geo->DrawArgs["cylinder"].Bounds;
		CylinderRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		CylinderRI->InMirror = true;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(CylinderRI.get());

		auto SphereRitem = std::make_unique<RenderItem>();
		SphereRitem->Geo = mGeometries["shapeGeo"].get();
		SphereRitem->IndexCount = SphereRitem->Geo->DrawArgs["sphere"].IndexCount;
		SphereRitem->StartIndexLocation = SphereRitem->Geo->DrawArgs["sphere"].StartIndexLocation;
		SphereRitem->BaseVertexLocation = SphereRitem->Geo->DrawArgs["sphere"].BaseVertexLocation;
		SphereRitem->Bounds = SphereRitem->Geo->DrawArgs["sphere"].Bounds;
		SphereRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		SphereRitem->InMirror = true;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(SphereRitem.get());

		auto GeoSphereRitem = std::make_unique<RenderItem>();
		GeoSphereRitem->Geo = mGeometries["shapeGeo"].get();
		GeoSphereRitem->IndexCount = GeoSphereRitem->Geo->DrawArgs["geoSphere"].IndexCount;
		GeoSphereRitem->StartIndexLocation = GeoSphereRitem->Geo->DrawArgs["geoSphere"].StartIndexLocation;
		GeoSphereRitem->BaseVertexLocation = GeoSphereRitem->Geo->DrawArgs["geoSphere"].BaseVertexLocation;
		GeoSphereRitem->Bounds = GeoSphereRitem->Geo->DrawArgs["geoSphere"].Bounds;
		GeoSphereRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		GeoSphereRitem->InMirror = true;
		mRenderItemLayer[(int)RenderLayer::GeoSphereLOD].push_back(GeoSphereRitem.get());

		for (int i = 0; i < 5; ++i)
		{
			XMMATRIX leftCylWorld = XMMatrixTranslation(-5.0f, 1.5f, -10.0f + i * 5.0f);
			XMMATRIX leftCylWorld_invT = MathHelper::InverseTranspose(leftCylWorld);
			XMMATRIX rightCylWorld = XMMatrixTranslation(+5.0f, 1.5f, -10.0f + i * 5.0f);
			XMMATRIX rightCylWorld_invT = MathHelper::InverseTranspose(rightCylWorld);

			XMMATRIX leftSphereWorld = XMMatrixTranslation(-5.0f, 3.5f, -10.0f + i * 5.0f);
			XMMATRIX leftSphereWorld_invT = MathHelper::InverseTranspose(leftSphereWorld);
			XMMATRIX rightSphereWorld = XMMatrixScaling(2.0f, 2.0f, 2.0f) * XMMatrixTranslation(+5.0f, 3.5f, -10.0f + i * 5.0f);
			XMMATRIX rightSphereWorld_invT = MathHelper::InverseTranspose(rightSphereWorld);

			InstanceData instance;
			XMStoreFloat4x4(&instance.World, leftCylWorld);
			XMStoreFloat4x4(&instance.WorldInvTranspose, leftCylWorld_invT);
			instance.MaterialIndex = mMaterials["bricks0"]->MatBufferIndex;
			CylinderRI->Instances.push_back(instance);

			XMStoreFloat4x4(&instance.World, rightCylWorld);
			XMStoreFloat4x4(&instance.WorldInvTranspose, rightCylWorld_invT);
			CylinderRI->Instances.push_back(instance);

			XMStoreFloat4x4(&instance.World, leftSphereWorld);
			XMStoreFloat4x4(&instance.WorldInvTranspose, leftSphereWorld_invT);
			instance.MaterialIndex = mMaterials["stone0"]->MatBufferIndex;
			SphereRitem->Instances.push_back(instance);

			XMStoreFloat4x4(&instance.World, rightSphereWorld);
			XMStoreFloat4x4(&instance.WorldInvTranspose, rightSphereWorld_invT);
			GeoSphereRitem->Instances.push_back(instance);
		}

		CylinderRI->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)CylinderRI->Instances.size();

		SphereRitem->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)SphereRitem->Instances.size();

		GeoSphereRitem->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)GeoSphereRitem->Instances.size();

		mAllRenderItems.push_back(std::move(CylinderRI));
		mAllRenderItems.push_back(std::move(SphereRitem));
		mAllRenderItems.push_back(std::move(GeoSphereRitem));
	}
	
	//skull
	auto skullRI = std::make_unique<RenderItem>();
	skullRI->Geo = mGeometries["shapeGeo"].get();
	skullRI->IndexCount = skullRI->Geo->DrawArgs["skull"].IndexCount;
	skullRI->StartIndexLocation = skullRI->Geo->DrawArgs["skull"].StartIndexLocation;
	skullRI->BaseVertexLocation = skullRI->Geo->DrawArgs["skull"].BaseVertexLocation;
	skullRI->Bounds = skullRI->Geo->DrawArgs["skull"].Bounds;
	skullRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	skullRI->InMirror = true;
	{
		InstanceData instance;
		auto world = XMMatrixScaling(0.2f, 0.2f, 0.2f) * XMMatrixTranslation(0.f, 1.f, 0.f);
		auto invTransposeWorld = MathHelper::InverseTranspose(world);
		XMStoreFloat4x4(&instance.World, world);
		XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
		instance.MaterialIndex = mMaterials["defaultMat"]->MatBufferIndex;
		skullRI->Instances.push_back(instance);
	}
	skullRI->StartInstanceLocation = InstanceBufferIndex;
	InstanceBufferIndex += (UINT)skullRI->Instances.size();
	mSkull = skullRI.get();
	mRenderItemLayer[(int)RenderLayer::Opaque].push_back(skullRI.get());
	mAllRenderItems.push_back(std::move(skullRI));

	//land
	auto landRI = std::make_unique<RenderItem>();
	landRI->Geo = mGeometries["landGeo"].get();
	landRI->IndexCount = landRI->Geo->DrawArgs["grid"].IndexCount;
	landRI->StartIndexLocation = landRI->Geo->DrawArgs["grid"].StartIndexLocation;
	landRI->BaseVertexLocation = landRI->Geo->DrawArgs["grid"].BaseVertexLocation;
	landRI->Bounds = landRI->Geo->DrawArgs["grid"].Bounds;
	landRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_4_CONTROL_POINT_PATCHLIST;
	{
		InstanceData instance;
		auto world = XMMatrixScaling(1, 1, 1) * XMMatrixTranslation(0, -5, 0);
		auto invTransposeWorld = MathHelper::InverseTranspose(world);
		XMStoreFloat4x4(&instance.World, world);
		XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
		XMStoreFloat4x4(&instance.TexTransform, XMMatrixScaling(5.0f, 5.0f, 1.0f));
		instance.MaterialIndex = mMaterials["grass0"]->MatBufferIndex;
		landRI->Instances.push_back(instance);
	}
	landRI->StartInstanceLocation = InstanceBufferIndex;
	InstanceBufferIndex += (UINT)landRI->Instances.size();
	excludeRI_InMirror.push_back(landRI.get());
	mRenderItemLayer[(int)RenderLayer::TessLand].push_back(landRI.get());
	mAllRenderItems.push_back(std::move(landRI));

	//wave
	auto waveRI = std::make_unique<RenderItem>();
	waveRI->Geo = mGeometries["waterGeo"].get();
	waveRI->IndexCount = waveRI->Geo->DrawArgs["grid"].IndexCount;
	waveRI->StartIndexLocation = waveRI->Geo->DrawArgs["grid"].StartIndexLocation;
	waveRI->BaseVertexLocation = waveRI->Geo->DrawArgs["grid"].BaseVertexLocation;
	waveRI->Bounds = waveRI->Geo->DrawArgs["grid"].Bounds;
	waveRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	{
		InstanceData instance;
		auto world = XMMatrixScaling(1, 1, 1) * XMMatrixTranslation(0, -1, 0);
		auto invTransposeWorld = MathHelper::InverseTranspose(world);
		XMStoreFloat4x4(&instance.World, world);
		XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
		XMStoreFloat4x4(&instance.TexTransform, XMMatrixScaling(5.0f, 5.0f, 1.0f));
		instance.MaterialIndex = mMaterials["water0"]->MatBufferIndex;
		instance.DisplacementMapTexelSize = { 1.0f / mWaves->ColumnCount(), 1.0f / mWaves->RowCount() };
		waveRI->Instances.push_back(instance);
	}
	waveRI->StartInstanceLocation = InstanceBufferIndex;
	InstanceBufferIndex += (UINT)waveRI->Instances.size();
	mRenderItemLayer[(int)RenderLayer::Waves].push_back(waveRI.get());
	mWavesRenderItem = waveRI.get();
	mAllRenderItems.push_back(std::move(waveRI));

	//mirror
	{
		auto mirrorRI = std::make_unique<RenderItem>();
		mirrorRI->Geo = mGeometries["shapeGeo"].get();
		mirrorRI->IndexCount = mirrorRI->Geo->DrawArgs["grid"].IndexCount;
		mirrorRI->StartIndexLocation = mirrorRI->Geo->DrawArgs["grid"].StartIndexLocation;
		mirrorRI->BaseVertexLocation = mirrorRI->Geo->DrawArgs["grid"].BaseVertexLocation;
		mirrorRI->Bounds = mirrorRI->Geo->DrawArgs["grid"].Bounds;
		mirrorRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		{
			InstanceData instance;
			auto world = XMMatrixScaling(0.2f, 1.0f, 0.5f) * XMMatrixRotationRollPitchYaw(0, 0, -XM_PIDIV2) * XMMatrixTranslation(-10, 2, 0);
			auto invTransposeWorld = MathHelper::InverseTranspose(world);
			XMStoreFloat4x4(&instance.World, world);
			XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
			XMStoreFloat4x4(&instance.TexTransform, XMMatrixScaling(1.0f, 2.0f, 1.0f)* XMMatrixRotationZ(XM_PIDIV2));
			instance.MaterialIndex = mMaterials["iceMirrorMat"]->MatBufferIndex;
			mirrorRI->Instances.push_back(instance);
		}
		mirrorRI->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)mirrorRI->Instances.size();
		mMirror = mirrorRI.get();
		excludeRI_InMirror.push_back(mirrorRI.get());
		mRenderItemLayer[(int)RenderLayer::MirrorStencil].push_back(mirrorRI.get());
		mRenderItemLayer[(int)RenderLayer::Transparent].push_back(mirrorRI.get());
		mAllRenderItems.push_back(std::move(mirrorRI));

		auto mirrorWallTessRI = std::make_unique<RenderItem>();
		mirrorWallTessRI->Geo = mGeometries["brickWallGeo"].get();
		mirrorWallTessRI->IndexCount = mirrorWallTessRI->Geo->DrawArgs["brickWall"].IndexCount;
		mirrorWallTessRI->StartIndexLocation = mirrorWallTessRI->Geo->DrawArgs["brickWall"].StartIndexLocation;
		mirrorWallTessRI->BaseVertexLocation = mirrorWallTessRI->Geo->DrawArgs["brickWall"].BaseVertexLocation;
		mirrorWallTessRI->Bounds = mirrorWallTessRI->Geo->DrawArgs["brickWall"].Bounds;
		mirrorWallTessRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_4_CONTROL_POINT_PATCHLIST;
		{
			InstanceData instance;
			auto world = XMMatrixScaling(0.3f, 1.0f, 1.0f) * XMMatrixRotationRollPitchYaw(0, 0, -XM_PIDIV2) * XMMatrixTranslation(-10.001f, 3.0f, 0.0f);
			auto invTransposeWorld = MathHelper::InverseTranspose(world);
			XMStoreFloat4x4(&instance.World, world);
			XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
			XMStoreFloat4x4(&instance.TexTransform, XMMatrixScaling(2.5f, 11.0f, 1.0f)* XMMatrixRotationZ(XM_PIDIV2));
			instance.MaterialIndex = mMaterials["bricks1"]->MatBufferIndex;
			mirrorWallTessRI->Instances.push_back(instance);
		}
		mirrorWallTessRI->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)mirrorWallTessRI->Instances.size();
		excludeRI_InMirror.push_back(mirrorWallTessRI.get());
		mRenderItemLayer[(int)RenderLayer::TessWall].push_back(mirrorWallTessRI.get());
		mAllRenderItems.push_back(std::move(mirrorWallTessRI));

		//거울 백플레이트
		auto mirrorBackRI = std::make_unique<RenderItem>();
		mirrorBackRI->Geo = mGeometries["shapeGeo"].get();
		mirrorBackRI->IndexCount = mirrorBackRI->Geo->DrawArgs["grid"].IndexCount;
		mirrorBackRI->StartIndexLocation = mirrorBackRI->Geo->DrawArgs["grid"].StartIndexLocation;
		mirrorBackRI->BaseVertexLocation = mirrorBackRI->Geo->DrawArgs["grid"].BaseVertexLocation;
		mirrorBackRI->Bounds = mirrorBackRI->Geo->DrawArgs["grid"].Bounds;
		mirrorBackRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		{
			InstanceData instance;
			auto world = XMMatrixScaling(0.2f, 1.0f, 0.5f) * XMMatrixRotationRollPitchYaw(0, 0, -XM_PIDIV2) * XMMatrixTranslation(-10, 2, 0);
			auto invTransposeWorld = MathHelper::InverseTranspose(world);
			XMStoreFloat4x4(&instance.World, world);
			XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
			instance.MaterialIndex = mMaterials["mirrorBaseMat"]->MatBufferIndex;
			mirrorBackRI->Instances.push_back(instance);
		}
		mirrorBackRI->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)mirrorBackRI->Instances.size();
		excludeRI_InMirror.push_back(mirrorBackRI.get());
		mRenderItemLayer[(int)RenderLayer::MirrorBaseFill].push_back(mirrorBackRI.get());
		mAllRenderItems.push_back(std::move(mirrorBackRI));
	}

	//skull shadow
	auto skullShadowRI = std::make_unique<RenderItem>();
	*skullShadowRI = *mSkull;
	skullShadowRI->Instances.clear();
	{
		InstanceData instance;
		auto world = XMMatrixTranslation(3.0f, 3.0f, 0.0f);
		auto invTransposeWorld = MathHelper::InverseTranspose(world);
		XMStoreFloat4x4(&instance.World, world);
		XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
		instance.MaterialIndex = mMaterials["shadowMat_skull"]->MatBufferIndex;
		skullShadowRI->Instances.push_back(instance);
	}
	skullShadowRI->StartInstanceLocation = InstanceBufferIndex;
	InstanceBufferIndex += (UINT)skullShadowRI->Instances.size();
	mSkullShadow = skullShadowRI.get();
	mRenderItemLayer[(int)RenderLayer::Shadow].push_back(skullShadowRI.get());
	mAllRenderItems.push_back(std::move(skullShadowRI));

	//tree billboard
	auto treeBillboardRI = std::make_unique<RenderItem>();
	treeBillboardRI->Geo = mGeometries["treeBillboard"].get();
	treeBillboardRI->IndexCount = treeBillboardRI->Geo->DrawArgs["tree"].IndexCount;
	treeBillboardRI->StartIndexLocation = treeBillboardRI->Geo->DrawArgs["tree"].StartIndexLocation;
	treeBillboardRI->BaseVertexLocation = treeBillboardRI->Geo->DrawArgs["tree"].BaseVertexLocation;
	treeBillboardRI->Bounds = treeBillboardRI->Geo->DrawArgs["tree"].Bounds;
	treeBillboardRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_POINTLIST;
	{
		InstanceData instance;
		instance.MaterialIndex = mMaterials["treeBillboardMat"]->MatBufferIndex;
		treeBillboardRI->Instances.push_back(instance);
	}
	treeBillboardRI->StartInstanceLocation = InstanceBufferIndex;
	InstanceBufferIndex += (UINT)treeBillboardRI->Instances.size();
	mRenderItemLayer[(int)RenderLayer::A2C_TreeBillboard].push_back(treeBillboardRI.get());
	mAllRenderItems.push_back(std::move(treeBillboardRI));

	//extended Cylinder
	auto cylRI = std::make_unique<RenderItem>();
	cylRI->Geo = mGeometries["cylinderWithoutTop"].get();
	cylRI->IndexCount = cylRI->Geo->DrawArgs["cylinderWithoutTop"].IndexCount;
	cylRI->StartIndexLocation = cylRI->Geo->DrawArgs["cylinderWithoutTop"].StartIndexLocation;
	cylRI->BaseVertexLocation = cylRI->Geo->DrawArgs["cylinderWithoutTop"].BaseVertexLocation;
	cylRI->Bounds = cylRI->Geo->DrawArgs["cylinderWithoutTop"].Bounds;
	cylRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_LINESTRIP;
	{
		InstanceData instance;
		auto world = XMMatrixScaling(1.f, 1.f, 1.f) * XMMatrixTranslation(0.f, 0.f, 13.f);
		auto invTransposeWorld = MathHelper::InverseTranspose(world);
		XMStoreFloat4x4(&instance.World, world);
		XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
		instance.MaterialIndex = mMaterials["bricks0"]->MatBufferIndex;
		cylRI->Instances.push_back(instance);
	}
	cylRI->StartInstanceLocation = InstanceBufferIndex;
	InstanceBufferIndex += (UINT)cylRI->Instances.size();
	mRenderItemLayer[(int)RenderLayer::LineToCylinder].push_back(cylRI.get());
	mAllRenderItems.push_back(std::move(cylRI));

	//explode
	auto explodeRI = std::make_unique<RenderItem>();
	explodeRI->Geo = mGeometries["shapeGeo"].get();
	explodeRI->IndexCount = explodeRI->Geo->DrawArgs["geoSphere"].IndexCount;
	explodeRI->StartIndexLocation = explodeRI->Geo->DrawArgs["geoSphere"].StartIndexLocation;
	explodeRI->BaseVertexLocation = explodeRI->Geo->DrawArgs["geoSphere"].BaseVertexLocation;
	explodeRI->Bounds = explodeRI->Geo->DrawArgs["geoSphere"].Bounds;
	explodeRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	{
		InstanceData instance;
		auto world = XMMatrixScaling(1.f, 1.f, 1.f) * XMMatrixTranslation(0.f, 6.0f, 0.0f);
		auto invTransposeWorld = MathHelper::InverseTranspose(world);
		XMStoreFloat4x4(&instance.World, world);
		XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
		instance.MaterialIndex = mMaterials["bricks0"]->MatBufferIndex;
		explodeRI->Instances.push_back(instance);
	}
	explodeRI->StartInstanceLocation = InstanceBufferIndex;
	InstanceBufferIndex += (UINT)explodeRI->Instances.size();
	mRenderItemLayer[(int)RenderLayer::GeoExplode].push_back(explodeRI.get());
	mAllRenderItems.push_back(std::move(explodeRI));
}

void RenderApp::BuildRenderItems_InMirror(UINT& InstanceBufferIndex)
{
	XMVECTOR mirrorPlane = GetMirrorPlane(); // x = -10 plane
	XMMATRIX R = XMMatrixReflect(mirrorPlane);

	std::vector<std::unique_ptr<RenderItem>> renderItems;
	//for (auto& ri : mRenderItemLayer[(int)RenderLayer::Opaque])
	for (auto& ri : mAllRenderItems)
	{
		if (ri->InMirror == false) continue;

		bool flag = false;
		for (auto ex : excludeRI_InMirror)
		{
			if (ex == ri.get())
			{
				flag = true;
				break;
			}
		}
		if (flag) continue;
		
		auto reflectedRI = std::make_unique<RenderItem>();
		*reflectedRI = *ri;	// 값 복사
		for (auto& instance : reflectedRI->Instances)
		{
			auto world = XMLoadFloat4x4(&instance.World) * R;
			auto invTransposeWorld = MathHelper::InverseTranspose(world);
			XMStoreFloat4x4(&instance.World, world);
			XMStoreFloat4x4(&instance.WorldInvTranspose, invTransposeWorld);
		}
		reflectedRI->StartInstanceLocation = InstanceBufferIndex;
		InstanceBufferIndex += (UINT)reflectedRI->Instances.size();

		if (ri.get() == mSkullShadow) mSkullShadowMirror = reflectedRI.get();
		if (ri.get() == mSkull) mSkullMirror = reflectedRI.get();

		mRenderItemLayer[(int)RenderLayer::Reflected].push_back(reflectedRI.get());
		renderItems.push_back(std::move(reflectedRI));
	}

	mAllRenderItems.insert(
		mAllRenderItems.end(),
		std::make_move_iterator(renderItems.begin()),
		std::make_move_iterator(renderItems.end()));
}

void RenderApp::BuildRenderItems_Selected(UINT& InstanceBufferIndex)
{
	//미완성된 객체. 클릭시 완성
	auto selectedRI = std::make_unique<RenderItem>();
	selectedRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	selectedRI->StartInstanceLocation = InstanceBufferIndex;
	selectedRI->Visible = false;
	InstanceBufferIndex += (UINT)selectedRI->Instances.size();
	mRenderItemLayer[(int)RenderLayer::Highlight].push_back(selectedRI.get());
	mAllRenderItems.push_back(std::move(selectedRI));
}

void RenderApp::BuildFrameResources()
{
	for (int i = 0; i < gNumFrameResources; i++)
	{
		mFrameResources.push_back(
			std::make_unique<FrameResource>(
				md3dDevice.Get(),
				2,
				mInstanceCount,
				(UINT)mWaves->VertexCount(),
				(UINT)mMaterials.size()));
	}
}
