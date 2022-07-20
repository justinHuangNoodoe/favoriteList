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
        if let cacheImage = ImageCacheManager.shared.cacheImage[url.description] {
            DispatchQueue.main.async() {
                self.image = cacheImage
            }
            print("Use cache Image")
            return
        } else {
            print("Download Started")
            RESTfulService.download(from: url) { [weak self] data, response, error in
                guard
                    let self = self,
                    let data = data, error == nil else { return }
                print("Download Finished")
                DispatchQueue.main.async() {
                    if let newImage = UIImage(data: data) {
                        self.image = newImage
                        ImageCacheManager.shared.setImage(url: url.description, image: newImage)
                    } else {
                        print("Data is not image")
                    }
                }
            }
        }
    }
}

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private(set) var cacheImage: [String: UIImage]
    private init() {
        cacheImage = [:]
    }
    
    func setImage(url: String, image: UIImage) {
        self.cacheImage[url] = image
    }
}
