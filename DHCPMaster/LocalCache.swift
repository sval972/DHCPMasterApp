//
//  LocalCache.swift
//  DHCPMaster
//
//  Created by Alexey Altoukhov on 3/31/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import Foundation

class LocalCache {
    
    private let _configFile = "appconfig.json"
    
    func getConfigFile()->Data? {
        return getData(fileName: _configFile)
    }
    
    func saveConfigFile(content: Data) {
        saveData(fileName: _configFile, data: content)
    }
    
    func getFilesList()->[String] {
        
        var files: [String] = [String]()
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL!, includingPropertiesForKeys: nil)
            
            for file in fileURLs {
                if (file.lastPathComponent != _configFile) {
                    files.append(file.lastPathComponent)
                }
            }
            
        } catch {
            print("Error while enumerating files \(documentsURL!.path): \(error.localizedDescription)")
        }
        
        return files
    }
    
    func saveData(fileName: String, data: Data)->() {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(fileName)
            
            do {
                try data.write(to: fileURL, options: Data.WritingOptions.atomic)
            }
            catch {
                print ("failed to write \(fileURL)")
            }
        }
    }

    func getData(fileName: String)->Data? {
        
        var data: Data? = nil
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(fileName)
            
            do {
                data = try Data(contentsOf: fileURL)
            }
            catch {
                print ("failed to read \(fileURL)")
            }
        }
        
        return data
    }
    
    func deleteFile(fileName: String) {

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(fileName)
            
            do {
                try FileManager.default.removeItem(at: fileURL)
            }
            catch {
                print ("failed to delete \(fileURL)")
            }
        }
    }
}
