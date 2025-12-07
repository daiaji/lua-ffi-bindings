local ffi = require 'ffi'
-- MinWinDef defines basic types including SIZE_T, NTSTATUS, LUID, IO_COUNTERS
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
/* --- Specific Types --- */
typedef SIZE_T *PSIZE_T;
typedef LONG KPRIORITY;

/* --- NT Status Codes --- */
static const ULONG STATUS_SUCCESS = 0x00000000;
static const ULONG STATUS_INFO_LENGTH_MISMATCH = 0xC0000004;
static const ULONG STATUS_BUFFER_OVERFLOW = 0x80000005;
static const ULONG STATUS_BUFFER_TOO_SMALL = 0xC0000023;
static const ULONG STATUS_NO_MORE_ENTRIES = 0x8000001A;
static const ULONG STATUS_ACCESS_DENIED = 0xC0000022;
static const ULONG STATUS_INVALID_PARAMETER = 0xC000000D;
static const ULONG STATUS_PRIVILEGE_NOT_HELD = 0xC0000061;
static const ULONG STATUS_VARIABLE_NOT_FOUND = 0xC0000034;
static const ULONG STATUS_IMAGE_ALREADY_LOADED = 0xC000010E;

/* --- Memory Constants --- */
static const ULONG MEM_DECOMMIT    = 0x4000;
static const ULONG MEM_FREE        = 0x10000;
static const ULONG MEM_PRIVATE     = 0x20000;
static const ULONG MEM_MAPPED      = 0x40000;
static const ULONG MEM_IMAGE       = 0x1000000;

static const ULONG PAGE_NOACCESS          = 0x01;
static const ULONG PAGE_READONLY          = 0x02;
static const ULONG PAGE_WRITECOPY         = 0x08;
static const ULONG PAGE_EXECUTE           = 0x10;
static const ULONG PAGE_EXECUTE_READ      = 0x20;
static const ULONG PAGE_EXECUTE_READWRITE = 0x40;
static const ULONG PAGE_EXECUTE_WRITECOPY = 0x80;
static const ULONG PAGE_GUARD             = 0x100;
static const ULONG PAGE_NOCACHE           = 0x200;
static const ULONG PAGE_WRITECOMBINE      = 0x400;

/* --- Strings & Attributes --- */
typedef struct _UNICODE_STRING {
    USHORT Length;
    USHORT MaximumLength;
    PWSTR  Buffer;
} UNICODE_STRING, *PUNICODE_STRING;

typedef struct _OBJECT_ATTRIBUTES {
    ULONG Length;
    HANDLE RootDirectory;
    PUNICODE_STRING ObjectName;
    ULONG Attributes;
    PVOID SecurityDescriptor;
    PVOID SecurityQualityOfService;
} OBJECT_ATTRIBUTES, *POBJECT_ATTRIBUTES;

/* Object Attributes Flags */
static const ULONG OBJ_INHERIT             = 0x00000002;
static const ULONG OBJ_PERMANENT           = 0x00000010;
static const ULONG OBJ_EXCLUSIVE           = 0x00000020;
static const ULONG OBJ_CASE_INSENSITIVE    = 0x00000040;
static const ULONG OBJ_OPENIF              = 0x00000080;
static const ULONG OBJ_OPENLINK            = 0x00000100;
static const ULONG OBJ_KERNEL_HANDLE       = 0x00000200;
static const ULONG OBJ_FORCE_ACCESS_CHECK  = 0x00000400;
static const ULONG OBJ_VALID_ATTRIBUTES    = 0x000007F2;

/* --- IO Status Block --- */
typedef struct _IO_STATUS_BLOCK {
    union {
        NTSTATUS Status;
        PVOID Pointer;
    };
    ULONG_PTR Information;
} IO_STATUS_BLOCK, *PIO_STATUS_BLOCK;

/* --- Information Classes --- */
typedef enum _SYSTEM_INFORMATION_CLASS {
    SystemBasicInformation = 0,
    SystemProcessInformation = 5,
    SystemHandleInformation = 16,
    SystemExtendedHandleInformation = 64
} SYSTEM_INFORMATION_CLASS;

