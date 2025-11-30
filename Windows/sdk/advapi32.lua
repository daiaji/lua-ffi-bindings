local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
static const DWORD MAXIMUM_ALLOWED = 0x02000000;
static const DWORD CREATE_UNICODE_ENVIRONMENT = 0x00000400;

/* Token & Privilege Constants (Added for proc_utils) */
static const DWORD TOKEN_ADJUST_PRIVILEGES = 0x0020;
static const DWORD TOKEN_QUERY = 0x0008;
static const DWORD SE_PRIVILEGE_ENABLED = 0x00000002;

typedef enum _SECURITY_IMPERSONATION_LEVEL {
    SecurityAnonymous,
    SecurityIdentification,
    SecurityImpersonation,
    SecurityDelegation
} SECURITY_IMPERSONATION_LEVEL;

typedef enum _TOKEN_TYPE {
    TokenPrimary = 1,
    TokenImpersonation
} TOKEN_TYPE;

/* LUID & Token Structures (Added for proc_utils) */
typedef struct _LUID {
    DWORD LowPart;
    LONG HighPart;
} LUID;

typedef struct _LUID_AND_ATTRIBUTES {
    LUID Luid;
    DWORD Attributes;
} LUID_AND_ATTRIBUTES;

typedef struct _TOKEN_PRIVILEGES {
    DWORD PrivilegeCount;
    LUID_AND_ATTRIBUTES Privileges[1];
} TOKEN_PRIVILEGES;

/* Process Creation API */
BOOL CreateProcessAsUserW(HANDLE hToken, LPCWSTR lpApplicationName, LPWSTR lpCommandLine, void* lpProcessAttributes, void* lpThreadAttributes, BOOL bInheritHandles, DWORD dwCreationFlags, void* lpEnvironment, LPCWSTR lpCurrentDirectory, void* lpStartupInfo, void* lpProcessInformation);
BOOL DuplicateTokenEx(HANDLE hExistingToken, DWORD dwDesiredAccess, void* lpTokenAttributes, SECURITY_IMPERSONATION_LEVEL ImpersonationLevel, TOKEN_TYPE TokenType, HANDLE* phNewToken);

/* Privilege & Token API (Added) */
BOOL OpenProcessToken(HANDLE ProcessHandle, DWORD DesiredAccess, HANDLE *TokenHandle);
BOOL LookupPrivilegeValueW(LPCWSTR lpSystemName, LPCWSTR lpName, LUID *lpLuid);
BOOL AdjustTokenPrivileges(HANDLE TokenHandle, BOOL DisableAllPrivileges, TOKEN_PRIVILEGES *NewState, DWORD BufferLength, void *PreviousState, DWORD *ReturnLength);

/* --- ENHANCEMENTS START --- */
LONG RegOpenKeyExW(HKEY hKey, LPCWSTR lpSubKey, DWORD ulOptions, DWORD samDesired, HKEY* phkResult);
LONG RegCreateKeyExW(HKEY hKey, LPCWSTR lpSubKey, DWORD Reserved, LPWSTR lpClass, DWORD dwOptions, DWORD samDesired, void* lpSecurityAttributes, HKEY* phkResult, DWORD* lpdwDisposition);
LONG RegCloseKey(HKEY hKey);
LONG RegQueryValueExW(HKEY hKey, LPCWSTR lpValueName, DWORD* lpReserved, DWORD* lpType, BYTE* lpData, DWORD* lpcbData);
LONG RegSetValueExW(HKEY hKey, LPCWSTR lpValueName, DWORD Reserved, DWORD dwType, const BYTE* lpData, DWORD cbData);
LONG RegDeleteValueW(HKEY hKey, LPCWSTR lpValueName);
LONG RegDeleteKeyW(HKEY hKey, LPCWSTR lpSubKey);
LONG RegEnumKeyExW(HKEY hKey, DWORD dwIndex, LPWSTR lpName, DWORD* lpcchName, DWORD* lpReserved, LPWSTR lpClass, DWORD* lpcchClass, FILETIME* lpftLastWriteTime);
/* --- ENHANCEMENTS END --- */
]]

return ffi.load("advapi32")
