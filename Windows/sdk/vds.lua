local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef[[
    /* --- Base COM Interface --- */
    typedef struct IUnknown IUnknown;
    typedef struct IUnknownVtbl {
        HRESULT (__stdcall *QueryInterface)(IUnknown *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IUnknown *This);
        ULONG (__stdcall *Release)(IUnknown *This);
    } IUnknownVtbl;
    struct IUnknown { const IUnknownVtbl *lpVtbl; };

    /* --- VDS Types --- */
    typedef GUID VDS_OBJECT_ID;
    
    typedef enum _VDS_OBJECT_TYPE {
        VDS_OT_UNKNOWN = 0,
        VDS_OT_PROVIDER,
        VDS_OT_PACK,
        VDS_OT_VOLUME,
        VDS_OT_VOLUME_PLEX,
        VDS_OT_DISK,
        VDS_OT_SUB_SYSTEM,
        VDS_OT_CONTROLLER,
        VDS_OT_DRIVE_LETTER,
        VDS_OT_FILE_SYSTEM,
        VDS_OT_MOUNT_POINT,
        VDS_OT_PORT,
        VDS_OT_LUN,
        VDS_OT_TARGET,
        VDS_OT_ISCSI_PORTAL_GROUP,
        VDS_OT_ISCSI_TARGET,
        VDS_OT_ISCSI_PORTAL,
        VDS_OT_ISCSI_INITIATOR,
        VDS_OT_ISCSI_LOGIN_SESSION,
        VDS_OT_ISCSI_BINDING,
        VDS_OT_HBA_PORT,
        VDS_OT_HBA,
        VDS_OT_LUN_PLEX,
        VDS_OT_PATH
    } VDS_OBJECT_TYPE;

    typedef enum _VDS_PARTITION_STYLE {
        VDS_PST_UNKNOWN = 0,
        VDS_PST_MBR = 1,
        VDS_PST_GPT = 2
    } VDS_PARTITION_STYLE;

    typedef struct _CREATE_PARTITION_PARAMETERS {
        VDS_PARTITION_STYLE style;
        union {
            struct {
                BYTE    PartitionType;
                BOOLEAN BootIndicator;
            } Mbr;
            struct {
                GUID      PartitionType;
                GUID      PartitionId;
                ULONGLONG Attributes;
                WCHAR     Name[36];
            } Gpt;
        } Info;
    } CREATE_PARTITION_PARAMETERS;

    /* --- Forward Declarations --- */
    typedef struct IVdsServiceLoader IVdsServiceLoader;
    typedef struct IVdsService IVdsService;
    typedef struct IEnumVdsObject IEnumVdsObject;
    typedef struct IVdsProvider IVdsProvider;
    typedef struct IVdsSwProvider IVdsSwProvider;
    typedef struct IVdsPack IVdsPack;
    typedef struct IVdsDisk IVdsDisk;
    typedef struct IVdsAdvancedDisk IVdsAdvancedDisk;
    typedef struct IVdsVolume IVdsVolume;
    typedef struct IVdsVolumeMF3 IVdsVolumeMF3;
    typedef struct IVdsAsync IVdsAsync;

    /* --- Structures --- */
    /* [FIXED] Correct VDS_DISK_PROP layout including pwszName */
    typedef struct _VDS_DISK_PROP {
        VDS_OBJECT_ID        id;
        int                  status;
        int                  ReserveMode;
        int                  health;
        DWORD                dwDeviceType;
        DWORD                dwMediaType;
        ULONGLONG            ullSize;
        ULONGLONG            ullBytesAllocated;
        ULONG                ulFlags;
        int                  BusType;
        VDS_PARTITION_STYLE  PartitionStyle;
        union {
            struct { DWORD dwSignature; } Mbr;
            struct { GUID DiskId; } Gpt;
        };
        LPWSTR               pwszDiskAddress;
        LPWSTR               pwszName;
        LPWSTR               pwszFriendlyName;
        LPWSTR               pwszAdaptorName;
        LPWSTR               pwszDevicePath;
    } VDS_DISK_PROP;

    typedef struct _VDS_VOLUME_PROP {
        VDS_OBJECT_ID        id;
        int                  type;
        int                  status;
        int                  health;
        int                  TransitionState;
        ULONGLONG            ullSize;
        ULONG                ulFlags;
        int                  RecommendedFileSystemType;
        LPWSTR               pwszName;
    } VDS_VOLUME_PROP;

    typedef struct _VDS_ASYNC_OUTPUT {
        int     type;
        union {
            struct {
                ULONG     ulPercentCompleted;
                ULONGLONG ullBytesCompleted;
            } cp;
            struct {
                HRESULT   hrState;
                void*     pIdArray;
            } cv;
            struct {
                HRESULT   hrState;
                BOOL      bRestartRequired;
            } b;
        } Info;
    } VDS_ASYNC_OUTPUT;

    /* --- VTables --- */
    typedef struct IVdsServiceLoaderVtbl {
        HRESULT (__stdcall *QueryInterface)(IVdsServiceLoader *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IVdsServiceLoader *This);
        ULONG (__stdcall *Release)(IVdsServiceLoader *This);
        HRESULT (__stdcall *LoadService)(IVdsServiceLoader *This, LPCWSTR pwszMachineName, IVdsService **ppService);
    } IVdsServiceLoaderVtbl;
    struct IVdsServiceLoader { const IVdsServiceLoaderVtbl *lpVtbl; };

    typedef struct IVdsServiceVtbl {
        HRESULT (__stdcall *QueryInterface)(IVdsService *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IVdsService *This);
        ULONG (__stdcall *Release)(IVdsService *This);
        HRESULT (__stdcall *IsServiceReady)(IVdsService *This);
        HRESULT (__stdcall *WaitForServiceReady)(IVdsService *This);
        HRESULT (__stdcall *GetProperties)(IVdsService *This, void *pServiceProp);
        HRESULT (__stdcall *QueryProviders)(IVdsService *This, DWORD masks, IEnumVdsObject **ppEnum);
        HRESULT (__stdcall *QueryMaskedDisks)(IVdsService *This, IEnumVdsObject **ppEnum);
        HRESULT (__stdcall *QueryUnallocatedDisks)(IVdsService *This, IEnumVdsObject **ppEnum);
        HRESULT (__stdcall *GetObject)(IVdsService *This, VDS_OBJECT_ID ObjectId, VDS_OBJECT_TYPE type, IUnknown **ppObjectUnk);
        HRESULT (__stdcall *QueryDriveLetters)(IVdsService *This, WCHAR wcFirstLetter, DWORD count, void *pDriveLetterPropArray);
        HRESULT (__stdcall *QueryFileSystemTypes)(IVdsService *This, void **ppFileSystemTypeProps, LONG *plNumberOfFileSystems);
        HRESULT (__stdcall *Reenumerate)(IVdsService *This);
        HRESULT (__stdcall *Refresh)(IVdsService *This);
        HRESULT (__stdcall *CleanupObsoleteMountPoints)(IVdsService *This);
        HRESULT (__stdcall *Advise)(IVdsService *This, void *pSink, DWORD *pdwCookie);
        HRESULT (__stdcall *Unadvise)(IVdsService *This, DWORD dwCookie);
        HRESULT (__stdcall *Reboot)(IVdsService *This);
        HRESULT (__stdcall *SetFlags)(IVdsService *This, ULONG ulFlags);
        HRESULT (__stdcall *ClearFlags)(IVdsService *This, ULONG ulFlags);
    } IVdsServiceVtbl;
    struct IVdsService { const IVdsServiceVtbl *lpVtbl; };

    typedef struct IEnumVdsObjectVtbl {
        HRESULT (__stdcall *QueryInterface)(IEnumVdsObject *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IEnumVdsObject *This);
        ULONG (__stdcall *Release)(IEnumVdsObject *This);
        HRESULT (__stdcall *Next)(IEnumVdsObject *This, ULONG celt, IUnknown **ppObjectArray, ULONG *pcFetched);
        HRESULT (__stdcall *Skip)(IEnumVdsObject *This, ULONG celt);
        HRESULT (__stdcall *Reset)(IEnumVdsObject *This);
        HRESULT (__stdcall *Clone)(IEnumVdsObject *This, IEnumVdsObject **ppEnum);
    } IEnumVdsObjectVtbl;
    struct IEnumVdsObject { const IEnumVdsObjectVtbl *lpVtbl; };

    typedef struct IVdsProviderVtbl {
        HRESULT (__stdcall *QueryInterface)(IVdsProvider *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IVdsProvider *This);
        ULONG (__stdcall *Release)(IVdsProvider *This);
        HRESULT (__stdcall *GetProperties)(IVdsProvider *This, void *pProviderProp);
    } IVdsProviderVtbl;
    struct IVdsProvider { const IVdsProviderVtbl *lpVtbl; };

    typedef struct IVdsSwProviderVtbl {
        HRESULT (__stdcall *QueryInterface)(IVdsSwProvider *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IVdsSwProvider *This);
        ULONG (__stdcall *Release)(IVdsSwProvider *This);
        HRESULT (__stdcall *QueryPacks)(IVdsSwProvider *This, IEnumVdsObject **ppEnum);
        HRESULT (__stdcall *CreatePack)(IVdsSwProvider *This, IVdsPack **ppPack);
    } IVdsSwProviderVtbl;
    struct IVdsSwProvider { const IVdsSwProviderVtbl *lpVtbl; };

    typedef struct IVdsPackVtbl {
        HRESULT (__stdcall *QueryInterface)(IVdsPack *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IVdsPack *This);
        ULONG (__stdcall *Release)(IVdsPack *This);
        HRESULT (__stdcall *GetProperties)(IVdsPack *This, void *pPackProp);
        HRESULT (__stdcall *GetProvider)(IVdsPack *This, IVdsProvider **ppProvider);
        HRESULT (__stdcall *QueryVolumes)(IVdsPack *This, IEnumVdsObject **ppEnum);
        HRESULT (__stdcall *QueryDisks)(IVdsPack *This, IEnumVdsObject **ppEnum);
    } IVdsPackVtbl;
    struct IVdsPack { const IVdsPackVtbl *lpVtbl; };

    typedef struct IVdsDiskVtbl {
        HRESULT (__stdcall *QueryInterface)(IVdsDisk *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IVdsDisk *This);
        ULONG (__stdcall *Release)(IVdsDisk *This);
        HRESULT (__stdcall *GetProperties)(IVdsDisk *This, VDS_DISK_PROP *pDiskProperties);
        HRESULT (__stdcall *GetPack)(IVdsDisk *This, IVdsPack **ppPack);
        HRESULT (__stdcall *GetIdentificationData)(IVdsDisk *This, void *pLunInfo);
        HRESULT (__stdcall *QueryExtents)(IVdsDisk *This, void **ppExtentArray, LONG *plNumberOfExtents);
        HRESULT (__stdcall *ConvertStyle)(IVdsDisk *This, int NewStyle);
        HRESULT (__stdcall *SetFlags)(IVdsDisk *This, ULONG ulFlags);
        HRESULT (__stdcall *ClearFlags)(IVdsDisk *This, ULONG ulFlags);
    } IVdsDiskVtbl;
    struct IVdsDisk { const IVdsDiskVtbl *lpVtbl; };

    typedef struct IVdsAdvancedDiskVtbl {
        HRESULT (__stdcall *QueryInterface)(IVdsAdvancedDisk *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IVdsAdvancedDisk *This);
        ULONG (__stdcall *Release)(IVdsAdvancedDisk *This);
        HRESULT (__stdcall *GetPartitionProperties)(IVdsAdvancedDisk *This, ULONGLONG ullOffset, void *pPartitionProp);
        HRESULT (__stdcall *QueryPartitions)(IVdsAdvancedDisk *This, void **ppPartitionPropArray, LONG *plNumberOfPartitions);
        HRESULT (__stdcall *CreatePartition)(IVdsAdvancedDisk *This, ULONGLONG ullOffset, ULONGLONG ullSize, CREATE_PARTITION_PARAMETERS *para, IVdsAsync **ppAsync);
        HRESULT (__stdcall *DeletePartition)(IVdsAdvancedDisk *This, ULONGLONG ullOffset, BOOL bForce, BOOL bForceProtected);
        HRESULT (__stdcall *ChangeAttributes)(IVdsAdvancedDisk *This, ULONGLONG ullOffset, void *para);
        HRESULT (__stdcall *AssignDriveLetter)(IVdsAdvancedDisk *This, ULONGLONG ullOffset, WCHAR wcLetter);
        HRESULT (__stdcall *DeleteDriveLetter)(IVdsAdvancedDisk *This, ULONGLONG ullOffset, WCHAR wcLetter);
        HRESULT (__stdcall *GetDriveLetter)(IVdsAdvancedDisk *This, ULONGLONG ullOffset, WCHAR *pwcLetter);
        HRESULT (__stdcall *FormatPartition)(IVdsAdvancedDisk *This, ULONGLONG ullOffset, int type, LPWSTR pwszLabel, DWORD dwUnitAllocationSize, BOOL bForce, BOOL bQuickFormat, BOOL bEnableCompression, IVdsAsync **ppAsync);
        HRESULT (__stdcall *Clean)(IVdsAdvancedDisk *This, BOOL bForce, BOOL bForceOEM, BOOL bFullClean, IVdsAsync **ppAsync);
    } IVdsAdvancedDiskVtbl;
    struct IVdsAdvancedDisk { const IVdsAdvancedDiskVtbl *lpVtbl; };

    typedef struct IVdsVolumeVtbl {
        HRESULT (__stdcall *QueryInterface)(IVdsVolume *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IVdsVolume *This);
        ULONG (__stdcall *Release)(IVdsVolume *This);
        HRESULT (__stdcall *GetProperties)(IVdsVolume *This, VDS_VOLUME_PROP *pVolumeProperties);
        HRESULT (__stdcall *GetPack)(IVdsVolume *This, IVdsPack **ppPack);
        HRESULT (__stdcall *QueryPlexes)(IVdsVolume *This, IEnumVdsObject **ppEnum);
        HRESULT (__stdcall *Extend)(IVdsVolume *This, void *pInputDiskArray, LONG lNumberOfDisks, IVdsAsync **ppAsync);
        HRESULT (__stdcall *Shrink)(IVdsVolume *This, ULONGLONG ullNumberOfBytesToRemove, IVdsAsync **ppAsync);
    } IVdsVolumeVtbl;
    struct IVdsVolume { const IVdsVolumeVtbl *lpVtbl; };

    typedef struct IVdsVolumeMF3Vtbl {
        HRESULT (__stdcall *QueryInterface)(IVdsVolumeMF3 *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IVdsVolumeMF3 *This);
        ULONG (__stdcall *Release)(IVdsVolumeMF3 *This);
        HRESULT (__stdcall *QueryVolumeGuidPathnames)(IVdsVolumeMF3 *This, LPWSTR **pwszPathArray, ULONG *pulNumberOfPaths);
        HRESULT (__stdcall *FormatEx2)(IVdsVolumeMF3 *This, LPWSTR pwszFileSystemTypeName, USHORT usFileSystemRevision, ULONG ulDesiredUnitAllocationSize, LPWSTR pwszLabel, DWORD Options, IVdsAsync **ppAsync);
        HRESULT (__stdcall *OfflineVolume)(IVdsVolumeMF3 *This);
    } IVdsVolumeMF3Vtbl;
    struct IVdsVolumeMF3 { const IVdsVolumeMF3Vtbl *lpVtbl; };

    typedef struct IVdsAsyncVtbl {
        HRESULT (__stdcall *QueryInterface)(IVdsAsync *This, const IID* riid, void **ppvObject);
        ULONG (__stdcall *AddRef)(IVdsAsync *This);
        ULONG (__stdcall *Release)(IVdsAsync *This);
        HRESULT (__stdcall *Cancel)(IVdsAsync *This);
        HRESULT (__stdcall *Wait)(IVdsAsync *This, HRESULT *pHrResult, VDS_ASYNC_OUTPUT *pAsyncOut);
        HRESULT (__stdcall *QueryStatus)(IVdsAsync *This, HRESULT *pHrResult, ULONG *pulPercentCompleted);
    } IVdsAsyncVtbl;
    struct IVdsAsync { const IVdsAsyncVtbl *lpVtbl; };
    
    /* --- Constants --- */
    static const DWORD VDS_QUERY_SOFTWARE_PROVIDERS = 0x1;
    static const DWORD VDS_RESCAN_REFRESH           = 0x1;
    static const DWORD VDS_RESCAN_REENUMERATE       = 0x2;
]]