typedef enum _OBJECT_INFORMATION_CLASS {
    ObjectBasicInformation = 0,
    ObjectNameInformation = 1,
    ObjectTypeInformation = 2
} OBJECT_INFORMATION_CLASS;

typedef enum _PROCESSINFOCLASS {
    ProcessBasicInformation = 0,
    ProcessDebugPort = 7,
    ProcessImageFileName = 27,
    ProcessHandleInformation = 51
} PROCESSINFOCLASS;

typedef enum _MEMORY_INFORMATION_CLASS {
    MemoryBasicInformation = 0,
    MemoryWorkingSetInformation = 1,
    MemoryMappedFilenameInformation = 2,
    MemoryRegionInformation = 3,
    MemoryWorkingSetExInformation = 4
} MEMORY_INFORMATION_CLASS;

/* --- Power Management Types --- */
typedef enum _POWER_ACTION {
    PowerActionNone = 0,
    PowerActionReserved,
    PowerActionSleep,
    PowerActionHibernate,
    PowerActionShutdown,
    PowerActionShutdownReset,
    PowerActionShutdownOff,
    PowerActionWarmEject
} POWER_ACTION;

typedef enum _SYSTEM_POWER_STATE {
    PowerSystemUnspecified = 0,
    PowerSystemWorking,
    PowerSystemSleeping1,
    PowerSystemSleeping2,
    PowerSystemSleeping3,
    PowerSystemHibernate,
    PowerSystemShutdown,
    PowerSystemMaximum
} SYSTEM_POWER_STATE;

typedef enum _SHUTDOWN_ACTION {
    ShutdownNoReboot,
    ShutdownReboot,
    ShutdownPowerOff
} SHUTDOWN_ACTION;

/* Power Action Flags */
static const ULONG POWER_ACTION_QUERY_ALLOWED   = 0x00000001;
static const ULONG POWER_ACTION_UI_ALLOWED      = 0x00000002;
static const ULONG POWER_ACTION_OVERRIDE_APPS   = 0x00000004;
static const ULONG POWER_ACTION_CRITICAL        = 0x80000000;

/* --- UEFI/Firmware Constants --- */
static const ULONG EFI_VARIABLE_NON_VOLATILE = 0x00000001;
static const ULONG EFI_VARIABLE_BOOTSERVICE_ACCESS = 0x00000002;
static const ULONG EFI_VARIABLE_RUNTIME_ACCESS = 0x00000004;

/* --- VM Counters --- */
typedef struct _VM_COUNTERS {
    SIZE_T PeakVirtualSize;
    SIZE_T VirtualSize;
    ULONG PageFaultCount;
    SIZE_T PeakWorkingSetSize;
    SIZE_T WorkingSetSize;
    SIZE_T QuotaPeakPagedPoolUsage;
    SIZE_T QuotaPagedPoolUsage;
    SIZE_T QuotaPeakNonPagedPoolUsage;
    SIZE_T QuotaNonPagedPoolUsage;
    SIZE_T PagefileUsage;
    SIZE_T PeakPagefileUsage;
} VM_COUNTERS;

/* --- Client ID --- */
typedef struct _CLIENT_ID {
    HANDLE UniqueProcess;
    HANDLE UniqueThread;
} CLIENT_ID;

/* --- System Process Information --- */
typedef struct _SYSTEM_THREAD_INFORMATION {
    LARGE_INTEGER KernelTime;
    LARGE_INTEGER UserTime;
    LARGE_INTEGER CreateTime;
    ULONG WaitTime;
    PVOID StartAddress;
    CLIENT_ID ClientId;
    LONG Priority;
    LONG BasePriority;
    ULONG ContextSwitches;
    ULONG ThreadState;
    ULONG WaitReason;
} SYSTEM_THREAD_INFORMATION;

typedef struct _SYSTEM_PROCESS_INFORMATION {
    ULONG NextEntryOffset;
    ULONG NumberOfThreads;
    LARGE_INTEGER WorkingSetPrivateSize;
    ULONG HardFaultCount;
    ULONG NumberOfThreadsHighWatermark;
    ULONGLONG CycleTime;
    LARGE_INTEGER CreateTime;
    LARGE_INTEGER UserTime;
    LARGE_INTEGER KernelTime;
    UNICODE_STRING ImageName;
    LONG BasePriority;
    HANDLE UniqueProcessId;
    HANDLE InheritedFromUniqueProcessId;
    ULONG HandleCount;
    ULONG SessionId;
    ULONG_PTR UniqueProcessKey;
    VM_COUNTERS VirtualMemoryCounters;
    size_t PrivatePageCount;
    IO_COUNTERS IoCounters;
    SYSTEM_THREAD_INFORMATION Threads[1];
} SYSTEM_PROCESS_INFORMATION;

