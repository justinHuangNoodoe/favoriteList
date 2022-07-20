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
    weak var delegate: TopListVCDelegate?
    
    private var viewModel: TopListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = TopListViewModel(delegate: self)
        viewModel?.getTopMangaList(page: 0)
    }
    
    private func setupUI() {
        listTableView.register(ListItemTableViewCell.loadNib(), forCellReuseIdentifier: ListItemTableViewCell.identifier)
        listTableView.delegate = self
        listTableView.dataSource = self
    }
}

extension TopListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.topList.count ?? 0
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
        
    }
}
