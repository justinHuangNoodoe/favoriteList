//
//  TopList.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

struct TopList: Codable {
    let data: [TopListItem]
    let pagination: TopListPagination
}

struct TopListPagination: Codable {
    enum CodingKeys: String, CodingKey {
        case lastVisiblePage = "last_visible_page"
        case hasNextPage = "has_next_page"
        case currentPage = "current_page"
    }
    let lastVisiblePage: Int?
    let hasNextPage: Bool?
    let currentPage: Int?
}

struct TopListItem: Codable {
    enum CodingKeys: String, CodingKey {
        case images
        case title
        case rank
        case type
        case published
        case aired
    }
    
    let images: [String: TopListItemImage]
    let title: String?
    let rank: Int?
    let type: String?
    
    // Only used in Top manga
    let published: FromAndToTime?
    
    // Only used in top anime
    let aired: FromAndToTime?
}


enum TopListItemImageType: String, Codable {
    case jpg
    case webp
}

struct TopListItemImage: Codable {
    enum CodingKeys: String, CodingKey {
        case image = "image_url"
        case smallImage = "small_image_url"
        case largeImage = "large_image_url"
    }
    let image: String?
    let smallImage: String?
    let largeImage: String?
}

struct FromAndToTime: Codable {
    let from: String?
    let to: String?
}
