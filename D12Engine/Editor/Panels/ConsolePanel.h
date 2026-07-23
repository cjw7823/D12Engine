#pragma once

#include "EngineCore/Logging/Logger.h"

#include <mutex>
#include <vector>

class ConsolePanel
{
public:
	ConsolePanel();
	~ConsolePanel();

	void OnImGuiRender();

private:
	void OnLogReceived(const LogMessage& message);
	void FlushPendingMessages();

private:
	std::mutex mConsoleMutex;
	std::vector<LogMessage> mMessages;
	std::vector<LogMessage> mPendingMessages;

	bool mAutoScroll = true;
	bool mScrollToBottom = false;

	Logger::ListenerId mListenerId;
};