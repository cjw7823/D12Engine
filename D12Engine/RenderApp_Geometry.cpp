#include "pch.h"
#include "RenderApp.h"
#include "GeometryGenerator.h"
#include "RenderData.h"

using namespace DirectX;

void RenderApp::BuildShapeGeometry()
{
	MeshData skull = LoadModelFromFile(L"Resource/Models/skull.txt");

	GeometryGenerator geoGen;
	MeshData box = geoGen.CreateBox(1.5, 1.5, 1.5, 3);
	MeshData grid = geoGen.CreateGrid(20, 30, 60, 40);
	MeshData sphere = geoGen.CreateSphere(0.5, 20, 20);
	MeshData geoSphere = geoGen.CreateGeosphere(0.5, 2);
	MeshData cylinder = geoGen.CreateCylinder(0.5f, 0.3f, 3.f, 20, 20);

	UINT boxVertexCount = (UINT)box.Vertices.size();
	UINT gridVertexCount = (UINT)grid.Vertices.size();
	UINT sphereVertexCount = (UINT)sphere.Vertices.size();
	UINT geoSphereVertexCount = (UINT)geoSphere.Vertices.size();
	UINT cylinderVertexCount = (UINT)cylinder.Vertices.size();
	UINT skullVertexCount = (UINT)skull.Vertices.size();

	UINT boxVertexOffset = 0;
	UINT gridVertexOffset = (UINT)box.Vertices.size();
	UINT sphereVertexOffset = gridVertexOffset + (UINT)grid.Vertices.size();
	UINT geoSphereVertexOffset = sphereVertexOffset + (UINT)sphere.Vertices.size();
	UINT cylinderVertexOffset = geoSphereVertexOffset + (UINT)geoSphere.Vertices.size();
	UINT skullVertexOffset = cylinderVertexOffset + (UINT)cylinder.Vertices.size();

	UINT boxIndexOffset = 0;
	UINT gridIndexOffset = (UINT)box.Indices32.size();
	UINT sphereIndexOffset = gridIndexOffset + (UINT)grid.Indices32.size();
	UINT geoSphereIndexOffset = sphereIndexOffset + (UINT)sphere.Indices32.size();
	UINT cylinderIndexOffset = geoSphereIndexOffset + (UINT)geoSphere.Indices32.size();
	UINT skullIndexOffset = cylinderIndexOffset + (UINT)cylinder.Indices32.size();

	SubmeshGeometry boxSubmesh;
	boxSubmesh.IndexCount = (UINT)box.Indices32.size();
	boxSubmesh.StartIndexLocation = boxIndexOffset;
	boxSubmesh.BaseVertexLocation = boxVertexOffset;
	boxSubmesh.VertexCount = boxVertexCount;

	SubmeshGeometry gridSubmesh;
	gridSubmesh.IndexCount = (UINT)grid.Indices32.size();
	gridSubmesh.StartIndexLocation = gridIndexOffset;
	gridSubmesh.BaseVertexLocation = gridVertexOffset;
	gridSubmesh.VertexCount = gridVertexCount;

	SubmeshGeometry sphereSubmesh;
	sphereSubmesh.IndexCount = (UINT)sphere.Indices32.size();
	sphereSubmesh.StartIndexLocation = sphereIndexOffset;
	sphereSubmesh.BaseVertexLocation = sphereVertexOffset;
	sphereSubmesh.VertexCount = sphereVertexCount;

	SubmeshGeometry geoSphereSubmesh;
	geoSphereSubmesh.IndexCount = (UINT)geoSphere.Indices32.size();
	geoSphereSubmesh.StartIndexLocation = geoSphereIndexOffset;
	geoSphereSubmesh.BaseVertexLocation = geoSphereVertexOffset;
	geoSphereSubmesh.VertexCount = geoSphereVertexCount;

	SubmeshGeometry cylinderSubmesh;
	cylinderSubmesh.IndexCount = (UINT)cylinder.Indices32.size();
	cylinderSubmesh.StartIndexLocation = cylinderIndexOffset;
	cylinderSubmesh.BaseVertexLocation = cylinderVertexOffset;
	cylinderSubmesh.VertexCount = cylinderVertexCount;

	SubmeshGeometry skullSubmesh;
	skullSubmesh.IndexCount = (UINT)skull.Indices32.size();
	skullSubmesh.StartIndexLocation = skullIndexOffset;
	skullSubmesh.BaseVertexLocation = skullVertexOffset;
	skullSubmesh.VertexCount = skullVertexCount;

	//여러 메시들을 한 버퍼에 관리.
	auto totalVertexCount =
		box.Vertices.size() +
		grid.Vertices.size() +
		sphere.Vertices.size() +
		geoSphere.Vertices.size() +
		cylinder.Vertices.size() +
		skull.Vertices.size();

	std::vector<Vertex> vertices(totalVertexCount);

	UINT k = 0;
	for (size_t i = 0; i < box.Vertices.size(); i++, k++)
	{
		vertices[k].Position = box.Vertices[i].Position;
		vertices[k].Normal = box.Vertices[i].Normal;
		vertices[k].TangentU = box.Vertices[i].TangentU;
		vertices[k].TexC = box.Vertices[i].TexC;
	}
	for (size_t i = 0; i < grid.Vertices.size(); i++, k++)
	{
		vertices[k].Position = grid.Vertices[i].Position;
		vertices[k].Normal = grid.Vertices[i].Normal;
		vertices[k].TangentU = grid.Vertices[i].TangentU;
		vertices[k].TexC = grid.Vertices[i].TexC;
	}
	for (size_t i = 0; i < sphere.Vertices.size(); i++, k++)
	{
		vertices[k].Position = sphere.Vertices[i].Position;
		vertices[k].Normal = sphere.Vertices[i].Normal;
		vertices[k].TangentU = sphere.Vertices[i].TangentU;
		vertices[k].TexC = sphere.Vertices[i].TexC;
	}
	for (size_t i = 0; i < geoSphere.Vertices.size(); i++, k++)
	{
		vertices[k].Position = geoSphere.Vertices[i].Position;
		vertices[k].Normal = geoSphere.Vertices[i].Normal;
		vertices[k].TangentU = geoSphere.Vertices[i].TangentU;
		vertices[k].TexC = geoSphere.Vertices[i].TexC;
	}
	for (size_t i = 0; i < cylinder.Vertices.size(); i++, k++)
	{
		vertices[k].Position = cylinder.Vertices[i].Position;
		vertices[k].Normal = cylinder.Vertices[i].Normal;
		vertices[k].TangentU = cylinder.Vertices[i].TangentU;
		vertices[k].TexC = cylinder.Vertices[i].TexC;
	}
	for (size_t i = 0; i < skull.Vertices.size(); i++, k++)
	{
		vertices[k].Position = skull.Vertices[i].Position;
		vertices[k].Normal = skull.Vertices[i].Normal;
		vertices[k].TangentU = skull.Vertices[i].TangentU;
		vertices[k].TexC = skull.Vertices[i].TexC;
	}

	std::vector<std::uint32_t> indices;
	indices.insert(indices.end(), box.Indices32.begin(), box.Indices32.end());
	indices.insert(indices.end(), grid.Indices32.begin(), grid.Indices32.end());
	indices.insert(indices.end(), sphere.Indices32.begin(), sphere.Indices32.end());
	indices.insert(indices.end(), geoSphere.Indices32.begin(), geoSphere.Indices32.end());
	indices.insert(indices.end(), cylinder.Indices32.begin(), cylinder.Indices32.end());
	indices.insert(indices.end(), skull.Indices32.begin(), skull.Indices32.end());

	const UINT vbByteSize = (UINT)vertices.size() * sizeof(Vertex);
	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint32_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "shapeGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, geo->VertexBufferCPU.GetAddressOf()));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, geo->IndexBufferCPU.GetAddressOf()));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), vertices.data(), vbByteSize, geo->VertexBufferUploader);

	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R32_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	geo->DrawArgs["box"] = boxSubmesh;
	geo->DrawArgs["grid"] = gridSubmesh;
	geo->DrawArgs["sphere"] = sphereSubmesh;
	geo->DrawArgs["geoSphere"] = geoSphereSubmesh;
	geo->DrawArgs["cylinder"] = cylinderSubmesh;
	geo->DrawArgs["skull"] = skullSubmesh;

	mGeometries[geo->Name] = std::move(geo);
}

