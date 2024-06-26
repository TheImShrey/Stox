//
//  UpstoxFileManager.swift
//  Upstox
//
//  Created by Shreyash Shah on 24/05/24.
//

import Foundation

final class UpstoxFileManager: FileManager {
    var documentsDirectoryURL: URL {
        return self.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL.documentsDirectory
    }
    
    var privateDirectoryURL: URL {
        return self.urls(for: .applicationSupportDirectory, in: .userDomainMask).first ?? URL.applicationSupportDirectory
    }
    
    var persistentStorageDirectoryURL: URL {
        return self.privateDirectoryURL.appending(component: "PersistentStorage")
    }
  
    func deleteItemIfExists(at url: URL) throws {
        guard self.fileExists(atPath: url.path(percentEncoded: false)) else { return }
        try self.removeItem(at: url)
    }
    
    func isDirectoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let isPathExists = self.fileExists(atPath: url.path(percentEncoded: false), isDirectory: &isDirectory)
        return isPathExists && isDirectory.boolValue
    }
    
    func isFileExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let isPathExists = self.fileExists(atPath: url.path(percentEncoded: false), isDirectory: &isDirectory)
        return isPathExists && !isDirectory.boolValue
    }
    
    func isItemExists(at url: URL) -> Bool {
        return self.fileExists(atPath: url.path(percentEncoded: false))
    }
    
    func copyFile(at sourceURL: URL, byCreatingIntermediateDirectoriesTo destinationURL: URL, shouldOverwrite: Bool) throws {
        let destinationDirectoryURL = destinationURL.deletingLastPathComponent()
        
        if self.isDirectoryExists(at: destinationDirectoryURL) == false {
            try self.createDirectory(at: destinationDirectoryURL, withIntermediateDirectories: true)
        } else {
            if shouldOverwrite {
                try self.deleteItemIfExists(at: destinationURL)
            }
        }
        
        try self.copyItem(at: sourceURL, to: destinationURL)
    }
    
    func moveFile(at sourceURL: URL, byCreatingIntermediateDirectoriesTo destinationURL: URL, shouldOverwrite: Bool) throws {
        let destinationDirectoryURL = destinationURL.deletingLastPathComponent()
        
        if self.isDirectoryExists(at: destinationDirectoryURL) == false {
            try self.createDirectory(at: destinationDirectoryURL, withIntermediateDirectories: true)
        } else {
            if shouldOverwrite {
                try self.deleteItemIfExists(at: destinationURL)
            }
        }
        
        try self.moveItem(at: sourceURL, to: destinationURL)
    }
    
    override init() {
        super.init()
        
        /// Deletion of PersistentStorage and Audio Storage depending on debug scenario
        let directoriesToDelete: [String] = [
///           - Warning Only enable for debugging:
//            self.persistentStorageDirectoryURL.lastPathComponent
        ]
        
        try? contentsOfDirectory(atPath: privateDirectoryURL.path(percentEncoded: false)).forEach { item in
           
            guard directoriesToDelete.contains(item) else { return }
            
            debugPrint("Deleting: private\(item)")
            try? removeItem(atPath: privateDirectoryURL.appending(path: item).path(percentEncoded: false))
        }
    }
}
