//
//  DhcpOptions.swift
//  DHCPMaster
//
//  Created by Alexey Altoukhov on 1/19/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import Foundation
import Network

protocol IDhcpOption {
    
    var _optionType : OptionType { get }
    var _stringValue: String { get }
    func toData() -> Data
}

enum OptionType: UInt8 {
    case Pad = 0
    case SubnetMask = 1
    case TimeOffset = 2
    case Router = 3
    case TimeServer = 4
    case NameServer = 5
    case DomainNameServer = 6
    case LogServer = 7
    case CookieServer = 8
    case LprServer = 9
    case ImpressServer = 10
    case ResourceLocationServer = 11
    case HostName = 12
    case BootFileSize = 13
    case MeritDumpFile = 14
    case DomainName = 15
    case SwapServer = 16
    case RootPath = 17
    case ExtensionPath = 18
    
    // 4: IP Layer Parameters per Host
    case IpForwardingEnable = 19
    case NonLocalSourceRoutingEnable = 20
    case PolicyFilter = 21
    case MaximumDatagramReassembly = 22
    case DefaultIpTtl = 23
    case PathMtuAgingTimeout = 24
    case PathMtuPlateauTable = 25
    
    // 5: IP Layer Parameters per Interface
    case InterfaceMtu = 26
    case AllSubnetsAreLocal = 27
    case BroadcastAddress = 28
    case PerformMaskDiscovery = 29
    case MaskSupplier = 30
    case PerformRouterDiscovery = 31
    case RouterSolicitationAddress = 32
    case StaticRoute = 33
    
    // 6: Link Layer Parameters per Interface
    case TrailerEncapsulation = 34
    case ArpCacheTimeout = 35
    case EthernetEncapsulation = 36
    
    // 7: TCP Parameters
    case TcpDefaultTtl = 37
    case TcpKeepaliveInterval = 38
    case TcpKeepaliveGarbage = 39
    
    // 8: Application and Service parameters
    case NetworkInformationServiceDomain = 40
    case NetworkInformationServiceServers = 41
    case NetworkTimeProtocolServers = 42
    case VendorSpecificInformation = 43
    case NetBiosOverTcpIpNameServer = 44
    case NetBiosOverTcpIpDatagramDistributionServer = 45
    case NetBiosOverTcpIpNodeType = 46
    case NetBiosOverTcpIpScope = 47
    case XWindowSystemFontServer = 48
    case XWindowSystemDisplayManager = 49
    
    // 9: DHCP Extensions
    case RequestedIpAddress = 50
    case IpAddressLeaseTime = 51
    case OptionOverload = 52
    case MessageType = 53
    case ServerIdentifier = 54
    case ParameterRequestList = 55
    case Message = 56
    case MaximumDhcpMessageSize = 57
    case RenewalTimeValue = 58
    case RebindingTimeValue = 59
    case VendorClassIdentifier = 60
    case ClientIdentifier = 61
    case NetworkInformationServicePlusDomain = 64
    case NetworkInformationServicePlusServers = 65
    case TftpServerName = 66
    case BootFileName = 67
    
    case MobileIpHomeAgent = 68
    case SimpleMailTransportProtocolServer = 69
    case PostOfficeProtocolServer = 70
    case NetworkNewsTransportProtocolServer = 71
    case DefaultWorldWideWebServer = 72
    case DefaultFingerServer = 73
    case DefaultInternetRelayChat = 74
    case StreetTalkServer = 75
    case StreetTalkDirectoryAssistanceServer = 76
    case UserClass = 77 // RFC3004
    
    case FullyQualifiedDomainName = 81 // RFC4702
    case RelayAgentInformation = 82
    
    case ClientSystemArchitectureType = 93 // RFC4578
    case ClientNetworkInterfaceIdentifier = 94 // RFC4578
    case ClientMachineIdentifier = 97 // RFC4578
    
    case AutoConfigure = 116 // RFC2563
    case ClasslessStaticRoutesA = 121 // RFC3442
    
    /*
     128   TFPT Server IP address                        // RFC 4578
     129   Call Server IP address                        // RFC 4578
     130   Discrimination string                         // RFC 4578
     131   Remote statistics server IP address           // RFC 4578
     132   802.1P VLAN ID
     133   802.1Q L2 Priority
     134   Diffserv Code Point
     135   HTTP Proxy for phone-specific applications
     */
    
