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

		mCamera.Pitch(dy);
		mCamera.RotateY(dx);
	}

	mLastMousePos = { x,y };
}

void RenderApp::OnMouseWheel(short zDelta, int x, int y)
{
	constexpr float wheelSpeed = 0.01f;
	mCamera.MoveForward(zDelta * wheelSpeed);
	mCamera.UpdateViewMatrix();
}

void RenderApp::OnKeyUp(WPARAM key)
{
	std::wstring s(1, static_cast<wchar_t>(key));
	s += L" ";
	OutputDebugStringW((std::wstring(L"UP : ") + s).c_str());
}

void RenderApp::OnKeyDown(WPARAM key)
{
	std::wstring s(1, static_cast<wchar_t>(key));
	s += L" ";
	OutputDebugStringW((std::wstring(L"DOWN : ") + s).c_str());

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

	//camera move
	const float speed = 10.0f;
	if (d3dUtil::IsKeyDown('W')) mCamera.MoveForward(speed * dt);
	if (d3dUtil::IsKeyDown('S')) mCamera.MoveForward(-speed * dt);
	if (d3dUtil::IsKeyDown('A')) mCamera.MoveRight(-speed * dt);
	if (d3dUtil::IsKeyDown('D')) mCamera.MoveRight(speed * dt);
	if (d3dUtil::IsKeyDown('Q')) mCamera.MoveUp(-speed * dt);
	if (d3dUtil::IsKeyDown('E')) mCamera.MoveUp(speed * dt);

	mCamera.UpdateViewMatrix();
}