void RenderApp::BuildLandGeometry()
{
	GeometryGenerator geoGen;
	//MeshData grid = geoGen.CreateGrid(160, 160, 17, 17);
	const int rows = 2;
	const int cols = 2;
	MeshData grid = geoGen.CreateGrid(160, 160, rows, cols);

	std::vector<Vertex> vertices(grid.Vertices.size());
	for (int i = 0; i < grid.Vertices.size(); i++)
	{
		DirectX::XMFLOAT3& p = grid.Vertices[i].Position;
		vertices[i].Position = p;
		vertices[i].Normal = XMFLOAT3(0.0f, 1.0f, 0.0f);//실제 높이 등은 DS에서 계산
		vertices[i].TangentU = grid.Vertices[i].TangentU;
		vertices[i].TexC = grid.Vertices[i].TexC;
	}

	const UINT vbByteSize = (UINT)vertices.size() * sizeof(Vertex);

	std::vector<std::uint16_t> indices;
	indices.reserve((rows - 1) * (cols - 1) * 4);
	for (int i = 0; i < rows - 1; ++i)
	{
		for (int j = 0; j < cols - 1; ++j)
		{
			indices.push_back(i * cols + j);
			indices.push_back(i * cols + j + 1);
			indices.push_back((i + 1) * cols + j);
			indices.push_back((i + 1) * cols + j + 1);
		}
	}

	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint16_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "landGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, geo->VertexBufferCPU.GetAddressOf()));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);
	ThrowIfFailed(D3DCreateBlob(ibByteSize, geo->IndexBufferCPU.GetAddressOf()));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), vertices.data(), vbByteSize, geo->VertexBufferUploader);
	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R16_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;
	sm.VertexCount = (UINT)vertices.size();

	geo->DrawArgs["grid"] = sm;
	mGeometries[geo->Name] = std::move(geo);
}

