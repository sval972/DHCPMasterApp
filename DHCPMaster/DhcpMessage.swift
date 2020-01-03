//
//  DhcpMessage.swift
//  DHCPMaster
//
//  Created by Alexey Altoukhov on 1/13/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import Foundation
import Network

class DhcpMessage {
    
    enum Opcode: UInt8 {
        case Unknown = 0
        case BootRequest = 1
        case BootReply = 2
    }
    
    enum HardwareType: UInt8 {
        case Unknown = 0
        case Ethernet = 1
        case Experimental_Ethernet = 2
        case Amateur_Radio_AX_25 = 3
        case Proteon_ProNET_Token_Ring = 4
        case Chaos = 5
        case IEEE_802_Networks = 6
        case ARCNET = 7
        case Hyperchannel = 8
        case Lanstar = 9
        case Autonet_Short_Address = 10
        case LocalTalk = 11
        case LocalNet = 12
        case Ultra_link = 13
        case SMDS = 14
        case Frame_Relay = 15
        case Asynchronous_Transmission_Mode1 = 16
        case HDLC = 17
        case Fibre_Channel = 18
        case Asynchronous_Transmission_Mode2 = 19
        case Serial_Line = 20
        case Asynchronous_Transmission_Mode3 = 21
    }
    
    var _opcode: Opcode
    var _hwType: HardwareType
    var _hops: UInt8
    var _xid: UInt32
    var _secs: UInt16
    var _broadcast: Bool
    var _clientIpAddress: IPAddress
    var _yourIpAddress: IPAddress
    var _nextServerIpAddress: IPAddress
    var _relayAgentIpAddress: IPAddress
    var _clientHardwareAddress: Data
    var _serverHostname: String
    var _bootFileName: String
    var _dhcpOptions: [IDhcpOption]
    
    var serverIp: IPAddress? {
        get {
            var value: IPAddress? = nil
            
            if let option = _dhcpOptions.first(where: {$0._optionType == OptionType.ServerIdentifier}) {
                value = (option as! ServerIdentifierDhcpOption).ipAddress
            }
            
            return value
        }
    }
    
    var requestedIp: IPAddress? {
        get {
            var value: IPAddress? = nil
            
            if let option = _dhcpOptions.first(where: {$0._optionType == OptionType.RequestedIpAddress}) {
                value = (option as! RequestedIpAddressDhcpOption).ipAddress
            }
            
            return value
        }
    }
    
    var messageType: MessageType? {
        get {
            var value: MessageType? = nil
            
            if let option = _dhcpOptions.first(where: {$0._optionType == OptionType.MessageType}) {
                value = (option as! MessageTypeDhcpOption).messageType
            }
            
            return value
        }
    }
    
    init() {
        _opcode = Opcode.Unknown
        _hwType = HardwareType.Ethernet
        _hops = 0
        _xid = 0
        _secs = 0
        _broadcast = false
        _clientIpAddress = IPv4Address("0.0.0.0")!
        _yourIpAddress = IPv4Address("0.0.0.0")!
        _nextServerIpAddress = IPv4Address("0.0.0.0")!
        _relayAgentIpAddress = IPv4Address("0.0.0.0")!
        _clientHardwareAddress = Data()
        _serverHostname = ""
        _bootFileName = ""
        _dhcpOptions = [IDhcpOption]()
    }
    
