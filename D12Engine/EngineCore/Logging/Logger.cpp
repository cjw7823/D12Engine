#include "pch.h"
#include "Logger.h"
#include "EngineCore/StringUtil.h"

#include <Windows.h>
#include <algorithm>

void Logger::Log(LogLevel level, const std::string& message)
{
    LogMessage logMessage;
    logMessage.Level = level;
    logMessage.Message = message;
    logMessage.Time = std::chrono::system_clock::now();

    // Visual Studio Output 창에도 출력
    std::string debugMessage = message;
    debugMessage += '\n';

    OutputDebugStringA(debugMessage.c_str());

    std::vector<Listener> listeners;

    {
        std::scoped_lock lock(Get().mMutex);
        listeners = Get().mListeners;
    }

    for (const Listener& listener : listeners)
    {
        if (listener.Callback)
            listener.Callback(logMessage);
    }
}

void Logger::Log(LogLevel level, const std::wstring& message)
{
    std::string msg = WideToUtf8(message);
    Log(level, msg);
}

void Logger::Trace(const std::string& message)
{
    Log(LogLevel::Trace, message);
}

void Logger::Trace(const std::wstring& message)
{
    Log(LogLevel::Trace, message);
}

void Logger::Info(const std::string& message)
{
    Log(LogLevel::Info, message);
}

void Logger::Info(const std::wstring& message)
{
    Log(LogLevel::Info, message);
}

void Logger::Warning(const std::string& message)
{
    Log(LogLevel::Warning, message);
}

void Logger::Warning(const std::wstring& message)
{
    Log(LogLevel::Warning, message);
}

void Logger::Error(const std::string& message)
{
    Log(LogLevel::Error, message);
}

void Logger::Error(const std::wstring& message)
{
    Log(LogLevel::Error, message);
}

Logger::ListenerId Logger::AddListener(const LogCallback& callback)
{
    std::scoped_lock lock(Get().mMutex);

    const ListenerId id = ++Get().mNextListenerId;

    Get().mListeners.push_back({ id, callback });

    return id;
}

void Logger::RemoveListener(ListenerId id)
{
    auto newEnd = std::remove_if(Get().mListeners.begin(), Get().mListeners.end(),
        [&id](Listener& listener) {
            if (listener.Id == id) return true;
            return false;
        });

    Get().mListeners.erase(newEnd, Get().mListeners.end());
}

Logger& Logger::Get()
{
    static Logger instance;
    return instance;
}
