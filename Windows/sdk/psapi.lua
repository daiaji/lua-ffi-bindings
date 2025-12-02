local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
typedef struct _PROCESS_MEMORY_COUNTERS_EX {
    DWORD cb;
    DWORD PageFaultCount;
    size_t PeakWorkingSetSize;
    size_t WorkingSetSize;
    size_t QuotaPeakPagedPoolUsage;
    size_t QuotaPagedPoolUsage;
    size_t QuotaPeakNonPagedPoolUsage;
    size_t QuotaNonPagedPoolUsage;
    size_t PagefileUsage;
    size_t PeakPagefileUsage;
    size_t PrivateUsage;
} PROCESS_MEMORY_COUNTERS_EX;

DWORD GetModuleFileNameExW(HANDLE hProcess, HMODULE hModule, LPWSTR lpFilename, DWORD nSize);
BOOL GetProcessMemoryInfo(HANDLE Process, void* ppsmemCounters, DWORD cb);

/* [NEW] Module Enumeration */
static const DWORD LIST_MODULES_ALL = 0x03;
static const DWORD LIST_MODULES_32BIT = 0x01;
static const DWORD LIST_MODULES_64BIT = 0x02;

BOOL EnumProcessModulesEx(HANDLE hProcess, HMODULE* lphModule, DWORD cb, LPDWORD lpcbNeeded, DWORD dwFilterFlag);
]]

return ffi.load("psapi")