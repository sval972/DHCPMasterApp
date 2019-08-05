//
//  AppConfig.swift
//  DHCPMaster
//
//  Created by Alexey Altoukhov on 8/5/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import Foundation

class AppConfig: Codable {
    
    var _termsAccepted : Bool
    var _macAddress: Data
    
    private init(termsAccepted: Bool, macAddress: Data) {
        _termsAccepted = termsAccepted
        _macAddress = macAddress
    }
    
    static func GetConfig(cache: LocalCache) -> AppConfig {
        
        var config: AppConfig? = nil
        
        let jsonCoder = JsonCoder()
        
        if let configData = cache.getConfigFile() {
            config = jsonCoder.fromJson(configData)
        }
        
        if (config == nil) {
            let randomMac = DhcpUtils.generateRandomBytes(count: 6)
            config = AppConfig(termsAccepted: false, macAddress: randomMac!)
            cache.saveConfigFile(content: jsonCoder.toJson(config)!)
        }
        
        return config!
    }
    
    func setTermsAccepted() {
        
        if (!_termsAccepted) {
            _termsAccepted = true
            
            let jsonCoder = JsonCoder()
            let cache = LocalCache()
            cache.saveConfigFile(content: jsonCoder.toJson(self)!)
        }
    }
    
    func changeMacAddress() {
        
        _macAddress = DhcpUtils.generateRandomBytes(count: 6)!
        let jsonCoder = JsonCoder()
        let cache = LocalCache()
        cache.saveConfigFile(content: jsonCoder.toJson(self)!)
    }
}
