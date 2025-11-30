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

/* --- Error Constants --- */
static const DWORD ERROR_ACCESS_DENIED = 5;
static const DWORD ERROR_INVALID_PARAMETER = 87;
static const DWORD ERROR_NOT_FOUND = 1168;

/* --- Priority Constants --- */
static const DWORD IDLE_PRIORITY_CLASS = 0x00000040;
static const DWORD BELOW_NORMAL_PRIORITY_CLASS = 0x00004000;
static const DWORD NORMAL_PRIORITY_CLASS = 0x00000020;
static const DWORD ABOVE_NORMAL_PRIORITY_CLASS = 0x00008000;
static const DWORD HIGH_PRIORITY_CLASS = 0x00000080;
static const DWORD REALTIME_PRIORITY_CLASS = 0x00000100;

/* --- FormatMessage & CodePage Constants --- */
static const DWORD FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00100;
static const DWORD FORMAT_MESSAGE_FROM_SYSTEM = 0x001000;
static const DWORD FORMAT_MESSAGE_IGNORE_INSERTS = 0x000200;
static const UINT CP_UTF8 = 65001;

/* --- File Access Rights --- */
static const DWORD GENERIC_READ = 0x80000000;
static const DWORD GENERIC_WRITE = 0x40000000;
static const DWORD GENERIC_EXECUTE = 0x20000000;
static const DWORD GENERIC_ALL = 0x10000000;

/* --- File Creation Disposition --- */
static const DWORD CREATE_NEW = 1;
static const DWORD CREATE_ALWAYS = 2;
static const DWORD OPEN_EXISTING = 3;
static const DWORD OPEN_ALWAYS = 4;
static const DWORD TRUNCATE_EXISTING = 5;

/* --- File Attributes --- */
static const DWORD FILE_ATTRIBUTE_NORMAL = 0x00000080;

/* --- File & Disposition Constants --- */
static const DWORD DELETE = 0x00010000;
static const DWORD FILE_SHARE_READ = 0x00000001;
static const DWORD FILE_SHARE_WRITE = 0x00000002;
static const DWORD FILE_SHARE_DELETE = 0x00000004;
static const DWORD FILE_FLAG_BACKUP_SEMANTICS = 0x02000000;

/* FileInformationClass constants */
static const int FileDispositionInfoEx = 21;

/* FILE_DISPOSITION_INFO_EX Flags */
static const DWORD FILE_DISPOSITION_DELETE = 0x00000001;
static const DWORD FILE_DISPOSITION_POSIX_SEMANTICS = 0x00000002;

/* --- File Move Constants --- */
static const DWORD MOVEFILE_REPLACE_EXISTING = 0x00000001;
static const DWORD MOVEFILE_COPY_ALLOWED = 0x00000002;
static const DWORD MOVEFILE_WRITE_THROUGH = 0x00000008;

/* --- Structures for CreateProcess --- */
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

/* --- Structures for Toolhelp32 --- */
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

/* --- Structures for File Operations --- */
typedef struct _FILE_DISPOSITION_INFO_EX {
    DWORD Flags;
} FILE_DISPOSITION_INFO_EX;

/* --- Handle API --- */
BOOL CloseHandle(HANDLE hObject);

/* --- Toolhelp32 API --- */
HANDLE CreateToolhelp32Snapshot(DWORD dwFlags, DWORD th32ProcessID);
BOOL Process32FirstW(HANDLE hSnapshot, PROCESSENTRY32W* lppe);
BOOL Process32NextW(HANDLE hSnapshot, PROCESSENTRY32W* lppe);

/* --- Process & Thread --- */
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

/* --- Module Handling --- */
HMODULE LoadLibraryW(LPCWSTR lpLibFileName);
BOOL FreeLibrary(HMODULE hLibModule);

/* --- Environment API --- */
BOOL SetEnvironmentVariableW(LPCWSTR lpName, LPCWSTR lpValue);
DWORD GetEnvironmentVariableW(LPCWSTR lpName, LPWSTR lpBuffer, DWORD nSize);

/* --- Event API --- */
HANDLE CreateEventW(void* lpEventAttributes, BOOL bManualReset, BOOL bInitialState, LPCWSTR lpName);
HANDLE OpenEventW(DWORD dwDesiredAccess, BOOL bInheritHandle, LPCWSTR lpName);
BOOL SetEvent(HANDLE hEvent);
BOOL ResetEvent(HANDLE hEvent);

