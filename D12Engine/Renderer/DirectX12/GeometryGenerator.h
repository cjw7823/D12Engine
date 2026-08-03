#pragma once

#include <cstdint>
#include <vector>
#include <DirectXMath.h>

#include "Renderer/Resources/RenderData.h"

class GeometryGenerator
{
public:
	MeshData CreateBox(float width, float height, float depth, uint32_t numSubdivisions);

	//slices 및 stacks 매개변수는 테셀레이션 정도를 제어.
	//삼각형이 극점 근처에 정점 과밀.
	MeshData CreateSphere(float radius, uint32_t sliceCount, uint32_t stackCount);

	//삼각형이 균등분포.
	MeshData CreateGeosphere(float radius, uint32_t numSubdivisions);
	MeshData CreateCylinder(float bottomRadius, float topRadius, float height, uint32_t sliceCount, uint32_t stackCount);
	//(XZ Plane)
	MeshData CreateGrid(float width, float depth, uint32_t m, uint32_t n);

	//화면에 맞춰 정렬된 사각형 영역을 생성. 이는 후처리 및 화면 효과에 유용.(XY Plane)
	MeshData CreateQuad(float x, float y, float w, float h, float depth);
	MeshData CreateCircleLine(float radius, uint32_t sliceCount);

private:
	void Subdivide(MeshData& meshData);
	Vertex MidPoint(const Vertex& v0, const Vertex& v1);
	void BuildCylinderTopCap(float topRadius, float height, uint32_t sliceCount, uint32_t stackCount, MeshData& meshData);
	void BuildCylinderBottomCap(float bottomRadius, float height, uint32_t sliceCount, uint32_t stackCount, MeshData& meshData);
};