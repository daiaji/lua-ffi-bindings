local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    /* --- TCP/UDP Tables --- */
    typedef struct {
        DWORD dwState;
        DWORD dwLocalAddr;
        DWORD dwLocalPort;
        DWORD dwRemoteAddr;
        DWORD dwRemotePort;
        DWORD dwOwningPid;
    } MIB_TCPROW_OWNER_PID;

    typedef struct {
        DWORD dwNumEntries;
        /* [FIX] Use Variable Length Array [?] to prevent bounds check errors in LuaJIT */
        MIB_TCPROW_OWNER_PID table[?];
    } MIB_TCPTABLE_OWNER_PID;

    typedef struct {
        DWORD dwLocalAddr;
        DWORD dwLocalPort;
        DWORD dwOwningPid;
    } MIB_UDPROW_OWNER_PID;

    typedef struct {
        DWORD dwNumEntries;
        /* [FIX] Use Variable Length Array [?] */
        MIB_UDPROW_OWNER_PID table[?];
    } MIB_UDPTABLE_OWNER_PID;

    DWORD GetExtendedTcpTable(PVOID pTcpTable, PDWORD pdwSize, BOOL bOrder, ULONG ulAf, int TableClass, ULONG Reserved);
    DWORD GetExtendedUdpTable(PVOID pUdpTable, PDWORD pdwSize, BOOL bOrder, ULONG ulAf, int TableClass, ULONG Reserved);

    /* --- ICMP (Ping) --- */
    typedef struct {
        BYTE Ttl;
        BYTE Tos;
        BYTE Flags;
        BYTE OptionsSize;
        PVOID OptionsData;
    } IP_OPTION_INFORMATION;

    typedef struct {
        DWORD Address; // IPAddr
        ULONG Status;
        ULONG RoundTripTime;
        USHORT DataSize;
        USHORT Reserved;
        PVOID Data;
        IP_OPTION_INFORMATION Options;
    } ICMP_ECHO_REPLY;

    HANDLE IcmpCreateFile();
    BOOL IcmpCloseHandle(HANDLE IcmpHandle);
    DWORD IcmpSendEcho(
        HANDLE IcmpHandle,
        DWORD DestinationAddress,
        LPVOID RequestData,
        WORD RequestSize,
        IP_OPTION_INFORMATION* RequestOptions,
        LPVOID ReplyBuffer,
        DWORD ReplySize,
        DWORD Timeout
    );

    /* --- Adapters (IP Helper) --- */
    /* Constants */
    static const ULONG GAA_FLAG_INCLUDE_PREFIX = 0x0010;
    static const ULONG GAA_FLAG_INCLUDE_GATEWAYS = 0x0080;
    
    typedef enum {
        IfOperStatusUp = 1,
        IfOperStatusDown = 2,
        IfOperStatusTesting = 3,
        IfOperStatusUnknown = 4,
        IfOperStatusDormant = 5,
        IfOperStatusNotPresent = 6,
        IfOperStatusLowerLayerDown = 7
    } IF_OPER_STATUS;

    typedef struct _SOCKET_ADDRESS {
        void* lpSockaddr;
        int iSockaddrLength;
    } SOCKET_ADDRESS;

    typedef struct _IP_ADAPTER_UNICAST_ADDRESS {
        union {
            ULONGLONG Alignment;
            struct { ULONG Length; DWORD Flags; };
        };
        struct _IP_ADAPTER_UNICAST_ADDRESS* Next;
        SOCKET_ADDRESS Address;
        int PrefixOrigin;
        int SuffixOrigin;
        int DadState;
        ULONG ValidLifetime;
        ULONG PreferredLifetime;
        ULONG LeaseLifetime;
        UINT8 OnLinkPrefixLength;
    } IP_ADAPTER_UNICAST_ADDRESS;

    typedef struct _IP_ADAPTER_GATEWAY_ADDRESS {
        union {
            ULONGLONG Alignment;
            struct { ULONG Length; DWORD Flags; };
        };
        struct _IP_ADAPTER_GATEWAY_ADDRESS* Next;
        SOCKET_ADDRESS Address;
    } IP_ADAPTER_GATEWAY_ADDRESS;

    typedef struct _IP_ADAPTER_ADDRESSES {
        union {
            ULONGLONG Alignment;
            struct { ULONG Length; DWORD IfIndex; };
        };
        struct _IP_ADAPTER_ADDRESSES* Next;
        PCHAR AdapterName;
        IP_ADAPTER_UNICAST_ADDRESS* FirstUnicastAddress;
        void* FirstAnycastAddress;
        void* FirstMulticastAddress;
        void* FirstDnsServerAddress;
        PWCHAR DnsSuffix;
        PWCHAR Description;
        PWCHAR FriendlyName;
        BYTE PhysicalAddress[8];
        DWORD PhysicalAddressLength;
        DWORD Flags;
        DWORD Mtu;
        DWORD IfType;
        IF_OPER_STATUS OperStatus;
        DWORD Ipv6IfIndex;
        DWORD ZoneIndices[16];
        IP_ADAPTER_GATEWAY_ADDRESS* FirstGatewayAddress;
    } IP_ADAPTER_ADDRESSES;

    ULONG GetAdaptersAddresses(ULONG Family, ULONG Flags, PVOID Reserved, IP_ADAPTER_ADDRESSES* AdapterAddresses, PULONG SizePointer);
]]

return ffi.load("iphlpapi")