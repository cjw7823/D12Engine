#pragma once

enum class ComputePass
{
	WavesUpdate,
	WavesDisturb,

	BlurHorizontal,
	BlurVertical,

	SobelExecute,
	SobelComposite,

	Count
};

enum class GraphicsPass
{
	DepthComplexityVisualize,

	SelectedMask,
	SelectedOutline,

	VertexNormalVisualize,

	Count
};

//상호 베타적인 렌더 모드들. 해당 모드에 따라서 특정 GraphicsPass On/Off
enum class SceneRenderMode
{
	Lit,
	Wireframe,
	DepthComplexity,
	VertexNormal,

	Count
};

//렌더링 순서에 영향
enum class RenderLayer : int
{
	Opaque = 0,
	SkinnedOpaque,
	TessLand,
	MultiTextureBlend,
	AlphaTestOpaque,
	A2C_TreeBillboard,			//트리 빌보드
	GeoSphereLOD,				//GeometryShader로 LOD 구현한 GeoShperes
	GeoExplode,
	LineToCylinder,				//선분으로 그리는 원통
	Waves,
	MirrorStencil,
	//MirrorWall,
	TessWall,
	MirrorBaseFill,
	Reflected,
	Shadow,
	Transparent,

	Gizmo,

	Count,
};

struct SceneRenderSettings
{
	SceneRenderMode Mode = SceneRenderMode::Lit;
	bool FrustumCullingEnabled = true;
	bool SobelEnabled = false;

	UINT GetBlurCount() const { return BlurCounts[mBlurCountIndex]; }
	void NextBlurCount()
	{
		mBlurCountIndex = (mBlurCountIndex + 1) % BlurCounts.size();
	}
private:
	inline static constexpr std::array<UINT, 5> BlurCounts =
	{
		0, 1, 2, 4, 8
	};

	size_t mBlurCountIndex = 0;
};