/* --- Process Handle Snapshot (Win8+) --- */
typedef struct _PROCESS_HANDLE_TABLE_ENTRY_INFO {
    HANDLE HandleValue;
    ULONG_PTR HandleCount;
    ULONG_PTR PointerCount;
    ULONG GrantedAccess;
    ULONG ObjectTypeIndex;
    ULONG HandleAttributes;
    ULONG Reserved;
} PROCESS_HANDLE_TABLE_ENTRY_INFO;

typedef struct _PROCESS_HANDLE_SNAPSHOT_INFORMATION {
    ULONG_PTR NumberOfHandles;
    ULONG_PTR Reserved;
    PROCESS_HANDLE_TABLE_ENTRY_INFO Handles[1];
} PROCESS_HANDLE_SNAPSHOT_INFORMATION;

/* --- Handle Enumeration (SystemExtendedHandleInformation) --- */
typedef struct _SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX {
    PVOID Object;
    ULONG_PTR UniqueProcessId;
    ULONG_PTR HandleValue;
    ULONG GrantedAccess;
    USHORT CreatorBackTraceIndex;
    USHORT ObjectTypeIndex;
    ULONG HandleAttributes;
    ULONG Reserved;
} SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX;

typedef struct _SYSTEM_HANDLE_INFORMATION_EX {
    ULONG_PTR NumberOfHandles;
    ULONG_PTR Reserved;
    SYSTEM_HANDLE_TABLE_ENTRY_INFO_EX Handles[1];
} SYSTEM_HANDLE_INFORMATION_EX;

/* --- Object Name Information --- */
typedef struct _OBJECT_NAME_INFORMATION {
    UNICODE_STRING Name;
} OBJECT_NAME_INFORMATION;

/* --- Memory Basic Information --- */
typedef struct _MEMORY_BASIC_INFORMATION {
    PVOID BaseAddress;
    PVOID AllocationBase;
    DWORD AllocationProtect;
    SIZE_T RegionSize;
    DWORD State;
    DWORD Protect;
    DWORD Type;
} MEMORY_BASIC_INFORMATION, *PMEMORY_BASIC_INFORMATION;

/* --- Token / Security --- */
typedef enum _TOKEN_INFORMATION_CLASS {
    TokenUser = 1,
    TokenGroups,
    TokenPrivileges,
    TokenOwner,
    TokenPrimaryGroup,
    TokenDefaultDacl,
    TokenSource,
    TokenType,
    TokenImpersonationLevel,
    TokenStatistics,
    TokenRestrictedSids,
    TokenSessionId,
    TokenGroupsAndPrivileges,
    TokenSandBoxInert,
    TokenOrigin,
    TokenElevationType,
    TokenLinkedToken,
    TokenElevation,
    TokenHasRestrictions,
    TokenAccessInformation,
    TokenVirtualizationAllowed,
    TokenVirtualizationEnabled,
    TokenIntegrityLevel,
    TokenUIAccess,
    TokenMandatoryPolicy,
    TokenLogonSid,
    TokenIsAppContainer,
    TokenCapabilities,
    TokenAppContainerSid,
    TokenAppContainerNumber,
    TokenUserClaimAttributes,
    TokenDeviceClaimAttributes,
    TokenRestrictedUserClaimAttributes,
    TokenRestrictedDeviceClaimAttributes,
    TokenDeviceGroups,
    TokenRestrictedDeviceGroups,
    TokenSecurityAttributes,
    TokenIsRestricted
} TOKEN_INFORMATION_CLASS;

/* LUID is now defined in minwindef.lua */

typedef struct _LUID_AND_ATTRIBUTES_NT {
    LUID Luid;
    DWORD Attributes;
} LUID_AND_ATTRIBUTES_NT;

