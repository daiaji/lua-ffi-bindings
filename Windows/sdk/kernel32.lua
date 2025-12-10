local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
/* --- Constants --- */
static const DWORD PROCESS_TERMINATE = 0x0001;
static const DWORD PROCESS_CREATE_THREAD = 0x0002;
static const DWORD PROCESS_SET_SESSIONID = 0x0004;
static const DWORD PROCESS_VM_OPERATION = 0x0008;
static const DWORD PROCESS_VM_READ = 0x0010;
static const DWORD PROCESS_VM_WRITE = 0x0020;
static const DWORD PROCESS_DUP_HANDLE = 0x0040;
static const DWORD PROCESS_CREATE_PROCESS = 0x0080;
static const DWORD PROCESS_SET_QUOTA = 0x0100;
static const DWORD PROCESS_SET_INFORMATION = 0x0200;
static const DWORD PROCESS_QUERY_INFORMATION = 0x0400;
static const DWORD PROCESS_QUERY_LIMITED_INFORMATION = 0x1000;
static const DWORD PROCESS_ALL_ACCESS = 0x1F0FFF;

static const DWORD SYNCHRONIZE = 0x00100000;
static const DWORD INFINITE = 0xFFFFFFFF;

static const DWORD WAIT_OBJECT_0 = 0;
static const DWORD WAIT_TIMEOUT = 258;
static const DWORD WAIT_FAILED = 0xFFFFFFFF;

static const DWORD TH32CS_SNAPPROCESS = 0x00000002;
static const DWORD STARTF_USESHOWWINDOW = 0x00000001;

/* --- File Types --- */
static const DWORD FILE_TYPE_UNKNOWN = 0x0000;
static const DWORD FILE_TYPE_DISK    = 0x0001;
static const DWORD FILE_TYPE_CHAR    = 0x0002;
static const DWORD FILE_TYPE_PIPE    = 0x0003;
static const DWORD FILE_TYPE_REMOTE  = 0x8000;

/* --- Memory Management --- */
static const DWORD MEM_COMMIT = 0x00001000;
static const DWORD MEM_RESERVE = 0x00002000;
static const DWORD MEM_RELEASE = 0x00008000;
static const DWORD PAGE_READWRITE = 0x04;

/* --- Error Constants --- */
static const DWORD ERROR_ACCESS_DENIED = 5;
static const DWORD ERROR_INVALID_PARAMETER = 87;
static const DWORD ERROR_NOT_FOUND = 1168;
static const DWORD ERROR_MORE_DATA = 234;
static const DWORD ERROR_NO_MORE_FILES = 18;
static const DWORD ERROR_HANDLE_EOF = 38;

/* --- Priority Constants --- */
static const DWORD IDLE_PRIORITY_CLASS = 0x00000040;
static const DWORD BELOW_NORMAL_PRIORITY_CLASS = 0x00004000;
static const DWORD NORMAL_PRIORITY_CLASS = 0x00000020;
static const DWORD ABOVE_NORMAL_PRIORITY_CLASS = 0x00008000;
static const DWORD HIGH_PRIORITY_CLASS = 0x00000080;
static const DWORD REALTIME_PRIORITY_CLASS = 0x00000100;

/* --- FormatMessage Constants --- */
static const DWORD FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00100;
static const DWORD FORMAT_MESSAGE_FROM_SYSTEM = 0x001000;
static const DWORD FORMAT_MESSAGE_IGNORE_INSERTS = 0x000200;
static const UINT CP_UTF8 = 65001;

/* --- File Access Rights --- */
static const DWORD GENERIC_READ = 0x80000000;
static const DWORD GENERIC_WRITE = 0x40000000;
static const DWORD GENERIC_EXECUTE = 0x20000000;
static const DWORD GENERIC_ALL = 0x10000000;

/* [ADDED] Specific Rights */
static const DWORD FILE_WRITE_ATTRIBUTES = 0x0100;

