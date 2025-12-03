local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

-- [FIX] Removed definitions that overlap with ntdll.lua to prevent redefinition errors
ffi.cdef [[
    /* --- File Information Classes --- */
    /* 
       Native Constants not in ntdll.lua enums
    */
    static const int FileBasicInformation       = 4;
    static const int FileDispositionInformation = 13;
    static const int FileDispositionInformationEx = 64;

    /* --- Native Security Information Constants --- */
    static const ULONG OWNER_SECURITY_INFORMATION = 0x00000001;
    static const ULONG GROUP_SECURITY_INFORMATION = 0x00000002;
    static const ULONG DACL_SECURITY_INFORMATION  = 0x00000004;
    static const ULONG SACL_SECURITY_INFORMATION  = 0x00000008;

    /* --- Native APIs (Missing from ntdll.lua) --- */
    
    /* Paging File Management */
    NTSTATUS NtCreatePagingFile(
        PUNICODE_STRING PageFileName,
        PLARGE_INTEGER MinimumSize,
        PLARGE_INTEGER MaximumSize,
        ULONG Priority
    );

    /* Object Security */
    NTSTATUS NtSetSecurityObject(
        HANDLE Handle,
        SECURITY_INFORMATION SecurityInformation,
        PSECURITY_DESCRIPTOR SecurityDescriptor
    );

    /* RTL Security Helpers */
    NTSTATUS RtlCreateSecurityDescriptor(
        PSECURITY_DESCRIPTOR SecurityDescriptor,
        ULONG Revision
    );
    
    NTSTATUS RtlSetOwnerSecurityDescriptor(
        PSECURITY_DESCRIPTOR SecurityDescriptor,
        PSID Owner,
        BOOLEAN OwnerDefaulted
    );
]]

-- 加载 ntdll.dll
return ffi.load("ntdll")