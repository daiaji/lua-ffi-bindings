local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    /* --- Constants for InternetOpen --- */
    static const DWORD INTERNET_OPEN_TYPE_PRECONFIG = 0;
    static const DWORD INTERNET_OPEN_TYPE_DIRECT = 1;
    static const DWORD INTERNET_OPEN_TYPE_PROXY = 3;

    /* --- Constants for InternetOpenUrl --- */
    static const DWORD INTERNET_FLAG_RELOAD = 0x80000000;
    static const DWORD INTERNET_FLAG_NO_CACHE_WRITE = 0x04000000;
    static const DWORD INTERNET_FLAG_SECURE = 0x00800000;

    /* --- Constants for InternetSetOption --- */
    static const DWORD INTERNET_OPTION_CONNECT_TIMEOUT = 2;
    static const DWORD INTERNET_OPTION_SEND_TIMEOUT = 5;
    static const DWORD INTERNET_OPTION_RECEIVE_TIMEOUT = 6;

    typedef void* HINTERNET;
    HINTERNET InternetOpenW(LPCWSTR lpszAgent, DWORD dwAccessType, LPCWSTR lpszProxy, LPCWSTR lpszProxyBypass, DWORD dwFlags);
    HINTERNET InternetOpenUrlW(HINTERNET hInternet, LPCWSTR lpszUrl, LPCWSTR lpszHeaders, DWORD dwHeadersLength, DWORD dwFlags, ULONG_PTR dwContext);
    BOOL InternetReadFile(HINTERNET hFile, void* lpBuffer, DWORD dwNumberOfBytesToRead, DWORD* lpdwNumberOfBytesRead);
    BOOL InternetCloseHandle(HINTERNET hInternet);
    
    /* --- ENHANCEMENTS --- */
    BOOL InternetSetOptionW(HINTERNET hInternet, DWORD dwOption, void* lpBuffer, DWORD dwBufferLength);
]]

return ffi.load("wininet")