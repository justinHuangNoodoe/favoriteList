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
