#include "pch.h"
#include "EditorLayer.h"

#include "Renderer/DirectX12/Scene/Scene.h"
#include "Renderer/DirectX12/Scene/SceneObject.h"
#include "Renderer/DirectX12/D3D12Util.h"
#include "Renderer/Resources/RenderData.h"

#include "EngineCore/StringUtil.h"

#include <unordered_set>
#include <utility>

void EditorLayer::RegisterSceneCommands(std::function<void(bool)> saveSceneCommand, std::function<void()> loadSceneCommand)
{
	mSaveSceneCommand = std::move(saveSceneCommand);
	mLoadSceneCommand = std::move(loadSceneCommand);
}

EditorLayer::EditorLayer(Scene& scene) : mScene(scene)
{
}

void EditorLayer::Initialize()
{
}

void EditorLayer::OnImGuiRender()
{
	DrawEditorUI();

	// 최초 실행 시 Scene View 탭을 기본 활성화
	if (!mInitialFocusApplied)
	{
		ImGui::SetWindowFocus("Scene View");
		mInitialFocusApplied = true;
	}
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

	if (mHelpWindow)
		DrawHelper();
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
			const bool canSaveScene = static_cast<bool>(mSaveSceneCommand);
			const bool canLoadScene = static_cast<bool>(mLoadSceneCommand);

			if (ImGui::MenuItem("Save Scene", nullptr, false, canSaveScene))
				mSaveSceneCommand(false);

			if (ImGui::MenuItem("Save Scene As...", nullptr, false, canSaveScene))
				mSaveSceneCommand(true);

			if (ImGui::MenuItem("Open Scene...", nullptr, false, canLoadScene))
				mLoadSceneCommand();

			ImGui::Separator();

			if (ImGui::MenuItem("Exit"))
				::PostQuitMessage(0);

			ImGui::EndMenu();
		}

		if (ImGui::BeginMenu("Window"))
		{
			ImGui::MenuItem("Scene View", nullptr, &mShowSceneView);
			ImGui::MenuItem("Content Browser", nullptr, &mShowContentBrowser);
			ImGui::MenuItem("Hierarchy", nullptr, &mShowHierarchy);
			ImGui::MenuItem("Inspector", nullptr, &mShowInspector);
			ImGui::MenuItem("Console", nullptr, &mShowConsole);

			ImGui::EndMenu();
		}

		if (ImGui::BeginMenu("Help"))
		{
			ImGui::MenuItem(WideToUtf8(L"조작키").c_str(), nullptr, &mHelpWindow);

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
	if (!ImGui::Begin("Hierarchy",&mShowHierarchy))
	{
		ImGui::End();
		return;
	}

	std::vector<SceneObjectId> ids = mScene.GetSelectedObjectIds();
	const auto& objects = mScene.GetObjects();

	auto isSelected = [&](SceneObjectId id)->bool
		{
			return std::find(ids.begin(), ids.end(), id) != ids.end();
		};

	for (const auto& object : objects)
	{
		if (!object) continue;

		if (object->HasFlag(SceneObjectFlags::HideInHierarchy)) continue;

		ImGui::PushID(reinterpret_cast<void*>(
			static_cast<std::uintptr_t>(object->Id)));

		const bool selected = isSelected(object->Id);
		const std::string objectName = WideToUtf8(object->Name);

		if (ImGui::Selectable(
			objectName.c_str(),
			selected,
			ImGuiSelectableFlags_SpanAllColumns))
		{
			if (!object->HasFlag(SceneObjectFlags::NotSelectable))
				mScene.SelectObject({ object->Id });
		}

		if (selected)
		{
			ImGui::SetItemDefaultFocus();
		}

		ImGui::PopID();
	}

	//하이어라키 빈 공간을 클릭하면 선택 해제.
	if (ImGui::IsWindowHovered() &&
		ImGui::IsMouseClicked(ImGuiMouseButton_Left) &&
		!ImGui::IsAnyItemHovered())
	{
		mScene.ClearSelection();
	}

	ImGui::End();
}

/// <summary>
/// 추후 여러개 선택 시 공통된 정보만 수정 가능하도록 변경 예정.
/// </summary>
void EditorLayer::DrawInspector()
{
	if (!ImGui::Begin("Inspector", &mShowInspector))
	{
		ImGui::End();
		return;
	}

	bool Selectedflag = false;
	std::vector<SceneObjectId> ids = mScene.GetSelectedObjectIds();
	SceneObject* selectedObject = nullptr;
	if (!ids.empty())
	{
		selectedObject = mScene.FindObject(ids[0]);
		if (selectedObject) Selectedflag = true;
	}

	if (!Selectedflag)
	{
		ImGui::TextDisabled(
			"%s",
			WideToUtf8(
				L"선택된 오브젝트가 없습니다.")
			.c_str());

		ImGui::End();
		return;
	}

	ImGui::Text("%s", WideToUtf8(selectedObject->Name).c_str());

	ImGui::TextDisabled(
		"ID: %llu",
		static_cast<unsigned long long>(
			selectedObject->Id));

	ImGui::Separator();

	DrawTransformInspector(*selectedObject);

	ImGui::Spacing();
	ImGui::Separator();
	ImGui::Spacing();

	DrawMaterialInspector(*selectedObject);

	ImGui::End();
}

