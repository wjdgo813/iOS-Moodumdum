//
//  MDDeveloperTableViewCell.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 7. 11..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MDDeveloperTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    init(style: UITableViewCellStyle, reuseIdentifier: String?, name: String, email : String) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
