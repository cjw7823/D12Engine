#pragma once

/*
* 파동 시뮬레이션 계산. 렌더링 관련 작업x
* 업데이트 후 렌더링을 위해 정점 버퍼에 복사.
*/

#include <vector>
#include <DirectXMath.h>

class Waves
{
public:
	Waves(int m, int n, float dx, float dt, float speed, float damping);
	Waves(const Waves& rhs) = delete;
	Waves& operator=(const Waves& rhs) = delete;
	~Waves(){};

	int RowCount()const;
	int ColumnCount()const;
	int VertexCount()const;
	int TriangleCount()const;
	float Width()const;
	float Depth()const;

	const DirectX::XMFLOAT3& Position(int i)const { return mCurrSolution[i]; }
	const DirectX::XMFLOAT3& Normal(int i)const { return mNormals[i]; }
	const DirectX::XMFLOAT3& TangentX(int i)const { return mTangentX[i]; }

	void Update(float dt);
	void Disturb(int i, int j, float magnitude);

private:
	int mNumRows = 0;
	int mNumCols = 0;

	int mVertexCount = 0;
	int mTriangleCount = 0;

	float mK1 = 0.0f;
	float mK2 = 0.0f;
	float mK3 = 0.0f;

	float mTimeStep = 0.0f;
	float mSpatialStep = 0.0;

	std::vector<DirectX::XMFLOAT3> mPrevSolution;
	std::vector<DirectX::XMFLOAT3> mCurrSolution;
	std::vector<DirectX::XMFLOAT3> mNormals;
	std::vector<DirectX::XMFLOAT3> mTangentX;
};