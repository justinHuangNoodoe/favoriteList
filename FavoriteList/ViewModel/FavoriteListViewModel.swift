//
//  FavoriteListViewModel.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/22.
//

import Foundation

protocol FavoriteListVMDelegate: AnyObject {
    func updateFavoriteItemsFinished()
}

class FavoriteListViewModel {
    
    private weak var delegate: FavoriteListVMDelegate?
    private(set) var topList: [TopListItem]
    
    var shouldShownEmptyBackgroundView: Bool {
        return topList.isEmpty
    }
    
    init(delegate: FavoriteListVMDelegate?) {
        self.delegate = delegate
        topList = []
    }

    func fetchFavoritItems() {
        topList = Array(FavoriteItemManager.shared.favoriteItems)
        delegate?.updateFavoriteItemsFinished()
    }
    
    func removeFavoriteItem(_ index: Int) {
        let item = topList[index]
        topList.remove(at: index)
        FavoriteItemManager.shared.favoriteItems.remove(item)
    }
}
