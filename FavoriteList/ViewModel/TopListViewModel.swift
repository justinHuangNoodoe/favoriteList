//
//  TopListViewModel.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

protocol TopListVMDelegate: AnyObject {
    func updateFavoriteItemsFinished()
    func updateTopListSucess()
    func updateTopListFailue(_ error: Error)
}

typealias FavoriteItemId = Int

class TopListViewModel {
    
    private weak var delegate: TopListVMDelegate?
    private var isLoadingList: Bool
    private var favoriteIds: [FavoriteItemId]
    private var currentPage: Int
    private var searchType: Elementable?
    private var searchFilter: Elementable?
    private(set) var hasNextPage: Bool
    private(set) var topList: [TopListItem]
    
    var shouldShownEmptyBackgroundView: Bool {
        return topList.isEmpty
    }
    
    var injection: TopListInjection {
        didSet {
            clearFilter()
            resetPageSetting()
        }
    }
    
    init(injection: TopListInjection, delegate: TopListVMDelegate?) {
        self.delegate = delegate
        self.injection = injection
        topList = []
        currentPage = 0
        isLoadingList = false
        hasNextPage = false
        favoriteIds = []
    }
    
    func setSearchType(_ index: Int) {
        searchType = injection.searchType(index: index)
        resetPageSetting()
    }
    
    func setSearchFilter(_ index: Int) {
        searchFilter = injection.searchFilter(index: index)
        resetPageSetting()
    }
    
    func isFavorite(_ id: Int) -> Bool {
        return favoriteIds.contains(id)
    }
    
    private func resetPageSetting() {
        topList = []
        currentPage = 0
        hasNextPage = false
    }
    
    private func clearFilter() {
        searchType = nil
        searchFilter = nil
    }
    
    func getTopList() {
        guard !isLoadingList else { return }
        isLoadingList = true
        let page = hasNextPage ? currentPage + 1 : currentPage
        injection.getTopList(searchType, searchFilter, page, 20) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoadingList = false
                switch result {
                case .success(let list):
                    if page > self.currentPage {
                        self.topList.append(contentsOf: list.data)
                    } else {
                        self.topList = list.data
                    }
                    
                    if
                        let currentPage = list.pagination.currentPage,
                        let hasNextPage = list.pagination.hasNextPage {
                        self.currentPage = currentPage
                        self.hasNextPage = hasNextPage
                    }
                    self.delegate?.updateTopListSucess()
                case .failure(let error):
                    self.delegate?.updateTopListFailue(error)
                }
            }
        }
    }
    
    func getFavoriteIds() {
        favoriteIds = FavoriteItemManager.shared.favoriteItems.map { $0.id }
        delegate?.updateFavoriteItemsFinished()
    }
    
    func updateFavoritItems(_ index: Int, isFavorite: Bool) {
        let item = topList[index]
        if isFavorite {
            FavoriteItemManager.shared.favoriteItems.insert(item)
        } else {
            FavoriteItemManager.shared.favoriteItems.remove(item)
        }
        favoriteIds = FavoriteItemManager.shared.favoriteItems.map{ $0.id }
    }
}

enum TopListInjection: Int, CaseIterable, Elementable {
    case manga = 0
    case anime = 1
    
    var text: String {
        return "\(self)"
    }
    
    var index: Int {
        return self.rawValue
    }
    
    var getTopList: (Elementable?, Elementable?, Int, Int, @escaping GetTopListHandler) -> () {
        switch self {
        case .manga:
            return TopListService.getTopMangaList
        case .anime:
            return TopListService.getTopAnimeList
        }
    }
    
    var searchTypeElements: [Elementable] {
        switch self {
        case .manga:
            return MangaType.allCases
        case .anime:
            return AnimeType.allCases
        }
    }
    
    var searchFilterElements: [Elementable] {
        switch self {
        case .manga:
            return MangaFilter.allCases
        case .anime:
            return AnimeFilter.allCases
        }
    }
    
    func searchType(index: Int) -> Elementable? {
        switch self {
        case .anime:
            return MangaType(rawValue: index)
        case .manga:
            return AnimeType(rawValue: index)
        }
    }
    
    func searchFilter(index: Int) -> Elementable? {
        switch self {
        case .anime:
            return MangaFilter(rawValue: index)
        case .manga:
            return AnimeFilter(rawValue: index)
        }
    }
}
