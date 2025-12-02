local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    /* --- Constants --- */
    typedef enum tagCLSCTX {
        CLSCTX_INPROC_SERVER   = 0x1,
        CLSCTX_INPROC_HANDLER  = 0x2,
        CLSCTX_LOCAL_SERVER    = 0x4,
        CLSCTX_INPROC_SERVER16 = 0x8,
        CLSCTX_REMOTE_SERVER   = 0x10,
        CLSCTX_INPROC_HANDLER16= 0x20,
        CLSCTX_NO_CODE_DOWNLOAD= 0x400,
        CLSCTX_NO_CUSTOM_MARSHAL= 0x1000,
        CLSCTX_ENABLE_CODE_DOWNLOAD= 0x2000,
        CLSCTX_NO_FAILURE_LOG  = 0x4000,
        CLSCTX_DISABLE_AAA     = 0x8000,
        CLSCTX_ENABLE_AAA      = 0x10000,
        CLSCTX_FROM_DEFAULT_CONTEXT= 0x20000,
        CLSCTX_INPROC          = (CLSCTX_INPROC_SERVER|CLSCTX_INPROC_HANDLER),
        CLSCTX_SERVER          = (CLSCTX_INPROC_SERVER|CLSCTX_LOCAL_SERVER|CLSCTX_REMOTE_SERVER),
        CLSCTX_ALL             = (CLSCTX_SERVER|CLSCTX_INPROC_HANDLER)
    } CLSCTX;

    /* CoInitializeEx Flags */
    static const DWORD COINIT_APARTMENTTHREADED = 0x2;
    static const DWORD COINIT_MULTITHREADED     = 0x0;
    static const DWORD COINIT_DISABLE_OLE1DDE   = 0x4;
    static const DWORD COINIT_SPEED_OVER_MEMORY = 0x8;

    HRESULT CoInitialize(void* pvReserved);
    HRESULT CoInitializeEx(void* pvReserved, DWORD dwCoInit);
    void CoUninitialize(void);

    HRESULT CoCreateInstance(const CLSID* rclsid, void* pUnkOuter, DWORD dwClsContext, const IID* riid, void** ppv);
    void CoTaskMemFree(void* pv);
    
    HRESULT CoCreateGuid(GUID* pguid);
]]

return ffi.load("ole32")