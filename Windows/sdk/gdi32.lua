local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef[[
    int AddFontResourceExW(LPCWSTR name, DWORD fl, PVOID res);
    BOOL RemoveFontResourceExW(LPCWSTR name, DWORD fl, PVOID res);
]]

return ffi.load("gdi32")