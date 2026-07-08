local ffi = require 'ffi'
local load = require 'ffi.load'

ffi.cdef [[
typedef struct ImGuiContext ImGuiContext;
typedef struct ImFontAtlas ImFontAtlas;
typedef struct ImDrawData ImDrawData;
typedef struct ID3D11Device ID3D11Device;
typedef struct ID3D11DeviceContext ID3D11DeviceContext;

typedef struct ImVec2 {
    float x;
    float y;
} ImVec2;

typedef struct ImVec4 {
    float x;
    float y;
    float z;
    float w;
} ImVec4;

const char* igGetVersion(void);
ImGuiContext* igCreateContext(ImFontAtlas* shared_font_atlas);
void igDestroyContext(ImGuiContext* ctx);
void igSetCurrentContext(ImGuiContext* ctx);
ImGuiContext* igGetCurrentContext(void);

void igNewFrame(void);
void igRender(void);
ImDrawData* igGetDrawData(void);

bool igBegin(const char* name, bool* p_open, int flags);
void igEnd(void);
void igText(const char* fmt, ...);
bool igButton(const char* label, ImVec2 size);
bool igInputText(const char* label, char* buf, size_t buf_size, int flags, void* callback, void* user_data);
void igSameLine(float offset_from_start_x, float spacing);
void igSeparator(void);
void igSetNextWindowSize(ImVec2 size, int cond);

bool ImGui_ImplWin32_Init(void* hwnd);
void ImGui_ImplWin32_Shutdown(void);
void ImGui_ImplWin32_NewFrame(void);
long ImGui_ImplWin32_WndProcHandler(void* hwnd, unsigned int msg, uintptr_t wParam, intptr_t lParam);

bool ImGui_ImplDX11_Init(ID3D11Device* device, ID3D11DeviceContext* device_context);
void ImGui_ImplDX11_Shutdown(void);
void ImGui_ImplDX11_NewFrame(void);
void ImGui_ImplDX11_RenderDrawData(ImDrawData* draw_data);
]]

return load 'cimgui'
