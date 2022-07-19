//
//  Coordinator.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/19.
//

import Foundation

protocol Coordinator {
    var childAppCoordinators: [Coordinator] { get set }
    func start()
}

protocol FLCoordinator: Coordinator {
    associatedtype T
    var rootViewController: T { get }
}
