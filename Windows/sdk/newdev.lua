local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

-- [Guideline #11] Windows types safety check
-- [Guideline #3] Explicit library loading

ffi.cdef [[
    /* --- Constants --- */
    static const DWORD INSTALLFLAG_FORCE          = 0x00000001;
    static const DWORD INSTALLFLAG_READONLY       = 0x00000002;
    static const DWORD INSTALLFLAG_NONINTERACTIVE = 0x00000004;
    static const DWORD INSTALLFLAG_BITS           = 0x00000007;

    /* 
       DiInstallDriverW 
       Pre-install / Install driver package 
       Equivalent to right-clicking an INF and selecting "Install".
    */
    BOOL DiInstallDriverW(
        HWND hwndParent,
        LPCWSTR FullInfPath,
        DWORD Flags,
        BOOL* NeedReboot
    );

    /* 
       UpdateDriverForPlugAndPlayDevicesW 
       Force install driver for specific HWID 
       This is the core API used by Snappy Driver Installer for precise driver injection.
    */
    BOOL UpdateDriverForPlugAndPlayDevicesW(
        HWND hwndParent,
        LPCWSTR HardwareId,
        LPCWSTR FullInfPath,
        DWORD InstallFlags,
        BOOL* bRebootRequired
    );
]]

return ffi.load("newdev")