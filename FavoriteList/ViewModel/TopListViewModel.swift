//
//  TopListViewModel.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

protocol TopListVMDelegate: AnyObject {
    func updateTopMangaListSucess()
    func updateTopMangaListFailue(_ error: Error)
}

class TopListViewModel {
    
    private weak var delegate: TopListVMDelegate?
    private(set) var topList: [TopListItem]
    private var isLoadingList: Bool
    private var currentPage: Int
    private var hasNextPage: Bool
    var mangaType: MangaType?
    var filter: TopListItemFilter?
    
    init(delegate: TopListVMDelegate?) {
        self.delegate = delegate
        topList = []
        currentPage = 0
        isLoadingList = false
        hasNextPage = false
    }
    
    func getTopMangaList(page: Int) {
        guard !isLoadingList else { return }
        isLoadingList = true
        TopListService.getTopMangaList(type: mangaType, filter: filter, page: page, limit: 20) { [weak self] result in
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
                    self.delegate?.updateTopMangaListSucess()
                case .failure(let error):
                    self.delegate?.updateTopMangaListFailue(error)
                }
            }
        }
    }
    
    func getNexPageMangaListIfNeed() {
        if hasNextPage {
            let nextPage = currentPage + 1
            getTopMangaList(page: nextPage)
        }
    }
    
}
