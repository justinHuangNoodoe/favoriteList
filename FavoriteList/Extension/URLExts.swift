//
//  URLExts.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

extension URL {
    func appendCustomQuery(_ dic: [String : String]) -> URL? {
        let query = dic.queryItems
        return appendToComponent(query)
    }
    
    private func appendToComponent(_ query: [URLQueryItem]) -> URL? {
        var component = URLComponents(string: self.absoluteString)
        component?.queryItems = query
        return component?.url
    }
}