typedef struct _TOKEN_PRIVILEGES_NT {
    DWORD PrivilegeCount;
    LUID_AND_ATTRIBUTES_NT Privileges[1];
} TOKEN_PRIVILEGES_NT;

typedef struct _SID_AND_ATTRIBUTES {
    PSID Sid;
    DWORD Attributes;
} SID_AND_ATTRIBUTES;

typedef struct _TOKEN_MANDATORY_LABEL {
    SID_AND_ATTRIBUTES Label;
} TOKEN_MANDATORY_LABEL;

typedef struct _TOKEN_ELEVATION {
    DWORD TokenIsElevated;
} TOKEN_ELEVATION;

/* --- PEB & Process Basic Information --- */
typedef struct _PEB {
    BYTE Reserved1[2];
    BYTE BeingDebugged;
    BYTE Reserved2[1];
    PVOID Reserved3[2];
    PVOID Ldr;
    PVOID ProcessParameters; /* PRTL_USER_PROCESS_PARAMETERS */
    /* ... incomplete opaque struct ... */
} PEB, *PPEB;

typedef struct _PROCESS_BASIC_INFORMATION {
    NTSTATUS ExitStatus;
    PPEB PebBaseAddress;
    ULONG_PTR AffinityMask;
    KPRIORITY BasePriority;
    ULONG_PTR UniqueProcessId;
    ULONG_PTR InheritedFromUniqueProcessId;
} PROCESS_BASIC_INFORMATION;

typedef struct _RTL_USER_PROCESS_PARAMETERS {
    BYTE Reserved1[16];
    PVOID Reserved2[10];
    UNICODE_STRING ImagePathName;
    UNICODE_STRING CommandLine;
} RTL_USER_PROCESS_PARAMETERS;

/* --- [NEW] File Directory Information (Moved from win-utils/fs/init.lua) --- */
typedef struct _FILE_DIRECTORY_INFORMATION {
    ULONG NextEntryOffset;
    ULONG FileIndex;
    LARGE_INTEGER CreationTime;
    LARGE_INTEGER LastAccessTime;
    LARGE_INTEGER LastWriteTime;
    LARGE_INTEGER ChangeTime;
    LARGE_INTEGER EndOfFile;
    LARGE_INTEGER AllocationSize;
    ULONG FileAttributes;
    ULONG FileNameLength;
    WCHAR FileName[1];
} FILE_DIRECTORY_INFORMATION, *PFILE_DIRECTORY_INFORMATION;

/* --- [NEW] File Basic Information (For NtSetInformationFile) --- */
typedef struct _FILE_BASIC_INFORMATION {
    LARGE_INTEGER CreationTime;
    LARGE_INTEGER LastAccessTime;
    LARGE_INTEGER LastWriteTime;
    LARGE_INTEGER ChangeTime;
    ULONG FileAttributes;
} FILE_BASIC_INFORMATION, *PFILE_BASIC_INFORMATION;

/* --- API Functions --- */
long __stdcall NtQuerySystemInformation(
    SYSTEM_INFORMATION_CLASS SystemInformationClass,
    PVOID SystemInformation,
    ULONG SystemInformationLength,
    PULONG ReturnLength
);

long __stdcall NtDuplicateObject(
    HANDLE SourceProcessHandle,
    HANDLE SourceHandle,
    HANDLE TargetProcessHandle,
    PHANDLE TargetHandle,
    DWORD DesiredAccess,
    ULONG HandleAttributes,
    ULONG Options
);

long __stdcall NtQueryObject(
    HANDLE Handle,
    OBJECT_INFORMATION_CLASS ObjectInformationClass,
    PVOID ObjectInformation,
    ULONG ObjectInformationLength,
    PULONG ReturnLength
);

long __stdcall NtQueryInformationProcess(
    HANDLE ProcessHandle,
    PROCESSINFOCLASS ProcessInformationClass,
    PVOID ProcessInformation,
    ULONG ProcessInformationLength,
    PULONG ReturnLength
);

long __stdcall NtOpenProcessToken(
    HANDLE ProcessHandle,
    DWORD DesiredAccess,
    PHANDLE TokenHandle
);