void EditorLayer::DrawTransformInspector(SceneObject& object)
{
	if (!ImGui::CollapsingHeader(
		"Transform",
		ImGuiTreeNodeFlags_DefaultOpen))
	{
		return;
	}

	bool changed = false;

	changed |= ImGui::DragFloat3(
		WideToUtf8(L"위치").c_str(),
		&object.Transform.Position.x,
		0.1f);

	changed |= ImGui::DragFloat3(
		WideToUtf8(L"회전").c_str(),
		&object.Transform.Rotation.x,
		0.5f);

	changed |= ImGui::DragFloat3(
		WideToUtf8(L"크기").c_str(),
		&object.Transform.Scale.x,
		0.01f);

}

void EditorLayer::DrawMaterialInspector(SceneObject& object)
{
	//if (!ImGui::CollapsingHeader(
	//	"Material",
	//	ImGuiTreeNodeFlags_DefaultOpen))
	//{
	//	return;
	//}

	//if (object.RenderBindings.empty())
	//{
	//	ImGui::TextDisabled(
	//		"%s",
	//		WideToUtf8(
	//			L"렌더 바인딩이 없습니다.")
	//		.c_str());

	//	return;
	//}

	//std::unordered_set<Material*> drawnMaterials;

	//bool materialFound = false;

	//for (const RenderInstanceBinding& binding :
	//	object.RenderBindings)
	//{
	//	Material* material =
	//		binding.MaterialData_GPU;

	//	if (!material)
	//		continue;

	//	/*
	//	 * 여러 서브메시가 같은 Material을 공유하면
	//	 * Inspector에 한 번만 출력.
	//	 */
	//	if (!drawnMaterials.insert(material).second)
	//		continue;

	//	materialFound = true;

	//	ImGui::PushID(material);

	//	const ImGuiTreeNodeFlags flags =
	//		object.RenderBindings.size() == 1
	//		? ImGuiTreeNodeFlags_DefaultOpen
	//		: ImGuiTreeNodeFlags_None;

	//	if (ImGui::CollapsingHeader(
	//		material->Name.c_str(),
	//		flags))
	//	{
	//		bool changed = false;

	//		changed |= ImGui::ColorEdit4(
	//			WideToUtf8(L"기본 색상").c_str(),
	//			&material->DiffuseAlbedo.x);

	//		changed |= ImGui::DragFloat3(
	//			"Fresnel R0",
	//			&material->FresnelR0.x,
	//			0.001f,
	//			0.0f,
	//			1.0f);

	//		changed |= ImGui::SliderFloat(
	//			WideToUtf8(L"거칠기").c_str(),
	//			&material->Roughness,
	//			0.0f,
	//			1.0f);

	//		ImGui::TextDisabled(
	//			"%s: %u",
	//			WideToUtf8(L"재질 버퍼 인덱스").c_str(),
	//			material->MatBufferIndex);

	//		if (changed)
	//		{
	//			material->NumFramesDirty =
	//				GlobalConfig::NumFrameResources;
	//		}
	//	}

	//	ImGui::PopID();
	//}

	//if (!materialFound)
	//{
	//	ImGui::TextDisabled(
	//		"%s",
	//		WideToUtf8(
	//			L"연결된 재질이 없습니다.")
	//		.c_str());
	//}
}

