
//#include "../Common/d3dApp.h"
#include "AppD3D.h"

class InitD3DApp : public AppD3D
{
public:
	InitD3DApp(HINSTANCE hInstance) : AppD3D(hInstance) {};
	~InitD3DApp() {};

	virtual bool Initialize() override
	{
		if (!AppD3D::Initialize())
			return false;
		return true;
	};
private:
	virtual void OnResize() override
	{
		AppD3D::OnResize();
	};
	virtual void Update(const GameTimer& gt) override {};
	virtual void Draw(const GameTimer& gt) override {};
};