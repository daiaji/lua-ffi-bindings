local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    /* Existing API */
    void PostQuitMessage(int nExitCode);
    int MessageBoxA(HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, unsigned int uType);

    /* --- [FIX] Constants for ShowWindow (SW_*) --- */
    static const int SW_HIDE = 0;
    static const int SW_SHOWNORMAL = 1;
    static const int SW_SHOWMINIMIZED = 2;
    static const int SW_SHOWMAXIMIZED = 3;
    static const int SW_SHOWNOACTIVATE = 4;
    static const int SW_SHOW = 5;
    static const int SW_MINIMIZE = 6;
    static const int SW_SHOWMINNOACTIVE = 7;
    static const int SW_SHOWNA = 8;
    static const int SW_RESTORE = 9;
    static const int SW_SHOWDEFAULT = 10;
    static const int SW_FORCEMINIMIZE = 11;

    /* Message Pump API */
    typedef struct tagPOINT {
        LONG x;
        LONG y;
    } POINT;

    typedef struct tagMSG {
        HWND hwnd;
        UINT message;
        WPARAM wParam;
        LPARAM lParam;
        DWORD time;
        POINT pt;
        DWORD lPrivate;
    } MSG, *PMSG;

    DWORD MsgWaitForMultipleObjects(DWORD nCount, const HANDLE *pHandles, BOOL fWaitAll, DWORD dwMilliseconds, DWORD dwWakeMask);
    BOOL PeekMessageW(PMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax, UINT wRemoveMsg);
    BOOL TranslateMessage(const MSG *lpMsg);
    LONG DispatchMessageW(const MSG *lpMsg);

    /* Window Enumeration & Messages */
    typedef BOOL (__stdcall *WNDENUMPROC)(HWND, LPARAM);

    BOOL EnumWindows(WNDENUMPROC lpEnumFunc, LPARAM lParam);
    DWORD GetWindowThreadProcessId(HWND hWnd, DWORD* lpdwProcessId);
    BOOL IsWindowVisible(HWND hWnd);
    BOOL PostMessageW(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);

    static const UINT WM_CLOSE = 0x0010;

    /* Keyboard / Hotkeys */
    short VkKeyScanW(WCHAR ch);

    /* Global Hotkeys */
    BOOL RegisterHotKey(HWND hWnd, int id, UINT fsModifiers, UINT vk);
    BOOL UnregisterHotKey(HWND hWnd, int id);

    /* Constants for Modifiers */
    static const UINT MOD_ALT = 0x0001;
    static const UINT MOD_CONTROL = 0x0002;
    static const UINT MOD_SHIFT = 0x0004;
    static const UINT MOD_WIN = 0x0008;
    static const UINT MOD_NOREPEAT = 0x4000;
]]

return ffi.load("user32")
