//
//  DhcpClient.swift
//  DHCPingTest2
//
//  Created by Alexey Altoukhov on 3/11/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import Foundation
import Network

class DhcpClient {
    
    private let _macAddress: Data
    private let _sentCallback: ((_ message: DhcpMessage) -> Void)
    private let _receivedCallback: ((_ message: DhcpMessage) -> Void)
    private let _errorCallback: ((_ error: String) -> Void)
    
    private var _broadcastConnection: UDPBroadcastConnection? = nil
    private var _pendingMap: [UInt32 : ((_ message: DhcpMessage) -> Void)]
    
    private let _localCache: LocalCache
    
    init(macAddress: Data,
        sentCallback: @escaping ((_ message: DhcpMessage) -> Void),
        receivedCallback: @escaping ((_ message: DhcpMessage) -> Void),
        errorCallback: @escaping ((_ error: String) -> Void)) {
        
        _macAddress = macAddress
        _sentCallback = sentCallback
        _receivedCallback = receivedCallback
        _errorCallback = errorCallback
    
        _pendingMap = [UInt32 : ((message: DhcpMessage) -> Void)]()
        
        _localCache = LocalCache()
        
        _broadcastConnection = UDPBroadcastConnection(remotePort: 67, localPort: 68) {(ipAddress: String, port: Int, response: [UInt8]) -> Void in
            do {
                self._localCache.saveData(fileName: "\(Date().timeIntervalSinceReferenceDate)", data: Data(response))
                
                let message: DhcpMessage = try DhcpMessage(data: Data(response))
                
                if (message._clientHardwareAddress.elementsEqual(macAddress)) {
                    receivedCallback(message)
                    
                    let callback = self._pendingMap[message._xid]
                    if (callback != nil) {
                        self._pendingMap.removeValue(forKey: message._xid)
                        callback!(message)
                    }
                }
            }
            catch (DhcpError.invalidOptionLength) {
                print("failed to parse, invalid option length")
                errorCallback("error")
            }
            catch (DhcpError.unexpectedDhcpOption) {
                print("failed to parse, unexpected option")
                errorCallback("error")
            }
            catch {
                print("error")
                errorCallback("error")
            }
        }
    }
    
    func runDhcp() {
        
        let xid = UInt32.random(in: 0..<UInt32.max)
        
        let discover = DhcpMessage.CreateDiscover(xid: xid, macAddress: _macAddress)
        
        _pendingMap[xid] = {(offer) -> Void in

            if let serverIp = offer.serverIp {
                
                let request = DhcpMessage.CreateRequest(xid: xid, macAddress: self._macAddress, serverIp: serverIp, requestIp: offer._yourIpAddress)
                
                self._localCache.saveData(fileName: "\(Date().timeIntervalSinceReferenceDate)", data: request.toData())
                self._broadcastConnection!.sendBroadcast(request.toData())
                self._sentCallback(request)
            }
        }
        
        self._localCache.saveData(fileName: "\(Date().timeIntervalSinceReferenceDate)", data: discover.toData())
        _broadcastConnection!.sendBroadcast(discover.toData())
        _sentCallback(discover)
    }
}
