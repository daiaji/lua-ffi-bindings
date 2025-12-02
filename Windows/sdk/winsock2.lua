local ffi = require 'ffi'
require 'ffi.req' 'Windows.sdk.minwindef'

ffi.cdef [[
    typedef UINT_PTR SOCKET;
    
    /* Use enum for constants to avoid static const parser issues with unsigned typedefs */
    enum {
        INVALID_SOCKET = -1,
        SOCKET_ERROR   = -1
    };

    /* Error Codes */
    static const int WSAEWOULDBLOCK     = 10035;
    static const int WSAEINPROGRESS     = 10036;
    static const int WSAEALREADY        = 10037;
    static const int WSAENOTSOCK        = 10038;
    static const int WSAEMSGSIZE        = 10040;
    static const int WSAEADDRINUSE      = 10048;
    static const int WSAECONNABORTED    = 10053;
    static const int WSAECONNRESET      = 10054;
    static const int WSAEISCONN         = 10056;
    static const int WSAETIMEDOUT       = 10060;
    static const int WSAECONNREFUSED    = 10061;
    static const int WSAEHOSTUNREACH    = 10065;
    static const int WSAEACCES          = 10013;
    
    /* DNS Errors */
    static const int WSAHOST_NOT_FOUND  = 11001;
    static const int WSATRY_AGAIN       = 11002;
    static const int WSANO_RECOVERY     = 11003;
    static const int WSANO_DATA         = 11004;

    /* Address Families */
    static const int AF_UNSPEC = 0;
    static const int AF_UNIX   = 1;
    static const int AF_INET   = 2;
    static const int AF_INET6  = 23;

    /* Socket Types */
    static const int SOCK_STREAM = 1;
    static const int SOCK_DGRAM  = 2;

    /* Protocols */
    static const int IPPROTO_IP   = 0;
    static const int IPPROTO_TCP  = 6;
    static const int IPPROTO_UDP  = 17;
    static const int IPPROTO_IPV6 = 41;

    /* Socket Options Levels */
    static const int SOL_SOCKET = 0xFFFF;
    
    /* Socket Options */
    static const int SO_DEBUG       = 0x0001;
    static const int SO_REUSEADDR   = 0x0004;
    static const int SO_KEEPALIVE   = 0x0008;
    static const int SO_DONTROUTE   = 0x0010;
    static const int SO_BROADCAST   = 0x0020;
    static const int SO_LINGER      = 0x0080;
    static const int SO_RCVBUF      = 0x1002;
    static const int SO_SNDBUF      = 0x1001;
    static const int SO_RCVTIMEO    = 0x1006;
    static const int SO_SNDTIMEO    = 0x1005;
    static const int SO_ERROR       = 0x1007;
    
    static const int TCP_NODELAY    = 0x0001;

    /* IPv6 Options */
    static const int IPV6_UNICAST_HOPS      = 4;
    static const int IPV6_MULTICAST_IF      = 9;
    static const int IPV6_MULTICAST_HOPS    = 10;
    static const int IPV6_MULTICAST_LOOP    = 11;
    static const int IPV6_ADD_MEMBERSHIP    = 12;
    static const int IPV6_DROP_MEMBERSHIP   = 13;
    static const int IPV6_V6ONLY            = 27;

    /* IP Options */
    static const int IP_MULTICAST_IF        = 9;
    static const int IP_MULTICAST_TTL       = 10;
    static const int IP_MULTICAST_LOOP      = 11;
    static const int IP_ADD_MEMBERSHIP      = 12;
    static const int IP_DROP_MEMBERSHIP     = 13;

    /* Name Info Flags */
    static const int NI_NUMERICHOST     = 0x02;
    static const int NI_NAMEREQD        = 0x04;
    static const int NI_NUMERICSERV     = 0x08;

    /* AI Flags */
    static const int AI_PASSIVE     = 0x00000001;
    static const int AI_CANONNAME   = 0x00000002;
    static const int AI_NUMERICHOST = 0x00000004;
    static const int AI_NUMERICSERV = 0x00000008;

    /* IOCTL */
    static const long FIONBIO = 0x8004667E;

    /* Structs */
    typedef struct {
        short sin_family;
        unsigned short sin_port;
        struct { unsigned long s_addr; } sin_addr;
        char sin_zero[8];
    } sockaddr_in;

    struct in6_addr {
        uint8_t s6_addr[16];
    };
    
    typedef struct {
        short   sin6_family;
        unsigned short sin6_port;
        unsigned long sin6_flowinfo;
        struct in6_addr sin6_addr;
        unsigned long sin6_scope_id;
    } sockaddr_in6;
    
    /* AF_UNIX for Windows 10+ */
    typedef struct {
        unsigned short sun_family;
        char sun_path[108];
    } sockaddr_un;

    typedef struct {
        unsigned short sa_family;
        char sa_data[14];
    } sockaddr;

    typedef struct {
        int ai_flags;
        int ai_family;
        int ai_socktype;
        int ai_protocol;
        size_t ai_addrlen;
        char* ai_canonname;
        sockaddr* ai_addr;
        void* ai_next;
    } addrinfo;

    typedef struct {
        long tv_sec;
        long tv_usec;
    } timeval;

    /* FD_SET implementation details for Windows */
    typedef struct {
        unsigned int fd_count;
        SOCKET fd_array[64];
    } fd_set;

    /* Option Structs */
    typedef struct {
        unsigned short l_onoff;
        unsigned short l_linger;
    } linger;

    struct ip_mreq {
        struct { unsigned long s_addr; } imr_multiaddr;
        struct { unsigned long s_addr; } imr_interface;
    };

    struct ipv6_mreq {
        struct in6_addr ipv6mr_multiaddr;
        unsigned int    ipv6mr_interface;
    };

    /* Initialization */
    typedef struct {
        WORD wVersion;
        WORD wHighVersion;
        char szDescription[257];
        char szSystemStatus[129];
        unsigned short iMaxSockets;
        unsigned short iMaxUdpDg;
        char* lpVendorInfo;
    } WSADATA, *LPWSADATA;

    int WSAStartup(WORD wVersionRequested, LPWSADATA lpWSAData);
    int WSACleanup();
    int WSAGetLastError();
    void WSASetLastError(int iError);

    /* Core Functions */
    SOCKET socket(int af, int type, int protocol);
    int closesocket(SOCKET s);
    int connect(SOCKET s, const sockaddr* name, int namelen);
    int bind(SOCKET s, const sockaddr* name, int namelen);
    int listen(SOCKET s, int backlog);
    SOCKET accept(SOCKET s, sockaddr* addr, int* addrlen);
    
    int send(SOCKET s, const char* buf, int len, int flags);
    int recv(SOCKET s, char* buf, int len, int flags);
    int sendto(SOCKET s, const char* buf, int len, int flags, const sockaddr* to, int tolen);
    int recvfrom(SOCKET s, char* buf, int len, int flags, sockaddr* from, int* fromlen);
    
    int ioctlsocket(SOCKET s, long cmd, unsigned long* argp);
    int setsockopt(SOCKET s, int level, int optname, const char* optval, int optlen);
    int getsockopt(SOCKET s, int level, int optname, char* optval, int* optlen);
    
    int select(int nfds, fd_set* readfds, fd_set* writefds, fd_set* exceptfds, const timeval* timeout);
    int __WSAFDIsSet(SOCKET fd, fd_set* set);

    /* DNS / Info */
    int getaddrinfo(const char* nodename, const char* servname, const addrinfo* hints, addrinfo** res);
    int getnameinfo(const sockaddr* sa, int salen, char* host, int hostlen, char* serv, int servlen, int flags);
    void freeaddrinfo(addrinfo* ai);
    int gethostname(char* name, int namelen);
    int getpeername(SOCKET s, sockaddr* name, int* namelen);
    int getsockname(SOCKET s, sockaddr* name, int* namelen);
    
    unsigned short htons(unsigned short hostshort);
    unsigned short ntohs(unsigned short netshort);
    unsigned long inet_addr(const char* cp);
    char* inet_ntoa(struct { unsigned long s_addr; } in);
]]

local M = ffi.load("ws2_32")

-- Initialize Winsock once
local wsa = ffi.new("WSADATA")
M.WSAStartup(0x0202, wsa)

return M