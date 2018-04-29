//
//  MDCategoryCollectionViewCell.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 2. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MDCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleImageView: UIImageView!
    
    var onTouchedUser: (()->Void)?
    var viewModel : MDCategoryCellViewModel? {
        didSet{
            display()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func display(){
        do {
            backgroundImageView.kf.setImage(with: viewModel?.background_url)
            titleImageView.kf.setImage(with: viewModel?.image_url)
        } catch  {
        }
    }
}