long __stdcall NtAdjustPrivilegesToken(
    HANDLE TokenHandle,
    BOOLEAN DisableAllPrivileges,
    TOKEN_PRIVILEGES_NT* NewState,
    DWORD BufferLength,
    TOKEN_PRIVILEGES_NT* PreviousState,
    PULONG ReturnLength
);

long __stdcall NtQueryInformationToken(
    HANDLE TokenHandle,
    TOKEN_INFORMATION_CLASS TokenInformationClass,
    PVOID TokenInformation,
    ULONG TokenInformationLength,
    PULONG ReturnLength
);

long __stdcall NtSuspendProcess(HANDLE ProcessHandle);
long __stdcall NtResumeProcess(HANDLE ProcessHandle);

long __stdcall NtQueryVirtualMemory(
    HANDLE ProcessHandle,
    PVOID BaseAddress,
    MEMORY_INFORMATION_CLASS MemoryInformationClass,
    PVOID MemoryInformation,
    SIZE_T MemoryInformationLength,
    PSIZE_T ReturnLength
);

/* --- File/IO Native APIs --- */
/* [FIX] Added missing NtOpenFile declaration */
NTSTATUS NtOpenFile(
    PHANDLE FileHandle,
    ACCESS_MASK DesiredAccess,
    POBJECT_ATTRIBUTES ObjectAttributes,
    PIO_STATUS_BLOCK IoStatusBlock,
    ULONG ShareAccess,
    ULONG OpenOptions
);

NTSTATUS NtSetInformationFile(
    HANDLE FileHandle,
    PIO_STATUS_BLOCK IoStatusBlock,
    PVOID FileInformation,
    ULONG Length,
    ULONG FileInformationClass
);

/* [NEW] Directory Query API */
NTSTATUS NtQueryDirectoryFile(
    HANDLE FileHandle,
    HANDLE Event,
    PVOID ApcRoutine,
    PVOID ApcContext,
    PIO_STATUS_BLOCK IoStatusBlock,
    PVOID FileInformation,
    ULONG Length,
    int FileInformationClass,
    BOOLEAN ReturnSingleEntry,
    PUNICODE_STRING FileName,
    BOOLEAN RestartScan
);

/* --- Registry Native APIs --- */
long __stdcall NtLoadKey(
    POBJECT_ATTRIBUTES TargetKey,
    POBJECT_ATTRIBUTES SourceFile
);

long __stdcall NtLoadKeyEx(
    POBJECT_ATTRIBUTES TargetKey,
    POBJECT_ATTRIBUTES SourceFile,
    ULONG Flags,
    HANDLE TrustClassKey,
    HANDLE Event,
    ACCESS_MASK DesiredAccess,
    PHANDLE RootHandle,
    PVOID Reserved
);

long __stdcall NtUnloadKey(
    POBJECT_ATTRIBUTES TargetKey
);

long __stdcall NtSaveKey(
    HANDLE KeyHandle,
    HANDLE FileHandle
);

/* --- Power Management Native APIs --- */
long __stdcall NtInitiatePowerAction(
    POWER_ACTION SystemAction,
    SYSTEM_POWER_STATE LightestSystemState,
    ULONG Flags,
    BOOLEAN Asynchronous
);

long __stdcall NtShutdownSystem(
    SHUTDOWN_ACTION Action
);

long __stdcall NtSetSystemPowerState(
    POWER_ACTION SystemAction,
    SYSTEM_POWER_STATE LightestSystemState,
    ULONG Flags
);

/* --- Driver Loading Native APIs --- */
long __stdcall NtLoadDriver(
    POBJECT_ATTRIBUTES DriverServiceName
);

long __stdcall NtUnloadDriver(
    POBJECT_ATTRIBUTES DriverServiceName
);

/* --- UEFI/Firmware APIs --- */
long __stdcall NtQuerySystemEnvironmentValueEx(
    PUNICODE_STRING VariableName,
    const GUID* VendorGuid,
    PVOID Buffer,
    PULONG ValueLength,
    PULONG Attributes
);

long __stdcall NtSetSystemEnvironmentValueEx(
    PUNICODE_STRING VariableName,
    const GUID* VendorGuid,
    PVOID Buffer,
    ULONG BufferLength,
    ULONG Attributes
);
]]

return ffi.load("ntdll")