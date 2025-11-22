local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef[[
    /* Existing API */
    void PostQuitMessage(int nExitCode);
    int MessageBoxA(HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, unsigned int uType);

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

    /* Window Enumeration & Messages (Added for Graceful Termination) */
    typedef BOOL (__stdcall *WNDENUMPROC)(HWND, LPARAM);
    
    BOOL EnumWindows(WNDENUMPROC lpEnumFunc, LPARAM lParam);
    DWORD GetWindowThreadProcessId(HWND hWnd, DWORD* lpdwProcessId);
    BOOL IsWindowVisible(HWND hWnd);
    BOOL PostMessageW(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
    
    static const UINT WM_CLOSE = 0x0010;
]]

return ffi.load("user32")