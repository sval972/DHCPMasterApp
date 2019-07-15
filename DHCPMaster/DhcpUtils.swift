//
//  DhcpUtils.swift
//  DHCPingTest2
//
//  Created by Alexey Altoukhov on 2/23/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import Foundation

class DhcpUtils {
    
    static func toZString(rawStr: String, length: Int) -> Data {
        
        var data : Data = Data()
        
        let str: String = rawStr.count >= length ? String(rawStr.prefix(length-1)) : rawStr
        
        for char in str.unicodeScalars
        {
            data.append(UInt8(char.value))
        }
        
        for _ in str.count..<length {
            data.append(0)
        }
        
        return data
    }
    
    static func fromZString(data: Data) -> String {
        
        var bytes = data
        if (bytes.last == 0) {
            bytes.removeLast()
        }
        
        return String(data: bytes, encoding: .utf8)!
    }
    
    static func toUInt32(data: Data) -> UInt32 {
        let i32array = data.withUnsafeBytes {
            UnsafeBufferPointer<UInt32>(start: $0, count: data.count/2).map(UInt32.init(bigEndian:))
        }
        return i32array[0]
    }
    
    static func toUInt16(data: Data) -> UInt16 {
        let i16array = data.withUnsafeBytes {
            UnsafeBufferPointer<UInt16>(start: $0, count: data.count/2).map(UInt16.init(bigEndian:))
        }
        return i16array[0]
    }
    
    static func toInt32(data: Data) -> Int32 {
        let i32array = data.withUnsafeBytes {
            UnsafeBufferPointer<Int32>(start: $0, count: data.count/2).map(Int32.init(bigEndian:))
        }
        return i32array[0]
    }
}
