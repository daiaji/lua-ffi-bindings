local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef[[
    typedef enum { DismLogErrors = 0, DismLogWarnings, DismLogInfo } DismLogLevel;
    typedef uint32_t DismSession;
    
    HRESULT DismInitialize(DismLogLevel LogLevel, PCWSTR LogFilePath, PCWSTR ScratchDirectory);
    HRESULT DismShutdown();
    HRESULT DismOpenSession(PCWSTR ImagePath, PCWSTR WindowsDirectory, PCWSTR SystemDrive, DismSession* Session);
    HRESULT DismCloseSession(DismSession Session);
    HRESULT DismAddDriver(DismSession Session, PCWSTR DriverPath, BOOL ForceUnsigned);
]]

return ffi.load("DismApi")