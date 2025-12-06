local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'
local kernel32 = require 'ffi.req' 'Windows.sdk.kernel32'

ffi.cdef [[
    LPWSTR* CommandLineToArgvW(LPCWSTR lpCmdLine, int* pNumArgs);
    LPCWSTR GetCommandLineW(void);

    /* --- File Operation Constants --- */
    static const UINT FO_MOVE = 0x0001;
    static const UINT FO_COPY = 0x0002;
    static const UINT FO_DELETE = 0x0003;
    static const UINT FO_RENAME = 0x0004;

    static const UINT FOF_MULTIDESTFILES = 0x0001;
    static const UINT FOF_CONFIRMMOUSE = 0x0002;
    static const UINT FOF_SILENT = 0x0004;
    static const UINT FOF_RENAMEONCOLLISION = 0x0008;
    static const UINT FOF_NOCONFIRMATION = 0x0010;
    static const UINT FOF_WANTMAPPINGHANDLE = 0x0020;
    static const UINT FOF_ALLOWUNDO = 0x0040;
    static const UINT FOF_FILESONLY = 0x0080;
    static const UINT FOF_SIMPLEPROGRESS = 0x0100;
    static const UINT FOF_NOCONFIRMMKDIR = 0x0200;
    static const UINT FOF_NOERRORUI = 0x0400;

    // Shell File Operations
    typedef struct _SHFILEOPSTRUCTW {
        HWND hwnd;
        UINT wFunc;
        LPCWSTR pFrom;
        LPCWSTR pTo;
        WORD fFlags;
        BOOL fAnyOperationsAborted;
        void* hNameMappings;
        LPCWSTR lpszProgressTitle;
    } SHFILEOPSTRUCTW;

    int SHFileOperationW(SHFILEOPSTRUCTW* lpFileOp);

    /* --- [FIX] Moved from user32.lua (Correct DLL) --- */
    void SHChangeNotify(LONG wEventId, UINT uFlags, LPCVOID dwItem1, LPCVOID dwItem2);

    // Browse Folder
    typedef int (__stdcall *BFFCALLBACK)(HWND, UINT, LPARAM, LPARAM);
    typedef struct _SHITEMID { WORD cb; BYTE abID[1]; } SHITEMID;
    typedef struct _ITEMIDLIST { SHITEMID mkid; } ITEMIDLIST;
    typedef ITEMIDLIST* LPITEMIDLIST;
    typedef const ITEMIDLIST* LPCITEMIDLIST;

    typedef struct _BROWSEINFOW {
        HWND hwndOwner;
        LPCITEMIDLIST pidlRoot;
        LPWSTR pszDisplayName;
        LPCWSTR lpszTitle;
        UINT ulFlags;
        BFFCALLBACK lpfn;
        LPARAM lParam;
        int iImage;
    } BROWSEINFOW;

    LPITEMIDLIST SHBrowseForFolderW(BROWSEINFOW* lpbi);
    BOOL SHGetPathFromIDListW(LPCITEMIDLIST pidl, LPWSTR pszPath);
    void CoTaskMemFree(void* pv);

    // COM Interfaces for Shortcuts
    typedef struct IShellLinkWVtbl {
        HRESULT (__stdcall *QueryInterface)(void* This, const IID* riid, void** ppvObject);
        ULONG (__stdcall *AddRef)(void* This);
        ULONG (__stdcall *Release)(void* This);
        HRESULT (__stdcall *GetPath)(void* This, LPWSTR pszFile, int cch, void* pfd, DWORD fFlags);
        HRESULT (__stdcall *GetIDList)(void* This, LPITEMIDLIST* ppidl);
        HRESULT (__stdcall *SetIDList)(void* This, LPCITEMIDLIST pidl);
        HRESULT (__stdcall *GetDescription)(void* This, LPWSTR pszName, int cch);
        HRESULT (__stdcall *SetDescription)(void* This, LPCWSTR pszName);
        HRESULT (__stdcall *GetWorkingDirectory)(void* This, LPWSTR pszDir, int cch);
        HRESULT (__stdcall *SetWorkingDirectory)(void* This, LPCWSTR pszDir);
        HRESULT (__stdcall *GetArguments)(void* This, LPWSTR pszArgs, int cch);
        HRESULT (__stdcall *SetArguments)(void* This, LPCWSTR pszArgs);
        HRESULT (__stdcall *GetHotkey)(void* This, WORD* pwHotkey);
        HRESULT (__stdcall *SetHotkey)(void* This, WORD wHotkey);
        HRESULT (__stdcall *GetShowCmd)(void* This, int* piShowCmd);
        HRESULT (__stdcall *SetShowCmd)(void* This, int iShowCmd);
        HRESULT (__stdcall *GetIconLocation)(void* This, LPWSTR pszIconPath, int cch, int* piIcon);
        HRESULT (__stdcall *SetIconLocation)(void* This, LPCWSTR pszIconPath, int iIcon);
        HRESULT (__stdcall *SetRelativePath)(void* This, LPCWSTR pszPathRel, DWORD dwReserved);
        HRESULT (__stdcall *Resolve)(void* This, HWND hwnd, DWORD fFlags);
        HRESULT (__stdcall *SetPath)(void* This, LPCWSTR pszFile);
    } IShellLinkWVtbl;
    typedef struct { IShellLinkWVtbl* lpVtbl; } IShellLinkW;

    typedef struct IPersistFileVtbl {
        HRESULT (__stdcall *QueryInterface)(void* This, const IID* riid, void** ppvObject);
        ULONG (__stdcall *AddRef)(void* This);
        ULONG (__stdcall *Release)(void* This);
        HRESULT (__stdcall *GetClassID)(void* This, CLSID* pClassID);
        HRESULT (__stdcall *IsDirty)(void* This);
        HRESULT (__stdcall *Load)(void* This, LPCWSTR pszFileName, DWORD dwMode);
        HRESULT (__stdcall *Save)(void* This, LPCWSTR pszFileName, BOOL fRemember);
        HRESULT (__stdcall *SaveCompleted)(void* This, LPCWSTR pszFileName);
        HRESULT (__stdcall *GetCurFile)(void* This, LPWSTR* ppszFileName);
    } IPersistFileVtbl;
    typedef struct { IPersistFileVtbl* lpVtbl; } IPersistFile;

    typedef struct _SHELLEXECUTEINFOW {
        DWORD     cbSize;
        ULONG     fMask;
        HWND      hwnd;
        LPCWSTR   lpVerb;
        LPCWSTR   lpFile;
        LPCWSTR   lpParameters;
        LPCWSTR   lpDirectory;
        int       nShow;
        HINSTANCE hInstApp;
        void      *lpIDList;
        LPCWSTR   lpClass;
        HKEY      hkeyClass;
        DWORD     dwHotKey;
        union {
            HANDLE hIcon;
            HANDLE hMonitor;
        } DUMMYUNIONNAME;
        HANDLE    hProcess;
    } SHELLEXECUTEINFOW;
    
    BOOL ShellExecuteExW(SHELLEXECUTEINFOW *pExecInfo);
]]

