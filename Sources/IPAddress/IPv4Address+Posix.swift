// (C) Dr. Michael 'Mickey' Lauer
import Foundation

public extension IPv4Address {

    /// Converts the `IPv4Address` to a `sockaddr_in` structure.
    ///
    /// - Parameter port: The port number in host byte order (default is `0`).
    /// - Returns: A `sockaddr_in` structure representing the IP address and port.
    func toSockAddrIn(port: UInt16 = 0) -> sockaddr_in {
        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = port.bigEndian  // Port needs to be in network byte order
        addr.sin_addr = in_addr(s_addr: value)  // IP address is already in network byte order
        addr.sin_zero = (0, 0, 0, 0, 0, 0, 0, 0)
        return addr
    }

    /// Syntax sugar for `toSockAddrIn()`.
    var sockaddr: sockaddr_in { toSockAddrIn() }

    /// Initializes an `IPv4Address` from a `sockaddr_in` structure.
    ///
    /// - Parameter addr: The `sockaddr_in` structure containing the IP address.
    init(fromSockAddrIn addr: sockaddr_in) {
        self.value = addr.sin_addr.s_addr  // IP address is in network byte order
    }

    /// Initializes an `IPv4Address` from a 4-tuple of octets.
    init (_ octets: (UInt8, UInt8, UInt8, UInt8)) {
        self.value = UInt32(octets.0 << 24 | octets.1 << 16 | octets.2 << 8 | octets.3)
    }
}
