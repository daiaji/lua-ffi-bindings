local ffi = require 'ffi'
-- [FIX] Ensure standard C types are available
require 'ffi.req' 'c.stddef'
require 'ffi.req' 'c.stdint'

ffi.cdef [[
/* --- Basic Types --- */
typedef unsigned long DWORD;
typedef int BOOL;
typedef unsigned char BYTE;
typedef unsigned short WORD;
typedef float FLOAT;
typedef int INT;
typedef unsigned int UINT;

/* --- BaseTsd.h Fixed-Width Types (Fixes iphlpapi UINT8 errors) --- */
typedef signed char         INT8, *PINT8;
typedef short               INT16, *PINT16;
typedef int                 INT32, *PINT32;
typedef __int64             INT64, *PINT64;
typedef unsigned char       UINT8, *PUINT8;
typedef unsigned short      UINT16, *PUINT16;
typedef unsigned int        UINT32, *PUINT32;
typedef unsigned __int64    UINT64, *PUINT64;

/* --- Extended Integers --- */
typedef unsigned long ULONG;
typedef unsigned short USHORT;
typedef long LONG;
typedef unsigned long long ULONGLONG;
typedef long long LONGLONG;
typedef unsigned long long DWORD64;

/* --- Pointers & Handles --- */
typedef void* HANDLE;
typedef HANDLE *PHANDLE;
typedef HANDLE *LPHANDLE;
typedef void* HINSTANCE;
typedef void* HMODULE;
typedef void* HWND;
typedef void* HLOCAL;
typedef void* HKEY;
typedef void* PVOID;
typedef void* LPVOID; 
typedef const void *LPCVOID; /* [FIX] Added LPCVOID for user32/shell32 APIs */
typedef void* PSID;

/* --- Status & Security Types --- */
/* [FIX] Moved NTSTATUS here to prevent dependency loops between ntdll/ntext */
typedef LONG NTSTATUS;
typedef NTSTATUS *PNTSTATUS;

/* [FIX] Added missing security types for ntdll/ntext */
typedef DWORD ACCESS_MASK;
typedef ACCESS_MASK *PACCESS_MASK;
typedef DWORD SECURITY_INFORMATION;
typedef SECURITY_INFORMATION *PSECURITY_INFORMATION;
typedef PVOID PSECURITY_DESCRIPTOR; /* [FIX] Centralized here */

/* --- Return Codes --- */
typedef LONG HRESULT;

/* --- Pointers to Integers --- */
typedef DWORD *PDWORD;
typedef DWORD *LPDWORD;
typedef ULONG *PULONG;
typedef USHORT *PUSHORT;
typedef unsigned char *PBYTE;
typedef unsigned char *LPBYTE;

/* --- Pointer-Sized Integers --- */
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

/* --- Strings (ANSI/Wide/Generic) (Fixes PCHAR errors) --- */
typedef char CHAR;
typedef char *PCHAR;
typedef char *LPSTR;
typedef char *PSTR;
typedef const char *LPCSTR;
typedef const char *PCSTR;

typedef wchar_t WCHAR;
typedef wchar_t *PWCHAR;
typedef wchar_t *LPWSTR;
typedef wchar_t *PWSTR;
typedef wchar_t *LPTSTR;
typedef const wchar_t *LPCWSTR;
typedef const wchar_t *PCWSTR;

typedef unsigned char UCHAR;
typedef unsigned char *PUCHAR;
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

/* --- IO Counters (Centralized Definition) --- */
typedef struct _IO_COUNTERS {
    ULONGLONG ReadOperationCount;
    ULONGLONG WriteOperationCount;
    ULONGLONG OtherOperationCount;
    ULONGLONG ReadTransferCount;
    ULONGLONG WriteTransferCount;
    ULONGLONG OtherTransferCount;
} IO_COUNTERS;
]]

return ffi.C