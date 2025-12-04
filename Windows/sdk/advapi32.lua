local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
/* --- Constants --- */
static const DWORD MAXIMUM_ALLOWED = 0x02000000;
static const DWORD CREATE_UNICODE_ENVIRONMENT = 0x00000400;

/* Token & Privilege Constants */
static const DWORD TOKEN_ADJUST_PRIVILEGES = 0x0020;
static const DWORD TOKEN_QUERY = 0x0008;
static const DWORD SE_PRIVILEGE_ENABLED = 0x00000002;

/* Service Constants */
static const DWORD SC_MANAGER_CONNECT = 0x0001;
static const DWORD SC_MANAGER_CREATE_SERVICE = 0x0002;
static const DWORD SC_MANAGER_ENUMERATE_SERVICE = 0x0004;
static const DWORD SC_MANAGER_ALL_ACCESS = 0xF003F;

static const DWORD SERVICE_QUERY_STATUS = 0x0004;
static const DWORD SERVICE_CHANGE_CONFIG = 0x0002;
static const DWORD SERVICE_START = 0x0010;
static const DWORD SERVICE_STOP = 0x0020;
static const DWORD SERVICE_ALL_ACCESS = 0xF01FF;

static const DWORD SERVICE_WIN32 = 0x00000030;
static const DWORD SERVICE_DRIVER = 0x0000000B;
static const DWORD SERVICE_STATE_ALL = 0x00000003;
static const DWORD SERVICE_ACTIVE = 0x00000001;

static const DWORD SC_ENUM_PROCESS_INFO = 0;
static const DWORD SERVICE_NO_CHANGE = 0xFFFFFFFF;

/* SID Constants */
typedef enum _SID_NAME_USE {
    SidTypeUser = 1,
    SidTypeGroup,
    SidTypeDomain,
    SidTypeAlias,
    SidTypeWellKnownGroup,
    SidTypeDeletedAccount,
    SidTypeInvalid,
    SidTypeUnknown,
    SidTypeComputer,
    SidTypeLabel
} SID_NAME_USE;

/* Structures */
/* LUID is in minwindef */

typedef struct _LUID_AND_ATTRIBUTES {
    LUID Luid;
    DWORD Attributes;
} LUID_AND_ATTRIBUTES;

typedef struct _TOKEN_PRIVILEGES {
    DWORD PrivilegeCount;
    LUID_AND_ATTRIBUTES Privileges[1];
} TOKEN_PRIVILEGES;

typedef struct _SERVICE_STATUS_PROCESS {
    DWORD dwServiceType;
    DWORD dwCurrentState;
    DWORD dwControlsAccepted;
    DWORD dwWin32ExitCode;
    DWORD dwServiceSpecificExitCode;
    DWORD dwCheckPoint;
    DWORD dwWaitHint;
    DWORD dwProcessId;
    DWORD dwServiceFlags;
} SERVICE_STATUS_PROCESS, *LPSERVICE_STATUS_PROCESS;

typedef struct _ENUM_SERVICE_STATUS_PROCESSW {
    LPWSTR lpServiceName;
    LPWSTR lpDisplayName;
    SERVICE_STATUS_PROCESS ServiceStatusProcess;
} ENUM_SERVICE_STATUS_PROCESSW;

/* Dependent Service Structures */
typedef struct _SERVICE_STATUS {
    DWORD dwServiceType;
    DWORD dwCurrentState;
    DWORD dwControlsAccepted;
    DWORD dwWin32ExitCode;
    DWORD dwServiceSpecificExitCode;
    DWORD dwCheckPoint;
    DWORD dwWaitHint;
} SERVICE_STATUS, *LPSERVICE_STATUS;

typedef struct _ENUM_SERVICE_STATUSW {
    LPWSTR         lpServiceName;
    LPWSTR         lpDisplayName;
    SERVICE_STATUS ServiceStatus;
} ENUM_SERVICE_STATUSW, *LPENUM_SERVICE_STATUSW;

typedef struct _QUERY_SERVICE_CONFIGW {
    DWORD   dwServiceType;
    DWORD   dwStartType;
    DWORD   dwErrorControl;
    LPWSTR  lpBinaryPathName;
    LPWSTR  lpLoadOrderGroup;
    DWORD   dwTagId;
    LPWSTR  lpDependencies;
    LPWSTR  lpServiceStartName;
    LPWSTR  lpDisplayName;
} QUERY_SERVICE_CONFIGW, *LPQUERY_SERVICE_CONFIGW;

/* API Functions */
/* Process Creation */
BOOL CreateProcessAsUserW(HANDLE hToken, LPCWSTR lpApplicationName, LPWSTR lpCommandLine, void* lpProcessAttributes, void* lpThreadAttributes, BOOL bInheritHandles, DWORD dwCreationFlags, void* lpEnvironment, LPCWSTR lpCurrentDirectory, void* lpStartupInfo, void* lpProcessInformation);
BOOL DuplicateTokenEx(HANDLE hExistingToken, DWORD dwDesiredAccess, void* lpTokenAttributes, int ImpersonationLevel, int TokenType, HANDLE* phNewToken);

