//
//  FavoriteLists.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/19.
//

import UIKit

protocol FavoriteListsVCDelegate: AnyObject {}

class FavoriteListsViewController: UIViewController, Loadable {
    
    weak var delegate: FavoriteListsVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
