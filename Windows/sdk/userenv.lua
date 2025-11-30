local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
BOOL CreateEnvironmentBlock(void** lpEnvironment, HANDLE hToken, BOOL bInherit);
BOOL DestroyEnvironmentBlock(void* lpEnvironment);
]]

return ffi.load("userenv")