/* Token / Privilege */
BOOL OpenProcessToken(HANDLE ProcessHandle, DWORD DesiredAccess, HANDLE *TokenHandle);
BOOL LookupPrivilegeValueW(LPCWSTR lpSystemName, LPCWSTR lpName, LUID *lpLuid);
BOOL AdjustTokenPrivileges(HANDLE TokenHandle, BOOL DisableAllPrivileges, TOKEN_PRIVILEGES *NewState, DWORD BufferLength, void *PreviousState, DWORD *ReturnLength);

/* SID */
BOOL ConvertSidToStringSidW(PSID Sid, LPWSTR* StringSid);
BOOL LookupAccountSidW(LPCWSTR lpSystemName, PSID Sid, LPWSTR Name, LPDWORD cchName, LPWSTR ReferencedDomainName, LPDWORD cchReferencedDomainName, SID_NAME_USE *peUse);

/* Service Manager */
SC_HANDLE OpenSCManagerW(LPCWSTR lpMachineName, LPCWSTR lpDatabaseName, DWORD dwDesiredAccess);
BOOL EnumServicesStatusExW(SC_HANDLE hSCManager, int InfoLevel, DWORD dwServiceType, DWORD dwServiceState, LPBYTE lpServices, DWORD cbBufSize, LPDWORD pcbBytesNeeded, LPDWORD lpServicesReturned, LPDWORD lpResumeHandle, LPCWSTR pszGroupName);
SC_HANDLE OpenServiceW(SC_HANDLE hSCManager, LPCWSTR lpServiceName, DWORD dwDesiredAccess);
BOOL ChangeServiceConfigW(SC_HANDLE hService, DWORD dwServiceType, DWORD dwStartType, DWORD dwErrorControl, LPCWSTR lpBinaryPathName, LPCWSTR lpLoadOrderGroup, LPDWORD lpdwTagId, LPCWSTR lpDependencies, LPCWSTR lpServiceStartName, LPCWSTR lpPassword, LPCWSTR lpDisplayName);
BOOL QueryServiceStatusEx(SC_HANDLE hService, int InfoLevel, LPBYTE lpBuffer, DWORD cbBufSize, LPDWORD pcbBytesNeeded);
BOOL StartServiceW(SC_HANDLE hService, DWORD dwNumServiceArgs, LPCWSTR* lpServiceArgVectors);
BOOL ControlService(SC_HANDLE hService, DWORD dwControl, void* lpServiceStatus);
BOOL CloseServiceHandle(SC_HANDLE hSCObject);

/* Service Dependency & Config APIs */
BOOL EnumDependentServicesW(SC_HANDLE hService, DWORD dwServiceState, LPENUM_SERVICE_STATUSW lpServices, DWORD cbBufSize, LPDWORD pcbBytesNeeded, LPDWORD lpServicesReturned);
BOOL QueryServiceConfigW(SC_HANDLE hService, LPQUERY_SERVICE_CONFIGW lpServiceConfig, DWORD cbBufSize, LPDWORD pcbBytesNeeded);

/* Registry */
LONG RegOpenKeyExW(HKEY hKey, LPCWSTR lpSubKey, DWORD ulOptions, DWORD samDesired, HKEY* phkResult);
LONG RegCreateKeyExW(HKEY hKey, LPCWSTR lpSubKey, DWORD Reserved, LPWSTR lpClass, DWORD dwOptions, DWORD samDesired, void* lpSecurityAttributes, HKEY* phkResult, DWORD* lpdwDisposition);
LONG RegCloseKey(HKEY hKey);
LONG RegQueryValueExW(HKEY hKey, LPCWSTR lpValueName, DWORD* lpReserved, DWORD* lpType, BYTE* lpData, DWORD* lpcbData);
LONG RegSetValueExW(HKEY hKey, LPCWSTR lpValueName, DWORD Reserved, DWORD dwType, const BYTE* lpData, DWORD cbData);
LONG RegDeleteValueW(HKEY hKey, LPCWSTR lpValueName);
LONG RegDeleteKeyW(HKEY hKey, LPCWSTR lpSubKey);
LONG RegEnumKeyExW(HKEY hKey, DWORD dwIndex, LPWSTR lpName, DWORD* lpcchName, DWORD* lpReserved, LPWSTR lpClass, DWORD* lpcchClass, FILETIME* lpftLastWriteTime);

/* [ADDED] Missing Symbols */
LONG RegDeleteTreeW(HKEY hKey, LPCWSTR lpSubKey);
BOOL ConvertStringSidToSidW(LPCWSTR StringSid, PSID* Sid);

/* [NEW] ACL / Security */
DWORD SetNamedSecurityInfoW(
    LPWSTR pObjectName,
    int ObjectType,
    DWORD SecurityInfo,
    PSID psidOwner,
    PSID psidGroup,
    PSECURITY_DESCRIPTOR pDacl,
    PSECURITY_DESCRIPTOR pSacl
);
]]

return ffi.load("advapi32")