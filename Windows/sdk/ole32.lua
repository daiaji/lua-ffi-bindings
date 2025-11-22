local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef[[
    HRESULT CoInitialize(void* pvReserved);
]]

return ffi.load("ole32")