//
//  ViewController.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/19.
//

import UIKit

protocol TopListVCDelegate: AnyObject {}

class TopListViewController: UIViewController, Loadable {
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchFilterSeqmentedControl: UISegmentedControl!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var noResultView: UIView!
    weak var delegate: TopListVCDelegate?
    
    private var viewModel: TopListViewModel?
    private var debounce: Debounce?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debounce = Debounce(interval: 0.5)
        viewModel = TopListViewModel(injection: .manga, delegate: self)
        setupUI()
        viewModel?.getTopList(page: 0)
    }
    
    private func reset(injection: TopListInjection) {
        viewModel?.injection = injection
        setupUI()
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
        typeSegmentedControl.removeAllSegments()
        TopListInjection.allCases.forEach { type in
            typeSegmentedControl.insertSegment(withTitle: type.text, at: type.index, animated: false)
        }
        
        searchTypeSegmentedControl.setTitleTextAttributes(attributes, for: .normal)
        searchTypeSegmentedControl.removeAllSegments()
        viewModel?.injection.searchTypeElements.forEach { type in
            searchTypeSegmentedControl.insertSegment(withTitle: type.text, at: type.index, animated: false)
        }
        searchFilterSeqmentedControl.removeAllSegments()
        searchFilterSeqmentedControl.setTitleTextAttributes(attributes, for: .normal)
        viewModel?.injection.searchFilterElements.forEach { filter in
            searchFilterSeqmentedControl.insertSegment(withTitle: filter.text, at: filter.index, animated: false)
        }
        typeSegmentedControl.selectedSegmentIndex = viewModel?.injection.index ?? 0
        searchTypeSegmentedControl.selectedSegmentIndex = -1
        searchFilterSeqmentedControl.selectedSegmentIndex = -1
    }
    
    func showNoResult(_ shown: Bool) {
        shown ?
            self.view.bringSubviewToFront(noResultView) :
            self.view.bringSubviewToFront(listTableView)
    }
    
    @IBAction func typeSegmentedDidChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let injection = TopListInjection(rawValue: index) ?? .manga
        debounce?.execute { [weak self] in
            self?.reset(injection: injection)
        }
    }
    
    @IBAction func searchTypeSegmentedDidChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        debounce?.execute { [weak self] in
            self?.viewModel?.setSearchType(index)
            self?.viewModel?.reset()
        }
    }
    
    @IBAction func searchFilterSeqmentedDidChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        debounce?.execute { [weak self] in
            self?.viewModel?.setSearchFilter(index)
            self?.viewModel?.reset()
        }
    }
}

extension TopListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel?.topList.count ?? 0
        showNoResult(count == 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ListItemTableViewCell
        let item = viewModel?.topList[indexPath.row]
        if let url = item?.images[TopListItemImageType.jpg.rawValue]?.image {
            cell.coverImageView?.downloadImage(from: url)
        }
        cell.titleLabel.text = item?.title
        cell.rankLabel.text = item?.rank?.description
        cell.startDateLabel.text = item?.published?.from?.date(.yyyyMMddTHHmmssZ)?.dateFormat(.yyyyMd)
        cell.endDateLabel.text = item?.aired?.to?.date(.yyyyMMddTHHmmssZ)?.dateFormat(.yyyyMd)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let didScrollHeight = scrollView.contentOffset.y + scrollView.visibleSize.height
        if didScrollHeight > scrollView.contentSize.height {
            viewModel?.getNexPageListIfNeed()
        }
    }
}

extension TopListViewController: TopListVMDelegate {
    func updateTopListSucess() {
        listTableView.reloadData()
    }
    
    func updateTopListFailue(_ error: Error) {
        print(error)
    }
}
