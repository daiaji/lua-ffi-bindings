local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

-- 补充 ntdll.lua 中缺失的 Native API 和结构体定义
ffi.cdef [[
    /* --- NT Status Codes --- */
    static const LONG STATUS_SUCCESS            = 0x00000000;
    static const LONG STATUS_PRIVILEGE_NOT_HELD = 0xC0000061;

    /* --- File Information Classes --- */
    /* 
       注意：基础 FileInformationClass 枚举已在 ntioapi.h / ntdll.lua 中定义。
       这里补充特定的常量值用于直接调用，或者使用已有的枚举。
    */
    static const int FileBasicInformation       = 4;
    static const int FileDispositionInformation = 13;
    static const int FileDispositionInformationEx = 64;

    /* --- Structures --- */
    /* 
       FILE_BASIC_INFORMATION 和 FILE_DISPOSITION_INFORMATION 通常在 ntdll.lua 或 kernel32.lua 中已有定义。
       这里仅定义核心缺失的结构体。
    */

    /* Native Security Information Constants */
    static const ULONG OWNER_SECURITY_INFORMATION = 0x00000001;
    static const ULONG GROUP_SECURITY_INFORMATION = 0x00000002;
    static const ULONG DACL_SECURITY_INFORMATION  = 0x00000004;
    static const ULONG SACL_SECURITY_INFORMATION  = 0x00000008;

    /* Security Descriptor (Opaque pointers) */
    typedef PVOID PSECURITY_DESCRIPTOR;

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