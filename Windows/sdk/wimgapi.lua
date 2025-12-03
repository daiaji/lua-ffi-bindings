local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    /* --- Handle Types --- */
    typedef void* WIM_HANDLE;

    /* --- Constants & Flags --- */
    /* Access Rights */
    static const DWORD WIM_GENERIC_READ  = 0x80000000;
    static const DWORD WIM_GENERIC_WRITE = 0x40000000;
    static const DWORD WIM_GENERIC_MOUNT = 0x20000000;

    /* Creation Disposition */
    static const DWORD WIM_CREATE_NEW        = 1;
    static const DWORD WIM_CREATE_ALWAYS     = 2;
    static const DWORD WIM_OPEN_EXISTING     = 3;
    static const DWORD WIM_OPEN_ALWAYS       = 4;

    /* Flags for WIMCreateFile */
    static const DWORD WIM_FLAG_VERIFY       = 0x00000002;
    static const DWORD WIM_FLAG_INDEX        = 0x00000004;

    /* Flags for WIMMountImageHandle */
    static const DWORD WIM_FLAG_MOUNT_READWRITE = 0x00000200;
    static const DWORD WIM_FLAG_MOUNT_READONLY  = 0x00000100;

    /* --- Structures --- */
    typedef struct _WIM_MOUNT_INFO_LEVEL1 {
        WCHAR WimPath[260];
        WCHAR MountPath[260];
        DWORD ImageIndex;
        DWORD MountFlags;
    } WIM_MOUNT_INFO_LEVEL1, *PWIM_MOUNT_INFO_LEVEL1;

    /* --- APIs --- */
    WIM_HANDLE WIMCreateFile(
        LPCWSTR WimPath,
        DWORD   DesiredAccess,
        DWORD   CreationDisposition,
        DWORD   FlagsAndAttributes,
        DWORD   CompressionType,
        PDWORD  CreationResult
    );

    BOOL WIMCloseHandle(WIM_HANDLE hObject);

    BOOL WIMSetTemporaryPath(
        WIM_HANDLE hWim,
        LPCWSTR    pszPath
    );

    WIM_HANDLE WIMLoadImage(
        WIM_HANDLE hWim,
        DWORD      dwImageIndex
    );

    /* 
       Note: We use WIMMountImageHandle instead of WIMMountImage 
       because it allows explicit control over flags (RW/RO) via a handle 
       that has been configured (e.g. with SetTemporaryPath).
    */
    BOOL WIMMountImageHandle(
        WIM_HANDLE hImage,
        LPCWSTR    pszMountPath,
        DWORD      dwMountFlags
    );

    BOOL WIMUnmountImage(
        LPCWSTR pszMountPath,
        LPCWSTR pszWimFileName, /* Optional */
        DWORD   dwImageIndex,   /* Optional */
        BOOL    bCommit
    );

    BOOL WIMGetMountedImageInfo(
        DWORD  dwInfoLevel,
        PDWORD pdwImageCount,
        PVOID  pMountInfo,
        DWORD  cbMountInfoLength,
        PDWORD pdwReturnLength
    );
]]

-- Load wimgapi.dll explicitly
-- On some minimal PE systems, this might be in a different path, 
-- but usually it's in System32.
local M = ffi.load("wimgapi")

return M