local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    typedef void* HDEVINFO;
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

    /* For CycleDevice */
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

    static const DWORD DIF_PROPERTYCHANGE = 0x00000012;
    static const DWORD DICS_ENABLE = 0x00000001;
    static const DWORD DICS_DISABLE = 0x00000002;
    static const DWORD DICS_FLAG_GLOBAL = 0x00000001;
    static const DWORD DICS_FLAG_CONFIGSPECIFIC = 0x00000002;

    HDEVINFO SetupDiGetClassDevsW(const GUID* ClassGuid, LPCWSTR Enumerator, HWND hwndParent, DWORD Flags);
    BOOL SetupDiEnumDeviceInfo(HDEVINFO DeviceInfoSet, DWORD MemberIndex, PSP_DEVINFO_DATA DeviceInfoData);
    BOOL SetupDiEnumDeviceInterfaces(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA DeviceInfoData, const GUID* InterfaceClassGuid, DWORD MemberIndex, PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData);
    BOOL SetupDiGetDeviceInterfaceDetailW(HDEVINFO DeviceInfoSet, PSP_DEVICE_INTERFACE_DATA DeviceInterfaceData, PSP_DEVICE_INTERFACE_DETAIL_DATA_W DeviceInterfaceDetailData, DWORD DeviceInterfaceDetailDataSize, DWORD* RequiredSize, PSP_DEVINFO_DATA DeviceInfoData);
    BOOL SetupDiGetDeviceRegistryPropertyW(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA DeviceInfoData, DWORD Property, DWORD* PropertyRegDataType, BYTE* PropertyBuffer, DWORD PropertyBufferSize, DWORD* RequiredSize);
    BOOL SetupDiDestroyDeviceInfoList(HDEVINFO DeviceInfoSet);
    
    BOOL SetupDiSetClassInstallParamsW(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA DeviceInfoData, PSP_CLASSINSTALL_HEADER ClassInstallParams, DWORD ClassInstallParamsSize);
    BOOL SetupDiChangeState(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA DeviceInfoData);
    BOOL SetupDiGetDeviceInstanceIdW(HDEVINFO DeviceInfoSet, PSP_DEVINFO_DATA DeviceInfoData, PWSTR DeviceInstanceId, DWORD DeviceInstanceIdSize, PDWORD RequiredSize);
]]

return ffi.load("setupapi")