    init(data: Data) throws {
        _opcode = Opcode(rawValue: data[0])!
        _hwType = HardwareType(rawValue: data[1])!
        let clientHwAddressCount: UInt8 = data[2]
        _hops = data[3]
        _xid = DhcpUtils.toUInt32(data: data.subdata(in: 4..<8))
        _secs = DhcpUtils.toUInt16(data: data.subdata(in: 8..<10))
        _broadcast = (DhcpUtils.toUInt16(data: data.subdata(in: 10..<12)) & 0x8000) == 0x8000
        _clientIpAddress = IPv4Address(data.subdata(in: 12..<16))!
        _yourIpAddress = IPv4Address(data.subdata(in: 16..<20))!
        _nextServerIpAddress = IPv4Address(data.subdata(in: 20..<24))!
        _relayAgentIpAddress = IPv4Address(data.subdata(in: 24..<28))!
        _clientHardwareAddress = data.subdata(in: 28..<(28+Int(clientHwAddressCount)))
        
        let serverHostnameBuffer = data.subdata(in: 44..<108)
        let bootFileNameBuffer = data.subdata(in: 108..<236)
        
        let optionsBuffer = data.subdata(in: 240..<data.count)
        
        let overload = try DhcpMessage.scanOverload(data: optionsBuffer)
        
        _serverHostname = String()
        _bootFileName = String()
        
        switch overload {
        case 1:
            _serverHostname = DhcpUtils.fromZString(data: serverHostnameBuffer)
            _dhcpOptions = try DhcpMessage.readDhcpOptions(buf1: optionsBuffer, buf2: bootFileNameBuffer, buf3: Data())
            
        case 2:
            _bootFileName = DhcpUtils.fromZString(data: bootFileNameBuffer)
            _dhcpOptions = try DhcpMessage.readDhcpOptions(buf1: optionsBuffer, buf2: serverHostnameBuffer, buf3: Data())
            
        case 3:
            _dhcpOptions = try DhcpMessage.readDhcpOptions(buf1: optionsBuffer, buf2: bootFileNameBuffer, buf3: serverHostnameBuffer)
            
        default:
            _serverHostname = DhcpUtils.fromZString(data: serverHostnameBuffer)
            _bootFileName = DhcpUtils.fromZString(data: bootFileNameBuffer)
            _dhcpOptions = try DhcpMessage.readDhcpOptions(buf1: optionsBuffer, buf2: Data(), buf3: Data())
        }
    }
    
    func toData() -> Data
    {
        var data: Data = Data()
        
        data.append(_opcode.rawValue)
        data.append(_hwType.rawValue)
        data.append(UInt8(_clientHardwareAddress.count))
        data.append(_hops)
        
        var xid = UInt32(bigEndian: _xid)
        data.append(Data(bytes: &xid, count: MemoryLayout.size(ofValue: xid)))
        
        var secs = UInt16(bigEndian: _secs)
        data.append(Data(bytes: &secs, count: MemoryLayout.size(ofValue: secs)))
        
        var broadcast: UInt16 = _broadcast ? UInt16(bigEndian: 0x8000) : UInt16(bigEndian: 0x0)
        data.append(Data(bytes: &broadcast, count: MemoryLayout.size(ofValue: broadcast)))
        
        data.append(_clientIpAddress.rawValue)
        data.append(_yourIpAddress.rawValue)
        data.append(_nextServerIpAddress.rawValue)
        data.append(_relayAgentIpAddress.rawValue)
        data.append(_clientHardwareAddress)
        
        for _ in _clientHardwareAddress.count..<16 {
            data.append(0)
        }
        
        data.append(DhcpUtils.toZString(rawStr: _serverHostname, length: 64))
        data.append(DhcpUtils.toZString(rawStr: _bootFileName, length: 128))

        data.append(UInt8(99))
        data.append(UInt8(130))
        data.append(UInt8(83))
        data.append(UInt8(99))
        
        var optionsToWrite = _dhcpOptions.filter {$0._optionType != OptionType.RelayAgentInformation}
        
        if let relayAgentInfoOption = _dhcpOptions.first(where: {$0._optionType == OptionType.RelayAgentInformation}) {
            optionsToWrite.append(relayAgentInfoOption)
        }
        
        for dhcpOption in optionsToWrite {
            let optionData = dhcpOption.toData()
            data.append(dhcpOption._optionType.rawValue)
            data.append(UInt8(optionData.count))
            data.append(optionData)
        }

        
        data.append(255)
        
        return data
    }
    
    func toString() -> String {
        var text:String = String()
        
        text.append("Opcode: " + String(describing: _opcode))
        text.append("\nHardwareType: " + String(describing: _hwType))
        text.append("\nHops: " + String(_hops))
        text.append("\nXID: " + String(_xid))
        text.append("\nSecs: " + String(_secs))
        text.append("\nBroadcast: " + String(_broadcast))
        text.append("\nClientIPAddress (ciaddr): " + (_clientIpAddress as! IPv4Address).debugDescription)
        text.append("\nYourIPAddress (yiaddr): " + (_yourIpAddress as! IPv4Address).debugDescription)
        text.append("\nNextServerIPAddress (siaddr): " + (_nextServerIpAddress as! IPv4Address).debugDescription)
        text.append("\nRelayAgentIPAddress (giaddr): " + (_relayAgentIpAddress as! IPv4Address).debugDescription)
        text.append("\nClientHardwareAddress (chaddr): " + _clientHardwareAddress.hexEncodedString())
        text.append("\nServerHostName (sname): " + _serverHostname)
        text.append("\nBootFileName (file): " + _bootFileName)
        
        for dhcpOption in _dhcpOptions {
            text.append("\n" + String(describing: dhcpOption))
        }
        
        text.append("\n")
        
        return text
    }
    
