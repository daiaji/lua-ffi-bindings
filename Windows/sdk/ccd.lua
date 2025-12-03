local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    /* --- CCD Constants --- */
    typedef enum {
        QDC_ALL_PATHS = 0x00000001,
        QDC_ONLY_ACTIVE_PATHS = 0x00000002,
        QDC_DATABASE_CURRENT = 0x00000004
    } QDC;

    typedef enum {
        SDC_TOPOLOGY_INTERNAL = 0x00000001,
        SDC_TOPOLOGY_CLONE = 0x00000002,
        SDC_TOPOLOGY_EXTEND = 0x00000004,
        SDC_TOPOLOGY_EXTERNAL = 0x00000008,
        SDC_APPLY = 0x00000080,
        SDC_USE_SUPPLIED_DISPLAY_CONFIG = 0x00000020,
        SDC_ALLOW_CHANGES = 0x00000400,
        SDC_SAVE_TO_DATABASE = 0x00000200
    } SDC;

    /* --- CCD Structures --- */
    typedef struct {
        LUID adapterId;
        uint32_t id;
    } DISPLAYCONFIG_DEVICE_INFO_HEADER;

    typedef struct {
        LUID adapterId;
        uint32_t id;
        uint32_t modeInfoIdx;
        uint32_t statusFlags;
    } DISPLAYCONFIG_PATH_SOURCE_INFO;

    typedef struct {
        LUID adapterId;
        uint32_t id;
        uint32_t modeInfoIdx;
        uint32_t outputTechnology;
        uint32_t rotation;
        uint32_t scaling;
        struct { uint32_t Numerator; uint32_t Denominator; } refreshRate;
        uint32_t scanLineOrdering;
        int targetAvailable; /* BOOL */
        uint32_t statusFlags;
    } DISPLAYCONFIG_PATH_TARGET_INFO;

    typedef struct {
        DISPLAYCONFIG_PATH_SOURCE_INFO sourceInfo;
        DISPLAYCONFIG_PATH_TARGET_INFO targetInfo;
        uint32_t flags;
    } DISPLAYCONFIG_PATH_INFO;

    typedef struct {
        uint32_t width;
        uint32_t height;
        uint32_t pixelFormat;
        struct { int x; int y; } position;
    } DISPLAYCONFIG_SOURCE_MODE;

    typedef struct {
        uint64_t pixelRate;
        struct { uint32_t Numerator; uint32_t Denominator; } hSyncFreq;
        struct { uint32_t Numerator; uint32_t Denominator; } vSyncFreq;
        struct { uint32_t cx; uint32_t cy; } activeSize;
        struct { uint32_t cx; uint32_t cy; } totalSize;
        uint32_t videoStandard;
        uint32_t scanLineOrdering;
    } DISPLAYCONFIG_VIDEO_SIGNAL_INFO;

    typedef struct {
        DISPLAYCONFIG_VIDEO_SIGNAL_INFO targetVideoSignalInfo;
    } DISPLAYCONFIG_TARGET_MODE;

    typedef struct {
        struct { int x; int y; } PathSourceSize;
        struct { int left; int top; int right; int bottom; } DesktopImageRegion;
        struct { int left; int top; int right; int bottom; } DesktopImageClip;
    } DISPLAYCONFIG_DESKTOP_IMAGE_INFO;

    /* Union for Mode Info */
    typedef struct {
        uint32_t infoType;
        uint32_t id;
        LUID adapterId;
        union {
            DISPLAYCONFIG_TARGET_MODE targetMode;
            DISPLAYCONFIG_SOURCE_MODE sourceMode;
            DISPLAYCONFIG_DESKTOP_IMAGE_INFO desktopImageInfo;
        } modeInfo;
    } DISPLAYCONFIG_MODE_INFO;

    /* Functions */
    LONG GetDisplayConfigBufferSizes(uint32_t flags, uint32_t* numPathArrayElements, uint32_t* numModeInfoArrayElements);
    LONG QueryDisplayConfig(uint32_t flags, uint32_t* numPathArrayElements, DISPLAYCONFIG_PATH_INFO* pathArray, uint32_t* numModeInfoArrayElements, DISPLAYCONFIG_MODE_INFO* modeInfoArray, void* currentTopologyId);
    LONG SetDisplayConfig(uint32_t numPathArrayElements, DISPLAYCONFIG_PATH_INFO* pathArray, uint32_t numModeInfoArrayElements, DISPLAYCONFIG_MODE_INFO* modeInfoArray, uint32_t flags);
]]

return ffi.load("user32")