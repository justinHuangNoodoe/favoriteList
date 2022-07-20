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
    @IBOutlet weak var filterSeqmentedControl: UISegmentedControl!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var noResultView: UIView!
    weak var delegate: TopListVCDelegate?
    
    private var viewModel: TopListViewModel?
    private var debounce: Debounce?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        debounce = Debounce(interval: 0.5)
        viewModel = TopListViewModel(delegate: self)
        viewModel?.getTopMangaList(page: 0)
    }
    
    private func setupUI() {
        listTableView.register(ListItemTableViewCell.loadNib(), forCellReuseIdentifier: ListItemTableViewCell.identifier)
        listTableView.delegate = self
        listTableView.dataSource = self
        let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 9)
        ]
        typeSegmentedControl.setTitleTextAttributes(attributes, for: .normal)
        typeSegmentedControl.removeAllSegments()
        MangaType.allCases.forEach { type in
            typeSegmentedControl.insertSegment(withTitle: type.text, at: type.rawValue, animated: false)
        }
        filterSeqmentedControl.removeAllSegments()
        filterSeqmentedControl.setTitleTextAttributes(attributes, for: .normal)
        MangaFilter.allCases.forEach { filter in
            filterSeqmentedControl.insertSegment(withTitle: filter.text, at: filter.rawValue, animated: false)
        }
        typeSegmentedControl.selectedSegmentIndex = -1
        filterSeqmentedControl.selectedSegmentIndex = -1
    }
    
    func showNoResult(_ shown: Bool) {
        shown ?
            self.view.bringSubviewToFront(noResultView) :
            self.view.bringSubviewToFront(listTableView)
    }
    
    @IBAction func typeSegmentedDidChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        viewModel?.mangaType = MangaType(rawValue: index)
        debounce?.execute { [weak self] in
            self?.viewModel?.reset()
        }
    }
    
    @IBAction func filterSeqmentedDidChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        viewModel?.filter = MangaFilter(rawValue: index)
        debounce?.execute { [weak self] in
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
            viewModel?.getNexPageMangaListIfNeed()
        }
    }
}

extension TopListViewController: TopListVMDelegate {
    func updateTopMangaListSucess() {
        listTableView.reloadData()
    }
    
    func updateTopMangaListFailue(_ error: Error) {
        print(error)
    }
}
