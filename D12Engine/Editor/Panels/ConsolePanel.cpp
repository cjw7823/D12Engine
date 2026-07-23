#include "pch.h"
#include "ConsolePanel.h"

ConsolePanel::ConsolePanel()
{
    mListenerId = Logger::AddListener(
		[this](const LogMessage& message) {
			OnLogReceived(message);
		});
}

ConsolePanel::~ConsolePanel()
{
    Logger::RemoveListener(mListenerId);
}

void ConsolePanel::OnImGuiRender()
{
    FlushPendingMessages();

    if (!ImGui::Begin("Console"))
    {
        ImGui::End();
        return;
    }

    if (ImGui::Button("Clear"))
    {
        mMessages.clear();
        
        std::scoped_lock lock(mConsoleMutex);
        mPendingMessages.clear();
    }

    ImGui::SameLine();
    ImGui::Checkbox("Auto Scroll", &mAutoScroll);

    ImGui::Separator();

    ImGui::BeginChild(
        "ConsoleScrollingRegion",
        ImVec2(0.0f, 0.0f),
        false,
        ImGuiWindowFlags_HorizontalScrollbar);

    for (const LogMessage& message : mMessages)
    {
        ImVec4 color;

        switch (message.Level)
        {
        case LogLevel::Trace:
            color = ImVec4(0.65f, 0.65f, 0.65f, 1.0f);
            break;

        case LogLevel::Info:
            color = ImVec4(1.0f, 1.0f, 1.0f, 1.0f);
            break;

        case LogLevel::Warning:
            color = ImVec4(1.0f, 0.75f, 0.2f, 1.0f);
            break;

        case LogLevel::Error:
            color = ImVec4(1.0f, 0.25f, 0.25f, 1.0f);
            break;

        default:
            color = ImVec4(1.0f, 1.0f, 1.0f, 1.0f);
            break;
        }

        ImGui::PushStyleColor(ImGuiCol_Text, color);
        ImGui::TextUnformatted(message.Message.c_str());
        ImGui::PopStyleColor();
    }

    bool scrollToBottom = false;
    {
        std::scoped_lock(mConsoleMutex);
        scrollToBottom = mScrollToBottom;
        mScrollToBottom = false;
    }

    if (scrollToBottom) ImGui::SetScrollHereY(1.0f);
    
    ImGui::EndChild();
    ImGui::End();
}

void ConsolePanel::OnLogReceived(const LogMessage& message)
{
    std::scoped_lock(mConsoleMutex);
    mPendingMessages.push_back(message);

    if (mAutoScroll) mScrollToBottom = true;
}

void ConsolePanel::FlushPendingMessages()
{
    std::vector<LogMessage> pending;
    {
        std::scoped_lock lock(mConsoleMutex);
        pending.swap(mPendingMessages);
    }
    
    mMessages.insert(
        mMessages.end(),
        std::make_move_iterator(pending.begin()),
        std::make_move_iterator(pending.end()));
}
