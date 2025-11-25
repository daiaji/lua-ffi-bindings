local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'
-- 引入 kernel32 以使用 LocalFree 和 WideCharToMultiByte
local kernel32 = require 'ffi.req' 'Windows.sdk.kernel32'

ffi.cdef[[
    LPWSTR* CommandLineToArgvW(LPCWSTR lpCmdLine, int* pNumArgs);
    LPCWSTR GetCommandLineW(void);

    /* --- ENHANCEMENTS START --- */
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

    // COM Interfaces for Shortcuts (IShellLinkW)
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
    /* --- ENHANCEMENTS END --- */
]]

local lib = ffi.load("shell32")

-- 辅助函数：将 Lua 字符串(UTF8)转为 WCHAR*
local function to_wide(str)
    if not str then return nil end
    local CP_UTF8 = 65001
    local len = kernel32.MultiByteToWideChar(CP_UTF8, 0, str, -1, nil, 0)
    if len == 0 then return nil end
    local buf = ffi.new("wchar_t[?]", len)
    kernel32.MultiByteToWideChar(CP_UTF8, 0, str, -1, buf, len)
    return buf
end

-- 辅助函数：将 WCHAR* 转为 Lua 字符串(UTF8)
local function from_wide(wstr)
    if wstr == nil then return nil end
    local CP_UTF8 = 65001
    local len = kernel32.WideCharToMultiByte(CP_UTF8, 0, wstr, -1, nil, 0, nil, nil)
    if len == 0 then return nil end
    local buf = ffi.new("char[?]", len)
    kernel32.WideCharToMultiByte(CP_UTF8, 0, wstr, -1, buf, len, nil, nil)
    return ffi.string(buf)
end

local M = {
    lib = lib,
    
    ---
    -- 将命令行字符串解析为参数数组
    -- @param cmd_line string: 完整的命令行字符串 (UTF-8)
    -- @return table|nil, string: 成功时返回 table，失败返回 nil, err
    commandline_to_argv = function(cmd_line)
        if not cmd_line or cmd_line == "" then return {} end

        local argc_ptr = ffi.new("int[1]")
        local w_cmd_line = to_wide(cmd_line)
        
        -- 调用 API
        local argv_w = lib.CommandLineToArgvW(w_cmd_line, argc_ptr)
        
        if argv_w == nil then
            return nil, "CommandLineToArgvW failed"
        end

        local argc = argc_ptr[0]
        local result = {}
        
        -- 遍历转换结果
        for i = 0, argc - 1 do
            result[i + 1] = from_wide(argv_w[i])
        end

        -- 释放 Windows 分配的内存
        kernel32.LocalFree(argv_w)
        
        return result
    end,

    -- 获取系统当前的命令行参数（UTF-8 格式）
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

-- 通过 metatable 让 M 可以像 ffi.load 的返回值一样直接被调用 API
return setmetatable(M, { __index = lib })