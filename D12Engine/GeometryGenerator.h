#pragma once

#include <vector>
#include <DirectXMath.h>
#include <cstdint>

//TangentU/TexC/Normal 은 추후 공부.
class GeometryGenerator
{
public:
	using uint16 = std::uint16_t;
	using uint32 = std::uint32_t;

	struct Vertex
	{
		Vertex() {}
		Vertex(
			const DirectX::XMFLOAT3& p,
			const DirectX::XMFLOAT3& n,
			const DirectX::XMFLOAT3& t,
			const DirectX::XMFLOAT2& uv) :
			Position(p),
			Normal(n),
			TangentU(t),
			TexC(uv) {}
		Vertex(
			float px, float py, float pz,
			float nx, float ny, float nz,
			float tx, float ty, float tz,
			float u, float v) :
			Position(px, py, pz),
			Normal(nx, ny, nz),
			TangentU(tx, ty, tz),
			TexC(u, v) {
		}

		DirectX::XMFLOAT3 Position;
		DirectX::XMFLOAT3 Normal;
		DirectX::XMFLOAT3 TangentU;
		DirectX::XMFLOAT2 TexC;
	};

	struct MeshData
	{
		std::vector<Vertex> Vertices;
		std::vector<uint32> Indices32;

		std::vector<uint16>& GetIndices16()
		{
			if (mIndices16.empty())
			{
				mIndices16.resize(Indices32.size());
				for (size_t i = 0; i < Indices32.size(); i++)
					mIndices16[i] = static_cast<uint16>(Indices32[i]);
			}
			return mIndices16;
		}

	private:
		std::vector<uint16> mIndices16;
	};

	//지정된 크기로 원점을 중심으로 하는 상자를 생성.
	MeshData CreateBox(float width, float height, float depth, uint32 numSubdivisions);

	//지정된 반지름으로 원점을 중심으로 하는 구를 생성.
	//slices 및 stacks 매개변수는 테셀레이션 정도를 제어.
	//삼각형이 극점 근처에 정점 과밀.
	MeshData CreateSphere(float radius, uint32 sliceCount, uint32 stackCount);

	//삼각형이 균등분포.
	//깊이가 테셀레이션 제어.
	MeshData CreateGeosphere(float radius, uint32 numSubdivisions);

	//y축에 평행하고 원점을 중심으로 하는 원기둥을 생성.
	MeshData CreateCylinder(float bottomRadius, float topRadius, float height, uint32 sliceCount, uint32 stackCount);

	MeshData CreateGrid(float width, float depth, uint32 m, uint32 n);

	//화면에 맞춰 정렬된 사각형 영역을 생성합니다. 이는 후처리 및 화면 효과에 유용
	MeshData CreateQuad(float x, float y, float w, float h, float depth);

private:
	void Subdivide(MeshData& meshData);
	Vertex MidPoint(const Vertex& v0, const Vertex& v1);
	void BuildCylinderTopCap(float bottomRadius, float topRadius, float height, uint32 sliceCount, uint32 stackCount, MeshData& meshData);
	void BuildCylinderBottomCap(float bottomRadius, float topRadius, float height, uint32 sliceCount, uint32 stackCount, MeshData& meshData);
};