/* --- File Creation Disposition --- */
static const DWORD CREATE_NEW = 1;
static const DWORD CREATE_ALWAYS = 2;
static const DWORD OPEN_EXISTING = 3;
static const DWORD OPEN_ALWAYS = 4;
static const DWORD TRUNCATE_EXISTING = 5;

/* --- File Attributes --- */
static const DWORD FILE_ATTRIBUTE_READONLY = 0x00000001;
static const DWORD FILE_ATTRIBUTE_HIDDEN = 0x00000002;
static const DWORD FILE_ATTRIBUTE_SYSTEM = 0x00000004;
static const DWORD FILE_ATTRIBUTE_DIRECTORY = 0x00000010;
static const DWORD FILE_ATTRIBUTE_ARCHIVE = 0x00000020;
static const DWORD FILE_ATTRIBUTE_DEVICE = 0x00000040;
static const DWORD FILE_ATTRIBUTE_NORMAL = 0x00000080;
static const DWORD FILE_ATTRIBUTE_TEMPORARY = 0x00000100;
static const DWORD FILE_ATTRIBUTE_SPARSE_FILE = 0x00000200;
static const DWORD FILE_ATTRIBUTE_REPARSE_POINT = 0x00000400;
static const DWORD FILE_ATTRIBUTE_COMPRESSED = 0x00000800;
static const DWORD FILE_ATTRIBUTE_OFFLINE = 0x00001000;
static const DWORD FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = 0x00002000;
static const DWORD FILE_ATTRIBUTE_ENCRYPTED = 0x00004000;

static const DWORD FILE_FLAG_NO_BUFFERING = 0x20000000;
static const DWORD FILE_FLAG_WRITE_THROUGH = 0x80000000;
static const DWORD FILE_FLAG_BACKUP_SEMANTICS = 0x02000000;
static const DWORD FILE_FLAG_OPEN_REPARSE_POINT = 0x00200000;

/* --- Disposition Constants --- */
static const DWORD DELETE = 0x00010000;
static const DWORD FILE_SHARE_READ = 0x00000001;
static const DWORD FILE_SHARE_WRITE = 0x00000002;
static const DWORD FILE_SHARE_DELETE = 0x00000004;

/* --- DefineDosDevice Flags --- */
static const DWORD DDD_RAW_TARGET_PATH = 0x00000001;
static const DWORD DDD_REMOVE_DEFINITION = 0x00000002;
static const DWORD DDD_EXACT_MATCH_ON_REMOVE = 0x00000004;
static const DWORD DDD_NO_BROADCAST_SYSTEM = 0x00000008;

/* --- Symbolic Link Flags --- */
static const DWORD SYMBOLIC_LINK_FLAG_DIRECTORY = 0x1;
static const DWORD SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE = 0x2;

/* --- Job Objects --- */
static const int JobObjectBasicLimitInformation = 2;
static const int JobObjectExtendedLimitInformation = 9;
static const DWORD JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE = 0x00002000;

typedef struct _JOBOBJECT_BASIC_LIMIT_INFORMATION {
    LARGE_INTEGER PerProcessUserTimeLimit;
    LARGE_INTEGER PerJobUserTimeLimit;
    DWORD         LimitFlags;
    SIZE_T        MinimumWorkingSetSize;
    SIZE_T        MaximumWorkingSetSize;
    DWORD         ActiveProcessLimit;
    ULONG_PTR     Affinity;
    DWORD         PriorityClass;
    DWORD         SchedulingClass;
} JOBOBJECT_BASIC_LIMIT_INFORMATION;

/* IO_COUNTERS is in minwindef */

typedef struct _JOBOBJECT_EXTENDED_LIMIT_INFORMATION {
    JOBOBJECT_BASIC_LIMIT_INFORMATION BasicLimitInformation;
    IO_COUNTERS                       IoInfo;
    SIZE_T                            ProcessMemoryLimit;
    SIZE_T                            JobMemoryLimit;
    SIZE_T                            PeakProcessMemoryUsed;
    SIZE_T                            PeakJobMemoryUsed;
} JOBOBJECT_EXTENDED_LIMIT_INFORMATION;

