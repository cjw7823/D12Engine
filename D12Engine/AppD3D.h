#include "InitD3DApp.h"
#include "../SampleSrc/MathHelper.h"
#include "../SampleSrc/UploadBuffer.h"

struct Vertex
{
	DirectX::XMFLOAT3 Pos;
	DirectX::XMFLOAT4 Color;
};

struct ObjectConstants
{
	DirectX::XMFLOAT4X4 WorldViewProj = MathHelper::Identity4x4();
};

class AppD3D : public InitD3DApp
{
public:
	AppD3D(HINSTANCE hInstance) : InitD3DApp(hInstance) {};
	~AppD3D() {};

	virtual bool Initialize() override;

private:
	virtual void OnResize() override
	{
		InitD3DApp::OnResize();
	};
	virtual void Update(const GameTimer& gt) override {};
	virtual void Draw(const GameTimer& gt) override {};

	void BuildDescriptorHeaps();
	void BuildConstantBuffers();
	void BuildRootSignature();
	void BuildShadersAndInputLayout();
	void BuildBoxGeometry();
	void BuildPSO();

	Microsoft::WRL::ComPtr<ID3D12RootSignature> mRootSignature = nullptr;
	Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> mCbvHeap;
	std::unique_ptr<UploadBuffer<ObjectConstants>> mObjectCB = nullptr;

	Microsoft::WRL::ComPtr<ID3DBlob> mvsByteCode = nullptr;
	Microsoft::WRL::ComPtr<ID3DBlob> mpsByteCode = nullptr;

	std::vector<D3D12_INPUT_ELEMENT_DESC> mInputLayout;
};