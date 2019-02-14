//
//  MDCommentViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 3. 20..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwipeCellKit
//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

protocol MDCommentViewControllerDelegate {
    func pressedLikeButton(boardData : MDDetailCategoryData)
    func removeLike(boardData:MDDetailCategoryData)
}

enum MDCommentState {
    case notYet
    case empty
    case haveList
}

class MDCommentViewController: MDPullUpController {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate : MDCommentViewControllerDelegate!
    var data : MDDetailCategoryData?
    var commentItem : MDCommentInfoSet?
    var isMoreLoading = false
    var commentState : MDCommentState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle =  UITableViewCellSeparatorStyle.none
        commentState = .notYet
        self.registerCell()
        self.requestCommentInfo()
        
        
        self.willMoveToStickyPoint = { point in
            print("willMoveToStickyPoint \(point)")
        }
        
        self.didMoveToStickyPoint = { point in
            print("didMoveToStickyPoint \(point)")
            self.tableView.isScrollEnabled = true;
        }
        self.setupTapGestureRecognizer()
    }
    

    
    func requestCommentInfo(){
        guard let data = data else { return }
        
        MDAPIManager.sharedManager.requestCommentInfo(commentId: data.id) { result -> (Void) in
            
            self.commentItem = nil
            self.commentItem = MDCommentInfoSet(rawJson: result)
            
            guard let commentItem = self.commentItem else { return }
            if commentItem.count ?? 0 > 0{
                self.commentState = .haveList
            }else{
                self.commentState = .empty
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    func requestMoreCommentInfo(){
        guard var commentItem = self.commentItem else { return }
        
        Alamofire.request((self.commentItem?.nextURL)!).responseJSON { response in
            let json = JSON(response.result.value)
            
            commentItem.loadMore(rawJson:json)
            self.tableView.reloadData()
            self.isMoreLoading = false
        }
    }
    
    func registerCell(){
        self.tableView.register(UINib.init(nibName:"MDCommentTableViewCell",bundle:nil), forCellReuseIdentifier: "MDCommentTableViewCell")
        self.tableView.register(UINib.init(nibName:"MDHeaderCommentTableViewCell",bundle:nil), forCellReuseIdentifier: "MDHeaderCommentTableViewCell")
        self.tableView.register(UINib.init(nibName:"MDCommentEmptyCell",bundle:nil), forCellReuseIdentifier: "MDCommentEmptyCell")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= 0){
            self.tableView.isScrollEnabled = false
            super.setupPanGestureRecognizer()
        }
        
        if isMoreLoading == false {
            let scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y
            if scrollPosition > 0 && scrollPosition < scrollView.contentSize.height*0.2{
                requestMoreCommentInfo()
                print("called!!!!!")
                self.isMoreLoading = true
            }
        }
    }
    
    @objc func reload(){
        DispatchQueue.main.async {
            self.tableView?.reloadData()
            self.isMoreLoading = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //MARK: overide PullUpController
    override var pullUpControllerPreferredSize: CGSize {
        guard let navigationController = self.navigationController else {
            return CGSize.zero
        }
        
        var differ : CGFloat = 20
        if MDDeviceInfo.isIphoneX(){
            differ = 45
        }
        
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - navigationController.navigationBar.frame.height - differ)
        
    }
    override func handleSingTapGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        UIView.animate(withDuration: 2, delay: 0.3, options: UIViewAnimationOptions.curveLinear, animations: {
            
            if MDDeviceInfo.isIphoneX() {
                self.topConstraint?.constant = (self.navigationController?.navigationBar.frame.height)! + 45
            }else{
                self.topConstraint?.constant = (self.navigationController?.navigationBar.frame.height)! + 20
            }
            
            self.view.layoutIfNeeded()
        }) {result in
            
        }
        
    }
    
    override var pullUpControllerPreviewOffset: CGFloat {
        return self.view.frame.height / 3
    }
    
    override var pullUpControllerIsBouncingEnabled: Bool {
        return false
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 5, y: 5, width: 280, height: UIScreen.main.bounds.height - 10)
    }
}