/* --- Structures --- */
typedef struct _SECURITY_ATTRIBUTES {
    DWORD nLength;
    LPVOID lpSecurityDescriptor;
    BOOL bInheritHandle;
} SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;

typedef struct _STARTUPINFOW {
    DWORD cb;
    LPWSTR lpReserved;
    LPWSTR lpDesktop;
    LPWSTR lpTitle;
    DWORD dwX;
    DWORD dwY;
    DWORD dwXSize;
    DWORD dwYSize;
    DWORD dwXCountChars;
    DWORD dwYCountChars;
    DWORD dwFillAttribute;
    DWORD dwFlags;
    WORD wShowWindow;
    WORD cbReserved2;
    BYTE* lpReserved2;
    HANDLE hStdInput;
    HANDLE hStdOutput;
    HANDLE hStdError;
} STARTUPINFOW, *LPSTARTUPINFOW;

typedef struct _PROCESS_INFORMATION {
    HANDLE hProcess;
    HANDLE hThread;
    DWORD dwProcessId;
    DWORD dwThreadId;
} PROCESS_INFORMATION, *LPPROCESS_INFORMATION;

typedef struct _PROCESSENTRY32W {
    DWORD dwSize;
    DWORD cntUsage;
    DWORD th32ProcessID;
    uintptr_t th32DefaultHeapID;
    DWORD th32ModuleID;
    DWORD cntThreads;
    DWORD th32ParentProcessID;
    LONG pcPriClassBase;
    DWORD dwFlags;
    WCHAR szExeFile[260];
} PROCESSENTRY32W;

typedef struct _FILE_DISPOSITION_INFO_EX {
    DWORD Flags;
} FILE_DISPOSITION_INFO_EX;

/* --- File Streams (ADS) --- */
typedef enum _STREAM_INFO_LEVELS {
    FindStreamInfoStandard = 0
} STREAM_INFO_LEVELS;

typedef struct _WIN32_FIND_STREAM_DATA {
    LARGE_INTEGER StreamSize;
    WCHAR         cStreamName[296]; // MAX_PATH + 36
} WIN32_FIND_STREAM_DATA;

typedef struct _WIN32_FIND_DATAW {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD dwReserved0;
    DWORD dwReserved1;
    WCHAR cFileName[260];
    WCHAR cAlternateFileName[14];
    DWORD dwFileType; 
    DWORD dwCreatorType; 
    WORD  wFinderFlags; 
} WIN32_FIND_DATAW, *PWIN32_FIND_DATAW, *LPWIN32_FIND_DATAW;

typedef struct _BY_HANDLE_FILE_INFORMATION {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD dwVolumeSerialNumber;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD nNumberOfLinks;
    DWORD nFileIndexHigh;
    DWORD nFileIndexLow;
} BY_HANDLE_FILE_INFORMATION;

typedef struct _MEMORYSTATUSEX {
    DWORD dwLength;
    DWORD dwMemoryLoad;
    uint64_t ullTotalPhys;
    uint64_t ullAvailPhys;
    uint64_t ullTotalPageFile;
    uint64_t ullAvailPageFile;
    uint64_t ullTotalVirtual;
    uint64_t ullAvailVirtual;
    uint64_t ullAvailExtendedVirtual;
} MEMORYSTATUSEX;

/* --- API Functions --- */
BOOL CloseHandle(HANDLE hObject);

/* Toolhelp */
HANDLE CreateToolhelp32Snapshot(DWORD dwFlags, DWORD th32ProcessID);
BOOL Process32FirstW(HANDLE hSnapshot, PROCESSENTRY32W* lppe);
BOOL Process32NextW(HANDLE hSnapshot, PROCESSENTRY32W* lppe);

