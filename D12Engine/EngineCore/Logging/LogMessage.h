#pragma once

#include <string>
#include <chrono>

enum class LogLevel
{
	Trace,
	Info,
	Warning,
	Error
};

struct LogMessage
{
	LogLevel Level = LogLevel::Info;
	std::string Message = "";
	std::chrono::system_clock::time_point Time;
};