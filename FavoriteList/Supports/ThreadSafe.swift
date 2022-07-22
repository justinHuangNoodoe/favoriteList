//
//  ThreadSafe.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/22.
//

import Foundation

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