/* Process & Thread */
BOOL CreateProcessW(LPCWSTR, LPWSTR, void*, void*, BOOL, DWORD, void*, LPCWSTR, STARTUPINFOW*, PROCESS_INFORMATION*);
HANDLE OpenProcess(DWORD dwDesiredAccess, BOOL bInheritHandle, DWORD dwProcessId);
BOOL TerminateProcess(HANDLE hProcess, unsigned int uExitCode);
DWORD WaitForSingleObject(HANDLE hHandle, DWORD dwMilliseconds);
BOOL SetPriorityClass(HANDLE hProcess, DWORD dwPriorityClass);
BOOL ProcessIdToSessionId(DWORD dwProcessId, DWORD* pSessionId);
BOOL ReadProcessMemory(HANDLE hProcess, const void* lpBaseAddress, void* lpBuffer, size_t nSize, size_t* lpNumberOfBytesRead);
void Sleep(DWORD dwMilliseconds);
DWORD GetTickCount(void);
ULONGLONG GetTickCount64(void);
DWORD GetCurrentProcessId(void);
DWORD GetProcessId(HANDLE hProcess);
DWORD GetModuleFileNameW(HMODULE hModule, LPWSTR lpFilename, DWORD nSize);
LPWSTR GetCommandLineW(void);
BOOL QueryFullProcessImageNameW(HANDLE hProcess, DWORD dwFlags, LPWSTR lpExeName, DWORD* lpdwSize);
DWORD WTSGetActiveConsoleSessionId(void);
UINT GetWindowsDirectoryW(LPWSTR lpBuffer, UINT uSize);
BOOL GetExitCodeProcess(HANDLE hProcess, LPDWORD lpExitCode);

/* Missing symbol */
HANDLE GetCurrentProcess(void);

/* Job Objects */
HANDLE CreateJobObjectW(void* lpJobAttributes, LPCWSTR lpName);
BOOL AssignProcessToJobObject(HANDLE hJob, HANDLE hProcess);
BOOL TerminateJobObject(HANDLE hJob, UINT uExitCode);
BOOL SetInformationJobObject(HANDLE hJob, int JobObjectInfoClass, void* lpJobObjectInfo, DWORD cbJobObjectInfoLength);

/* Module */
HMODULE LoadLibraryW(LPCWSTR lpLibFileName);
HMODULE GetModuleHandleW(LPCWSTR lpModuleName);
void* GetProcAddress(HMODULE hModule, LPCSTR lpProcName);
BOOL FreeLibrary(HMODULE hLibModule);

/* Env */
BOOL SetEnvironmentVariableW(LPCWSTR lpName, LPCWSTR lpValue);
DWORD GetEnvironmentVariableW(LPCWSTR lpName, LPWSTR lpBuffer, DWORD nSize);
DWORD ExpandEnvironmentStringsW(LPCWSTR lpSrc, LPWSTR lpDst, DWORD nSize);

/* Event */
HANDLE CreateEventW(void* lpEventAttributes, BOOL bManualReset, BOOL bInitialState, LPCWSTR lpName);
HANDLE OpenEventW(DWORD dwDesiredAccess, BOOL bInheritHandle, LPCWSTR lpName);
BOOL SetEvent(HANDLE hEvent);
BOOL ResetEvent(HANDLE hEvent);

/* Pipe */
BOOL CreatePipe(PHANDLE hReadPipe, PHANDLE hWritePipe, LPSECURITY_ATTRIBUTES lpPipeAttributes, DWORD nSize);
BOOL SetHandleInformation(HANDLE hObject, DWORD dwMask, DWORD dwFlags);

