local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef[[
    typedef struct _FBWF_CACHE_DETAIL {
        unsigned long  cacheSize;
        unsigned long  openFiles;
        unsigned long  flags;
    } FBWF_CACHE_DETAIL, *PFBWF_CACHE_DETAIL;

    unsigned long FbwfEnableFilter();
    unsigned long FbwfDisableFilter();
    unsigned long FbwfSetThreshold(unsigned long threshold); // Bytes
    unsigned long FbwfGetThreshold(unsigned long* threshold);
    unsigned long FbwfProtectVolume(const wchar_t* volume, unsigned long reserved);
    unsigned long FbwfUnprotectVolume(const wchar_t* volume);
    unsigned long FbwfAddExclusion(const wchar_t* volume, const wchar_t* path);
    unsigned long FbwfRemoveExclusion(const wchar_t* volume, const wchar_t* path);
    unsigned long FbwfCommitFile(const wchar_t* path);
    unsigned long FbwfRestoreFile(const wchar_t* path);
    unsigned long FbwfGetCacheDetail(PFBWF_CACHE_DETAIL detail);
]]

-- Usually provided by fbwflib.dll in WinPE
return ffi.load("fbwflib")