local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    HRESULT CoInitialize(void* pvReserved);

    /* --- ENHANCEMENTS --- */
    void CoUninitialize(void);

    /* Creating Instances */
    /* rclsid: Class ID, pUnkOuter: Aggregate, dwClsContext: Execution Context */
    HRESULT CoCreateInstance(const CLSID* rclsid, void* pUnkOuter, DWORD dwClsContext, const IID* riid, void** ppv);
]]

return ffi.load("ole32")
