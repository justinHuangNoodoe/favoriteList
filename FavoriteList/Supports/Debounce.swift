//
//  Debounce.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

class Debounce {
    private let debounceQueue = DispatchQueue(label: "com.gogolook.interview.FavoriteList", qos: .background)
    private var debounceJob: DispatchWorkItem?
    private let interval: TimeInterval
    
    init(interval: TimeInterval) {
        self.interval = interval
    }
    
    func execute(action: @escaping () -> ()) {
        debounceJob?.cancel()
        debounceJob = DispatchWorkItem(block: {
            DispatchQueue.main.async {
                action()
            }
        })

        if let job = debounceJob {
            debounceQueue.asyncAfter(deadline: .now() + interval, execute: job)
        }
    }
}
