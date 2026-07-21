#include "pch.h"
#include "EditorLayer.h"
#include "Renderer/DirectX12/D3D12Util.h"
#include "EngineCore/StringUtil.h"

void EditorLayer::Initialize()
{
}

void EditorLayer::OnImGuiRender()
{
	DrawEditorUI();
}

void EditorLayer::SetSceneViewTexture(ImTextureID textureID)
{
	mSceneViewPanel.SetTexture(textureID);
}

void EditorLayer::DrawEditorUI()
{
	DrawMainDockSpace();

	if (mShowSceneView)
		mSceneViewPanel.OnImGuiRender();

	if (mShowContentBrowser)
		DrawContentBrowser();

	if (mShowHierarchy)
		DrawHierarchy();

	if (mShowInspector)
		DrawInspector();

	if (mShowConsole)
		mConsolePanel.OnImGuiRender();

	if (mShowDemoWindow)
		ImGui::ShowDemoWindow(&mShowDemoWindow);
}

void EditorLayer::DrawMainDockSpace()
{
	ImGuiWindowFlags windowFlags =
		ImGuiWindowFlags_MenuBar |
		ImGuiWindowFlags_NoDocking |
		ImGuiWindowFlags_NoTitleBar |
		ImGuiWindowFlags_NoCollapse |
		ImGuiWindowFlags_NoResize |
		ImGuiWindowFlags_NoMove |
		ImGuiWindowFlags_NoBringToFrontOnFocus |
		ImGuiWindowFlags_NoNavFocus;

	const ImGuiViewport* viewport = ImGui::GetMainViewport();

	ImGui::SetNextWindowPos(viewport->WorkPos);
	ImGui::SetNextWindowSize(viewport->WorkSize);
	ImGui::SetNextWindowViewport(viewport->ID);

	ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 0.0f);
	ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0.0f);
	ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(0.0f, 0.0f));

	bool open = true;
	ImGui::Begin("EditorDockSpaceWindow", &open, windowFlags);

	ImGui::PopStyleVar(3);

	DrawMainMenuBar();

	ImGuiID dockspaceId = ImGui::GetID("EditorDockSpace");
	ImGuiDockNodeFlags dockspaceFlags = ImGuiDockNodeFlags_None;

	ImGui::DockSpace(dockspaceId, ImVec2(0.0f, 0.0f), dockspaceFlags);

	ImGui::End();
}

void EditorLayer::DrawMainMenuBar()
{
	if (ImGui::BeginMenuBar())
	{
		if (ImGui::BeginMenu("File"))
		{
			if (ImGui::MenuItem("Exit"))
			{
				::PostQuitMessage(0);
			}

			ImGui::EndMenu();
		}

		if (ImGui::BeginMenu("Window"))
		{
			ImGui::MenuItem("Scene View", nullptr, &mShowSceneView);
			ImGui::MenuItem("Content Browser", nullptr, &mShowContentBrowser);
			ImGui::MenuItem("Hierarchy", nullptr, &mShowHierarchy);
			ImGui::MenuItem("Inspector", nullptr, &mShowInspector);
			ImGui::MenuItem("Console", nullptr, &mShowConsole);
			ImGui::Separator();
			ImGui::MenuItem("ImGui Demo", nullptr, &mShowDemoWindow);

			ImGui::EndMenu();
		}

		ImGui::EndMenuBar();
	}
}

