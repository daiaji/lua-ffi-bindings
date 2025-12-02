local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef[[
    /* --- FMIFS Media Types --- */
    /* Derived from reverse engineering fmifs.dll or reactos headers */
    static const int FMIFS_HARDDISK = 0x0C;
    static const int FMIFS_FLOPPY   = 0x08;

    typedef BOOLEAN (__stdcall *PFILE_SYSTEM_CALLBACK)(
        int Command,
        DWORD Action,
        void* pData
    );

    /* Structure for Chkdsk Output */
    typedef struct {
        DWORD Lines;
        PWSTR Output;
    } TEXTOUTPUT, *PTEXTOUTPUT;

    void __stdcall FormatEx(
        LPCWSTR              DriveRoot,
        DWORD                MediaType, 
        LPCWSTR              FileSystemTypeName,
        LPCWSTR              Label,
        BOOL                 QuickFormat,
        DWORD                ClusterSize,
        PFILE_SYSTEM_CALLBACK Callback
    );

    void __stdcall Chkdsk(
        LPCWSTR              DriveRoot,
        LPCWSTR              FileSystemTypeName,
        BOOL                 CheckOnly,
        BOOL                 FixErrors,
        BOOL                 RecoverBadSectors,
        BOOL                 Extended,
        BOOL                 Resize,
        LPCWSTR              LogFile,
        PFILE_SYSTEM_CALLBACK Callback
    );
    
    /* Callback Commands */
    static const int FCC_PROGRESS = 0;
    static const int FCC_DONE_WITH_STRUCTURE = 1;
    static const int FCC_UNKNOWN2 = 2;
    static const int FCC_UNKNOWN3 = 3;
    static const int FCC_UNKNOWN4 = 4;
    static const int FCC_UNKNOWN5 = 5;
    static const int FCC_INSUFFICIENT_RIGHTS = 6;
    static const int FCC_WRITE_PROTECTED = 7;
    static const int FCC_UNKNOWN8 = 8;
    static const int FCC_UNKNOWN9 = 9;
    static const int FCC_UNKNOWNA = 10;
    static const int FCC_DONE = 11;
    static const int FCC_UNKNOWNC = 12;
    static const int FCC_UNKNOWND = 13;
    static const int FCC_UNKNOWNE = 14;
    static const int FCC_UNKNOWNF = 15;
    
    /* Chkdsk Specific */
    static const int FCC_CHECKDISK_PROGRESS = 18;
    static const int FCC_OUTPUT = 20; 
]]

return ffi.load("fmifs")