    case Etherboot = 175
    case ClasslessStaticRoutesB = 249
    case WindowsBcdFilePath = 252
    case End = 255
    
    case Option62 = 62
    case Option63 = 63
    case Option78 = 78
    case Option79 = 79
    case Option80 = 80
    case Option83 = 83
    case Option84 = 84
    case Option85 = 85
    case Option86 = 86
    case Option87 = 87
    case Option88 = 88
    case Option89 = 89
    case Option90 = 90
    case Option91 = 91
    case Option92 = 92
    case Option95 = 95
    case Option96 = 96
    case Option98 = 98
    case Option99 = 99
    case Option100 = 100
    case Option101 = 101
    case Option102 = 102
    case Option103 = 103
    case Option104 = 104
    case Option105 = 105
    case Option106 = 106
    case Option107 = 107
    case Option108 = 108
    case Option109 = 109
    case Option110 = 110
    case Option111 = 111
    case Option112 = 112
    case Option113 = 113
    case Option114 = 114
    case Option115 = 115
    case Option117 = 117
    case Option118 = 118
    case Option119 = 119
    case Option120 = 120
    case Option122 = 122
    case Option123 = 123
    case Option124 = 124
    case Option125 = 125
    case Option126 = 126
    case Option127 = 127
    case Option128 = 128
    case Option129 = 129
    case Option130 = 130
    case Option131 = 131
    case Option132 = 132
    case Option133 = 133
    case Option134 = 134
    case Option135 = 135
    case Option136 = 136
    case Option137 = 137
    case Option138 = 138
    case Option139 = 139
    case Option140 = 140
    case Option141 = 141
    case Option142 = 142
    case Option143 = 143
    case Option144 = 144
    case Option145 = 145
    case Option146 = 146
    case Option147 = 147
    case Option148 = 148
    case Option149 = 149
    case Option150 = 150
    case Option151 = 151
    case Option152 = 152
    case Option153 = 153
    case Option154 = 154
    case Option155 = 155
    case Option156 = 156
    case Option157 = 157
    case Option158 = 158
    case Option159 = 159
    case Option160 = 160
    case Option161 = 161
    case Option162 = 162
    case Option163 = 163
    case Option164 = 164
    case Option165 = 165
    case Option166 = 166
    case Option167 = 167
    case Option168 = 168
    case Option169 = 169
    case Option170 = 170
    case Option171 = 171
    case Option172 = 172
    case Option173 = 173
    case Option174 = 174
    case Option176 = 176
    case Option177 = 177
    case Option178 = 178
    case Option179 = 179
    case Option180 = 180
    case Option181 = 181
    case Option182 = 182
    case Option183 = 183
    case Option184 = 184
    case Option185 = 185
    case Option186 = 186
    case Option187 = 187
    case Option188 = 188
    case Option189 = 189
    case Option190 = 190
    case Option191 = 191
    case Option192 = 192
    case Option193 = 193
    case Option194 = 194
    case Option195 = 195
    case Option196 = 196
    case Option197 = 197
    case Option198 = 198
    case Option199 = 199
    case Option200 = 200
    case Option201 = 201
    case Option202 = 202
    case Option203 = 203
    case Option204 = 204
    case Option205 = 205
    case Option206 = 206
    case Option207 = 207
    case Option208 = 208
    case Option209 = 209
    case Option210 = 210
    case Option211 = 211
    case Option212 = 212
    case Option213 = 213
    case Option214 = 214
    case Option215 = 215
    case Option216 = 216
    case Option217 = 217
    case Option218 = 218
    case Option219 = 219
    case Option220 = 220
    case Option221 = 221
    case Option222 = 222
    case Option223 = 223
    case Option224 = 224
    case Option225 = 225
    case Option226 = 226
    case Option227 = 227
    case Option228 = 228
    case Option229 = 229
    case Option230 = 230
    case Option231 = 231
    case Option232 = 232
    case Option233 = 233
    case Option234 = 234
    case Option235 = 235
    case Option236 = 236
    case Option237 = 237
    case Option238 = 238
    case Option239 = 239
    case Option240 = 240
    case Option241 = 241
    case Option242 = 242
    case Option243 = 243
    case Option244 = 244
    case Option245 = 245
    case Option246 = 246
    case Option247 = 247
    case Option248 = 248
    case Option250 = 250
    case Option251 = 251
    case Option253 = 253
    case Option254 = 254
}

