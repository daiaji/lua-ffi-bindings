local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    typedef unsigned long PNP_VETO_TYPE;
    typedef DWORD CONFIGRET;
    typedef DWORD DEVINST;
    typedef DEVINST *PDEVINST; /* [FIX] Added pointer definition */
    typedef DWORD DEVNODE;
    typedef DEVNODE *PDEVNODE; /* [FIX] Added pointer definition */
    typedef CHAR* DEVINSTID_A;
    typedef WCHAR* DEVINSTID_W;

    /* ConfigRet Codes */
    static const CONFIGRET CR_SUCCESS = 0x00000000;
    static const CONFIGRET CR_NO_SUCH_DEVNODE = 0x0000000D;

    /* Property Codes */
    static const DWORD CM_DRP_DEVICEDESC = 0x00000001;
    static const DWORD CM_DRP_HARDWAREID = 0x00000002;
    static const DWORD CM_DRP_SERVICE = 0x00000005;
    static const DWORD CM_DRP_CLASS = 0x00000007;
    static const DWORD CM_DRP_CLASSGUID = 0x00000008;
    static const DWORD CM_DRP_FRIENDLYNAME = 0x0000000C;
    static const DWORD CM_DRP_ADDRESS = 0x0000001C;
    static const DWORD CM_DRP_PHYSICAL_DEVICE_OBJECT_NAME = 0x0000000E;

    /* Flags */
    static const ULONG CM_LOCATE_DEVNODE_NORMAL = 0x00000000;
    static const ULONG CM_LOCATE_DEVNODE_PHANTOM = 0x00000001;

    CONFIGRET CM_Locate_DevNodeW(PDEVINST pdnDevInst, DEVINSTID_W pDeviceID, ULONG ulFlags);
    CONFIGRET CM_Get_Parent(PDEVINST pdnDevInst, DEVINST dnDevInst, ULONG ulFlags);
    CONFIGRET CM_Get_Device_IDW(DEVINST dnDevInst, WCHAR* Buffer, ULONG BufferLen, ULONG ulFlags);
    CONFIGRET CM_Get_DevNode_Registry_PropertyW(DEVINST dnDevInst, ULONG ulProperty, PULONG pulRegDataType, PVOID Buffer, PULONG pulLength, ULONG ulFlags);
    CONFIGRET CM_Get_DevNode_Status(PULONG pulStatus, PULONG pulProblemNumber, DWORD dnDevInst, ULONG ulFlags);
    CONFIGRET CM_Request_Device_EjectW(DWORD dnDevInst, PNP_VETO_TYPE* pVetoType, WCHAR* pszVetoName, ULONG ulNameLength, ULONG ulFlags);
]]

return ffi.load("cfgmgr32")