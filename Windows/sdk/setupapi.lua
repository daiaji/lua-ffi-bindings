local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    /* --- Handle Types --- */
    typedef void* HDEVINFO;
    typedef void* HINF;
    
    /* --- Structures --- */
    typedef struct _SP_DEVINFO_DATA {
        DWORD cbSize;
        GUID  ClassGuid;
        DWORD DevInst;
        ULONG_PTR Reserved;
    } SP_DEVINFO_DATA, *PSP_DEVINFO_DATA;

    typedef struct _SP_DEVICE_INTERFACE_DATA {
        DWORD cbSize;
        GUID  InterfaceClassGuid;
        DWORD Flags;
        ULONG_PTR Reserved;
    } SP_DEVICE_INTERFACE_DATA, *PSP_DEVICE_INTERFACE_DATA;

    typedef struct _SP_DEVICE_INTERFACE_DETAIL_DATA_W {
        DWORD cbSize;
        WCHAR DevicePath[1];
    } SP_DEVICE_INTERFACE_DETAIL_DATA_W, *PSP_DEVICE_INTERFACE_DETAIL_DATA_W;

    /* For Device State Change / Cycle Port */
    typedef struct _SP_CLASSINSTALL_HEADER {
        DWORD cbSize;
        DWORD InstallFunction;
    } SP_CLASSINSTALL_HEADER, *PSP_CLASSINSTALL_HEADER;

    typedef struct _SP_PROPCHANGE_PARAMS {
        SP_CLASSINSTALL_HEADER ClassInstallHeader;
        DWORD StateChange;
        DWORD Scope;
        DWORD HwProfile;
    } SP_PROPCHANGE_PARAMS, *PSP_PROPCHANGE_PARAMS;

    typedef struct { 
        UINT_PTR opaque[2];
        uint32_t padding[4];
    } INFCONTEXT;

    typedef UINT (CALLBACK *PSP_FILE_CALLBACK_W)(void* Context, UINT Notification, UINT_PTR Param1, UINT_PTR Param2);

    typedef struct _FILE_IN_CABINET_INFO_W {
        PCWSTR NameInCabinet;
        DWORD  FileSize;
        DWORD  Win32Error;
        WORD   DosDate;
        WORD   DosTime;
        WORD   DosAttribs;
        WCHAR  FullTargetName[260];
    } FILE_IN_CABINET_INFO_W, *PFILE_IN_CABINET_INFO_W;

    /* --- Constants --- */
    static const DWORD DIF_PROPERTYCHANGE = 0x00000012;
    
    static const DWORD DICS_ENABLE  = 0x00000001;
    static const DWORD DICS_DISABLE = 0x00000002;
    
    static const DWORD DICS_FLAG_GLOBAL         = 0x00000001;
    static const DWORD DICS_FLAG_CONFIGSPECIFIC = 0x00000002;

    /* --- Device Enumeration APIs --- */
    HDEVINFO SetupDiGetClassDevsW(const GUID* ClassGuid, LPCWSTR Enumerator, HWND hwndParent, DWORD Flags);
    BOOL SetupDiEnumDeviceInfo(HDEVINFO DeviceInfoSet, DWORD MemberIndex, PSP_DEVINFO_DATA DeviceInfoData);
    BOOL SetupDiEnumDeviceInterfaces(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA DeviceInfoData, const GUID* InterfaceClassGuid, DWORD MemberIndex, PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData);
    BOOL SetupDiGetDeviceInterfaceDetailW(HDEVINFO DeviceInfoSet, PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData, PSP_DEVICE_INTERFACE_DETAIL_DATA_W DeviceInterfaceDetailData, DWORD DeviceInterfaceDetailDataSize, DWORD* RequiredSize, PSP_DEVINFO_DATA DeviceInfoData);
    
    /* Used for getting HardwareIDs, Descriptions, etc. */
    BOOL SetupDiGetDeviceRegistryPropertyW(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA DeviceInfoData, DWORD Property, DWORD* PropertyRegDataType, BYTE* PropertyBuffer, DWORD PropertyBufferSize, DWORD* RequiredSize);
    
    BOOL SetupDiDestroyDeviceInfoList(HDEVINFO DeviceInfoSet);
    
    /* --- State Change APIs --- */
    BOOL SetupDiSetClassInstallParamsW(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA DeviceInfoData, PSP_CLASSINSTALL_HEADER ClassInstallParams, DWORD ClassInstallParamsSize);
    BOOL SetupDiChangeState(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA DeviceInfoData);
    BOOL SetupDiGetDeviceInstanceIdW(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA DeviceInfoData, PWSTR DeviceInstanceId, DWORD DeviceInstanceIdSize, PDWORD RequiredSize);

    /* --- [NEW] Driver Store Operations (SetupCopyOEMInf) --- */
    
    /* Copy Styles */
    static const DWORD SPOST_NONE = 0;
    static const DWORD SPOST_PATH = 1;
    static const DWORD SPOST_URL  = 2;

    /* Flags */
    static const DWORD SP_COPY_DELETESOURCE        = 0x00000001;
    static const DWORD SP_COPY_REPLACEONLY         = 0x00000002;
    static const DWORD SP_COPY_NOOVERWRITE         = 0x00000004;
    static const DWORD SP_COPY_OEMINF_CATALOG_ONLY = 0x00800000;

    /* 
       Pre-loads a driver into the Driver Store. 
       This allows PnP to automatically find the driver later.
    */
    BOOL SetupCopyOEMInfW(
        PCWSTR SourceInfFileName,
        PCWSTR OEMSourceMediaLocation,
        DWORD OEMSourceMediaType,
        DWORD CopyStyle,
        PWSTR DestinationInfFileName,
        DWORD DestinationInfFileNameSize,
        PDWORD RequiredSize,
        PWSTR* DestinationInfFileNameComponent
    );

    /* INF File APIs */
    HINF SetupOpenInfFileW(PCWSTR FileName, PCWSTR InfClass, DWORD InfStyle, UINT* ErrorLine);
    void SetupCloseInfFile(HINF InfHandle);
    BOOL SetupFindFirstLineW(HINF InfHandle, PCWSTR Section, PCWSTR Key, PVOID Context);
    BOOL SetupFindNextLine(PVOID Context, PVOID ContextOut);
    BOOL SetupGetStringFieldW(PVOID Context, DWORD FieldIndex, PWSTR ReturnBuffer, DWORD ReturnBufferSize, PDWORD RequiredSize);
    BOOL SetupIterateCabinetW(PCWSTR CabinetFile, DWORD Reserved, PSP_FILE_CALLBACK_W MsgHandler, void* Context);
]]

return ffi.load("setupapi")