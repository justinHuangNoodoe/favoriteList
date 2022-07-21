//
//  FavoriteItemManager.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/21.
//

import Foundation

class FavoriteItemManager {
    static let shared = FavoriteItemManager()
    private let debounce: Debounce
    private let queue: DispatchQueue
    private let archivePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("FavoriteItems")
    
    private init() {
        debounce = Debounce(interval: 0.5)
        queue = DispatchQueue(label: String(describing: Self.self))
    }
    
    
    
    private var favoriteItems: [TopListItem] {
        get {
            guard let archivePath = archivePath else { return [] }
            do {
                let data = try Data(contentsOf: archivePath)
                let archiveData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data
                if let _archiveData = archiveData {
                    let items = try PropertyListDecoder().decode([TopListItem].self, from: _archiveData)
                    return items
                } else {
                    return []
                }
            } catch {
                return []
            }
        }
        
        set {
            guard let archivePath = archivePath else { return }
            do {
                let objectData = try PropertyListEncoder().encode(newValue)
                let archiveData = try NSKeyedArchiver.archivedData(withRootObject: objectData, requiringSecureCoding: true)
                try archiveData.write(to: archivePath)
            } catch {
                print("Set favoriteItems fail, reason: \(error)")
            }
            
        }
    }
    
//    private(set) var threadSafeFavoriteItems: [TopListItem] {
//        get {
//            var result: [TopListItem] = []
//            queue.sync {
//                result = topList
//            }
//            return result
//        }
//        
//        set {
//            queue.async {
//                self.topList = newValue
//            }
//        }
//    }
}

class ThreadSafe<T> {
    private var originalObject: T
    private let queue: DispatchQueue
    init(label: String, oringinal: T) {
        originalObject = oringinal
        queue = DispatchQueue(label: label)
    }
    
    var threadSafeObject: T {
        get {
            var result: T!
            queue.sync {
                result = originalObject
            }
            return result
        }
        
        set {
            queue.async {
                self.originalObject = newValue
            }
        }
    }
}
