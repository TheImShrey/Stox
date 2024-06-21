//
//  Environment.swift
//  Upstox
//
//  Created by Shreyash Shah on 22/05/24.
//

import Foundation
import UIKit
import SwiftData

enum EnvType: String {
    case release
    case debug
}

final class Environment {
    struct Constants {
        static let persistanceStoreFileName = "Upstox.store"
    }
    
    let defaultNetworkConfiguration: URLSessionConfiguration
    let sharedNetworkSession: URLSession
    let fileManager: UpstoxFileManager
    let persistanceContainer: ModelContainer?
    let jsonDecoder: JSONDecoder
    
    init(with type: EnvType) {
        // TODO: Configure environment variables depending `type` in future, ex: Mocked FileManager & urlSession with debug logs etc
        let fileManager = UpstoxFileManager()
        self.fileManager = fileManager
        
        /// - Note By doing this, we can easily mock the URLSession in future for testing, or add app wide network logging capabilities, throttling, etc
        let configuration = URLSessionConfiguration.default
        self.defaultNetworkConfiguration = configuration
        self.sharedNetworkSession = URLSession(configuration: configuration)
        
        self.jsonDecoder = JSONDecoder()
        
        do {
            try Environment.setupPersistentStorageDirectory(using: fileManager)
            let persistentStorageDirectoryURL = fileManager.persistentStorageDirectoryURL
            let persistentStoreFilePath = persistentStorageDirectoryURL.appending(component: Constants.persistanceStoreFileName)

            let configuration = ModelConfiguration(url: persistentStoreFilePath,
                                                   allowsSave: true)
            self.persistanceContainer = try ModelContainer(for: Persistables.Holding.self,
                                                           configurations: configuration)
        } catch {
            self.persistanceContainer = nil
            debugPrint("Error while creating persistanceContainer: \(error)")
        }
    }
    
    class func setupPersistentStorageDirectory(using fileManager: UpstoxFileManager) throws {
        let persistentStorageDirectoryURL = fileManager.persistentStorageDirectoryURL
        guard fileManager.isDirectoryExists(at: persistentStorageDirectoryURL) == false else { return }
        try fileManager.createDirectory(at: persistentStorageDirectoryURL, withIntermediateDirectories: true)
    }
}
