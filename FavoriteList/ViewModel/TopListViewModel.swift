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
    
    weak var delegate: TopListVMDelegate?
    
    var topList: [TopListItem]
    
    init(delegate: TopListVMDelegate?) {
        self.delegate = delegate
        topList = []
    }
    
    func getTopMangaList(type: MangaType? = nil, filter: TopListItemFilter? = nil) {
        TopListService.getTopMangaList(type: type, filter: filter, page: 10, limit: 10) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self.topList = list.data
                    self.delegate?.updateTopMangaListSucess(self.topList)
                case .failure(let error):
                    self.delegate?.updateTopMangaListFailue(error)
                }
            }
        }
    }
    
}
