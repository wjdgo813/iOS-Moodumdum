//
//  MDWirteCategorySlideCell.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 5. 1..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MDWirteCategorySlideCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    var slideCollectionView : MDWriteSlideCollectionViewController?
    var pressedCategoryButton: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryButton.layer.cornerRadius = 5.0
    }
    @IBAction func pressedCategoryButton(_ sender: Any) {
        if pressedCategoryButton != nil{
            pressedCategoryButton!()
        }
    }
    
}
