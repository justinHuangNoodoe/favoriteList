//
//  ListItemTableViewCell.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import UIKit

protocol ListItemCellDelegate: AnyObject {
    func didTappedFavoriteButton(cell: ListItemTableViewCell)
}

class ListItemTableViewCell: UITableViewCell, Loadable {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankTitleLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var startDateTitleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateTitleLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: ListItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        rankTitleLabel.text = "排名"
        startDateTitleLabel.text = "上架時間"
        endDateTitleLabel.text = "下架時間"
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func tapFavoriteButton(_ sender: UIButton) {
        favoriteButton.isSelected = !sender.isSelected
        delegate?.didTappedFavoriteButton(cell: self)
    }
    
}