enum DhcpError: Error {
    case invalidOptionLength
    case unexpectedDhcpOption
}

enum MessageType: UInt8 {
    case None = 0
    case Discover = 1
    case Offer = 2
    case Request = 3
    case Decline = 4
    case Ack = 5
    case Nak = 6
    case Release = 7
    case Inform = 8
}

class DhcpOptionFactory {
    static func fromData(code: UInt8, data: Data) throws -> IDhcpOption {

        switch code {

            case OptionType.SubnetMask.rawValue:
                return try SubnetMaskDhcpOption(data: data)
            
            case OptionType.TimeOffset.rawValue:
                return try TimeOffsetDhcpOption(data: data)
            
            case OptionType.Router.rawValue:
                return try RouterDhcpOption(data: data)
            
            case OptionType.TimeServer.rawValue:
                return try TimeServerDhcpOption(data: data)
            
            case OptionType.DomainNameServer.rawValue:
                return try DomainNameServerDhcpOption(data: data)
            
            case OptionType.LogServer.rawValue:
                return try LogServerDhcpOption(data: data)
            
            case OptionType.HostName.rawValue:
                return HostnameDhcpOption(data: data)
            
            case OptionType.DomainName.rawValue:
                return DomainNameDhcpOption(data: data)
            
            case OptionType.DefaultIpTtl.rawValue:
                return try DefaultIpTtlDhcpOption(data: data)
            
            case OptionType.BroadcastAddress.rawValue:
                return try BroadcastDhcpOption(data: data)
            
            case OptionType.NetworkTimeProtocolServers.rawValue:
                return try NtpServersDhcpOption(data: data)
            
            case OptionType.VendorSpecificInformation.rawValue:
                return VendorSpecificInformationDhcpOption(data: data)
            
            case OptionType.RequestedIpAddress.rawValue:
                return try RequestedIpAddressDhcpOption(data: data)
            
            case OptionType.IpAddressLeaseTime.rawValue:
                return try IpAddressLeaseTimeDhcpOption(data: data)
            
            case OptionType.OptionOverload.rawValue:
                return try OptionOverloadDhcpOption(data: data)
            
            case OptionType.MessageType.rawValue:
                return try MessageTypeDhcpOption(data: data)
            
            case OptionType.ServerIdentifier.rawValue:
                return try ServerIdentifierDhcpOption(data: data)
            
            case OptionType.ParameterRequestList.rawValue:
                return try ParameterRequestListDhcpOption(data: data)
            
            case OptionType.Message.rawValue:
                return MessageDhcpOption(data: data)
            
            case OptionType.MaximumDhcpMessageSize.rawValue:
                return try MaximumDhcpMessageSizeDhcpOption(data: data)
            
            case OptionType.RenewalTimeValue.rawValue:
                return try RenewalTimeDhcpOption(data: data)
            
            case OptionType.RebindingTimeValue.rawValue:
                return try RebindingTimeDhcpOption(data: data)
            
            case OptionType.VendorClassIdentifier.rawValue:
                return VendorClassIdentifierDhcpOption(data: data)
            
            case OptionType.ClientIdentifier.rawValue:
                return try ClientIdentifierDhcpOption(data: data)
            
            case OptionType.TftpServerName.rawValue:
                return TftpServerNameDhcpOption(data: data)
            
            case OptionType.BootFileName.rawValue:
                return BootFileNameDhcpOption(data: data)
            
            case OptionType.UserClass.rawValue:
                return UserClassDhcpOption(data: data)
            
            case OptionType.FullyQualifiedDomainName.rawValue:
                return FullyQualifiedDomainNameDhcpOption(data: data)
            
            case OptionType.RelayAgentInformation.rawValue:
                return RelayAgentInformationDhcpOption(data: data)
            
            case OptionType.ClientSystemArchitectureType.rawValue:
                return try ClientSystemArchitectureTypeDhcpOption(data: data)
            
            case OptionType.ClientNetworkInterfaceIdentifier.rawValue:
                return try ClientNetworkInterfaceIdentifierDhcpOption(data: data)
            
            case OptionType.ClientMachineIdentifier.rawValue:
                return try ClientMachineIdentifierDhcpOption(data: data)
            
            case OptionType.AutoConfigure.rawValue:
                return try AutoConfigureDhcpOption(data: data)
            
            case OptionType.WindowsBcdFilePath.rawValue:
                return WindowsBcdFilePathDhcpOption(data: data)
            
            case OptionType.Pad.rawValue:
                throw DhcpError.unexpectedDhcpOption
            
            case OptionType.End.rawValue:
                throw DhcpError.unexpectedDhcpOption
            
            default:
                return GenericDhcpOption(optionType: OptionType(rawValue: code)!, data: data)
        }
    }
}

