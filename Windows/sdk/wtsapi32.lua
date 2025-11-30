local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
BOOL WTSQueryUserToken(ULONG SessionId, HANDLE *phToken);
]]

return ffi.load("wtsapi32")
