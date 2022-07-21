//
//  TopListViewModel.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

protocol TopListVMDelegate: AnyObject {
    func updateTopListSucess()
    func updateTopListFailue(_ error: Error)
}

class TopListViewModel {
    
    private weak var delegate: TopListVMDelegate?
    private var isLoadingList: Bool
    private(set) var currentPage: Int
    private(set) var hasNextPage: Bool
    private(set) var topList: [TopListItem]
    private(set) var searchType: Elementable?
    private(set) var searchFilter: Elementable?
    
    var injection: TopListInjection {
        didSet { reset() }
    }
    
    init(injection: TopListInjection, delegate: TopListVMDelegate?) {
        self.delegate = delegate
        self.injection = injection
        topList = []
        currentPage = 0
        isLoadingList = false
        hasNextPage = false
    }
    
    func setSearchType(_ index: Int) {
        searchType = injection.searchType(index: index)
    }
    
    func setSearchFilter(_ index: Int) {
        searchFilter = injection.searchFilter(index: index)
    }
    
    func reset() {
        topList = []
        currentPage = 0
        hasNextPage = false
        getTopList(page: 0)
    }
    
    func getTopList(page: Int) {
        guard !isLoadingList else { return }
        isLoadingList = true
        injection.serviceProvider(searchType, searchFilter, page, 20) { [weak self] result in
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
    
    var serviceProvider: (Elementable?, Elementable?, Int, Int, @escaping GetTopListHandler) -> () {
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
