local ffi = require 'ffi'
-- stddef provides size_t, ptrdiff_t which represent pointer-sized integers
require 'ffi.req' 'c.stddef' 

ffi.cdef[[
/* MinWinDef.h Basic Types */
typedef unsigned long DWORD;
typedef int BOOL;
typedef unsigned char BYTE;
typedef unsigned short WORD;
typedef float FLOAT;
typedef void* HANDLE;
typedef void* HINSTANCE;
typedef void* HMODULE;
typedef void* HWND;
typedef void* HLOCAL;
typedef long HRESULT;

/* Integer Types */
typedef unsigned int UINT;
typedef int INT;
typedef void* PVOID;
typedef void* LPVOID;

typedef unsigned long ULONG;
typedef unsigned short USHORT;
typedef long LONG;
typedef unsigned long long ULONGLONG;
typedef long long LONGLONG;

/* Pointer Sized Types (Critical for x64/x86 compatibility) */
/* LuaJIT provides size_t and ptrdiff_t via built-in types or c.stddef */
typedef size_t ULONG_PTR;
typedef ptrdiff_t LONG_PTR;
typedef size_t UINT_PTR;
typedef ptrdiff_t INT_PTR;

/* Message Parameters */
typedef UINT_PTR WPARAM;
typedef LONG_PTR LPARAM;
typedef LONG_PTR LRESULT;

/* WinNT.h Strings */
typedef wchar_t* LPTSTR;
typedef const wchar_t* LPCWSTR;
typedef char* LPSTR;
typedef const char* LPCSTR;
typedef unsigned char BOOLEAN;
typedef wchar_t* LPWSTR; 
typedef wchar_t WCHAR;

/* --- ENHANCEMENTS START --- */

/* 64-bit Integer Unions (Essential for Disk/File Sizes) */
typedef union _LARGE_INTEGER {
    struct {
        DWORD LowPart;
        LONG HighPart;
    } u;
    LONGLONG QuadPart;
} LARGE_INTEGER, *PLARGE_INTEGER;

typedef union _ULARGE_INTEGER {
    struct {
        DWORD LowPart;
        DWORD HighPart;
    } u;
    ULONGLONG QuadPart;
} ULARGE_INTEGER, *PULARGE_INTEGER;

/* Time Structures (Essential for Registry/File timestamps) */
typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;

typedef struct _SYSTEMTIME {
    WORD wYear;
    WORD wMonth;
    WORD wDayOfWeek;
    WORD wDay;
    WORD wHour;
    WORD wMinute;
    WORD wSecond;
    WORD wMilliseconds;
} SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;

/* GUID/UUID Support (Essential for COM/ShellLink) */
typedef struct _GUID {
    unsigned long  Data1;
    unsigned short Data2;
    unsigned short Data3;
    unsigned char  Data4[8];
} GUID;
typedef GUID IID;
typedef GUID CLSID;
typedef const GUID* REFGUID;
typedef const IID* REFIID;
typedef const CLSID* REFCLSID;

/* --- ENHANCEMENTS END --- */
]]

return ffi.C