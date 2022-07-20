//
//  UITableViewExts.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T>(indexPath: IndexPath) -> T where T: UITableViewCell, T: Identifiable {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            return T()
        }
        return cell
    }
}
