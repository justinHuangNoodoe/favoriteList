//
//  ViewController.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/19.
//

import UIKit

protocol TopListVCDelegate: AnyObject {}

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
        if let url = item.images[TopListItemImageType.jpg.rawValue]?.image {
            cell.coverImageView?.downloadImage(from: url)
        }
        cell.titleLabel.text = item.title
        cell.rankLabel.text = item.rank?.description
        cell.startDateLabel.text = item.published?.from?.date(.yyyyMMddTHHmmssZ)?.dateFormat(.yyyyMd)
        cell.endDateLabel.text = item.aired?.to?.date(.yyyyMMddTHHmmssZ)?.dateFormat(.yyyyMd)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let didScrollHeight = scrollView.contentOffset.y + scrollView.visibleSize.height
        if didScrollHeight > scrollView.contentSize.height, viewModel.hasNextPage {
            getTopList()
        }
    }
}

extension TopListViewController: TopListVMDelegate {
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
        if let index = listTableView.indexPath(for: cell) {
            viewModel.saveFavoritItems(index.row)
        }
    }
}