//DHCP Option 1 (Subnet Mask)
class SubnetMaskDhcpOption : IpListDhcpOption {
    
    convenience init(ipAddress: IPAddress) {
        var ips = [IPAddress]()
        ips.append(ipAddress)
        self.init(optionType: OptionType.SubnetMask, ipList: ips)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.SubnetMask, data: data)
    }
    
    var ipAddress: IPAddress? {
        get {
            return _ipList.first
        }
    }
}

//DHCP Option 2 (Time Offset)
class TimeOffsetDhcpOption : Int32DhcpOption {
    
    convenience init(timeOffset: TimeInterval) {
        self.init(optionType: OptionType.TimeOffset, value: Int32(timeOffset))
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.TimeOffset, data: data)
    }
    
    var timeOffset: TimeInterval {
        get {
            return Double(self._value)
        }
    }
}

//DHCP Option 3 (Router)
class RouterDhcpOption : IpListDhcpOption {
    
    convenience init(ipAddresses: [IPAddress]) {
        self.init(optionType: OptionType.Router, ipList: ipAddresses)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.Router, data: data)
    }
    
    var ipAddresses: [IPAddress] {
        get {
            return _ipList
        }
    }
}

//DHCP Option 4 (Time Server)
class TimeServerDhcpOption : IpListDhcpOption {
    
    convenience init(ipAddresses: [IPAddress]) {
        self.init(optionType: OptionType.TimeServer, ipList: ipAddresses)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.TimeServer, data: data)
    }
    
    var ipAddresses: [IPAddress] {
        get {
            return _ipList
        }
    }
}

//DHCP Option 6 (Domain Server)
class DomainNameServerDhcpOption : IpListDhcpOption {
    
    convenience init(ipAddresses: [IPAddress]) {
        self.init(optionType: OptionType.DomainNameServer, ipList: ipAddresses)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.DomainNameServer, data: data)
    }
    
    var ipAddresses: [IPAddress] {
        get {
            return _ipList
        }
    }
}

//DHCP Option 7 (Log Server)
class LogServerDhcpOption : IpListDhcpOption {
    
    convenience init(ipAddresses: [IPAddress]) {
        self.init(optionType: OptionType.LogServer, ipList: ipAddresses)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.LogServer, data: data)
    }
    
    var ipAddresses: [IPAddress] {
        get {
            return _ipList
        }
    }
}

//DHCP Option 12 (Hostname)
class HostnameDhcpOption : StringDhcpOption {
    
    convenience init(hostname: String) {
        self.init(optionType: OptionType.HostName, string: hostname)
    }
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.HostName, data: data)
    }
    
    var hostname: String {
        get {
            return _string
        }
    }
}

//DHCP Option 15 (Domain Name)
class DomainNameDhcpOption : StringDhcpOption {
    
    convenience init(hostname: String) {
        self.init(optionType: OptionType.DomainName, string: hostname)
    }
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.DomainName, data: data)
    }
    
    var domainName: String {
        get {
            return _string
        }
    }
}

//DHCP Option 23 (Default IP TTL)
class DefaultIpTtlDhcpOption : UInt8DhcpOption {
    
    convenience init(ttlValue: UInt8) {
        self.init(optionType: OptionType.DefaultIpTtl, value: ttlValue)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.DefaultIpTtl, data: data)
    }
    
    var ttlValue: UInt8 {
        get {
            return _value
        }
    }
}

//DHCP Option 28 (Broadcast Address)
class BroadcastDhcpOption : IpListDhcpOption {
    
    convenience init(ipAddress: IPAddress) {
        var ips = [IPAddress]()
        ips.append(ipAddress)
        self.init(optionType: OptionType.BroadcastAddress, ipList: ips)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.BroadcastAddress, data: data)
    }
    
    var ipAddress: IPAddress? {
        get {
            return _ipList.first
        }
    }
}

