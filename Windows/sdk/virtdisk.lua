local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    /* --- Constants --- */
    static const int VIRTUAL_DISK_ACCESS_ALL = 0x00030000;
    static const int VIRTUAL_DISK_ACCESS_CREATE = 0x00100000;
    
    static const int CREATE_VIRTUAL_DISK_FLAG_FULL_PHYSICAL_ALLOCATION = 0x00000008;
    static const int OPEN_VIRTUAL_DISK_FLAG_NONE = 0x00000000;
    
    static const int ATTACH_VIRTUAL_DISK_FLAG_NONE = 0x00000000;
    static const int DETACH_VIRTUAL_DISK_FLAG_NONE = 0x00000000;
    static const int EXPAND_VIRTUAL_DISK_FLAG_NONE = 0x00000000;

    /* Device IDs */
    static const int VIRTUAL_STORAGE_TYPE_DEVICE_UNKNOWN = 0;
    static const int VIRTUAL_STORAGE_TYPE_DEVICE_ISO     = 1;
    static const int VIRTUAL_STORAGE_TYPE_DEVICE_VHD     = 2;
    static const int VIRTUAL_STORAGE_TYPE_DEVICE_VHDX    = 3;

    typedef struct _VIRTUAL_STORAGE_TYPE {
        DWORD DeviceId;
        GUID  VendorId;
    } VIRTUAL_STORAGE_TYPE;

    typedef struct _CREATE_VIRTUAL_DISK_PARAMETERS {
        DWORD Version;
        struct {
            GUID      UniqueId;
            ULONGLONG MaximumSize;
            ULONG     BlockSizeInBytes;
            ULONG     SectorSizeInBytes;
            ULONG     PhysicalSectorSizeInBytes;
            LPCWSTR   ParentPath;
            LPCWSTR   SourcePath;
            DWORD     OpenFlags;
            VIRTUAL_STORAGE_TYPE ParentVirtualStorageType;
            VIRTUAL_STORAGE_TYPE SourceVirtualStorageType;
            GUID                 ResiliencyGuid;
        } Version2;
    } CREATE_VIRTUAL_DISK_PARAMETERS;

    typedef struct _EXPAND_VIRTUAL_DISK_PARAMETERS {
        DWORD Version; // 1
        struct {
            ULONGLONG NewSize;
        } Version1;
    } EXPAND_VIRTUAL_DISK_PARAMETERS;

    DWORD OpenVirtualDisk(void* VirtualStorageType, const wchar_t* Path, int VirtualDiskAccessMask, int Flags, void* Parameters, HANDLE* Handle);
    DWORD AttachVirtualDisk(HANDLE VirtualDiskHandle, void* SecurityDescriptor, int Flags, uint32_t ProviderSpecificFlags, void* Parameters, void* Overlapped);
    DWORD DetachVirtualDisk(HANDLE VirtualDiskHandle, int Flags, uint32_t ProviderSpecificFlags);
    DWORD GetVirtualDiskPhysicalPath(HANDLE VirtualDiskHandle, DWORD* DiskPathSizeInBytes, wchar_t* DiskPath);
    
    DWORD CreateVirtualDisk(
        void* VirtualStorageType,
        const wchar_t* Path,
        int VirtualDiskAccessMask,
        void* SecurityDescriptor,
        int Flags,
        uint32_t ProviderSpecificFlags,
        void* Parameters,
        void* Overlapped,
        HANDLE* Handle
    );

    DWORD ExpandVirtualDisk(
        HANDLE VirtualDiskHandle,
        int Flags,
        EXPAND_VIRTUAL_DISK_PARAMETERS* Parameters,
        void* Overlapped
    );
]]

return ffi.load("virtdisk")