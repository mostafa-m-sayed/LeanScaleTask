//
//  CachingController.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 27/09/2021.
//

import Foundation
class CachingController {
    struct CacheProperties {
        var directory: String
        var limit: Int
    }
    
    enum Types {
        static var allCases: [Types] {
            return [.gameDetails, .gamesList]
        }
        
        case gameDetails
        case gamesList
        
        func getProperties() -> CacheProperties {
            switch self {
                case .gameDetails: return CacheProperties(directory: "/gameDetails/", limit: 100)
                case .gamesList: return CacheProperties(directory: "/gamesList/", limit: 100)
            }
        }
    }
    
    var selectedCache: Types
    let cacheLimit: Int
    let directory: String
    
    init(type: Types) {
        selectedCache = type
        cacheLimit = type.getProperties().limit
        directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + type.getProperties().directory
        
        do {
            try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            print(error)
        }
    }
    
    func save(response: NSDictionary, url: String) {
        if let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            if #available(iOS 11.0, *) {
                do {
                    let sw = try NSKeyedArchiver.archivedData(withRootObject: response, requiringSecureCoding: false)
                    try sw.write(to: URL(fileURLWithPath: directory + escapedString), options: .atomic)
                }
                catch {
                    print(error)
                }
            }
            else {}
        }
        DispatchQueue.global(qos: .background).async {
            if !self.checkLimit() { self.removeOldUsers() }
        }
    }
    
    func get(url: String) -> NSDictionary? {
        if let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: directory + escapedString))
                let unarchived = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary
                return unarchived
            }
            catch {
                print(error)
            }
        }
        return nil
    }
    
    private func checkLimit() -> Bool {
        guard let contents = try? FileManager().contentsOfDirectory(atPath: directory)
        else {
            return false
        }
        return contents.count <= cacheLimit
    }
    
    private func removeOldUsers() {
        guard let contents = try? FileManager().contentsOfDirectory(at: URL(fileURLWithPath: directory), includingPropertiesForKeys: [.contentModificationDateKey], options: .skipsHiddenFiles)
        else { return }
        
        let sortedContents = contents.map { url in
            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
        }
        .sorted(by: { $0.1 > $1.1 }).map { $0.0 }
        
        for i in 0 ... 5 {
            try? FileManager().removeItem(atPath: sortedContents[i])
        }
    }
    
    func delete(url: String) {
        if let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            do {
                try FileManager.default.removeItem(atPath: directory + escapedString)
            }
            catch {
                print(error)
            }
            
            DispatchQueue.global(qos: .background).async {
                if !self.checkLimit() { self.removeOldUsers() }
            }
        }
    }
    
    static func clearCache() {
        CachingController.Types.allCases.forEach {
            do {
                let dir = $0.getProperties().directory
                let directoryURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + dir
                try FileManager.default.removeItem(atPath: directoryURL)
            }
            catch { print(error) }
        }
    }
}
