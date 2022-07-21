//
//  LoadingView.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/21.
//

import UIKit

class LoadingView: UIView {
    
    private let animationView = UIActivityIndicatorView(style: .large)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    deinit {
        animationView.stopAnimating()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.loadingBgGrey
        
        animationView.startAnimating()
        animationView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        addSubview(animationView)
    }
}