void RenderApp::BuildWavesGeometry()
{
	GeometryGenerator geoGen;
	MeshData grid = geoGen.CreateGrid(160.0f, 160.0f, mWaves->RowCount(), mWaves->ColumnCount());

	const std::vector<Vertex>& vertices = grid.Vertices;
	const std::vector<std::uint32_t>& indices = grid.Indices32;	//인덱스 사이즈가 16비트(65535)를 넘을 가능성.

	UINT vbByteSize = mWaves->VertexCount() * sizeof(Vertex);
	UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint32_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "waterGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, &geo->VertexBufferCPU));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);
	ThrowIfFailed(D3DCreateBlob(ibByteSize, &geo->IndexBufferCPU));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), vertices.data(), vbByteSize, geo->VertexBufferUploader);
	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R32_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;

	geo->DrawArgs["grid"] = sm;

	mGeometries[geo->Name] = std::move(geo);
}

void RenderApp::BuildTreeBillboardGeometry()
{
	struct TreeVertex
	{
		XMFLOAT3 pos;
		XMFLOAT2 size;
	};

	static const int treeCount = 48;
	std::array<TreeVertex, treeCount> vertices;
	for (UINT i = 0; i < treeCount; i++)
	{
		float x = 0, y = 0, z = 0;
		while (true)
		{
			float range = 70.0f;
			x = MathHelper::RandF(-range, range);
			z = MathHelper::RandF(-range, range);
			if ((x > -15.f && x < 15.f) || (z > -15.f && z < 15.f))
			{
				//std::string s = std::to_string(i) + "\n";
				//OutputDebugStringA(s.c_str());
				continue;
			}

			y = GetHillsHeight(x, z);
			if (y > 2) break;
		}
		y += 2.0f;
		vertices[i].pos = XMFLOAT3(x, y, z);
		vertices[i].size = XMFLOAT2(11.0f, 15.0f);
	}

	std::array<std::uint16_t, treeCount> indices;
	for (int i = 0; i < treeCount; i++) indices[i] = i;

	const UINT vbByteSize = (UINT)vertices.size() * sizeof(TreeVertex);
	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint16_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "treeBillboard";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, &geo->VertexBufferCPU));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, &geo->IndexBufferCPU));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), vertices.data(), vbByteSize, geo->VertexBufferUploader);

	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), indices.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(TreeVertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R16_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;
	sm.VertexCount = (UINT)vertices.size();

	geo->DrawArgs["tree"] = sm;
	mGeometries[geo->Name] = std::move(geo);
}

