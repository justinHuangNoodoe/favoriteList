//
//  FavoriteLists.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/19.
//

import UIKit

protocol FavoriteListsVCDelegate: AnyObject {}

class FavoriteListsViewController: UIViewController, Loadable {
    @IBOutlet weak var emptyBackgroundView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    weak var delegate: FavoriteListVCDelegate?

    private lazy var viewModel: FavoriteListViewModel = FavoriteListViewModel(delegate: self)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchFavoritItems()
    }
    
    private func setupUI() {
        listTableView.register(ListItemTableViewCell.loadNib(), forCellReuseIdentifier: ListItemTableViewCell.identifier)
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
    private func showNoResultIfNeed() {
        let topLevelView: UIView = viewModel.shouldShownEmptyBackgroundView ? emptyBackgroundView : listTableView
        self.view.bringSubviewToFront(topLevelView)
    }
}

extension FavoriteListsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showNoResultIfNeed()
        return viewModel.topList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ListItemTableViewCell
        let item = viewModel.topList[indexPath.row]
        if let url = item.images?[TopListItemImageType.jpg.rawValue]?.image {
            cell.coverImageView?.downloadImage(from: url)
        }
        cell.titleLabel.text = item.title
        cell.rankLabel.text = item.rank?.description
        cell.startDateLabel.text = item.published?.from?.date(.yyyyMMddTHHmmssZ)?.dateFormat(.yyyyMd)
        cell.endDateLabel.text = item.aired?.to?.date(.yyyyMMddTHHmmssZ)?.dateFormat(.yyyyMd)
        cell.favoriteButton.isSelected = true
        cell.delegate = self
        return cell
    }
}

extension FavoriteListsViewController: FavoriteListVMDelegate {
    func updateFavoriteItemsFinished() {
        listTableView.reloadData()
    }
}

extension FavoriteListsViewController: ListItemCellDelegate {
    func didTappedFavoriteButton(cell: ListItemTableViewCell) {
        guard let index = listTableView.indexPath(for: cell) else { return }
        viewModel.removeFavoriteItem(index.row)
        listTableView.deleteRows(at: [index], with: .right)
    }
}
