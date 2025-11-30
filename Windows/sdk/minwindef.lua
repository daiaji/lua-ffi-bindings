local ffi = require 'ffi'
-- stddef provides size_t, ptrdiff_t which represent pointer-sized integers
require 'ffi.req' 'c.stddef'

ffi.cdef [[
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
typedef void* HKEY;

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

/* Pointer Sized Types */
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

/* 64-bit Integer Unions */
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

/* Time Structures */
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

/* GUID/UUID Support */
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

/* --- [MOVED] Registry Constants (From winnt.h) --- */
static const DWORD REG_NONE = 0;
static const DWORD REG_SZ = 1;
static const DWORD REG_EXPAND_SZ = 2;
static const DWORD REG_BINARY = 3;
static const DWORD REG_DWORD = 4;
static const DWORD REG_DWORD_LITTLE_ENDIAN = 4;
static const DWORD REG_DWORD_BIG_ENDIAN = 5;
static const DWORD REG_LINK = 6;
static const DWORD REG_MULTI_SZ = 7;
static const DWORD REG_RESOURCE_LIST = 8;
static const DWORD REG_FULL_RESOURCE_DESCRIPTOR = 9;
static const DWORD REG_RESOURCE_REQUIREMENTS_LIST = 10;
static const DWORD REG_QWORD = 11;
static const DWORD REG_QWORD_LITTLE_ENDIAN = 11;
]]

return ffi.C
