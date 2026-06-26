#include "pch.h"
#include "RenderApp.h"
#include "MathHelper.h"

using namespace DirectX;

void RenderApp::OnMouseDown(WPARAM btnState, int x, int y)
{
	mLastMousePos = { x,y };
	SetCapture(mhMainWnd); //마우스 커서가 창 밖으로 나가도 마우스 메시지 유지.
}

void RenderApp::OnMouseUp(WPARAM btnState, int x, int y)
{
	ReleaseCapture();
}

void RenderApp::OnMouseMove(WPARAM btnState, int x, int y)
{
	if ((btnState & MK_LBUTTON) != 0)
	{
		float dx = DirectX::XMConvertToRadians(0.5f * static_cast<float>(x - mLastMousePos.x));
		float dy = DirectX::XMConvertToRadians(0.5f * static_cast<float>(y - mLastMousePos.y));

		mTheta += dx;
		mPhi += dy;

		//LookAt 행렬 생성 시 up 벡터와 시선 벡터가 평행해져서 직교 기저를 만들 수 없는 수학적 퇴화 현상 방지.
		mPhi = MathHelper::Clamp(mPhi, 0.1f, DirectX::XM_PI - 0.1f);
	}

	mLastMousePos = { x,y };
}

void RenderApp::OnMouseWheel(short zDelta, int x, int y)
{
	constexpr float wheelSpeed = 0.01f;
	mRadius -= zDelta * wheelSpeed;
	mRadius = MathHelper::Clamp(mRadius, 0.1f, 150.0f);
}

void RenderApp::OnKeyUp(WPARAM key)
{
	std::wstring s(1, static_cast<wchar_t>(key));
	s += L" ";
	OutputDebugStringW((std::wstring(L"UP : ") + s).c_str());

	isMoving = false;
}

void RenderApp::OnKeyDown(WPARAM key)
{
	std::wstring s(1, static_cast<wchar_t>(key));
	s += L" ";
	OutputDebugStringW((std::wstring(L"DOWN : ") + s).c_str());

	isMoving = true;
	if (key == 'W') md = 1;
	else if (key == 'S') md = 2;
	else if (key == 'A') md = 3;
	else if (key == 'D') md = 4;
	else if (key == 'Q') md = 5;
	else if (key == 'E') md = 6;
	else isMoving = false;

	if (key == VK_F1) NextMsaaOoption();
	else if (key == VK_F2) NextBlurCount();
	else if (key == VK_F3) is_Sobel = !is_Sobel;
}

void RenderApp::OnKeyboardInput(const GameTimer& gt)
{
	static bool prevKeyDown1 = false;
	static bool prevKeyDown2 = false;
	static bool prevKeyDown3 = false;

	bool KeyDown1 = d3dUtil::IsKeyDown('1');
	bool KeyDown2 = d3dUtil::IsKeyDown('2');
	bool KeyDown3 = d3dUtil::IsKeyDown('3');

	if (KeyDown1 && !prevKeyDown1)
	{
		mIsWireframe = !mIsWireframe;
		mIsDepthComplexityDebug = false;
		mIsVertexNormalDebug = false;
	}
	if (KeyDown2 && !prevKeyDown2)
	{
		mIsWireframe = false;
		mIsDepthComplexityDebug = !mIsDepthComplexityDebug;
		mIsVertexNormalDebug = false;
	}
	if (KeyDown3 && !prevKeyDown3)
	{
		mIsWireframe = false;
		mIsDepthComplexityDebug = false;
		mIsVertexNormalDebug = !mIsVertexNormalDebug;
	}

	prevKeyDown1 = KeyDown1;
	prevKeyDown2 = KeyDown2;
	prevKeyDown3 = KeyDown3;

	const float dt = gt.DeltaTime();

	if (d3dUtil::IsKeyDown(VK_LEFT))
		mSunTheta -= 1.0f * dt;

	if (d3dUtil::IsKeyDown(VK_RIGHT))
		mSunTheta += 1.0f * dt;

	if (d3dUtil::IsKeyDown(VK_UP))
		mSunPhi -= 1.0f * dt;

	if (d3dUtil::IsKeyDown(VK_DOWN))
		mSunPhi += 1.0f * dt;

	mSunPhi = MathHelper::Clamp(mSunPhi, 1.0f, XM_PIDIV2);
}
