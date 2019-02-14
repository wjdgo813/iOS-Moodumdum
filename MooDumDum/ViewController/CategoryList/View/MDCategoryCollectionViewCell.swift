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
        guard let viewModel = viewModel else {
            return
        }
        
        backgroundImageView.cacheSetImage(url: viewModel.background_url)
        titleImageView.cacheSetImage(url: viewModel.image_url)
    }
}
