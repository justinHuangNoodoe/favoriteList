//
//  AppCoordinator.swift
//  FalconInterview
//
//  Created by Justin Haung on 2022/6/30.
//

import UIKit

class AppCoordinator: Coordinator {
    private weak var window: UIWindow?
    var childAppCoordinators: [Coordinator]
    
    func start() {
        let mainCoordinator = MainCoordinator()
        childAppCoordinators.append(mainCoordinator)
        window?.rootViewController = mainCoordinator.rootViewController
        mainCoordinator.start()
    }
    
    init(window: UIWindow?) {
        self.window = window
        self.childAppCoordinators = []
    }
}