//DHCP Option 42 (NTP Servers)
class NtpServersDhcpOption : IpListDhcpOption {
    
    convenience init(ipAddresses: [IPAddress]) {
        self.init(optionType: OptionType.NetworkTimeProtocolServers, ipList: ipAddresses)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.NetworkTimeProtocolServers, data: data)
    }
    
    var ipAddresses: [IPAddress] {
        get {
            return _ipList
        }
    }
}

//DHCP Option 43 (Vendor Specific Information)
class VendorSpecificInformationDhcpOption : DataDhcpOption {
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.VendorSpecificInformation, data: data)
    }
    
    var data: Data {
        get {
            return _data
        }
    }
}

//DHCP Option 50 (Requested IP Address)
class RequestedIpAddressDhcpOption : IpListDhcpOption {
    
    convenience init(ipAddress: IPAddress) {
        var ips = [IPAddress]()
        ips.append(ipAddress)
        self.init(optionType: OptionType.RequestedIpAddress, ipList: ips)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.RequestedIpAddress, data: data)
    }
    
    var ipAddress: IPAddress? {
        get {
            return _ipList.first
        }
    }
}

//DHCP Option 51 (IP Address Lease Time)
class IpAddressLeaseTimeDhcpOption : UInt32DhcpOption {
    
    convenience init(leaseTime: TimeInterval) {
        self.init(optionType: OptionType.IpAddressLeaseTime, value: UInt32(leaseTime))
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.IpAddressLeaseTime, data: data)
    }
    
    var leaseTime: TimeInterval {
        get {
            return TimeInterval(_value)
        }
    }
}

//DHCP Option 52 (Overload sname)
class OptionOverloadDhcpOption : UInt8DhcpOption {
    
    convenience init(overloadValue: UInt8) {
        self.init(optionType: OptionType.OptionOverload, value: overloadValue)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.OptionOverload, data: data)
    }
    
    var overloadValue: UInt8 {
        get {
            return _value
        }
    }
}

//DHCP Option 53 (DHCP Message Type)
class MessageTypeDhcpOption : UInt8DhcpOption {
    
    convenience init(messageType: MessageType) {
        self.init(optionType: OptionType.MessageType, value: messageType.rawValue)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.MessageType, data: data)
    }
    
    var messageType: MessageType {
        get {
            return MessageType(rawValue: _value)!
        }
    }
    
    override var _stringValue: String {
        get {
            return String(describing: messageType)
        }
    }
}

//DHCP Option 54 (DHCP Server Identifier)
class ServerIdentifierDhcpOption : IpListDhcpOption {
    
    convenience init(ipAddress: IPAddress) {
        var ips = [IPAddress]()
        ips.append(ipAddress)
        self.init(optionType: OptionType.ServerIdentifier, ipList: ips)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.ServerIdentifier, data: data)
    }
    
    var ipAddress: IPAddress? {
        get {
            return _ipList.first
        }
    }
}

//DHCP Option 55 (Parameter Request List)
class ParameterRequestListDhcpOption : IDhcpOption {
    let _optionType: OptionType
    let _requestedOptions: [OptionType]
    
    init(requestedOptions: [OptionType]) {
        _optionType = OptionType.ParameterRequestList
        _requestedOptions = requestedOptions
    }
    
    convenience init(data: Data) throws {
        
        if (data.count == 0) {
            throw DhcpError.invalidOptionLength
        }
        
        var optionsList: [OptionType] = [OptionType]()
        
        for i in 0..<data.count {
            optionsList.append(OptionType(rawValue: data[i])!)
        }
        
        self.init(requestedOptions: optionsList)
    }
    
    func toData() -> Data {
        
        var data: Data = Data()
        
        for option in _requestedOptions {
            data.append(option.rawValue)
        }
        
        return data
    }
    
    var _stringValue: String {
        get {
            let options = _requestedOptions.map({ String(describing: $0)})
            return options.joined(separator: ",")
        }
    }
}

//DHCP Option 56 (DHCP Error Message)
class MessageDhcpOption : StringDhcpOption {
    
    convenience init(message: String) {
        self.init(optionType: OptionType.Message, string: message)
    }
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.Message, data: data)
    }
    
    var message: String {
        get {
            return _string
        }
    }
}

