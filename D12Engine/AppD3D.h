#include "InitD3DApp.h"

class AppD3D : public InitD3DApp
{
public:
	AppD3D(HINSTANCE hInstance) : InitD3DApp(hInstance) {};
	~AppD3D() {};

	virtual bool Initialize() override
	{
		if (!InitD3DApp::Initialize())
			return false;
		return true;
	};
private:
	virtual void OnResize() override
	{
		InitD3DApp::OnResize();
	};
	virtual void Update(const GameTimer& gt) override {};
	virtual void Draw(const GameTimer& gt) override {};
};