//
//  MDCommentTableViewCell.swift
//  MooDumDum
//
//  Created by JHH on 2018. 3. 21..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit
import Alamofire
import SwipeCellKit

protocol MDCommentTableViewCellDelegate {
    func pressedCommentLikeButton(cell: MDCommentTableViewCell,data:MDCommentItem)
}

class MDCommentTableViewCell: SwipeTableViewCell {

    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var nickname: UILabel!
    var cellDelegate : MDCommentTableViewCellDelegate?
    
    var commentData : MDCommentItem?{
        didSet{
            set()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(){
        content.text = commentData?.description
        nickname.text = commentData?.userObject?.name
        commentCountLabel.text = "공감 \((self.commentData?.like_count)!)개"
        
        if (self.commentData?.is_liked)!{
            likeButton.setImage(UIImage(named: "afterLikeButton"), for: .normal)
        }else{
            likeButton.setImage(UIImage(named: "beforeLikeButton"), for: .normal)
        }
    }
    
    @IBAction func pressedLikeButton(_ sender: Any) {
        
        self.cellDelegate?.pressedCommentLikeButton(cell:self ,data:commentData!)
    }
}
