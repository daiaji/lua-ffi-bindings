local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    typedef struct _VS_FIXEDFILEINFO {
        DWORD dwSignature; DWORD dwStrucVersion;
        DWORD dwFileVersionMS; DWORD dwFileVersionLS;
        DWORD dwProductVersionMS; DWORD dwProductVersionLS;
        DWORD dwFileFlagsMask; DWORD dwFileFlags;
        DWORD dwFileOS; DWORD dwFileType; DWORD dwFileSubtype;
        DWORD dwFileDateMS; DWORD dwFileDateLS;
    } VS_FIXEDFILEINFO;

    DWORD GetFileVersionInfoSizeW(LPCWSTR lptstrFilename, DWORD* lpdwHandle);
    BOOL GetFileVersionInfoW(LPCWSTR lptstrFilename, DWORD dwHandle, DWORD dwLen, void* lpData);
    BOOL VerQueryValueW(const void* pBlock, LPCWSTR lpSubBlock, void** lplpBuffer, UINT* puLen);
]]

return ffi.load("version")
