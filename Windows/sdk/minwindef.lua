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
]]

return ffi.C