/* File I/O */
HANDLE CreateFileW(LPCWSTR lpFileName, DWORD dwDesiredAccess, DWORD dwShareMode, void* lpSecurityAttributes, DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes, HANDLE hTemplateFile);
BOOL ReadFile(HANDLE hFile, void* lpBuffer, DWORD nNumberOfBytesToRead, DWORD* lpNumberOfBytesRead, void* lpOverlapped);
BOOL WriteFile(HANDLE hFile, const void* lpBuffer, DWORD nNumberOfBytesToWrite, DWORD* lpNumberOfBytesWritten, void* lpOverlapped);
BOOL FlushFileBuffers(HANDLE hFile);
BOOL GetFileSizeEx(HANDLE hFile, LARGE_INTEGER* lpFileSize);
BOOL SetFilePointerEx(HANDLE hFile, LARGE_INTEGER liDistanceToMove, LARGE_INTEGER* lpNewFilePointer, DWORD dwMoveMethod);
BOOL SetFilePointer(HANDLE hFile, LONG lDistanceToMove, PLONG lpDistanceToMoveHigh, DWORD dwMoveMethod);
BOOL DeviceIoControl(HANDLE hDevice, DWORD dwIoControlCode, LPVOID lpInBuffer, DWORD nInBufferSize, LPVOID lpOutBuffer, DWORD nOutBufferSize, LPDWORD lpBytesReturned, void* lpOverlapped);
DWORD GetFileType(HANDLE hFile); 
BOOL GetFileInformationByHandle(HANDLE hFile, BY_HANDLE_FILE_INFORMATION* lpFileInformation);
DWORD GetCompressedFileSizeW(LPCWSTR lpFileName, LPDWORD lpFileSizeHigh);
BOOL SetFileTime(HANDLE hFile, const FILETIME* lpCreationTime, const FILETIME* lpLastAccessTime, const FILETIME* lpLastWriteTime);

/* File Operations */
BOOL CopyFileW(LPCWSTR lpExistingFileName, LPCWSTR lpNewFileName, BOOL bFailIfExists);
BOOL MoveFileExW(LPCWSTR lpExistingFileName, LPCWSTR lpNewFileName, DWORD dwFlags);
BOOL DeleteFileW(LPCWSTR lpFileName);
BOOL SetFileAttributesW(LPCWSTR lpFileName, DWORD dwFileAttributes);
BOOL CreateHardLinkW(LPCWSTR lpFileName, LPCWSTR lpExistingFileName, void* lpSecurityAttributes);
BOOLEAN CreateSymbolicLinkW(LPCWSTR lpSymlinkFileName, LPCWSTR lpTargetFileName, DWORD dwFlags);
DWORD GetShortPathNameW(LPCWSTR lpszLongPath, LPWSTR lpszShortPath, DWORD cchBuffer);
DWORD GetTempPathW(DWORD nBufferLength, LPWSTR lpBuffer);
UINT GetTempFileNameW(LPCWSTR lpPathName, LPCWSTR lpPrefixString, UINT uUnique, LPWSTR lpTempFileName);
BOOL SetFileInformationByHandle(HANDLE hFile, int FileInformationClass, void* lpFileInformation, DWORD dwBufferSize);
BOOL CreateDirectoryW(LPCWSTR lpPathName, void* lpSecurityAttributes);
BOOL RemoveDirectoryW(LPCWSTR lpPathName);
DWORD GetFullPathNameW(LPCWSTR lpFileName, DWORD nBufferLength, LPWSTR lpBuffer, LPWSTR* lpFilePart);
DWORD SearchPathW(LPCWSTR lpPath, LPCWSTR lpFileName, LPCWSTR lpExtension, DWORD nBufferLength, LPWSTR lpBuffer, LPWSTR* lpFilePart);
void ExitProcess(UINT uExitCode);

/* Directory Iteration */
HANDLE FindFirstFileW(LPCWSTR lpFileName, WIN32_FIND_DATAW* lpFindFileData);
BOOL FindNextFileW(HANDLE hFindFile, WIN32_FIND_DATAW* lpFindFileData);
BOOL FindClose(HANDLE hFindFile);

/* Volume & Drive Info */
DWORD GetFileAttributesW(LPCWSTR lpFileName);
DWORD GetLogicalDrives(void);
UINT GetDriveTypeW(LPCWSTR lpRootPathName);
BOOL GetDiskFreeSpaceExW(LPCWSTR lpDirectoryName, ULARGE_INTEGER* lpFreeBytesAvailableToCaller, ULARGE_INTEGER* lpTotalNumberOfBytes, ULARGE_INTEGER* lpTotalNumberOfFreeBytes);