//DHCP Option 57 (DHCP Maximum Message Size)
class MaximumDhcpMessageSizeDhcpOption : UInt16DhcpOption {
    
    convenience init(size: UInt16) {
        self.init(optionType: OptionType.MaximumDhcpMessageSize, value: size)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.MaximumDhcpMessageSize, data: data)
    }
    
    var messageSize: UInt16 {
        get {
            return _value
        }
    }
}

//DHCP Option 58 (DHCP Renewal T1 Time)
class RenewalTimeDhcpOption : UInt32DhcpOption {
    
    convenience init(renewalTime: TimeInterval) {
        self.init(optionType: OptionType.RenewalTimeValue, value: UInt32(renewalTime))
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.RenewalTimeValue, data: data)
    }
    
    var renewalTime: TimeInterval {
        get {
            return TimeInterval(_value)
        }
    }
}

//DHCP Option 59 (DHCP Rebinding T2 Time)
class RebindingTimeDhcpOption : UInt32DhcpOption {
    
    convenience init(rebindingTime: TimeInterval) {
        self.init(optionType: OptionType.RebindingTimeValue, value: UInt32(rebindingTime))
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.RebindingTimeValue, data: data)
    }
    
    var rebindingTime: TimeInterval {
        get {
            return TimeInterval(_value)
        }
    }
}

//DHCP Option 60 (Class Identifier)
class VendorClassIdentifierDhcpOption : StringDhcpOption {
    
    static let pxeClientIdentifier = "PXEClient"
    
    convenience init(classIdentifier: String) {
        self.init(optionType: OptionType.VendorClassIdentifier, string: classIdentifier)
    }
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.VendorClassIdentifier, data: data)
    }
    
    var classIdentifier: String {
        get {
            return _string
        }
    }
}

//DHCP Option 61 (Client Identifier)
class ClientIdentifierDhcpOption: IDhcpOption {
    let _optionType: OptionType
    let _hardwareType: DhcpMessage.HardwareType
    let _clientId: Data
    
    init(hwType: DhcpMessage.HardwareType, clientId: Data) {
        _optionType = OptionType.ClientIdentifier
        _hardwareType = hwType
        _clientId = clientId
    }
    
    convenience init(data: Data) throws {
        
        if (data.count < 2) {
            throw DhcpError.invalidOptionLength
        }
        
        let hardwareType = DhcpMessage.HardwareType(rawValue: data[0])!
        let clientId = data.subdata(in: 1..<data.count)
        
        self.init(hwType: hardwareType, clientId: clientId)
    }
    
    func toData() -> Data {
        var data: Data = Data()
        
        data.append(_hardwareType.rawValue)
        data.append(_clientId)
        
        return data
    }
    
    var _stringValue: String {
        get {
            return "\(String(describing: _hardwareType)), \(String(describing: _clientId))"
        }
    }
}

//DHCP Option 66 (TFTP Server Name)
class TftpServerNameDhcpOption : StringDhcpOption {
    
    convenience init(tftpServer: String) {
        self.init(optionType: OptionType.TftpServerName, string: tftpServer)
    }
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.TftpServerName, data: data)
    }
    
    var tftpServer: String {
        get {
            return _string
        }
    }
}

//DHCP Option 67 (Boot File Name)
class BootFileNameDhcpOption : StringDhcpOption {

    convenience init(bootFile: String) {
        self.init(optionType: OptionType.BootFileName, string: bootFile)
    }
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.BootFileName, data: data)
    }
    
    var bootFile: String {
        get {
            return _string
        }
    }
}

//DHCP Option 77 (User Class)
class UserClassDhcpOption : StringDhcpOption {

    convenience init(userClass: String) {
        self.init(optionType: OptionType.UserClass, string: userClass)
    }
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.UserClass, data: data)
    }
    
    var userClass: String {
        get {
            return _string
        }
    }
}

//DHCP Option 81 (Fully Qualified Domain Name)
class FullyQualifiedDomainNameDhcpOption : StringDhcpOption {
    
    convenience init(fullyQualifiedDomainName: String) {
        self.init(optionType: OptionType.FullyQualifiedDomainName, string: fullyQualifiedDomainName)
    }
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.FullyQualifiedDomainName, data: data)
    }
    
    var fullyQualifiedDomainName: String {
        get {
            return _string
        }
    }
}

