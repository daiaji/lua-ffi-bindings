local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    HRESULT RegInstallW(HMODULE hMod, LPCWSTR pszSection, const void* pstTable);
]]

return ffi.load("advpack")