local M = {
    CLSID_VdsLoader = ffi.new("GUID", { 0x9c38ed61, 0xd565, 0x4728, { 0xae, 0xee, 0xc8, 0x09, 0x52, 0xf0, 0xec, 0xde } }),
    IID_IVdsServiceLoader = ffi.new("GUID", { 0xe0393303, 0x90d4, 0x4a97, { 0xab, 0x71, 0xe9, 0xb6, 0x71, 0xee, 0x27, 0x29 } }),
    IID_IVdsProvider = ffi.new("GUID", { 0x10c5e575, 0x7984, 0x4e81, { 0xa5, 0x6b, 0x43, 0x1f, 0x5f, 0x92, 0xae, 0x42 } }),
    IID_IVdsSwProvider = ffi.new("GUID", { 0x9aa58360, 0xce33, 0x4f92, { 0xb6, 0x58, 0xed, 0x24, 0xb1, 0x44, 0x25, 0xb8 } }),
    IID_IVdsPack = ffi.new("GUID", { 0x3b69d7f5, 0x9d94, 0x4648, { 0x91, 0xca, 0x79, 0x93, 0x9b, 0xa2, 0x63, 0xbf } }),
    IID_IVdsDisk = ffi.new("GUID", { 0x07e5c822, 0xf00c, 0x47a1, { 0x8f, 0xce, 0xb2, 0x44, 0xda, 0x56, 0xfd, 0x06 } }),
    IID_IVdsAdvancedDisk = ffi.new("GUID", { 0x6e6f6b40, 0x977c, 0x4069, { 0xbd, 0xdd, 0xac, 0x71, 0x00, 0x59, 0xf8, 0xc0 } }),
    IID_IVdsVolume = ffi.new("GUID", { 0x88306BB2, 0xE71F, 0x478C, { 0x86, 0xA2, 0x79, 0xDA, 0x20, 0x0A, 0x0F, 0x11} }),
    IID_IVdsVolumeMF3 = ffi.new("GUID", { 0x6788FAF9, 0x214E, 0x4B85, { 0xBA, 0x59, 0x26, 0x69, 0x53, 0x61, 0x6E, 0x09 } }),
    
    C = ffi.C
}

return M