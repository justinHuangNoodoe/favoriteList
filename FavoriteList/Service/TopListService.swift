//
//  TopListService.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

typealias GetTopMangaListHandler = ResfulHandler<TopList>

class TopListService {
    private init() {}
    static func getTopMangaList(type: MangaType?, filter: TopListItemFilter?, page: Int, limit: Int, completionHander: @escaping GetTopMangaListHandler) {
        
        var queryDic: [String: String] = [:]
        queryDic["type"] = type?.text
        queryDic["filter"] = filter?.text
        queryDic["page"] = page.description
        queryDic["limit"] = limit.description
        
        guard let url = getTopMangaListApi.appendCustomQuery(queryDic) else {
            completionHander(.failure(RESTfulServiceError.invalidURL))
            return
        }
        
        RESTfulService.asyncRESTfulService(.get, targetType: TopList.self, url: url, body: nil, header: nil, completion: completionHander)
    }
}

enum MangaType: Int, CaseIterable {
    case manga = 0
    case novel = 1
    case lightnovel = 2
    case oneshot = 3
    case doujin = 4
    case manhwa = 5
    case manhua = 6
    
    var text: String {
        return "\(self)"
    }
}

enum TopListItemFilter: Int, CaseIterable {
    case publishing = 0
    case upcoming = 1
    case bypopularity = 2
    case favorite = 3
    
    var text: String {
        return "\(self)"
    }
}

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
