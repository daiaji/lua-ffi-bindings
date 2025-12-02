local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    BOOL DnsFlushResolverCache();
]]

return ffi.load("dnsapi")