    private static func readDhcpOptions(buf1: Data, buf2: Data, buf3: Data) throws -> [IDhcpOption] {
        
        var options: [IDhcpOption] = [IDhcpOption]()
    
        try DhcpMessage.readDhcpOptions(options: &options, dataRo: buf1, spilloversRo: buf2, buf3)
        try DhcpMessage.readDhcpOptions(options: &options, dataRo: buf2, spilloversRo: buf3)
        try DhcpMessage.readDhcpOptions(options: &options, dataRo: buf3)
        
        return options
    }
    
    private static func readDhcpOptions(options: inout [IDhcpOption], dataRo: Data, spilloversRo: Data...) throws {
        
        var data = Data(dataRo)
        var spillovers = [Data]()
        
        for s in spilloversRo {
            spillovers.append(Data(s))
        }
        
        var i: Int = 0
        
        while (i<data.count) {
            if (data[i] == 0) {
                i+=1
                continue
            }
            if (data[i] == 255) {
                break
            }
            
            let code = data[i]
            let length = Int(data[i+1])
            var concatData = data.subdata(in: (i+2)..<(i+2+length))
            
            DhcpMessage.appendOverflow(code: code, startPosition: i+2+length, source: &data, target: &concatData)
            
            for j in 0..<spillovers.count {
                DhcpMessage.appendOverflow(code: code, startPosition: 0, source: &spillovers[j], target: &concatData)
            }
            
            options.append(try DhcpOptionFactory.fromData(code: code, data: concatData))
            
            i+=(length + 2)
        }
    }
    
    private static func appendOverflow(code: UInt8, startPosition: Int, source: inout Data, target: inout Data) {
        
        var i: Int = startPosition
        
        while (i<source.count) {
            if (source[i] == 0) {
                i+=1
                continue
            }
            if (source[i] == 255) {
                break
            }
            
            let c = source[i]
            let l = Int(source[i+1])
            
            if (c == code) {
                target.append(source.subdata(in: (i+2)..<(i+2+l)))
                source.resetBytes(in: i..<(i+2+l))
            }
            else {
                i+=(l + 2)
            }
        }
    }
    
    private static func scanOverload(data: Data) throws -> UInt8 {
    
        var code: UInt8 = 0
        var i: Int = 0
        
        while (i<data.count) {
            if (data[i] == 0) {
                i+=1
                continue
            }
            if (data[i] == 255) {
                break
            }
            if (data[i] == 52) {
                if (data[i+1] != 1) {
                    throw DhcpError.invalidOptionLength
                }
                code = data[i+2]
                break
            }
            else {
                let opLen = data[i+1]
                i+=Int(opLen+2)
            }
        }
    
        return code
    }
    
    static func CreateDiscover(xid: UInt32, macAddress: Data) -> DhcpMessage {
        
        let message: DhcpMessage = DhcpMessage()
        message._opcode = DhcpMessage.Opcode.BootRequest
        message._hwType = DhcpMessage.HardwareType.Ethernet
        message._hops = 1
        message._xid = xid
        message._secs = 10
        message._broadcast = true
        message._clientHardwareAddress = macAddress
        message._dhcpOptions.append(MessageTypeDhcpOption(messageType: MessageType.Discover))
        
        return message
    }
    
    static func CreateRequest(xid: UInt32, macAddress: Data, serverIp: IPAddress, requestIp: IPAddress) -> DhcpMessage {
        
        let message: DhcpMessage = DhcpMessage()
        message._opcode = DhcpMessage.Opcode.BootRequest
        message._hwType = DhcpMessage.HardwareType.Ethernet
        message._hops = 1
        message._xid = xid
        message._secs = 10
        message._broadcast = true
        message._clientHardwareAddress = macAddress
        message._dhcpOptions.append(MessageTypeDhcpOption(messageType: MessageType.Request))
        message._dhcpOptions.append(ServerIdentifierDhcpOption(ipAddress: serverIp))
        message._dhcpOptions.append(RequestedIpAddressDhcpOption(ipAddress: requestIp))
        
        return message
    }
}

extension Data {
    func subdata(in range: ClosedRange<Index>) -> Data {
        return subdata(in: range.lowerBound ..< range.upperBound + 1)
    }
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
