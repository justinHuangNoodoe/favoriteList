//
//  MainCoordinator.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/19.
//

import Foundation
import UIKit

enum TabbarItem: Int {
    case top = 0
    case favorite = 1
    
    var item: UITabBarItem {
        switch self {
        case .top:
            return UITabBarItem(tabBarSystemItem: .topRated, tag: self.rawValue)
        case .favorite:
            return UITabBarItem(tabBarSystemItem: .favorites, tag: self.rawValue)
        }
    }
}

class MainCoordinator: FLCoordinator {
    var childAppCoordinators: [Coordinator]
    let rootViewController: UITabBarController
    
    init() {
        childAppCoordinators = []
        rootViewController = UITabBarController()
    }
    
    func start() {
        let topListVC = TopListViewController.loadFromStoryBoard(name: .main)
        topListVC.tabBarItem = TabbarItem.top.item
        let favoriteListVC = FavoriteListsViewController.loadFromStoryBoard(name: .main)
        favoriteListVC.tabBarItem = TabbarItem.favorite.item
        rootViewController.setViewControllers([topListVC, favoriteListVC], animated: true)
    }
}
