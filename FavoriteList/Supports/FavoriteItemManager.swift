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
    private let fileName: String = "FavoriteItems"
    
    private init() {
        debounce = Debounce(interval: 0.5)
        queue = DispatchQueue(label: String(describing: Self.self))
        favoriteItems = (try? TLFileManager.read(path: fileName)) ?? []
    }
    
    
    var favoriteItems: Set<TopListItem> {
        didSet {
            debounce.execute {
                do {
                    try TLFileManager.write(path: self.fileName, data: oldValue)
                } catch {
                    print("Set favoriteItems fail, reason: \(error)")
                }
            }
        }
    }
    
}
