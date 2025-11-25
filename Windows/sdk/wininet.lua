local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef[[
    typedef void* HINTERNET;
    HINTERNET InternetOpenW(LPCWSTR lpszAgent, DWORD dwAccessType, LPCWSTR lpszProxy, LPCWSTR lpszProxyBypass, DWORD dwFlags);
    HINTERNET InternetOpenUrlW(HINTERNET hInternet, LPCWSTR lpszUrl, LPCWSTR lpszHeaders, DWORD dwHeadersLength, DWORD dwFlags, ULONG_PTR dwContext);
    BOOL InternetReadFile(HINTERNET hFile, void* lpBuffer, DWORD dwNumberOfBytesToRead, DWORD* lpdwNumberOfBytesRead);
    BOOL InternetCloseHandle(HINTERNET hInternet);
]]

return ffi.load("wininet")