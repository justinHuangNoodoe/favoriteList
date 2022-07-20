//
//  DictionaryExts.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    var queryItems: [URLQueryItem] {
        let queryItems = self.map { return URLQueryItem(name: $0.key, value: $0.value) }
        return queryItems
    }
}
