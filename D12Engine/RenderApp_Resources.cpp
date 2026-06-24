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
	bricksTex1->Filename = L"Resource/Textures/bricks3.dds";

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
		0 ~ N-1		: 기존 텍스처
		N			: ImGui Font
		N+1 ~	M	: ImGui용 추가 슬롯(optional)
		M ~		M+6	: mWaves의 DiscriptorCount개수 6개.
	*/
	D3D12_DESCRIPTOR_HEAP_DESC srvHeapDesc = {};
	const UINT textureCount = (UINT)mTextures.size();
	const UINT imguiReservedCount = 1; //폰트만
	srvHeapDesc.NumDescriptors = textureCount + imguiReservedCount + mWaves->DescriptorCount();
	srvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
	srvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
	ThrowIfFailed(md3dDevice->CreateDescriptorHeap(&srvHeapDesc, IID_PPV_ARGS(mSrvHeap.GetAddressOf())));

	CD3DX12_CPU_DESCRIPTOR_HANDLE hDescriptor(mSrvHeap->GetCPUDescriptorHandleForHeapStart());

	int i = 0;
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

	const UINT wavesBaseIndex = textureCount + imguiReservedCount;

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
}

void RenderApp::BuildMaterials()
{
	UINT index = 0;

	auto skullMat = std::make_unique<Material>();
	skullMat->Name = "skullMat";
	skullMat->MatCBIndex = index++;
	skullMat->DiffuseSrvHeapIndex = mTextures["defaultTex"]->SrvHeapIndex; //텍스처 없음.
	skullMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	skullMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	skullMat->Roughness = 0.3f;

	auto tileMat = std::make_unique<Material>();
	tileMat->Name = "tile0";
	tileMat->MatCBIndex = index++;
	tileMat->DiffuseSrvHeapIndex = mTextures["tileTex"]->SrvHeapIndex;
	tileMat->DiffuseAlbedo = XMFLOAT4(Colors::LightGray);
	tileMat->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	tileMat->Roughness = 0.2f;

	auto bricksMat0 = std::make_unique<Material>();
	bricksMat0->Name = "bricks0";
	bricksMat0->MatCBIndex = index++;
	bricksMat0->DiffuseSrvHeapIndex = mTextures["bricksTex0"]->SrvHeapIndex;
	bricksMat0->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	bricksMat0->FresnelR0 = XMFLOAT3(0.02f, 0.02f, 0.02f);
	bricksMat0->Roughness = 0.1f;

	auto stoneMat = std::make_unique<Material>();
	stoneMat->Name = "stone0";
	stoneMat->MatCBIndex = index++;
	stoneMat->DiffuseSrvHeapIndex = mTextures["stoneTex"]->SrvHeapIndex;
	stoneMat->DiffuseAlbedo = XMFLOAT4(Colors::LightSteelBlue);
	stoneMat->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	stoneMat->Roughness = 0.3f;

	auto grassMat = std::make_unique<Material>();
	grassMat->Name = "grass0";
	grassMat->MatCBIndex = index++;
	grassMat->DiffuseSrvHeapIndex = mTextures["grassTex"]->SrvHeapIndex;
	grassMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	grassMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	grassMat->Roughness = 0.125f;

	auto waterMat = std::make_unique<Material>();
	waterMat->Name = "water0";
	waterMat->MatCBIndex = index++;
	waterMat->DiffuseSrvHeapIndex = mTextures["waterTex"]->SrvHeapIndex;
	waterMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.5f);
	waterMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	waterMat->Roughness = 0.0f;

	auto woodCrateMat = std::make_unique<Material>();
	woodCrateMat->Name = "woodCrate";
	woodCrateMat->MatCBIndex = index++;
	woodCrateMat->DiffuseSrvHeapIndex = mTextures["woodCrateTex"]->SrvHeapIndex;
	woodCrateMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	woodCrateMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	woodCrateMat->Roughness = 0.0f;

	auto swirlingMat = std::make_unique<Material>();
	swirlingMat->Name = "swirling";
	swirlingMat->MatCBIndex = index++;
	swirlingMat->DiffuseSrvHeapIndex = mTextures["swirlingTex"]->SrvHeapIndex;
	swirlingMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMat->Roughness = 0.0f;

	auto swirlingMaskMat = std::make_unique<Material>();
	swirlingMaskMat->Name = "swirlingMask";
	swirlingMaskMat->MatCBIndex = index++;
	swirlingMaskMat->DiffuseSrvHeapIndex = mTextures["swirlingMaskTex"]->SrvHeapIndex;
	swirlingMaskMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	swirlingMaskMat->FresnelR0 = XMFLOAT3(0.2f, 0.2f, 0.2f);
	swirlingMaskMat->Roughness = 0.0f;

	auto wireFence = std::make_unique<Material>();
	wireFence->Name = "wireFence";
	wireFence->MatCBIndex = index++;
	wireFence->DiffuseSrvHeapIndex = mTextures["fenceTex"]->SrvHeapIndex;
	wireFence->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	wireFence->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	wireFence->Roughness = 0.25f;

	auto bricksMat1 = std::make_unique<Material>();
	bricksMat1->Name = "bricks1";
	bricksMat1->MatCBIndex = index++;
	bricksMat1->DiffuseSrvHeapIndex = mTextures["bricksTex1"]->SrvHeapIndex;
	bricksMat1->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	bricksMat1->FresnelR0 = XMFLOAT3(0.05f, 0.05f, 0.05f);
	bricksMat1->Roughness = 0.25f;

	auto checkerTileMat = std::make_unique<Material>();
	checkerTileMat->Name = "checkerTileMat";
	checkerTileMat->MatCBIndex = index++;
	checkerTileMat->DiffuseSrvHeapIndex = mTextures["checkboardTex"]->SrvHeapIndex;
	checkerTileMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	checkerTileMat->FresnelR0 = XMFLOAT3(0.07f, 0.07f, 0.07f);
	checkerTileMat->Roughness = 0.3f;

	auto iceMirrorMat = std::make_unique<Material>();
	iceMirrorMat->Name = "iceMirrorMat";
	iceMirrorMat->MatCBIndex = index++;
	iceMirrorMat->DiffuseSrvHeapIndex = mTextures["iceTex"]->SrvHeapIndex;
	iceMirrorMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 0.3f);
	iceMirrorMat->FresnelR0 = XMFLOAT3(0.1f, 0.1f, 0.1f);
	iceMirrorMat->Roughness = 0.5f;

	auto shadowMat_skull = std::make_unique<Material>();
	shadowMat_skull->Name = "shadowMat_skull";
	shadowMat_skull->MatCBIndex = index++;
	shadowMat_skull->DiffuseSrvHeapIndex = mTextures["defaultTex"]->SrvHeapIndex;
	shadowMat_skull->DiffuseAlbedo = XMFLOAT4(0.0f, 0.0f, 0.0f, 0.5f);
	shadowMat_skull->FresnelR0 = XMFLOAT3(0.001f, 0.001f, 0.001f);
	shadowMat_skull->Roughness = 0.0f;

	auto treeBillboardMat = std::make_unique<Material>();
	treeBillboardMat->Name = "treeBillboardMat";
	treeBillboardMat->MatCBIndex = index++;
	treeBillboardMat->DiffuseSrvHeapIndex = mTextures["treeArrayTex"]->SrvHeapIndex;
	treeBillboardMat->DiffuseAlbedo = XMFLOAT4(1.0f, 1.0f, 1.0f, 1.0f);
	treeBillboardMat->FresnelR0 = XMFLOAT3(0.01f, 0.01f, 0.01f);
	treeBillboardMat->Roughness = 0.125f;

	auto mirrorBaseMat = std::make_unique<Material>();
	mirrorBaseMat->Name = "mirrorBaseMat";
	mirrorBaseMat->MatCBIndex = index++;
	mirrorBaseMat->DiffuseSrvHeapIndex = mTextures["defaultTex"]->SrvHeapIndex;
	mirrorBaseMat->DiffuseAlbedo = mMainPassCB.gFogColor;
	mirrorBaseMat->FresnelR0 = XMFLOAT3(0.0f, 0.0f, 0.0f);
	mirrorBaseMat->Roughness = 1.0f;

	mMaterials[skullMat->Name] = std::move(skullMat);
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
}

