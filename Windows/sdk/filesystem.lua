local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    /* --- FAT32 Structures --- */
    #pragma pack(1)
    typedef struct {
        uint8_t  JumpBoot[3];
        uint8_t  OEMName[8];
        uint16_t BytesPerSector;
        uint8_t  SectorsPerCluster;
        uint16_t ReservedSectors;
        uint8_t  NumFATs;
        uint16_t RootEntryCount;
        uint16_t TotalSectors16;
        uint8_t  Media;
        uint16_t FATsz16;
        uint16_t SectorsPerTrack;
        uint16_t NumHeads;
        uint32_t HiddenSectors;
        uint32_t TotalSectors32;
        uint32_t FATsz32;
        uint16_t ExtFlags;
        uint16_t FSVer;
        uint32_t RootCluster;
        uint16_t FSInfo;
        uint16_t BackupBootSec;
        uint8_t  Reserved[12];
        uint8_t  DriveNumber;
        uint8_t  Reserved1;
        uint8_t  BootSig;
        uint32_t VolID;
        uint8_t  VolLab[11];
        uint8_t  FilSysType[8];
        uint8_t  BootCode[420];
        uint16_t BootSign;
    } FAT32_BOOT_SECTOR;

    typedef struct {
        uint32_t LeadSig;       // 0x41615252
        uint8_t  Reserved1[480];
        uint32_t StrucSig;      // 0x61417272
        uint32_t Free_Count;    // 0xFFFFFFFF
        uint32_t Next_Free;     // 0xFFFFFFFF
        uint8_t  Reserved2[12];
        uint32_t TrailSig;      // 0xAA550000
    } FAT32_FSINFO;
    #pragma pack()
    
    /* --- Constants --- */
    static const uint32_t FAT32_LEAD_SIG  = 0x41615252;
    static const uint32_t FAT32_STRUC_SIG = 0x61417272;
    static const uint32_t FAT32_TRAIL_SIG = 0xAA550000;
]]

return ffi.C