local lib = ffi.load("shell32")

local function to_wide(str)
    if not str then return nil end
    local CP_UTF8 = 65001
    local len = kernel32.MultiByteToWideChar(CP_UTF8, 0, str, -1, nil, 0)
    if len == 0 then return nil end
    local buf = ffi.new("wchar_t[?]", len)
    kernel32.MultiByteToWideChar(CP_UTF8, 0, str, -1, buf, len)
    return buf
end

local function from_wide(wstr)
    if wstr == nil then return nil end
    local CP_UTF8 = 65001
    local len = kernel32.WideCharToMultiByte(CP_UTF8, 0, wstr, -1, nil, 0, nil, nil)
    if len == 0 then return nil end
    local buf = ffi.new("char[?]", len)
    kernel32.WideCharToMultiByte(CP_UTF8, 0, wstr, -1, buf, len, nil, nil)
    return ffi.string(buf)
end

-- [MOVED] ShellLink GUIDs
local M = {
    lib = lib,

    CLSID_ShellLink = ffi.new("GUID", { 0x00021401, 0, 0, { 0xC0, 0, 0, 0, 0, 0, 0, 0x46 } }),
    IID_IShellLinkW = ffi.new("GUID", { 0x000214F9, 0, 0, { 0xC0, 0, 0, 0, 0, 0, 0, 0x46 } }),
    IID_IPersistFile = ffi.new("GUID", { 0x0000010b, 0, 0, { 0xC0, 0, 0, 0, 0, 0, 0, 0x46 } }),

    commandline_to_argv = function(cmd_line)
        if not cmd_line or cmd_line == "" then return {} end
        local argc_ptr = ffi.new("int[1]")
        local w_cmd_line = to_wide(cmd_line)
        local argv_w = lib.CommandLineToArgvW(w_cmd_line, argc_ptr)
        if argv_w == nil then return nil, "CommandLineToArgvW failed" end
        local argc = argc_ptr[0]
        local result = {}
        for i = 0, argc - 1 do
            result[i + 1] = from_wide(argv_w[i])
        end
        kernel32.LocalFree(argv_w)
        return result
    end,

    get_arguments = function()
        local cmd_line_w = ffi.C.GetCommandLineW()
        local argc_ptr = ffi.new("int[1]")
        local argv_w = lib.CommandLineToArgvW(cmd_line_w, argc_ptr)
        if argv_w == nil then return nil end
        local argc = argc_ptr[0]
        local result = {}
        for i = 0, argc - 1 do
            result[i + 1] = from_wide(argv_w[i])
        end
        kernel32.LocalFree(argv_w)
        return result
    end
}

return setmetatable(M, { __index = lib })