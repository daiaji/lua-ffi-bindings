local ffi = require 'ffi'
require 'ffi.req' 'c.stddef'
require 'ffi.req' 'c.stdint'

ffi.cdef [[
/* --- Integers --- */
typedef unsigned long       DWORD, *PDWORD, *LPDWORD;
typedef int                 BOOL, *PBOOL, *LPBOOL;
typedef unsigned char       BYTE, *PBYTE, *LPBYTE;
typedef unsigned short      WORD, *PWORD, *LPWORD;
typedef int                 INT, *PINT, *LPINT;
typedef unsigned int        UINT, *PUINT, *LPUINT;
typedef long                LONG, *PLONG, *LPLONG;
typedef unsigned long       ULONG, *PULONG;
typedef unsigned short      USHORT, *PUSHORT;
typedef float               FLOAT;

/* --- Fixed Width --- */
typedef int8_t              INT8, *PINT8;
typedef int16_t             INT16, *PINT16;
typedef int32_t             INT32, *PINT32;
typedef int64_t             INT64, *PINT64;
typedef uint8_t             UINT8, *PUINT8;
typedef uint16_t            UINT16, *PUINT16;
typedef uint32_t            UINT32, *PUINT32;
typedef uint64_t            UINT64, *PUINT64, ULONGLONG;
typedef int64_t             LONGLONG;
typedef uint64_t            DWORD64;

/* --- Pointers & Handles --- */
typedef void                *PVOID, *LPVOID;
typedef const void          *LPCVOID;
typedef void                *HANDLE, *PHANDLE, *LPHANDLE;
typedef HANDLE              HMODULE, HINSTANCE, HKEY, HLOCAL, HWND, SC_HANDLE;
typedef void                *PSID;

/* --- Status & Security --- */
typedef LONG                NTSTATUS, *PNTSTATUS;
typedef LONG                HRESULT;
typedef DWORD               ACCESS_MASK, *PACCESS_MASK;
typedef DWORD               SECURITY_INFORMATION, *PSECURITY_INFORMATION;
typedef PVOID               PSECURITY_DESCRIPTOR;

/* --- Pointer Sizing --- */
typedef size_t              ULONG_PTR, DWORD_PTR, SIZE_T;
typedef ptrdiff_t           LONG_PTR, INT_PTR, SSIZE_T;
/* [FIX] Added UINT_PTR for winsock2 compatibility */
typedef ULONG_PTR           UINT_PTR; 
typedef ULONG_PTR           WPARAM;
typedef LONG_PTR            LPARAM, LRESULT;

/* [FIX] Pointer to Pointer Sizing Types (Critical for x64 API calls like SendMessageTimeout) */
typedef ULONG_PTR           *PULONG_PTR;
typedef DWORD_PTR           *PDWORD_PTR;
typedef LONG_PTR            *PLONG_PTR;

/* --- Strings --- */
typedef char                CHAR, *PCHAR, *LPSTR, *PSTR;
typedef const char          *LPCSTR, *PCSTR;
typedef wchar_t             WCHAR, *PWCHAR, *LPWSTR, *PWSTR, *LPTSTR;
typedef const wchar_t       *LPCWSTR, *PCWSTR;
typedef unsigned char       UCHAR, *PUCHAR, BOOLEAN;

/* --- Structures --- */
typedef union _LARGE_INTEGER {
    struct { DWORD LowPart; LONG HighPart; } u;
    LONGLONG QuadPart;
} LARGE_INTEGER, *PLARGE_INTEGER;

typedef union _ULARGE_INTEGER {
    struct { DWORD LowPart; DWORD HighPart; } u;
    ULONGLONG QuadPart;
} ULARGE_INTEGER, *PULARGE_INTEGER;

typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;

typedef struct _SYSTEMTIME {
    WORD wYear; WORD wMonth; WORD wDayOfWeek; WORD wDay;
    WORD wHour; WORD wMinute; WORD wSecond; WORD wMilliseconds;
} SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;

typedef struct _GUID {
    unsigned long  Data1;
    unsigned short Data2;
    unsigned short Data3;
    unsigned char  Data4[8];
} GUID, IID, CLSID;
typedef const GUID *REFGUID, *REFIID, *REFCLSID;

typedef struct _IO_COUNTERS {
    ULONGLONG ReadOperationCount;
    ULONGLONG WriteOperationCount;
    ULONGLONG OtherOperationCount;
    ULONGLONG ReadTransferCount;
    ULONGLONG WriteTransferCount;
    ULONGLONG OtherTransferCount;
} IO_COUNTERS;

typedef struct _LUID {
    DWORD LowPart;
    LONG HighPart;
} LUID, *PLUID;

/* --- Registry Constants --- */
static const DWORD REG_NONE                         = 0;
static const DWORD REG_SZ                           = 1;
static const DWORD REG_EXPAND_SZ                    = 2;
static const DWORD REG_BINARY                       = 3;
static const DWORD REG_DWORD                        = 4;
static const DWORD REG_DWORD_LITTLE_ENDIAN          = 4;
static const DWORD REG_DWORD_BIG_ENDIAN             = 5;
static const DWORD REG_LINK                         = 6;
static const DWORD REG_MULTI_SZ                     = 7;
static const DWORD REG_RESOURCE_LIST                = 8;
static const DWORD REG_FULL_RESOURCE_DESCRIPTOR     = 9;
static const DWORD REG_RESOURCE_REQUIREMENTS_LIST   = 10;
static const DWORD REG_QWORD                        = 11;
static const DWORD REG_QWORD_LITTLE_ENDIAN          = 11;

/* --- Common Constants --- */
static const DWORD INVALID_FILE_ATTRIBUTES = 0xFFFFFFFF;
]]

return ffi.C