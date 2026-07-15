#include "pch.h"
#include "GlobalInputHandler.h"

GlobalInputHandler::GlobalInputHandler()
{
}

void GlobalInputHandler::ProcessGlobalShortcuts(const InputSystem& input)
{
	if (input.IsKeyDown(VK_ESCAPE))
		::PostQuitMessage(0);
}
