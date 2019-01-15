//
//  MDCategoryDetailCollectionViewCell.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 3. 20..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit
import Kingfisher

class MDCategoryDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var viewModel : MDDetailCategoryCellViewModel? {
        didSet{
            display()
        }
    }
    
    private func display(){
        do {

            content.text = viewModel?.description
            nicknameLabel.text = viewModel?.name
            likeCount.text = String((viewModel?.like_count)!)
            replyCount.text = String((viewModel?.comment_count)!)
            backgroundImg.kf.setImage(with: (viewModel?.image_url)!)
        } catch  {
        }
    }

}
