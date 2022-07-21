//
//  UISegmentedControl.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/21.
//

import UIKit

extension UISegmentedControl {
    func selectedNonSegment() {
        self.selectedSegmentIndex = -1
    }
    
    func setSegments(_ sequence: [Elementable], animated: Bool) {
        self.removeAllSegments()
        sequence.forEach { type in
            self.insertSegment(withTitle: type.text, at: type.index, animated: animated)
        }
    }
}