//DHCP Option 82 (Relay Agent Information)
class RelayAgentInformationDhcpOption : DataDhcpOption {
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.RelayAgentInformation, data: data)
    }
    
    var data: Data {
        get {
            return _data
        }
    }
}

//DHCP Option 93 (Client System Architecture)
class ClientSystemArchitectureTypeDhcpOption : UInt16DhcpOption {
    
    convenience init(arcType: UInt16) {
        self.init(optionType: OptionType.ClientSystemArchitectureType, value: arcType)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.ClientSystemArchitectureType, data: data)
    }
    
    var clientSystemArchitectureType: UInt16 {
        get {
            return _value
        }
    }
}

//DHCP Option 94 (Client Network Device Interface)
class ClientNetworkInterfaceIdentifierDhcpOption: IDhcpOption {
    let _optionType: OptionType
    let _type: UInt8
    let _majorVersion: UInt8
    let _minorVersion: UInt8
    
    init(type: UInt8, majorVersion: UInt8, minorVersion: UInt8) {
        _optionType = OptionType.ClientNetworkInterfaceIdentifier
        _type = type
        _majorVersion = majorVersion
        _minorVersion = minorVersion
    }
    
    convenience init(data: Data) throws {
        
        if (data.count != 3) {
            throw DhcpError.invalidOptionLength
        }
        
        self.init(type: data[0], majorVersion: data[1], minorVersion: data[2])
    }
    
    func toData() -> Data {
        
        var data: Data = Data()
        
        data.append(_type)
        data.append(_majorVersion)
        data.append(_minorVersion)
        
        return data
    }
    
    var _stringValue: String {
        get {
            return "\(_type)=>\(_majorVersion).\(_minorVersion)"
        }
    }
}

//DHCP Option 97 (UUID/GUID-based Client Identifier)
class ClientMachineIdentifierDhcpOption: IDhcpOption {
    let _optionType: OptionType
    let _type: UInt8
    let _id: Data
    
    init(type: UInt8, id: Data) {
        _optionType = OptionType.ClientMachineIdentifier
        _type = type
        _id = id
    }
    
    convenience init(data: Data) throws {
        
        if (data.count < 1) {
            throw DhcpError.invalidOptionLength
        }
        
        let type = data[0]
        let id = data.subdata(in: 1..<data.count)
        
        self.init(type: type, id: id)
    }
    
    func toData() -> Data {
        var data: Data = Data()
        
        data.append(_type)
        data.append(_id)
        
        return data
    }
    
    var _stringValue: String {
        get {
            return "\(_type)=>\(String(describing: _id))"
        }
    }
}

//DHCP Option 116 (DHCP Auto-Configuration)
class AutoConfigureDhcpOption : UInt8DhcpOption {
    
    convenience init(autoConfigure: UInt8) {
        self.init(optionType: OptionType.AutoConfigure, value: autoConfigure)
    }
    
    convenience init(data: Data) throws {
        try self.init(optionType: OptionType.AutoConfigure, data: data)
    }
    
    var autoConfigure: UInt8 {
        get {
            return _value
        }
    }
}

//DHCP Option 252 (Windows BCD Path)
class WindowsBcdFilePathDhcpOption : StringDhcpOption {
    
    convenience init(bcdPath: String) {
        self.init(optionType: OptionType.WindowsBcdFilePath, string: bcdPath)
    }
    
    convenience init(data: Data) {
        self.init(optionType: OptionType.WindowsBcdFilePath, data: data)
    }
    
    var bcdPath: String {
        get {
            return _string
        }
    }
}

class GenericDhcpOption: DataDhcpOption {
}

class IpListDhcpOption: IDhcpOption {
    let _optionType: OptionType
    let _ipList: [IPAddress]
    
    init(optionType: OptionType, ipList: [IPAddress]) {
        _optionType = optionType
        _ipList = ipList
    }
    
    convenience init(optionType: OptionType, data: Data) throws {
        
        if (data.count < 4 || data.count % 4 != 0) {
            throw DhcpError.invalidOptionLength
        }
        
        var ipList: [IPAddress] = [IPAddress]()
        
        for i in 0..<data.count/4 {
            ipList.append(IPv4Address(data.subdata(in: (i*4)..<(i*4+4)))!)
        }
        
        self.init(optionType: optionType, ipList: ipList)
    }
    
