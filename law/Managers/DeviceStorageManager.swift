//
//  DeviceStorageManager.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import UIKit

final class DeviceStorageManager {
    private let manager = FileManager.default
    private let defaultDirectory: URL
    
    static let shared = DeviceStorageManager()
    
    init() {
        do {
            self.defaultDirectory = try self.manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            fatalError("Failed to fetch default directory")
        }
    }
    
    func saveImage(image: UIImage, name: String) throws -> String? {
        let fileUrl = self.defaultDirectory.appending(path: "\(name).png")
        guard let data = image.pngData() else { return nil }
        do {
            try data.write(to: fileUrl)
            return "\(name).png"
        } catch {
            throw error
        }
    }
    
    func copyFile(from url: URL, to name: String) throws -> String? {
        let fileUrl = self.defaultDirectory.appending(path: name)
        do {
            try self.manager.copyItem(at: url, to: fileUrl)
            return name
        } catch {
            throw error
        }
    }
    
    func removeFile(at name: String) throws -> Bool {
        let fileUrl = self.defaultDirectory.appending(path: name)
        guard self.manager.fileExists(atPath: fileUrl.path) else { return false }
        
        do {
            try self.manager.removeItem(at: fileUrl)
            return true
        } catch {
            throw error
        }
    }
    
    func fullPath(for filePath: String) -> URL {
        self.defaultDirectory.appending(path: filePath)
    }
}
