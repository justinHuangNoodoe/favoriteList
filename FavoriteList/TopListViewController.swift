//
//  ViewController.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/19.
//

import UIKit

protocol TopListVCDelegate: AnyObject {}

class TopListViewController: UIViewController, Loadable {
    
    weak var delegate: TopListVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