    func toData() -> Data {
        
        var data: Data = Data()
        
        for ip in _ipList {
            data.append(ip.rawValue)
        }
        
        return data
    }
    
    var _stringValue: String {
        get {
            let ips = _ipList.map({ ($0 as! IPv4Address).debugDescription})
            return ips.joined(separator: ",")
        }
    }
}

class DataDhcpOption: IDhcpOption {
    let _optionType: OptionType
    let _data: Data
    
    init(optionType: OptionType, data: Data) {
        _optionType = optionType
        _data = data
    }
    
    func toData() -> Data {
        return _data
    }
    
    var _stringValue: String {
        get {
            return _data.hexEncodedString()
        }
    }
}

class StringDhcpOption: IDhcpOption {
    let _optionType: OptionType
    let _string: String
    
    init(optionType: OptionType, string: String) {
        _optionType = optionType
        _string = string
    }
    
    convenience init(optionType: OptionType, data: Data) {
        self.init(optionType: optionType, string: DhcpUtils.fromZString(data: data))
    }
    
    func toData() -> Data {
        
        var data: Data = Data()
        data.append(DhcpUtils.toZString(rawStr: _string, length: _string.count))
        return data
    }
    
    var _stringValue: String {
        get {
            return _string
        }
    }
}

class UInt8DhcpOption: IDhcpOption {
    let _optionType: OptionType
    let _value: UInt8
    
    init(optionType: OptionType, value: UInt8) {
        _optionType = optionType
        _value = value
    }
    
    convenience init(optionType: OptionType, data: Data) throws {
        if (data.count != 1) {
            throw DhcpError.invalidOptionLength
        }
        
        self.init(optionType: optionType, value: data[0])
    }
    
    func toData() -> Data {
        var data: Data = Data()
        data.append(_value)
        return data
    }
    
    var _stringValue: String {
        get {
            return String(describing: _value)
        }
    }
}

class UInt16DhcpOption: IDhcpOption {
    let _optionType: OptionType
    let _value: UInt16
    
    init(optionType: OptionType, value: UInt16) {
        _optionType = optionType
        _value = value
    }
    
    convenience init(optionType: OptionType, data: Data) throws {
        if (data.count != 2) {
            throw DhcpError.invalidOptionLength
        }
        
        self.init(optionType: optionType, value: DhcpUtils.toUInt16(data: data))
    }
    
    func toData() -> Data {
        
        var data: Data = Data()
        
        var value = UInt16(bigEndian: _value)
        data.append(Data(bytes: &value, count: MemoryLayout.size(ofValue: value)))
        
        return data
    }
    
    var _stringValue: String {
        get {
            return String(describing: _value)
        }
    }
}

class UInt32DhcpOption: IDhcpOption {
    let _optionType: OptionType
    let _value: UInt32
    
    init(optionType: OptionType, value: UInt32) {
        _optionType = optionType
        _value = value
    }
    
    convenience init(optionType: OptionType, data: Data) throws {
        if (data.count != 4) {
            throw DhcpError.invalidOptionLength
        }
        
        self.init(optionType: optionType, value: DhcpUtils.toUInt32(data: data))
    }
    
    func toData() -> Data {
        
        var data: Data = Data()
        
        var value = UInt32(bigEndian: _value)
        data.append(Data(bytes: &value, count: MemoryLayout.size(ofValue: value)))
        
        return data
    }
    
    var _stringValue: String {
        get {
            return String(describing: _value)
        }
    }
}

class Int32DhcpOption: IDhcpOption {
    let _optionType: OptionType
    let _value: Int32
    
    init(optionType: OptionType, value: Int32) {
        _optionType = optionType
        _value = value
    }
    
    convenience init(optionType: OptionType, data: Data) throws {
        if (data.count != 4) {
            throw DhcpError.invalidOptionLength
        }
        
        self.init(optionType: optionType, value: DhcpUtils.toInt32(data: data))
    }
    
    func toData() -> Data {
        
        var data: Data = Data()
        
        var value = Int32(bigEndian: _value)
        data.append(Data(bytes: &value, count: MemoryLayout.size(ofValue: value)))
        
        return data
    }
    
    var _stringValue: String {
        get {
            return String(describing: _value)
        }
    }
}