void RenderApp::BuildRenderItems()
{
	UINT objCBIndex = 0;
	{
		auto boxRI = std::make_unique<RenderItem>();
		XMStoreFloat4x4(&boxRI->World, XMMatrixScaling(2.f, 2.f / 3.f, 2.f) * XMMatrixTranslation(0.f, 0.5f, -5.f));
		boxRI->ObjCBIndex = objCBIndex++;
		boxRI->Geo = mGeometries["shapeGeo"].get();
		boxRI->Mat = mMaterials["woodCrate"].get();
		boxRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		boxRI->IndexCount = boxRI->Geo->DrawArgs["box"].IndexCount;
		boxRI->StartIndexLocation = boxRI->Geo->DrawArgs["box"].StartIndexLocation;
		boxRI->BaseVertexLocation = boxRI->Geo->DrawArgs["box"].BaseVertexLocation;
		boxRI->VertexCount = boxRI->Geo->DrawArgs["box"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(boxRI.get());
		mAllRenderItems.push_back(std::move(boxRI));

		auto blendBoxRI = std::make_unique<RenderItem>();
		XMStoreFloat4x4(&blendBoxRI->World, XMMatrixScaling(2.f, 2.f, 2.f) * XMMatrixTranslation(0.f, 2.f, 8.f));
		blendBoxRI->ObjCBIndex = objCBIndex++;
		blendBoxRI->Geo = mGeometries["shapeGeo"].get();
		blendBoxRI->Mat = mMaterials["swirling"].get();
		blendBoxRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		blendBoxRI->IndexCount = blendBoxRI->Geo->DrawArgs["box"].IndexCount;
		blendBoxRI->StartIndexLocation = blendBoxRI->Geo->DrawArgs["box"].StartIndexLocation;
		blendBoxRI->BaseVertexLocation = blendBoxRI->Geo->DrawArgs["box"].BaseVertexLocation;
		blendBoxRI->VertexCount = blendBoxRI->Geo->DrawArgs["box"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::MultiTextureBlend].push_back(blendBoxRI.get());
		mAllRenderItems.push_back(std::move(blendBoxRI));

		auto netBoxRI = std::make_unique<RenderItem>();
		XMStoreFloat4x4(&netBoxRI->World, XMMatrixScaling(1.f, 1.f, 1.f) * XMMatrixTranslation(0.f, 1.f, -10.f));
		netBoxRI->ObjCBIndex = objCBIndex++;
		netBoxRI->Geo = mGeometries["shapeGeo"].get();
		netBoxRI->Mat = mMaterials["wireFence"].get();
		netBoxRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		netBoxRI->IndexCount = netBoxRI->Geo->DrawArgs["box"].IndexCount;
		netBoxRI->StartIndexLocation = netBoxRI->Geo->DrawArgs["box"].StartIndexLocation;
		netBoxRI->BaseVertexLocation = netBoxRI->Geo->DrawArgs["box"].BaseVertexLocation;
		netBoxRI->VertexCount = netBoxRI->Geo->DrawArgs["box"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::AlphaTestOpaque].push_back(netBoxRI.get());
		mAllRenderItems.push_back(std::move(netBoxRI));

		auto gridRI = std::make_unique<RenderItem>();
		gridRI->World = MathHelper::Identity4x4();
		XMStoreFloat4x4(&gridRI->TexTransform, XMMatrixScaling(8.0f, 8.0f, 1.0f));
		gridRI->ObjCBIndex = objCBIndex++;
		gridRI->Geo = mGeometries["shapeGeo"].get();
		gridRI->Mat = mMaterials["tile0"].get();
		gridRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		gridRI->IndexCount = gridRI->Geo->DrawArgs["grid"].IndexCount;
		gridRI->StartIndexLocation = gridRI->Geo->DrawArgs["grid"].StartIndexLocation;
		gridRI->BaseVertexLocation = gridRI->Geo->DrawArgs["grid"].BaseVertexLocation;
		gridRI->VertexCount = gridRI->Geo->DrawArgs["grid"].VertexCount;
		mRenderItemLayer[(int)RenderLayer::Opaque].push_back(gridRI.get());
		mAllRenderItems.push_back(std::move(gridRI));

		for (int i = 0; i < 5; ++i)
		{
			auto leftCylRitem = std::make_unique<RenderItem>();
			auto rightCylRitem = std::make_unique<RenderItem>();
			auto leftSphereRitem = std::make_unique<RenderItem>();
			auto rightGeoSphereRitem = std::make_unique<RenderItem>();

			XMMATRIX leftCylWorld = XMMatrixTranslation(-5.0f, 1.5f, -10.0f + i * 5.0f);
			XMMATRIX rightCylWorld = XMMatrixTranslation(+5.0f, 1.5f, -10.0f + i * 5.0f);

			XMMATRIX leftSphereWorld = XMMatrixTranslation(-5.0f, 3.5f, -10.0f + i * 5.0f);
			XMMATRIX rightSphereWorld = XMMatrixScaling(2.0f, 2.0f, 2.0f) * XMMatrixTranslation(+5.0f, 3.5f, -10.0f + i * 5.0f);

			XMStoreFloat4x4(&leftCylRitem->World, leftCylWorld);
			leftCylRitem->ObjCBIndex = objCBIndex++;
			leftCylRitem->Geo = mGeometries["shapeGeo"].get();
			leftCylRitem->Mat = mMaterials["bricks0"].get();
			leftCylRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
			leftCylRitem->IndexCount = leftCylRitem->Geo->DrawArgs["cylinder"].IndexCount;
			leftCylRitem->StartIndexLocation = leftCylRitem->Geo->DrawArgs["cylinder"].StartIndexLocation;
			leftCylRitem->BaseVertexLocation = leftCylRitem->Geo->DrawArgs["cylinder"].BaseVertexLocation;
			leftCylRitem->VertexCount = leftCylRitem->Geo->DrawArgs["cylinder"].VertexCount;
			mRenderItemLayer[(int)RenderLayer::Opaque].push_back(leftCylRitem.get());

			XMStoreFloat4x4(&rightCylRitem->World, rightCylWorld);
			rightCylRitem->ObjCBIndex = objCBIndex++;
			rightCylRitem->Geo = mGeometries["shapeGeo"].get();
			rightCylRitem->Mat = mMaterials["bricks0"].get();
			rightCylRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
			rightCylRitem->IndexCount = rightCylRitem->Geo->DrawArgs["cylinder"].IndexCount;
			rightCylRitem->StartIndexLocation = rightCylRitem->Geo->DrawArgs["cylinder"].StartIndexLocation;
			rightCylRitem->BaseVertexLocation = rightCylRitem->Geo->DrawArgs["cylinder"].BaseVertexLocation;
			rightCylRitem->VertexCount = rightCylRitem->Geo->DrawArgs["cylinder"].VertexCount;
			mRenderItemLayer[(int)RenderLayer::Opaque].push_back(rightCylRitem.get());

			XMStoreFloat4x4(&leftSphereRitem->World, leftSphereWorld);
			leftSphereRitem->ObjCBIndex = objCBIndex++;
			leftSphereRitem->Geo = mGeometries["shapeGeo"].get();
			leftSphereRitem->Mat = mMaterials["stone0"].get();
			leftSphereRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
			leftSphereRitem->IndexCount = leftSphereRitem->Geo->DrawArgs["sphere"].IndexCount;
			leftSphereRitem->StartIndexLocation = leftSphereRitem->Geo->DrawArgs["sphere"].StartIndexLocation;
			leftSphereRitem->BaseVertexLocation = leftSphereRitem->Geo->DrawArgs["sphere"].BaseVertexLocation;
			leftSphereRitem->VertexCount = leftSphereRitem->Geo->DrawArgs["sphere"].VertexCount;
			mRenderItemLayer[(int)RenderLayer::Opaque].push_back(leftSphereRitem.get());

			XMStoreFloat4x4(&rightGeoSphereRitem->World, rightSphereWorld);
			rightGeoSphereRitem->ObjCBIndex = objCBIndex++;
			rightGeoSphereRitem->Geo = mGeometries["shapeGeo"].get();
			rightGeoSphereRitem->Mat = mMaterials["stone0"].get();
			rightGeoSphereRitem->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
			rightGeoSphereRitem->IndexCount = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].IndexCount;
			rightGeoSphereRitem->StartIndexLocation = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].StartIndexLocation;
			rightGeoSphereRitem->BaseVertexLocation = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].BaseVertexLocation;
			rightGeoSphereRitem->VertexCount = rightGeoSphereRitem->Geo->DrawArgs["geoSphere"].VertexCount;
			mRenderItemLayer[(int)RenderLayer::GeoSphereLOD].push_back(rightGeoSphereRitem.get());

			mAllRenderItems.push_back(std::move(leftCylRitem));
			mAllRenderItems.push_back(std::move(rightCylRitem));
			mAllRenderItems.push_back(std::move(leftSphereRitem));
			mAllRenderItems.push_back(std::move(rightGeoSphereRitem));
		}
	}

	//skull
	auto skullRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&skullRI->World, XMMatrixScaling(0.2f, 0.2f, 0.2f) * XMMatrixTranslation(0.f, 1.f, 0.f));
	skullRI->ObjCBIndex = objCBIndex++;
	skullRI->Geo = mGeometries["shapeGeo"].get();
	skullRI->Mat = mMaterials["skullMat"].get();
	skullRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	skullRI->IndexCount = skullRI->Geo->DrawArgs["skull"].IndexCount;
	skullRI->StartIndexLocation = skullRI->Geo->DrawArgs["skull"].StartIndexLocation;
	skullRI->BaseVertexLocation = skullRI->Geo->DrawArgs["skull"].BaseVertexLocation;
	skullRI->VertexCount = skullRI->Geo->DrawArgs["skull"].VertexCount;
	mSkull = skullRI.get();
	mRenderItemLayer[(int)RenderLayer::Opaque].push_back(skullRI.get());
	mAllRenderItems.push_back(std::move(skullRI));

	//land
	auto landRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&landRI->World, XMMatrixScaling(1, 1, 1) * XMMatrixTranslation(0, -5, 0));
	XMStoreFloat4x4(&landRI->TexTransform, XMMatrixScaling(5.0f, 5.0f, 1.0f));
	landRI->ObjCBIndex = objCBIndex++;
	landRI->Geo = mGeometries["landGeo"].get();
	landRI->Mat = mMaterials["grass0"].get();
	landRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	landRI->IndexCount = landRI->Geo->DrawArgs["grid"].IndexCount;
	landRI->StartIndexLocation = landRI->Geo->DrawArgs["grid"].StartIndexLocation;
	landRI->BaseVertexLocation = landRI->Geo->DrawArgs["grid"].BaseVertexLocation;
	landRI->VertexCount = landRI->Geo->DrawArgs["grid"].VertexCount;
	excludeRI_InMirror.push_back(landRI.get());
	mRenderItemLayer[(int)RenderLayer::Opaque].push_back(landRI.get());
	mAllRenderItems.push_back(std::move(landRI));

	//wave
	auto waveRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&waveRI->World, XMMatrixScaling(1, 1, 1) * XMMatrixTranslation(0, -1, 0));
	XMStoreFloat4x4(&waveRI->TexTransform, XMMatrixScaling(5.0f, 5.0f, 1.0f));
	waveRI->DisplacementMapTexelSize = { 1.0f / mWaves->ColumnCount(), 1.0f / mWaves->RowCount() };
	waveRI->ObjCBIndex = objCBIndex++;
	waveRI->Geo = mGeometries["waterGeo"].get();
	waveRI->Mat = mMaterials["water0"].get();
	waveRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	waveRI->IndexCount = waveRI->Geo->DrawArgs["grid"].IndexCount;
	waveRI->StartIndexLocation = waveRI->Geo->DrawArgs["grid"].StartIndexLocation;
	waveRI->BaseVertexLocation = waveRI->Geo->DrawArgs["grid"].BaseVertexLocation;
	waveRI->VertexCount = waveRI->Geo->DrawArgs["grid"].VertexCount;
	mRenderItemLayer[(int)RenderLayer::Waves].push_back(waveRI.get());
	mWavesRenderItem = waveRI.get();
	mAllRenderItems.push_back(std::move(waveRI));

	//mirror
	{
		auto mirrorRI = std::make_unique<RenderItem>();
		XMMATRIX mirrorM1 = XMMatrixScaling(0.2f, 1.0f, 0.5f) * XMMatrixRotationRollPitchYaw(0, 0, -XM_PIDIV2) * XMMatrixTranslation(-10, 2, 0);
		XMStoreFloat4x4(&mirrorRI->World, mirrorM1);
		XMMATRIX mirrorM2 = XMMatrixScaling(1.0f, 2.0f, 1.0f) * XMMatrixRotationZ(XM_PIDIV2);
		XMStoreFloat4x4(&mirrorRI->TexTransform, mirrorM2);
		mirrorRI->ObjCBIndex = objCBIndex++;
		mirrorRI->Geo = mGeometries["shapeGeo"].get();
		mirrorRI->Mat = mMaterials["iceMirrorMat"].get();
		mirrorRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		mirrorRI->IndexCount = mirrorRI->Geo->DrawArgs["grid"].IndexCount;
		mirrorRI->StartIndexLocation = mirrorRI->Geo->DrawArgs["grid"].StartIndexLocation;
		mirrorRI->BaseVertexLocation = mirrorRI->Geo->DrawArgs["grid"].BaseVertexLocation;
		mirrorRI->VertexCount = mirrorRI->Geo->DrawArgs["grid"].VertexCount;
		mMirror = mirrorRI.get();
		excludeRI_InMirror.push_back(mirrorRI.get());
		mRenderItemLayer[(int)RenderLayer::MirrorStencil].push_back(mirrorRI.get());
		mRenderItemLayer[(int)RenderLayer::Transparent].push_back(mirrorRI.get());
		mAllRenderItems.push_back(std::move(mirrorRI));

		auto mirrorWallRI = std::make_unique<RenderItem>();
		XMMATRIX m1 = XMMatrixScaling(0.3f, 1.0f, 1.0f) * XMMatrixRotationRollPitchYaw(0, 0, -XM_PIDIV2) * XMMatrixTranslation(-10.001f, 3.0f, 0.0f);
		XMStoreFloat4x4(&mirrorWallRI->World, m1);
		XMMATRIX m2 = XMMatrixScaling(2.5f, 11.0f, 1.0f) * XMMatrixRotationZ(XM_PIDIV2);
		XMStoreFloat4x4(&mirrorWallRI->TexTransform, m2);
		mirrorWallRI->ObjCBIndex = objCBIndex++;
		mirrorWallRI->Geo = mGeometries["shapeGeo"].get();
		mirrorWallRI->Mat = mMaterials["bricks1"].get();
		mirrorWallRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		mirrorWallRI->IndexCount = mirrorWallRI->Geo->DrawArgs["grid"].IndexCount;
		mirrorWallRI->StartIndexLocation = mirrorWallRI->Geo->DrawArgs["grid"].StartIndexLocation;
		mirrorWallRI->BaseVertexLocation = mirrorWallRI->Geo->DrawArgs["grid"].BaseVertexLocation;
		mirrorWallRI->VertexCount = mirrorWallRI->Geo->DrawArgs["grid"].VertexCount;
		excludeRI_InMirror.push_back(mirrorWallRI.get());
		mRenderItemLayer[(int)RenderLayer::MirrorWall].push_back(mirrorWallRI.get());
		mAllRenderItems.push_back(std::move(mirrorWallRI));

		//거울 백플레이트
		auto mirrorBackRI = std::make_unique<RenderItem>();
		mirrorBackRI->World = mMirror->World;
		mirrorBackRI->ObjCBIndex = objCBIndex++;
		mirrorBackRI->Geo = mGeometries["shapeGeo"].get();
		mirrorBackRI->Mat = mMaterials["mirrorBaseMat"].get();
		mirrorBackRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
		mirrorBackRI->IndexCount = mirrorBackRI->Geo->DrawArgs["grid"].IndexCount;
		mirrorBackRI->StartIndexLocation = mirrorBackRI->Geo->DrawArgs["grid"].StartIndexLocation;
		mirrorBackRI->BaseVertexLocation = mirrorBackRI->Geo->DrawArgs["grid"].BaseVertexLocation;
		mirrorBackRI->VertexCount = mirrorBackRI->Geo->DrawArgs["grid"].VertexCount;
		excludeRI_InMirror.push_back(mirrorBackRI.get());
		mRenderItemLayer[(int)RenderLayer::MirrorBaseFill].push_back(mirrorBackRI.get());
		mAllRenderItems.push_back(std::move(mirrorBackRI));
	}

	//skull shadow
	auto skullShadowRI = std::make_unique<RenderItem>();
	*skullShadowRI = *mSkull;
	XMMATRIX m1 = XMMatrixTranslation(3.0f, 3.0f, 0.0f);
	XMStoreFloat4x4(&skullShadowRI->World, m1);
	skullShadowRI->ObjCBIndex = objCBIndex++;
	skullShadowRI->Mat = mMaterials["shadowMat_skull"].get();
	mSkullShadow = skullShadowRI.get();
	mRenderItemLayer[(int)RenderLayer::Shadow].push_back(skullShadowRI.get());
	mAllRenderItems.push_back(std::move(skullShadowRI));

	BuildRenderItems_InMirror(objCBIndex);

	//tree billboard
	auto treeBillboardRI = std::make_unique<RenderItem>();
	treeBillboardRI->World = MathHelper::Identity4x4();
	treeBillboardRI->ObjCBIndex = objCBIndex++;
	treeBillboardRI->Mat = mMaterials["treeBillboardMat"].get();
	treeBillboardRI->Geo = mGeometries["treeBillboard"].get();
	treeBillboardRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_POINTLIST;
	treeBillboardRI->IndexCount = treeBillboardRI->Geo->DrawArgs["tree"].IndexCount;
	treeBillboardRI->StartIndexLocation = treeBillboardRI->Geo->DrawArgs["tree"].StartIndexLocation;
	treeBillboardRI->BaseVertexLocation = treeBillboardRI->Geo->DrawArgs["tree"].BaseVertexLocation;
	treeBillboardRI->VertexCount = treeBillboardRI->Geo->DrawArgs["tree"].VertexCount;
	mRenderItemLayer[(int)RenderLayer::A2C_TreeBillboard].push_back(treeBillboardRI.get());
	mAllRenderItems.push_back(std::move(treeBillboardRI));

	//extended Cylinder
	auto cylRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&cylRI->World, XMMatrixScaling(1.f, 1.f, 1.f)* XMMatrixTranslation(0.f, 0.f, 13.f));
	cylRI->ObjCBIndex = objCBIndex++;
	cylRI->Mat = mMaterials["bricks0"].get();
	cylRI->Geo = mGeometries["cylinderWithoutTop"].get();
	cylRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_LINESTRIP;
	cylRI->IndexCount = cylRI->Geo->DrawArgs["cylinderWithoutTop"].IndexCount;
	cylRI->StartIndexLocation = cylRI->Geo->DrawArgs["cylinderWithoutTop"].StartIndexLocation;
	cylRI->BaseVertexLocation = cylRI->Geo->DrawArgs["cylinderWithoutTop"].BaseVertexLocation;
	cylRI->VertexCount = cylRI->Geo->DrawArgs["cylinderWithoutTop"].VertexCount;
	mRenderItemLayer[(int)RenderLayer::LineToCylinder].push_back(cylRI.get());
	mAllRenderItems.push_back(std::move(cylRI));

	//explode
	auto explodeRI = std::make_unique<RenderItem>();
	XMStoreFloat4x4(&explodeRI->World, XMMatrixScaling(1.f, 1.f, 1.f)* XMMatrixTranslation(0.f, 6.0f, 0.0f));
	explodeRI->ObjCBIndex = objCBIndex++;
	explodeRI->Mat = mMaterials["bricks0"].get();
	explodeRI->Geo = mGeometries["shapeGeo"].get();
	explodeRI->PrimitiveType = D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	explodeRI->IndexCount = explodeRI->Geo->DrawArgs["geoSphere"].IndexCount;
	explodeRI->StartIndexLocation = explodeRI->Geo->DrawArgs["geoSphere"].StartIndexLocation;
	explodeRI->BaseVertexLocation = explodeRI->Geo->DrawArgs["geoSphere"].BaseVertexLocation;
	explodeRI->VertexCount = explodeRI->Geo->DrawArgs["geoSphere"].VertexCount;
	mRenderItemLayer[(int)RenderLayer::GeoExplode].push_back(explodeRI.get());
	mAllRenderItems.push_back(std::move(explodeRI));
}

void RenderApp::BuildRenderItems_InMirror(UINT& objCBIndex)
{
	XMVECTOR mirrorPlane = GetMirrorPlane(); // x = -10 plane
	XMMATRIX R = XMMatrixReflect(mirrorPlane);

	std::vector<std::unique_ptr<RenderItem>> renderItems;
	//for (auto& ri : mRenderItemLayer[(int)RenderLayer::Opaque])
	for (auto& ri : mAllRenderItems)
	{
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
		XMMATRIX worldM = XMLoadFloat4x4(&reflectedRI->World);
		XMStoreFloat4x4(&reflectedRI->World, worldM * R);
		reflectedRI->ObjCBIndex = objCBIndex++;

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

void RenderApp::BuildFrameResources()
{
	for (int i = 0; i < gNumFrameResources; i++)
	{
		mFrameResources.push_back(
			std::make_unique<FrameResource>(
				md3dDevice.Get(),
				2,
				(UINT)mAllRenderItems.size(),
				(UINT)mWaves->VertexCount(),
				(UINT)mMaterials.size()));
	}
}
