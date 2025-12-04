local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef[[
    /* --- IOCTL Codes --- */
    static const uint32_t IOCTL_STORAGE_QUERY_PROPERTY     = 0x002D1400;
    static const uint32_t IOCTL_STORAGE_GET_DEVICE_NUMBER  = 0x002D1080;
    static const uint32_t IOCTL_STORAGE_CHECK_VERIFY       = 0x002D4800;
    static const uint32_t IOCTL_MOUNTMGR_QUERY_AUTO_MOUNT  = 0x006D003C;
    static const uint32_t IOCTL_MOUNTMGR_SET_AUTO_MOUNT    = 0x006D0040;
    
    static const uint32_t IOCTL_DISK_GET_DRIVE_GEOMETRY_EX = 0x000700A0;
    static const uint32_t IOCTL_DISK_GET_DRIVE_LAYOUT_EX   = 0x00070050;
    static const uint32_t IOCTL_DISK_SET_DRIVE_LAYOUT_EX   = 0x0007C054;
    static const uint32_t IOCTL_DISK_CREATE_DISK           = 0x0007C058;
    static const uint32_t IOCTL_DISK_UPDATE_PROPERTIES     = 0x00070014;
    static const uint32_t IOCTL_DISK_GET_DISK_ATTRIBUTES   = 0x0007003C;
    static const uint32_t IOCTL_DISK_SET_DISK_ATTRIBUTES   = 0x0007C040;
    
    static const uint32_t FSCTL_LOCK_VOLUME                = 0x00090018;
    static const uint32_t FSCTL_UNLOCK_VOLUME              = 0x0009001C;
    static const uint32_t FSCTL_DISMOUNT_VOLUME            = 0x00090020;
    static const uint32_t FSCTL_ALLOW_EXTENDED_DASD_IO     = 0x00090083;
    static const uint32_t FSCTL_SHRINK_VOLUME              = 0x000900A4;
    static const uint32_t FSCTL_EXTEND_VOLUME              = 0x00090090;
    
    static const uint32_t VOLUME_GET_VOLUME_DISK_EXTENTS   = 0x00560000;
    static const uint32_t IOCTL_USB_HUB_CYCLE_PORT         = 0x00220444;

    /* Reparse & Compression */
    static const uint32_t FSCTL_GET_REPARSE_POINT    = 0x000900A8;
    static const uint32_t FSCTL_SET_REPARSE_POINT    = 0x000900A4;
    static const uint32_t FSCTL_DELETE_REPARSE_POINT = 0x000900AC;
    static const uint32_t FSCTL_SET_SPARSE           = 0x000900C4;
    static const uint32_t FSCTL_SET_COMPRESSION      = 0x0009C040;
    static const uint32_t FSCTL_GET_COMPRESSION      = 0x0009003C;

    /* --- Constants --- */
    static const uint16_t COMPRESSION_FORMAT_NONE    = 0x0000;
    static const uint16_t COMPRESSION_FORMAT_DEFAULT = 0x0001;
    static const uint16_t COMPRESSION_FORMAT_LZNT1   = 0x0002;

    /* ... [Include structs from original code: DISK_GEOMETRY, DRIVE_LAYOUT_INFORMATION_EX etc.] ... */
    /* (Ensure all structs from previous context are retained here) */
    typedef struct _DISK_GEOMETRY {
        LARGE_INTEGER Cylinders;
        int           MediaType;
        DWORD         TracksPerCylinder;
        DWORD         SectorsPerTrack;
        DWORD         BytesPerSector;
    } DISK_GEOMETRY;

    typedef struct _DISK_GEOMETRY_EX {
        DISK_GEOMETRY Geometry;
        LARGE_INTEGER DiskSize;
        BYTE          Data[1];
    } DISK_GEOMETRY_EX;

    typedef struct _PARTITION_INFORMATION_MBR {
        BYTE    PartitionType;
        BOOLEAN BootIndicator;
        BOOLEAN RecognizedPartition;
        DWORD   HiddenSectors;
        GUID    PartitionId; 
    } PARTITION_INFORMATION_MBR;

    typedef struct _PARTITION_INFORMATION_GPT {
        GUID    PartitionType;
        GUID    PartitionId;
        DWORD64 Attributes;
        WCHAR   Name[36];
    } PARTITION_INFORMATION_GPT;

    typedef enum _PARTITION_STYLE {
        PARTITION_STYLE_MBR = 0,
        PARTITION_STYLE_GPT = 1,
        PARTITION_STYLE_RAW = 2
    } PARTITION_STYLE;

    typedef struct _PARTITION_INFORMATION_EX {
        PARTITION_STYLE PartitionStyle;
        LARGE_INTEGER   StartingOffset;
        LARGE_INTEGER   PartitionLength;
        DWORD           PartitionNumber;
        BOOLEAN         RewritePartition;
        BOOLEAN         IsServicePartition; 
        union {
            PARTITION_INFORMATION_MBR Mbr;
            PARTITION_INFORMATION_GPT Gpt;
        };
    } PARTITION_INFORMATION_EX;

    /* Extended version for FFI allocation (Max partitions) */
    typedef struct _DRIVE_LAYOUT_INFORMATION_EX_FULL {
        DWORD           PartitionStyle;
        DWORD           PartitionCount;
        union {
            struct { DWORD Signature; DWORD CheckSum; } Mbr;
            struct {
                GUID          DiskId;
                LARGE_INTEGER StartingUsableOffset;
                LARGE_INTEGER UsableLength;
                DWORD         MaxPartitionCount;
            } Gpt;
        };
        PARTITION_INFORMATION_EX PartitionEntry[128];
    } DRIVE_LAYOUT_INFORMATION_EX_FULL;

    typedef struct _CREATE_DISK {
        PARTITION_STYLE PartitionStyle;
        union {
            struct { DWORD Signature; } Mbr;
            struct {
                GUID  DiskId;
                DWORD MaxPartitionCount;
            } Gpt;
        };
    } CREATE_DISK;

    typedef struct _DISK_EXTENT {
        DWORD         DiskNumber;
        LARGE_INTEGER StartingOffset;
        LARGE_INTEGER ExtentLength;
    } DISK_EXTENT;

    typedef struct _VOLUME_DISK_EXTENTS {
        DWORD       NumberOfDiskExtents;
        DISK_EXTENT Extents[1];
    } VOLUME_DISK_EXTENTS;

    typedef struct _GET_DISK_ATTRIBUTES {
        DWORD   Version;
        DWORD   Reserved1;
        DWORD64 Attributes;
    } GET_DISK_ATTRIBUTES;

    typedef struct _SET_DISK_ATTRIBUTES {
        DWORD   Version;
        BOOLEAN Persist;
        BYTE    Reserved1[3];
        DWORD64 Attributes;
        DWORD64 AttributesMask;
        DWORD   Reserved2[4];
    } SET_DISK_ATTRIBUTES;
    
    typedef struct _STORAGE_DEVICE_NUMBER {
        DWORD DeviceType;
        DWORD DeviceNumber;
        DWORD PartitionNumber;
    } STORAGE_DEVICE_NUMBER;
    
    typedef struct _STORAGE_DESCRIPTOR_HEADER {
        DWORD Version;
        DWORD Size;
    } STORAGE_DESCRIPTOR_HEADER;

    typedef struct _STORAGE_DEVICE_DESCRIPTOR {
        DWORD Version;
        DWORD Size;
        BYTE  DeviceType;
        BYTE  DeviceTypeModifier;
        BOOLEAN RemovableMedia;
        BOOLEAN CommandQueueing;
        DWORD VendorIdOffset;
        DWORD ProductIdOffset;
        DWORD ProductRevisionOffset;
        DWORD SerialNumberOffset;
        BYTE  BusType;
        DWORD RawPropertiesLength;
        BYTE  RawDeviceProperties[1];
    } STORAGE_DEVICE_DESCRIPTOR;

    typedef struct _STORAGE_PROPERTY_QUERY {
        DWORD PropertyId;
        DWORD QueryType;
        BYTE  AdditionalParameters[1];
    } STORAGE_PROPERTY_QUERY;

    /* USB Parameters */
    typedef struct _USB_CYCLE_PORT_PARAMS {
        ULONG ConnectionIndex;
        ULONG StatusReturned;
    } USB_CYCLE_PORT_PARAMS;
]]

return ffi.C