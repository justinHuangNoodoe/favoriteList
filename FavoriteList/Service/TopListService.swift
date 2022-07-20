//
//  TopListService.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

typealias GetTopListHandler = ResfulHandler<TopList>

class TopListService {
    private init() {}
    static func getTopMangaList(type: MangaType?, filter: MangaFilter?, page: Int, limit: Int, completionHander: @escaping GetTopListHandler) {
        
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
    
    static func getTopAnimeList(type: AnimeType?, filter: AnimeFilter?, page: Int, limit: Int, completionHander: @escaping GetTopListHandler) {
        
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

enum MangaType: Int, Segmentedable {
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
    
    var index: Int {
        return self.rawValue
    }
}

enum MangaFilter: Int, Segmentedable {
    case publishing = 0
    case upcoming = 1
    case bypopularity = 2
    case favorite = 3
    
    var text: String {
        return "\(self)"
    }
    
    var index: Int {
        return self.rawValue
    }
}

enum AnimeType: Int, Segmentedable {
    case tv = 0
    case movie = 1
    case ova = 2
    case special = 3
    case ona = 4
    case music = 5
    
    var text: String {
        return "\(self)"
    }
    
    var index: Int {
        return self.rawValue
    }
}

enum AnimeFilter: Int, Segmentedable {
    case airing = 0
    case upcoming = 1
    case bypopularity = 2
    case favorite = 3
    
    var text: String {
        return "\(self)"
    }
    
    var index: Int {
        return self.rawValue
    }
}

protocol Segmentedable: CaseIterable {
    var text: String { get }
    var index: Int { get }
}
