#include "pch.h"
#include "RenderApp.h"

bool RenderApp::InitImGui()
{
	ImGui::CreateContext();
	ImGui_ImplWin32_Init(mhMainWnd);

	UINT textureCount = (UINT)mTextures.size();
	UINT imguiFontIndex = textureCount;

	CD3DX12_CPU_DESCRIPTOR_HANDLE cpuHandle(mSrvHeap->GetCPUDescriptorHandleForHeapStart());
	cpuHandle.Offset(imguiFontIndex, mCbvSrvUavDescriptorSize);

	CD3DX12_GPU_DESCRIPTOR_HANDLE gpuHandle(mSrvHeap->GetGPUDescriptorHandleForHeapStart());
	gpuHandle.Offset(imguiFontIndex, mCbvSrvUavDescriptorSize);

	ImGui_ImplDX12_InitInfo init_info = {};
	init_info.Device = md3dDevice.Get();
	init_info.CommandQueue = mCommandQueue.Get();
	init_info.NumFramesInFlight = gNumFrameResources;
	init_info.RTVFormat = mBackBufferFormat;
	init_info.DSVFormat = mDepthStencilFormat;
	init_info.SrvDescriptorHeap = mSrvHeap.Get();
	init_info.LegacySingleSrvCpuDescriptor = cpuHandle;
	init_info.LegacySingleSrvGpuDescriptor = gpuHandle;

	ImGui_ImplDX12_Init(&init_info);

	ImGuiIO& io = ImGui::GetIO();

	io.Fonts->AddFontFromFileTTF(
		"C:\\Windows\\Fonts\\malgun.ttf",  // 맑은 고딕
		18.0f,
		nullptr,
		io.Fonts->GetGlyphRangesKorean()
	);
	ImGui_ImplDX12_InvalidateDeviceObjects();
	ImGui_ImplDX12_CreateDeviceObjects();

	return mImGuiInitialized = true;
}

void RenderApp::RenderImGui()
{
	using namespace ImGui;

	ImGui_ImplDX12_NewFrame();
	ImGui_ImplWin32_NewFrame();
	ImGui::NewFrame();

	if (mIsShowHelper)
	{
		ImGui::SetNextWindowPos(ImVec2(5, 5), ImGuiCond_Appearing);
		ImGui::SetNextWindowSize(ImVec2(240, 230), ImGuiCond_Appearing);

		ImGui::Begin(u8"조작 안내", &mIsShowHelper, ImGuiWindowFlags_NoResize);

		ImGui::TextUnformatted(u8"화면 드래그 : 화면 회전");
		ImGui::TextUnformatted(u8"마우스 휠   : 확대 / 축소");
		ImGui::Separator();
		ImGui::TextUnformatted(u8"W A S D     : 이동");
		ImGui::TextUnformatted(u8"Q / E       : 위 / 아래 이동");
		ImGui::Separator();
		ImGui::TextUnformatted(u8"방향키      : 주광원 이동");
		ImGui::Separator();
		ImGui::TextUnformatted(u8"숫자 1		: 와이어 프레임 모드");
		ImGui::TextUnformatted(u8"숫자 2		: 깊이 복잡도 렌더 모드");
		ImGui::TextUnformatted(u8"숫자 3		: 정점 법선 렌더 모드");

		ImGui::TextUnformatted(u8"F2		: MSAA 4x 모드 토글");

		ImGui::End();
	}
	else
	{
		SetNextWindowPos(ImVec2(0, 0), ImGuiCond_Once);
		SetNextWindowBgAlpha(0.0f);

		UINT index = mTextures["helpTex"]->SrvHeapIndex;

		CD3DX12_GPU_DESCRIPTOR_HANDLE handle(mSrvHeap->GetGPUDescriptorHandleForHeapStart());
		handle.Offset(index, mCbvSrvUavDescriptorSize);

		Begin("overlay",
			nullptr,
			ImGuiWindowFlags_NoDecoration |
			ImGuiWindowFlags_NoBackground |
			ImGuiWindowFlags_NoMove);

		ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.7f, 0.7f, 0.7f, 0.5f));
		ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.7f, 0.7f, 0.7f, 0.7f));
		ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImVec4(0.8f, 0.8f, 0.8f, 0.7f));

		if (ImGui::ImageButton("btn", (ImTextureID)handle.ptr, ImVec2(40, 40)))
		{
			mIsShowHelper = true;
		}
		ImGui::PopStyleColor(3);
		ImGui::End();
	}

	//MSAA 텍스트
	{
		ImGuiViewport* viewport = ImGui::GetMainViewport();

		ImVec2 pos = ImVec2(
			viewport->WorkPos.x + viewport->WorkSize.x - 10.0f,
			viewport->WorkPos.y + 10.0f
		);

		ImGui::SetNextWindowPos(pos, ImGuiCond_Always, ImVec2(1.0f, 0.0f));
		ImGui::SetNextWindowBgAlpha(0.0f);

		ImGuiWindowFlags flags =
			ImGuiWindowFlags_NoDecoration |
			ImGuiWindowFlags_AlwaysAutoResize |
			ImGuiWindowFlags_NoBackground |
			ImGuiWindowFlags_NoMove |
			ImGuiWindowFlags_NoSavedSettings |
			ImGuiWindowFlags_NoInputs;

		ImGui::Begin("TopRightText", nullptr, flags);

		std::string s = "MSAA Level : " + std::to_string(mMsaaOption.SampleCount());
		ImGui::TextUnformatted(s.c_str());

		ImGui::End();
	}

	Render();
	ImGui_ImplDX12_RenderDrawData(GetDrawData(), mCommandList.Get());
}