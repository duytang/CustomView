//
//  ArrowMenuCell.swift
//  Blank
//
//  Created by Dii on 5/3/25.
//


import UIKit

final class ArrowMenuCell: UITableViewCell {
    
    private var viewModel: ArrowMenuViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    fileprivate lazy var config = ArrowMenuConfiguration()
    fileprivate lazy var iconImageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        return imageView
    }()
    
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .clear
        label.font = AppTheme.Font.smallMedium
        contentView.addSubview(label)
        return label
    }()
    
    func bindData(_ viewModel: ArrowMenuViewModel) {
        selectionStyle = .none
        self.viewModel = viewModel
        self.backgroundColor = .clear
        
        if var iconImage: UIImage = UIImage(named: viewModel.imageName ?? "") {
            if  config.ignoreImageOriginalColor {
                iconImage = iconImage.withRenderingMode(.alwaysTemplate)
            }
            iconImageView.tintColor = config.textColor
            iconImageView.frame =  CGRect(x: config.padding, y: (config.menuRowHeight - config.iconSize)/2,
                                          width: config.iconSize, height: config.iconSize)
            iconImageView.image = iconImage
            nameLabel.frame = CGRect(x: config.padding * 2 + config.iconSize,
                                     y: (config.menuRowHeight - config.iconSize)/2,
                                     width: (config.menuWidth - config.iconSize - config.padding * 3),
                                     height: config.iconSize)
        } else {
            nameLabel.frame = CGRect(x: config.padding, y: 0,
                                     width: config.menuWidth - config.padding * 2,
                                     height: config.menuRowHeight)
        }
        
        nameLabel.font = config.textFont
        nameLabel.textColor = config.textColor
        nameLabel.textAlignment = config.textAlignment
        nameLabel.text = viewModel.title
    }
}