extension MDCommentViewController : MDCommentTableViewCellDelegate{
    func pressedCommentLikeButton(cell: MDCommentTableViewCell, data: MDCommentItem) {
        
        let parameters: Parameters = [
            "comment_id": (data.comment_id)!,
            "user":MDDeviceInfo.getCurrentDeviceID()
        ]
        
        Alamofire.request("http://13.125.76.112/api/board/comment/like/",method:.post,parameters:parameters).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result{
            case .success:
                
                let indexPath = self.tableView.indexPath(for: cell)
                var commentItemTemp = self.commentItem?.commentList[(indexPath?.row)! - 1]
                commentItemTemp?.is_liked = true
                commentItemTemp?.like_count = (self.commentItem?.commentList[(indexPath?.row)! - 1].like_count)! + 1
                self.commentItem?.commentList[(indexPath?.row)! - 1] = commentItemTemp!
                
                cell.commentData?.like_count = (cell.commentData?.like_count)! + 1
                cell.commentData?.is_liked = true
                cell.likeButton.setImage(UIImage(named: "afterLikeButton"), for: .normal)
                cell.commentCountLabel.text = "공감 \((cell.commentData?.like_count)!)개"
                break
            case .failure:
                break
            }
        }
    }
    
    func pressedCommentUnLikeButton(cell: MDCommentTableViewCell, data: MDCommentItem) {
        
        Alamofire.request("http://13.125.76.112/api/board/comment/like/\(MDDeviceInfo.getCurrentDeviceID())/\((data.comment_id)!)/",method:.delete).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result{
            case .success:
                
                let indexPath = self.tableView.indexPath(for: cell)
                var commentItemTemp = self.commentItem?.commentList[(indexPath?.row)! - 1]
                commentItemTemp?.is_liked = false
                commentItemTemp?.like_count = (self.commentItem?.commentList[(indexPath?.row)! - 1].like_count)! - 1
                self.commentItem?.commentList[(indexPath?.row)! - 1] = commentItemTemp!
                
                cell.commentData?.like_count = (cell.commentData?.like_count)! - 1
                cell.commentData?.is_liked = false
                cell.likeButton.setImage(UIImage(named: "beforeLikeButton"), for: .normal)
                cell.commentCountLabel.text = "공감 \((cell.commentData?.like_count)!)개"
                break
            case .failure:
                break
            }
        }
        
    }
}


extension MDCommentViewController : MDHeaderCommentTableViewCellDelegate{
    func pressedBoardLikeButton(cell: MDHeaderCommentTableViewCell) {
        guard delegate != nil,
            let data = data
        else {
            return
        }
        
        
        if !(data.is_liked) {
            self.delegate.pressedLikeButton(boardData: data)
        }else{
            self.delegate.removeLike(boardData: data)
        }
        
    }
}


extension MDCommentViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hit the cell!!")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 38
        }
        
        if commentState == .haveList {
            return UITableViewAutomaticDimension
        }
        
        return 175
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 38
        }
        
        if commentState == .haveList {
            return 100
        }
        return 175
        
        
    }
}


extension MDCommentViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let item = self.commentItem {
            if self.commentState == .haveList{
                return item.count!+1
            }else{
                return 2
            }
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MDHeaderCommentTableViewCell") as? MDHeaderCommentTableViewCell
            cell?.commentCount.text = "\((self.commentItem?.totalCount)!)"
            cell?.likeCount.text = "\((self.data?.like_count)!)"
            cell?.delegate = self
            
            if (data?.is_liked)! {
                cell?.likeButton.setImage(UIImage(named: "afterLikeButton"), for: .normal)
            }else{
                cell?.likeButton.setImage(UIImage(named: "beforeLikeButton"), for: .normal)
            }
            
            return cell!
        }
        
        if commentState == .empty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MDCommentEmptyCell") as? MDCommentEmptyCell
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MDCommentTableViewCell") as? MDCommentTableViewCell
        cell?.commentData = self.commentItem?.commentList[indexPath.row-1]
        cell?.cellDelegate = self
        
        if commentItem?.commentList[indexPath.row-1].userObject?.UUID == MDDeviceInfo.getCurrentDeviceID() {
            cell?.delegate = self
        }
        
        return cell!
    }
}

extension MDCommentViewController : SwipeTableViewCellDelegate{

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            MDAPIManager.sharedManager.deleteComment(commentId: (self.commentItem?.commentList[indexPath.row-1].comment_id)!, completion: { (result) -> (Void) in
                self.requestCommentInfo()
            })
        }
        
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
}
