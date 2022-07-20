//
//  ExtsUIImageView.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/19.
//

import UIKit

extension UIImageView {
    func downloadImage(from url: String) {
        guard let url = URL(string: url) else {
            print("Image url is invalid")
            return
        }
        print("Download Started")
        RESTfulService.download(from: url) { [weak self] data, response, error in
            guard
                let self = self,
                let data = data, error == nil else { return }
            print("Download Finished")
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}
