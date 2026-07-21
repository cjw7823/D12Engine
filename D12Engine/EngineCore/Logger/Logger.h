#pragma once

#include "LogMessage.h"

#include <functional>
#include <mutex>
#include <string>
#include <vector>

class Logger
{
public:
	using ListenerId = uint64_t;
	using LogCallback = std::function<void(const LogMessage&)>;
	
	static void Log(LogLevel level, const std::string& message);
	static void Log(LogLevel level, const std::wstring& message);

	static void Trace(const std::string& message);
	static void Trace(const std::wstring& message);
	static void Info(const std::string& message);
	static void Info(const std::wstring& message);
	static void Warning(const std::string& message);
	static void Warning(const std::wstring& message);
	static void Error(const std::string& message);
	static void Error(const std::wstring& message);

	static ListenerId AddListener(const LogCallback& callback);
	static void RemoveListener(ListenerId id);

private:
	Logger() = default;
	static Logger& Get();

private:
	struct Listener
	{
		ListenerId Id;
		LogCallback Callback;
	};

	std::mutex mMutex;
	std::vector<Listener> mListeners;
	ListenerId mNextListenerId = 0;
};
