local ffi = require("ffi")

-- --------------------------------------------------------------------------------
-- Secur32.dll Definitions
-- --------------------------------------------------------------------------------

ffi.cdef[[
    // -------------------------------------------------------------------------
    // User / System Name Formats
    // -------------------------------------------------------------------------
    typedef enum {
        NameUnknown             = 0,
        NameFullyQualifiedDN    = 1,
        NameSamCompatible       = 2,
        NameDisplay             = 3,
        NameUniqueId            = 6,
        NameCanonical           = 7,
        NameUserPrincipal       = 8,
        NameCanonicalEx         = 9,
        NameServicePrincipal    = 10,
        NameDnsDomain           = 12
    } EXTENDED_NAME_FORMAT;

    // -------------------------------------------------------------------------
    // Functions
    // -------------------------------------------------------------------------
    // 获取当前用户或服务账户的扩展名称信息 (如 UPN, DN 等)
    BOOLEAN __stdcall GetUserNameExW(
        EXTENDED_NAME_FORMAT NameFormat,
        LPWSTR lpNameBuffer,
        PULONG nSize
    );
]]

-- Load Library explicitly
local lib = ffi.load("secur32")

return {
    C = ffi.C,
    lib = lib,
    
    -- Expose Enum Constants for convenience
    NameUnknown             = 0,
    NameFullyQualifiedDN    = 1,
    NameSamCompatible       = 2,
    NameDisplay             = 3,
    NameUniqueId            = 6,
    NameCanonical           = 7,
    NameUserPrincipal       = 8,
    NameCanonicalEx         = 9,
    NameServicePrincipal    = 10,
    NameDnsDomain           = 12,

    -- Expose Function Shortcuts
    GetUserNameExW = lib.GetUserNameExW
}