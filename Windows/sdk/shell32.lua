local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'
-- 引入 kernel32 以使用 LocalFree 和 WideCharToMultiByte
local kernel32 = require 'ffi.req' 'Windows.sdk.kernel32'

ffi.cdef[[
    LPWSTR* CommandLineToArgvW(LPCWSTR lpCmdLine, int* pNumArgs);
    LPCWSTR GetCommandLineW(void);
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