void EditorLayer::DrawHelper()
{
	if (!mHelpWindow)
		return;

	const std::string windowTitle = WideToUtf8(L"조작키");

	ImGui::SetNextWindowSize(ImVec2(620.0f, 560.0f), ImGuiCond_FirstUseEver);
	ImGui::SetNextWindowSizeConstraints(
		ImVec2(320.0f, 240.0f),
		ImVec2(FLT_MAX, FLT_MAX));

	if (!ImGui::Begin(windowTitle.c_str(), &mHelpWindow))
	{
		ImGui::End();
		return;
	}

	ImGui::TextWrapped(
		"%s",
		WideToUtf8(
			L"씬 뷰가 포커스된 상태에서 마우스와 키보드 입력을 사용할 수 있습니다.")
		.c_str());

	ImGui::Separator();

	/*
	 * 창의 높이가 작아졌을 때 전체 도움말을 세로로 스크롤할 수 있게 한다.
	 */
	if (ImGui::BeginChild(
		"HelperScrollingRegion",
		ImVec2(0.0f, 0.0f),
		ImGuiChildFlags_None,
		ImGuiWindowFlags_AlwaysVerticalScrollbar))
	{
		const ImGuiTableFlags tableFlags =
			ImGuiTableFlags_Borders |
			ImGuiTableFlags_RowBg |
			ImGuiTableFlags_SizingStretchProp;

		/*
		 * key는 호출 중에만 사용되므로 const char*로 받을 수 있다.
		 * description은 UTF-8로 변환한 뒤 현재 열 너비에 맞춰 자동 줄바꿈한다.
		 */
		auto DrawShortcut =
			[](const char* key, const std::wstring& description)
			{
				const std::string utf8Description = WideToUtf8(description);

				ImGui::TableNextRow();

				ImGui::TableSetColumnIndex(0);
				ImGui::AlignTextToFramePadding();
				ImGui::TextUnformatted(key);

				ImGui::TableSetColumnIndex(1);

				/*
				 * 현재 테이블 열의 남은 가로 영역을 줄바꿈 너비로 사용한다.
				 */
				ImGui::PushTextWrapPos(ImGui::GetCursorPosX() +
					ImGui::GetContentRegionAvail().x);

				ImGui::TextUnformatted(utf8Description.c_str());

				ImGui::PopTextWrapPos();
			};

		auto SetupTableColumns = []()
			{
				ImGui::TableSetupColumn(
					WideToUtf8(L"입력").c_str(),
					ImGuiTableColumnFlags_WidthFixed,
					145.0f);

				ImGui::TableSetupColumn(
					WideToUtf8(L"기능").c_str(),
					ImGuiTableColumnFlags_WidthStretch);

				ImGui::TableHeadersRow();
			};

		if (ImGui::CollapsingHeader(WideToUtf8(L"마우스 조작").c_str(), ImGuiTreeNodeFlags_DefaultOpen))
		{
			if (ImGui::BeginTable("MouseInputTable", 2, tableFlags))
			{
				SetupTableColumns();

				DrawShortcut(
					WideToUtf8(L"마우스 왼쪽 클릭").c_str(),
					L"오브젝트를 선택합니다. 기즈모 위를 클릭한 경우에는 "
					L"오브젝트 대신 해당 기즈모 축을 선택합니다.");

				DrawShortcut(
					WideToUtf8(L"마우스 왼쪽 드래그").c_str(),
					L"선택한 기즈모 축을 따라 오브젝트를 이동합니다.");

				DrawShortcut(
					WideToUtf8(L"마우스 오른쪽 드래그").c_str(),
					L"마우스 상대 이동량을 사용하여 카메라 시점을 회전합니다.");

				DrawShortcut(
					WideToUtf8(L"마우스 휠").c_str(),
					L"카메라를 확대하거나 축소합니다.");

				ImGui::EndTable();
			}
		}

		ImGui::Spacing();

		if (ImGui::CollapsingHeader(
			WideToUtf8(L"카메라 이동").c_str(),
			ImGuiTreeNodeFlags_DefaultOpen))
		{
			if (ImGui::BeginTable(
				"CameraInputTable",
				2,
				tableFlags))
			{
				SetupTableColumns();

				DrawShortcut("W", L"카메라 전진");
				DrawShortcut("S", L"카메라 후진");
				DrawShortcut("A", L"카메라 왼쪽 이동");
				DrawShortcut("D", L"카메라 오른쪽 이동");
				DrawShortcut("Q", L"카메라 아래쪽 이동");
				DrawShortcut("E", L"카메라 위쪽 이동");

				ImGui::EndTable();
			}
		}

		ImGui::Spacing();

		if (ImGui::CollapsingHeader(
			WideToUtf8(L"렌더링 설정").c_str(),
			ImGuiTreeNodeFlags_DefaultOpen))
		{
			if (ImGui::BeginTable(
				"RenderInputTable",
				2,
				tableFlags))
			{
				SetupTableColumns();

				DrawShortcut("1", L"일반 라이팅 렌더링 모드로 변경");
				DrawShortcut("2", L"와이어프레임 렌더링 모드로 변경");
				DrawShortcut("3", L"깊이 복잡도 시각화 모드로 변경");
				DrawShortcut("4", L"버텍스 노멀 시각화 모드로 변경");
				DrawShortcut("5", L"소벨 외곽선 효과 활성화 또는 비활성화");
				DrawShortcut("6", L"블러 적용 횟수를 다음 단계로 변경");
				DrawShortcut("7", L"MSAA 설정을 다음 옵션으로 변경");

				ImGui::EndTable();
			}
		}

		ImGui::Spacing();

		if (ImGui::CollapsingHeader(
			WideToUtf8(L"태양 방향 조작").c_str(),
			ImGuiTreeNodeFlags_DefaultOpen))
		{
			if (ImGui::BeginTable("SunInputTable", 2, tableFlags))
			{
				SetupTableColumns();

				DrawShortcut(
					WideToUtf8(L"왼쪽 방향키").c_str(),
					L"태양을 왼쪽 방향으로 회전합니다.");

				DrawShortcut(
					WideToUtf8(L"오른쪽 방향키").c_str(),
					L"태양을 오른쪽 방향으로 회전합니다.");

				DrawShortcut(
					WideToUtf8(L"위쪽 방향키").c_str(),
					L"태양의 수직 회전 각도를 감소시킵니다.");

				DrawShortcut(
					WideToUtf8(L"아래쪽 방향키").c_str(),
					L"태양의 수직 회전 각도를 증가시킵니다.");

				ImGui::EndTable();
			}
		}
	}

	ImGui::EndChild();
	ImGui::End();
}