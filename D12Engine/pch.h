#pragma once

#ifndef NOMINMAX
#define NOMINMAX
#endif

#include <Windows.h>

#include "DirectX-Headers\d3dx12.h"
#include <dxgi1_5.h>				//For DXGI Interfaces
#include <WRL.h>					//For ComPtr
#include <windowsX.h>				// GET_X_LPARAM(), GET_Y_LPARAM()
#include <d3dcompiler.h>
#include <DirectXMath.h>
#include <DirectXPackedVector.h>
#include <DirectXColors.h>
#include <DirectXCollision.h>
#include <memory>
#include <algorithm>
#include <string>
#include <vector>
#include <array>
#include <unordered_map>
#include <cstdint>
#include <sstream>
#include <fstream>
#include <cassert>
#include <cfloat>
#include <cmath>
#include <utility>

#include "imgui.h"
#include "imgui_impl_dx12.h"
#include "imgui_impl_win32.h"

#include "DDSTextureLoader\DDSTextureLoader12.h"