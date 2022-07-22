//
//  ViewController.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/19.
//

import UIKit

protocol TopListVCDelegate: AnyObject {
    func openWebPage(url: String)
}

class TopListViewController: UIViewController, Loadable, LoadingProtocol {
    var loadingView: LoadingView = LoadingView()
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchFilterSeqmentedControl: UISegmentedControl!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var noResultView: UIView!
    weak var delegate: TopListVCDelegate?
    
    private lazy var viewModel: TopListViewModel = TopListViewModel(injection: .manga, delegate: self)
    private var debounce: Debounce?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debounce = Debounce(interval: 0.5)
        setupUI()
        getTopList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getFavoriteIds()
    }
    
    private func setupUI() {
        listTableView.register(ListItemTableViewCell.loadNib(), forCellReuseIdentifier: ListItemTableViewCell.identifier)
        listTableView.delegate = self
        listTableView.dataSource = self
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 9)
        ]
        
        typeSegmentedControl.setTitleTextAttributes(attributes, for: .normal)
        typeSegmentedControl.setSegments(TopListInjection.allCases, animated: false)
        
        searchTypeSegmentedControl.setTitleTextAttributes(attributes, for: .normal)
        searchTypeSegmentedControl.setSegments(viewModel.injection.searchTypeElements, animated: false)
        
        searchFilterSeqmentedControl.setTitleTextAttributes(attributes, for: .normal)
        searchFilterSeqmentedControl.setSegments(viewModel.injection.searchFilterElements, animated: false)
        
        typeSegmentedControl.selectedSegmentIndex = viewModel.injection.index
        searchTypeSegmentedControl.selectedNonSegment()
        searchFilterSeqmentedControl.selectedNonSegment()
    }
    
    private func showNoResultIfNeed() {
        viewModel.shouldShownEmptyBackgroundView ?
            self.view.bringSubviewToFront(noResultView) :
            self.view.bringSubviewToFront(listTableView)
    }
    
    private func getTopList() {
        showLoadingView()
        viewModel.getTopList()
    }
    
    @IBAction func typeSegmentedDidChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let injection = TopListInjection(rawValue: index) ?? .manga
        viewModel.injection = injection
        setupSegmentedControl()
        debounce?.execute { [weak self] in
            self?.getTopList()
        }
    }
    
    @IBAction func searchTypeSegmentedDidChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        viewModel.setSearchType(index)
        debounce?.execute { [weak self] in
            self?.getTopList()
        }
    }
    
    @IBAction func searchFilterSeqmentedDidChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        viewModel.setSearchFilter(index)
        debounce?.execute { [weak self] in
            self?.getTopList()
        }
    }
}

extension TopListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.topList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ListItemTableViewCell
        let item = viewModel.topList[indexPath.row]
        if let imageUrl = item.images?[TopListItemImageType.jpg.rawValue]?.image {
            cell.coverImageView?.downloadImage(from: imageUrl)
        }
        cell.titleLabel.text = item.title
        cell.rankLabel.text = item.rank?.description
        cell.startDateLabel.text = item.published?.from?.date(.yyyyMMddTHHmmssZ)?.dateFormat(.yyyyMd)
        cell.endDateLabel.text = item.aired?.to?.date(.yyyyMMddTHHmmssZ)?.dateFormat(.yyyyMd)
        cell.favoriteButton.isSelected = viewModel.isFavorite(item.id)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.topList[indexPath.row]
        guard let url = item.url else { return }
        delegate?.openWebPage(url: url)
        listTableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let didScrollHeight = scrollView.contentOffset.y + scrollView.visibleSize.height
        if didScrollHeight > scrollView.contentSize.height, viewModel.hasNextPage {
            getTopList()
        }
    }
}

extension TopListViewController: TopListVMDelegate {
    func updateFavoriteItemsFinished() {
        listTableView.reloadData()
    }
    
    func updateTopListSucess() {
        hideLoadingView()
        showNoResultIfNeed()
        listTableView.reloadData()
    }
    
    func updateTopListFailue(_ error: Error) {
        hideLoadingView()
        showNoResultIfNeed()
        print(error)
    }
}

extension TopListViewController: ListItemCellDelegate {
    func didTappedFavoriteButton(cell: ListItemTableViewCell) {
        guard let index = listTableView.indexPath(for: cell) else { return }
        viewModel.updateFavoritItems(index.row, isFavorite: cell.favoriteButton.isSelected)
        listTableView.reloadRows(at: [index], with: .none)
    }
}