void RenderApp::BuildCylinderWithoutTopGeometry()
{
	GeometryGenerator geoGen;
	MeshData cylinder = geoGen.CreateCircleLine(2, 10);

	SubmeshGeometry cylinderSubmesh;
	cylinderSubmesh.IndexCount = (UINT)cylinder.Indices32.size();
	cylinderSubmesh.StartIndexLocation = 0;
	cylinderSubmesh.BaseVertexLocation = 0;
	cylinderSubmesh.VertexCount = (UINT)cylinder.Vertices.size();

	std::vector<Vertex> vertices(cylinder.Vertices.size());

	for (size_t i = 0; i < cylinder.Vertices.size(); i++)
	{
		vertices[i].Position = cylinder.Vertices[i].Position;
		vertices[i].Normal = cylinder.Vertices[i].Normal;
		vertices[i].TangentU = cylinder.Vertices[i].TangentU;
		vertices[i].TexC = cylinder.Vertices[i].TexC;
	}

	const UINT vbByteSize = (UINT)cylinder.Vertices.size() * sizeof(Vertex);
	const UINT ibByteSize = (UINT)cylinder.Indices32.size() * sizeof(std::uint32_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "cylinderWithoutTop";
	ThrowIfFailed(D3DCreateBlob(vbByteSize, geo->VertexBufferCPU.GetAddressOf()));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, geo->IndexBufferCPU.GetAddressOf()));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), cylinder.Indices32.data(), ibByteSize);

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), vertices.data(), vbByteSize, geo->VertexBufferUploader);
	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(md3dDevice.Get(), mCommandList.Get(), cylinder.Indices32.data(), ibByteSize, geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R32_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	geo->DrawArgs["cylinderWithoutTop"] = cylinderSubmesh;
	mGeometries[geo->Name] = std::move(geo);
}

void RenderApp::BuildBrickWallGeometry()
{
	std::array<Vertex, 4> vertices{};

	float w = 20.0f;
	float d = 30.0f;

	vertices[0].Position = XMFLOAT3(-w * 0.5f, 0.0f, -d * 0.5f);
	vertices[1].Position = XMFLOAT3(w * 0.5f, 0.0f, -d * 0.5f);
	vertices[2].Position = XMFLOAT3(-w * 0.5f, 0.0f, d * 0.5f);
	vertices[3].Position = XMFLOAT3(w * 0.5f, 0.0f, d * 0.5f);

	for (auto& v : vertices)
	{
		v.Normal = XMFLOAT3(0.0f, 1.0f, 0.0f);
		v.TangentU = XMFLOAT3(1.0f, 0.0f, 0.0f);
	}

	vertices[0].TexC = XMFLOAT2(0.0f, 1.0f);
	vertices[1].TexC = XMFLOAT2(1.0f, 1.0f);
	vertices[2].TexC = XMFLOAT2(0.0f, 0.0f);
	vertices[3].TexC = XMFLOAT2(1.0f, 0.0f);

	std::array<std::uint16_t, 4> indices = { 0, 1, 2, 3 };

	const UINT vbByteSize = (UINT)vertices.size() * sizeof(Vertex);
	const UINT ibByteSize = (UINT)indices.size() * sizeof(std::uint16_t);

	auto geo = std::make_unique<MeshGeometry>();
	geo->Name = "brickWallGeo";

	ThrowIfFailed(D3DCreateBlob(vbByteSize, geo->VertexBufferCPU.GetAddressOf()));
	CopyMemory(geo->VertexBufferCPU->GetBufferPointer(), vertices.data(), vbByteSize);

	ThrowIfFailed(D3DCreateBlob(ibByteSize, geo->IndexBufferCPU.GetAddressOf()));
	CopyMemory(geo->IndexBufferCPU->GetBufferPointer(), indices.data(), ibByteSize);

	geo->VertexBufferGPU = d3dUtil::CreateDefaultBuffer(
		md3dDevice.Get(),
		mCommandList.Get(),
		vertices.data(),
		vbByteSize,
		geo->VertexBufferUploader);

	geo->IndexBufferGPU = d3dUtil::CreateDefaultBuffer(
		md3dDevice.Get(),
		mCommandList.Get(),
		indices.data(),
		ibByteSize,
		geo->IndexBufferUploader);

	geo->VertexByteStride = sizeof(Vertex);
	geo->VertexBufferByteSize = vbByteSize;
	geo->IndexFormat = DXGI_FORMAT_R16_UINT;
	geo->IndexBufferByteSize = ibByteSize;

	SubmeshGeometry sm;
	sm.IndexCount = (UINT)indices.size();
	sm.StartIndexLocation = 0;
	sm.BaseVertexLocation = 0;
	sm.VertexCount = (UINT)vertices.size();

	geo->DrawArgs["brickWall"] = sm;

	mGeometries[geo->Name] = std::move(geo);
}
