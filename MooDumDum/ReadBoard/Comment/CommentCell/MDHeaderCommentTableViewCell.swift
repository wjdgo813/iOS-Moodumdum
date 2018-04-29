//
//  MDHeaderCommentTableViewCell.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 3. 21..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

protocol MDHeaderCommentTableViewCellDelegate {
    func pressedBoardLikeButton(cell: MDHeaderCommentTableViewCell)
}

class MDHeaderCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    var delegate : MDHeaderCommentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pressedLikeButton(_ sender: Any) {
        delegate?.pressedBoardLikeButton(cell: self)
    }
}