/* Volume Management */
HANDLE FindFirstVolumeW(LPWSTR lpszVolumeName, DWORD cchBufferLength);
BOOL FindNextVolumeW(HANDLE hFindVolume, LPWSTR lpszVolumeName, DWORD cchBufferLength);
BOOL FindVolumeClose(HANDLE hFindVolume);
BOOL GetVolumeInformationW(LPCWSTR lpRootPathName, LPWSTR lpVolumeNameBuffer, DWORD nVolumeNameSize, DWORD* lpVolumeSerialNumber, DWORD* lpMaximumComponentLength, DWORD* lpFileSystemFlags, LPWSTR lpFileSystemNameBuffer, DWORD nFileSystemNameSize);
BOOL GetVolumePathNamesForVolumeNameW(LPCWSTR lpszVolumeName, LPWSTR lpszVolumePathNames, DWORD cchBufferLength, DWORD* lpcchReturnLength);
BOOL SetVolumeMountPointW(LPCWSTR lpszVolumeMountPoint, LPCWSTR lpszVolumeName);
BOOL DeleteVolumeMountPointW(LPCWSTR lpszVolumeMountPoint);
BOOL GetVolumeNameForVolumeMountPointW(LPCWSTR lpszVolumeMountPoint, LPWSTR lpszVolumeName, DWORD cchBufferLength);
BOOL SetVolumeLabelW(LPCWSTR lpRootPathName, LPCWSTR lpVolumeName);

/* Streams */
HANDLE FindFirstStreamW(LPCWSTR lpFileName, STREAM_INFO_LEVELS InfoLevel, void* lpFindStreamData, DWORD dwFlags);
BOOL FindNextStreamW(HANDLE hFindStream, void* lpFindStreamData);

/* DOS Device Management */
DWORD QueryDosDeviceW(LPCWSTR lpDeviceName, LPWSTR lpTargetPath, DWORD ucchMax);
BOOL DefineDosDeviceW(DWORD dwFlags, LPCWSTR lpDeviceName, LPCWSTR lpTargetPath);

/* Memory */
HLOCAL LocalFree(HLOCAL hMem);
LPVOID VirtualAlloc(LPVOID lpAddress, SIZE_T dwSize, DWORD flAllocationType, DWORD flProtect);
BOOL VirtualFree(LPVOID lpAddress, SIZE_T dwSize, DWORD dwFreeType);
BOOL GlobalMemoryStatusEx(MEMORYSTATUSEX* lpBuffer);

/* String */
int WideCharToMultiByte(unsigned int CodePage, DWORD dwFlags, LPCWSTR lpWideCharStr, int cchWideChar, LPSTR lpMultiByteStr, int cbMultiByte, LPCSTR lpDefaultChar, int* lpUsedDefaultChar);
int MultiByteToWideChar(unsigned int CodePage, DWORD dwFlags, LPCSTR lpMultiByteStr, int cbMultiByte, LPTSTR lpWideCharStr, int cchWideChar);
int lstrcmpiW(LPCWSTR lpString1, LPCWSTR lpString2);

/* Error */
DWORD GetLastError(void);
void SetLastError(DWORD dwErrCode);
DWORD FormatMessageW(DWORD dwFlags, const void* lpSource, DWORD dwMessageId, DWORD dwLanguageId, LPWSTR lpBuffer, DWORD nSize, void* Arguments);

void GetSystemTimeAsFileTime(FILETIME* lpSystemTimeAsFileTime);

/* [ADDED] Firmware Environment */
DWORD GetFirmwareEnvironmentVariableW(LPCWSTR lpName, LPCWSTR lpGuid, PVOID pBuffer, DWORD nSize);
]]

return ffi.load("kernel32")