void EditorLayer::DrawSceneView()
{
	ImGui::Begin("Scene View", &mShowSceneView);

	ImVec2 contentSize = ImGui::GetContentRegionAvail();

	if (contentSize.x < 10.0f)
		contentSize.x = 10.0f;

	if (contentSize.y < 10.0f)
		contentSize.y = 10.0f;

	ImVec2 canvasPos = ImGui::GetCursorScreenPos();
	ImVec2 canvasEnd = ImVec2(
		canvasPos.x + contentSize.x,
		canvasPos.y + contentSize.y
	);

	ImDrawList* drawList = ImGui::GetWindowDrawList();

	drawList->AddRectFilled(
		canvasPos,
		canvasEnd,
		IM_COL32(35, 35, 35, 255)
	);

	drawList->AddRect(
		canvasPos,
		canvasEnd,
		IM_COL32(90, 90, 90, 255)
	);

	drawList->AddText(
		ImVec2(canvasPos.x + 10.0f, canvasPos.y + 10.0f),
		IM_COL32(220, 220, 220, 255),
		"Scene Render Target will be displayed here."
	);

	ImGui::InvisibleButton(
		"SceneViewCanvas",
		contentSize,
		ImGuiButtonFlags_MouseButtonLeft |
		ImGuiButtonFlags_MouseButtonRight |
		ImGuiButtonFlags_MouseButtonMiddle
	);

	bool sceneHovered = ImGui::IsItemHovered();
	bool sceneFocused = ImGui::IsWindowFocused();

	ImGui::Separator();
	ImGui::Text("Hovered: %s", sceneHovered ? "true" : "false");
	ImGui::Text("Focused: %s", sceneFocused ? "true" : "false");
	ImGui::Text("Size: %.0f x %.0f", contentSize.x, contentSize.y);

	ImGui::End();
}

void EditorLayer::DrawContentBrowser()
{
	ImGui::Begin("Content Browser", &mShowContentBrowser);

	ImGui::Text("Current Directory:");
	ImGui::TextWrapped("%s", PathToUtf8(mCurrentDirectory).c_str());

	ImGui::Separator();

	if (mCurrentDirectory != mResourcesRoot)
	{
		if (ImGui::Button(".."))
		{
			mCurrentDirectory = mCurrentDirectory.parent_path();
		}

		ImGui::Separator();
	}

	try
	{
		for (const auto& entry : std::filesystem::directory_iterator(mCurrentDirectory))
		{
			const std::filesystem::path& path = entry.path();
			std::string filename = PathToUtf8(path.filename());

			if (entry.is_directory())
			{
				std::string label = "[DIR] " + filename;

				if (ImGui::Selectable(label.c_str(), false, ImGuiSelectableFlags_AllowDoubleClick))
				{
					if (ImGui::IsMouseDoubleClicked(ImGuiMouseButton_Left))
					{
						mCurrentDirectory = path;
					}
				}
			}
			else
			{
				bool selected = (mSelectedAssetPath == path);

				if (ImGui::Selectable(filename.c_str(), selected))
				{
					mSelectedAssetPath = path;
				}
			}
		}
	}
	catch (const std::filesystem::filesystem_error& e)
	{
		ImGui::TextColored(
			ImVec4(1.0f, 0.3f, 0.3f, 1.0f),
			"Filesystem error: %s",
			e.what()
		);
	}

	ImGui::End();
}

void EditorLayer::DrawHierarchy()
{
	ImGui::Begin("Hierarchy", &mShowHierarchy);

	ImGui::Text("Scene Objects");

	ImGui::Separator();

	ImGui::Selectable("Camera");
	ImGui::Selectable("Directional Light");
	ImGui::Selectable("Cube");
	ImGui::Selectable("Sphere");

	//for (auto& object : scene.GetObjects())
	//{
	//	ImGui::Selectable(object.Name.c_str());
	//}

	ImGui::End();
}

void EditorLayer::DrawInspector()
{
	ImGui::Begin("Inspector", &mShowInspector);

	if (!mSelectedAssetPath.empty())
	{
		ImGui::Text("Selected Asset");
		ImGui::Separator();

		ImGui::Text("Name:");
		ImGui::TextWrapped("%s", PathToUtf8(mSelectedAssetPath.filename()).c_str());

		ImGui::Text("Path:");
		ImGui::TextWrapped("%s", PathToUtf8(mSelectedAssetPath).c_str());

		if (std::filesystem::exists(mSelectedAssetPath) &&
			std::filesystem::is_regular_file(mSelectedAssetPath))
		{
			auto size = std::filesystem::file_size(mSelectedAssetPath);
			ImGui::Text("Size: %llu bytes", static_cast<unsigned long long>(size));
		}
	}
	else
	{
		ImGui::TextDisabled("No asset selected.");
	}

	ImGui::End();
}