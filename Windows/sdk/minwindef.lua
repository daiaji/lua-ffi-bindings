local ffi = require 'ffi'
-- Ensure size_t/ptrdiff_t are available
require 'ffi.req' 'c.stddef'

ffi.cdef [[
/* --- Basic Integer Types --- */
typedef unsigned long DWORD;
typedef int BOOL;
typedef unsigned char BYTE;
typedef unsigned short WORD;
typedef float FLOAT;
typedef int INT;
typedef unsigned int UINT;

/* --- Extended Integers (Moved up for dependency resolution) --- */
typedef unsigned long ULONG;
typedef unsigned short USHORT;
typedef long LONG;
typedef unsigned long long ULONGLONG;
typedef long long LONGLONG;
typedef unsigned long long DWORD64;

/* --- Pointer Types --- */
typedef void* HANDLE;
typedef void* HINSTANCE;
typedef void* HMODULE;
typedef void* HWND;
typedef void* HLOCAL;
typedef void* HKEY;
typedef void* PVOID;
typedef void* LPVOID; 

/* --- Pointers to Integers --- */
typedef DWORD *PDWORD;
typedef DWORD *LPDWORD;
typedef ULONG *PULONG;
typedef USHORT *PUSHORT;
typedef unsigned char *PBYTE;
typedef unsigned char *LPBYTE;
typedef ULONG *PULONG;
typedef USHORT *PUSHORT;

/* --- Pointer-Sized Integers & Types --- */
typedef size_t ULONG_PTR;
typedef ptrdiff_t LONG_PTR;
typedef size_t UINT_PTR;
typedef ptrdiff_t INT_PTR;
typedef ULONG_PTR DWORD_PTR;
typedef size_t SIZE_T;
typedef ptrdiff_t SSIZE_T;

/* --- Message Params --- */
typedef UINT_PTR WPARAM;
typedef LONG_PTR LPARAM;
typedef LONG_PTR LRESULT;

/* --- Strings --- */
typedef wchar_t WCHAR;
typedef wchar_t* LPWSTR;
typedef wchar_t* LPTSTR;
typedef const wchar_t* LPCWSTR;
typedef char* LPSTR;
typedef const char* LPCSTR;
typedef WCHAR *PWSTR;
typedef unsigned char BOOLEAN;

/* --- Large Integers --- */
typedef union _LARGE_INTEGER {
    struct { DWORD LowPart; LONG HighPart; } u;
    LONGLONG QuadPart;
} LARGE_INTEGER, *PLARGE_INTEGER;

typedef union _ULARGE_INTEGER {
    struct { DWORD LowPart; DWORD HighPart; } u;
    ULONGLONG QuadPart;
} ULARGE_INTEGER, *PULARGE_INTEGER;

/* --- Time --- */
typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;

typedef struct _SYSTEMTIME {
    WORD wYear; WORD wMonth; WORD wDayOfWeek; WORD wDay;
    WORD wHour; WORD wMinute; WORD wSecond; WORD wMilliseconds;
} SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;

/* --- GUID --- */
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

/* --- Registry Constants --- */
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