/* --- File API --- */
HANDLE CreateFileW(LPCWSTR lpFileName, DWORD dwDesiredAccess, DWORD dwShareMode, void* lpSecurityAttributes, DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes, HANDLE hTemplateFile);
BOOL CopyFileW(LPCWSTR lpExistingFileName, LPCWSTR lpNewFileName, BOOL bFailIfExists);
BOOL MoveFileExW(LPCWSTR lpExistingFileName, LPCWSTR lpNewFileName, DWORD dwFlags);
BOOL CreateHardLinkW(LPCWSTR lpFileName, LPCWSTR lpExistingFileName, void* lpSecurityAttributes);
BOOLEAN CreateSymbolicLinkW(LPCWSTR lpSymlinkFileName, LPCWSTR lpTargetFileName, DWORD dwFlags);
DWORD GetShortPathNameW(LPCWSTR lpszLongPath, LPWSTR lpszShortPath, DWORD cchBuffer);
DWORD GetTempPathW(DWORD nBufferLength, LPWSTR lpBuffer);
UINT GetTempFileNameW(LPCWSTR lpPathName, LPCWSTR lpPrefixString, UINT uUnique, LPWSTR lpTempFileName);
BOOL SetFileInformationByHandle(HANDLE hFile, int FileInformationClass, void* lpFileInformation, DWORD dwBufferSize);
BOOL CreateDirectoryW(LPCWSTR lpPathName, void* lpSecurityAttributes);
BOOL RemoveDirectoryW(LPCWSTR lpPathName);
DWORD GetFullPathNameW(LPCWSTR lpFileName, DWORD nBufferLength, LPWSTR lpBuffer, LPWSTR* lpFilePart);

/* --- Memory Management --- */
HLOCAL LocalFree(HLOCAL hMem);

/* --- String Encoding & Comparisons --- */
int WideCharToMultiByte(unsigned int CodePage, DWORD dwFlags, LPCWSTR lpWideCharStr, int cchWideChar, LPSTR lpMultiByteStr, int cbMultiByte, LPCSTR lpDefaultChar, int* lpUsedDefaultChar);
int MultiByteToWideChar(unsigned int CodePage, DWORD dwFlags, LPCSTR lpMultiByteStr, int cbMultiByte, LPTSTR lpWideCharStr, int cchWideChar);
/* [MOVED] Needed for zero-allocation comparisons in proc.lua */
int lstrcmpiW(LPCWSTR lpString1, LPCWSTR lpString2);

/* --- Error Handling --- */
DWORD GetLastError(void);
void SetLastError(DWORD dwErrCode);
DWORD FormatMessageW(DWORD dwFlags, const void* lpSource, DWORD dwMessageId, DWORD dwLanguageId, LPWSTR lpBuffer, DWORD nSize, void* Arguments);

/* --- File I/O --- */
BOOL ReadFile(HANDLE hFile, void* lpBuffer, DWORD nNumberOfBytesToRead, DWORD* lpNumberOfBytesRead, void* lpOverlapped);
BOOL WriteFile(HANDLE hFile, const void* lpBuffer, DWORD nNumberOfBytesToWrite, DWORD* lpNumberOfBytesWritten, void* lpOverlapped);
BOOL FlushFileBuffers(HANDLE hFile);
BOOL GetFileSizeEx(HANDLE hFile, LARGE_INTEGER* lpFileSize);
BOOL SetFilePointerEx(HANDLE hFile, LARGE_INTEGER liDistanceToMove, LARGE_INTEGER* lpNewFilePointer, DWORD dwMoveMethod);

/* --- File Attributes & Drive Info --- */
DWORD GetFileAttributesW(LPCWSTR lpFileName);
BOOL SetFileAttributesW(LPCWSTR lpFileName, DWORD dwFileAttributes);
DWORD GetLogicalDrives(void);
UINT GetDriveTypeW(LPCWSTR lpRootPathName);
BOOL GetVolumeInformationW(LPCWSTR lpRootPathName, LPWSTR lpVolumeNameBuffer, DWORD nVolumeNameSize, DWORD* lpVolumeSerialNumber, DWORD* lpMaximumComponentLength, DWORD* lpFileSystemFlags, LPWSTR lpFileSystemNameBuffer, DWORD nFileSystemNameSize);
BOOL GetDiskFreeSpaceExW(LPCWSTR lpDirectoryName, ULARGE_INTEGER* lpFreeBytesAvailableToCaller, ULARGE_INTEGER* lpTotalNumberOfBytes, ULARGE_INTEGER* lpTotalNumberOfFreeBytes);

/* --- Environment Expansion --- */
DWORD ExpandEnvironmentStringsW(LPCWSTR lpSrc, LPWSTR lpDst, DWORD nSize);
]]

return ffi.load("kernel32")
