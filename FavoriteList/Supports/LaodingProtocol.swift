//
//  LaodingProtocol.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/21.
//

import UIKit

protocol LoadingProtocol where Self: UIViewController {
    var loadingView: LoadingView { get }
    func showLoadingView()
    func hideLoadingView()
}

extension LoadingProtocol {
    func showLoadingView() {
        guard loadingView.superview == nil else { return }
        loadingView.frame = self.view.bounds
        self.view.addSubview(loadingView)
    }
    
    func hideLoadingView() {
        loadingView.removeFromSuperview()
    }
}
