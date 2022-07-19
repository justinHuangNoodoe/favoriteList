//
//  Loadable.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/19.
//

import UIKit

enum StoryBoardName: String {
    case main = "Main"
}

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

protocol Loadable: Identifiable {
    static func loadNib(bundle: Bundle?) -> UINib
}

extension Loadable {
    static func loadNib(bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: identifier, bundle: bundle)
    }
}

extension Loadable where Self: UIViewController {
    static func loadFromStoryBoard(name: StoryBoardName, storyboardBundleOrNil: Bundle? = nil) -> Self {
        return UIStoryboard(name: name.rawValue, bundle: storyboardBundleOrNil).instantiateViewController(identifier: Self.identifier) as! Self
    }
}
