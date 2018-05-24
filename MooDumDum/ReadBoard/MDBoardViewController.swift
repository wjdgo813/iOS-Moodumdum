//
//  MDBoardViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 3. 20..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Gifu
import Toaster


class MDBoardViewController: UIViewController ,UIGestureRecognizerDelegate{

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var commentBackForX: UIView!
    
    
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var likeMotionView: UIView!
    
    @IBOutlet weak var movePetalView: UIView!
    @IBOutlet weak var moveFlowerView: UIView!
    @IBOutlet weak var moveTextView: UIView!
    @IBOutlet weak var flowerTextLabel: UILabel!
    
    var motionPetalImageView : GIFImageView!
    var motionFlowerImageView : GIFImageView!
    
    var likeMotionImageView: GIFImageView!
    
    var prevView : UIView?
    var data : MDDetailCategoryData?
    var pullUpController : MDCommentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyBoardAddGesture()
        
        backgroundImageView.kf.setImage(with: data?.image_url)
        content.text = data?.description
        content.textColor = UIColor(hexString:(data?.color)!)
        
        
        initMotionView()
        
        let gradient = CAGradientLayer()
        gradient.frame = self.gradientView.bounds
        gradient.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
        self.gradientView.layer.insertSublayer(gradient, at: 0)
        self.gradientView.alpha = 0.5
        
        
        drawSendCommentView()
        initNavigationBar()
        requestBoardInfo()
        registerNotification()
        tapGestureAdd()
    }
    
    
    
    
    func initNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    
    
    func drawSendCommentView(){
        inputTextView.delegate = self
        inputTextView.text = "가까운 영혼에게 위로 한 마디.."
        inputTextView.textColor = UIColor(hexString: "#979797")
        
        sendButton.layer.borderColor = UIColor(hexString: "#979797").cgColor
        sendButton.layer.borderWidth = 0.5
        sendButton.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    
    func tapGestureAdd(){
        let doubleTapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(recognizer:)))
        doubleTapGestureRecog.numberOfTapsRequired = 2;
        doubleTapGestureRecog.delegate = self
        self.view.addGestureRecognizer(doubleTapGestureRecog)
    }
    
    
    
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector:  #selector(onUIKeyboardWillShowNotification(noti:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUIKeyboardWillHideNotification(noti:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    
    
    private func addPullUpController() {
        pullUpController = UIStoryboard(name: "Board", bundle: nil)
                   .instantiateViewController(withIdentifier: "MDCommentViewController") as? MDCommentViewController
        
        pullUpController?.data = data
        pullUpController?.delegate = self
        addPullUpController(pullUpController!)
        self.view.bringSubview(toFront: self.commentView)
        self.view.bringSubview(toFront: self.commentBackForX)
        self.view.bringSubview(toFront: self.likeMotionView)
        pullUpController?.tableView.isScrollEnabled = false;
    }
    
    
    
    
    func requestBoardInfo(){
        if let boardId = data?.id {
            MDAPIManager.sharedManager.requestBoardInfo(boardId: boardId) { (result) -> (Void) in
                self.data = nil
                self.data = MDDetailCategoryData(rawJson: result)
                
                guard self.pullUpController == nil else{return}
                self.addPullUpController()
            }
        }
    }
    
    
    
    
    
    func refreshPrevInfo(boardData:MDDetailCategoryData){
        if self.prevView is DraggableView {
            let view = self.prevView as? DraggableView
            view?.likeCount.text = "\(boardData.like_count)"
            if boardData.is_liked {
                view?.likeButton.setImage(UIImage(named: "afterLikeButton"), for: .normal)
            }else{
                view?.likeButton.setImage(UIImage(named: "beforeLikeButton"), for: .normal)
            }
            
            view?.commentCount.text = "\(boardData.comment_counnt)"
        }else if self.prevView is MDCategoryDetailCollectionViewCell{
            let view = self.prevView as? MDCategoryDetailCollectionViewCell
            view?.likeCount.text = "\(boardData.like_count)"
            view?.replyCount.text = "\(boardData.comment_counnt)"
        }
        requestBoardInfo()
    }
    
    
    
    
    @objc func handleDoubleTapGesture(recognizer : UITapGestureRecognizer){
        pressedLikeButton(boardData: data!)
    }
    
    
    
    
    @objc func onUIKeyboardWillShowNotification(noti : Notification){
        
        if let keyboardFrame: NSValue = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if MDDeviceInfo.isIphoneX() {
                self.commentViewBottom.constant = -keyboardHeight + 33
            }else{
                self.commentViewBottom.constant = -keyboardHeight
            }
        }
    }
    
    
    

    @objc func onUIKeyboardWillHideNotification(noti : Notification){
        self.commentViewBottom.constant = 0
    }
    
    
    func initMotionView(){
        
        likeMotionView.isHidden = true

        
        movePetalView.isHidden = true
        motionPetalImageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: self.movePetalView.frame.width, height: self.movePetalView.frame.height))
        movePetalView.addSubview(motionPetalImageView)
        motionPetalImageView.isHidden = true
        motionPetalImageView.alpha = 0
        
        
        moveFlowerView.isHidden = true
        motionFlowerImageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: self.moveFlowerView.frame.width, height: self.moveFlowerView.frame.height))
        moveFlowerView.addSubview(motionFlowerImageView)
        motionFlowerImageView.isHidden = true
        motionFlowerImageView.alpha = 0
        
        flowerTextLabel.isHidden = true
        flowerTextLabel.alpha = 0
        
        
    }
    
    
    
    @IBAction func pressedSendButton(_ sender: Any) {
        
        if inputTextView.textColor == UIColor(hexString: "#979797") ||
           inputTextView.text.count == 0 {
            //텍스트가 없을 때
            return
        }
        
        
        let parameters: Parameters = [
            "board_id": data?.id ?? "",
            "name":UserDefaults.standard.string(forKey: "nickname") ?? "",
            "description":inputTextView.text!
        ]
        var boardData = self.data
        let commentCount = boardData?.comment_counnt
        
        MDAPIManager.sharedManager.requestRegisterReply(parameters: parameters) { (result) -> (Void) in
            self.pullUpController?.requestCommentInfo()
            
            boardData?.comment_counnt = commentCount! + 1
            self.refreshPrevInfo(boardData: boardData!)
            
            Toast(text: "댓글이 등록되었습니다.", duration: Delay.long).show()

        }
        
        inputTextView.textColor = UIColor(hexString: "#979797")
        inputTextView.text = "가까운 영혼에게 위로 한 마디.."
        inputTextView.resignFirstResponder()
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}


extension MDBoardViewController : MDCommentViewControllerDelegate{
    func pressedLikeButton(boardData:MDDetailCategoryData){
        
        var boardData = boardData
        animateLikeMotion()
        
        guard !(boardData.is_liked) else {return}
        
        let likeCount = boardData.like_count
        let parameters: Parameters = [
            "board_id": data!.id,
            "user":MDDeviceInfo.getCurrentDeviceID(),
            ]
        
        MDAPIManager.sharedManager.reqeustBoardLike(parameters: parameters) { result -> (Void) in
            boardData.like_count = likeCount + 1
            boardData.is_liked = true
            self.refreshPrevInfo(boardData: boardData)
            
            self.pullUpController?.data?.like_count = boardData.like_count
            self.pullUpController?.data?.is_liked = true
            self.pullUpController?.tableView.reloadData()
        }
    }
    
    func removeLike(boardData:MDDetailCategoryData){
        var boardData = boardData
        
        guard boardData.is_liked else {return}
        let likeCount = boardData.like_count
        
        MDAPIManager.sharedManager.requestRemoveLike(boardID: (data?.id)!) { (result) -> (Void) in
            boardData.like_count = likeCount - 1
            boardData.is_liked = false
            self.refreshPrevInfo(boardData: boardData)
            
            self.pullUpController?.data?.like_count = boardData.like_count
            self.pullUpController?.data?.is_liked = false
            self.pullUpController?.tableView.reloadData()
        }
    }
    
    func animateLikeMotion(){
        if  self.motionFlowerImageView.isAnimatingGIF ||
            self.motionPetalImageView.isAnimatingGIF { return }
        
        self.likeMotionView.isHidden = false
        self.likeMotionView.bringSubview(toFront: self.movePetalView)
        self.likeMotionView.bringSubview(toFront: self.moveFlowerView)
        self.likeMotionView.bringSubview(toFront: self.flowerTextLabel)
        
        self.movePetalView.bringSubview(toFront: self.motionPetalImageView)
        self.movePetalView.bringSubview(toFront: self.motionPetalImageView)
        
        self.movePetalView.isHidden = false
        self.motionPetalImageView.isHidden = false
        self.motionPetalImageView.alpha = 1
        self.motionPetalImageView.animate(withGIFNamed: "movePetal.gif", loopCount: 1, completionHandler: {
            print("success")
        })
        
        self.moveFlowerView.isHidden = false
        self.motionFlowerImageView.isHidden = false
        self.motionFlowerImageView.alpha = 1
        self.motionFlowerImageView.animate(withGIFNamed: "moveFlower", loopCount: 1, completionHandler: nil)
        
        self.flowerTextLabel.isHidden = false
        self.flowerTextLabel.alpha = 1

        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.7, execute: {            
            UIView.animate(withDuration: 0.3, animations: {
                self.motionPetalImageView.stopAnimatingGIF()
                self.motionFlowerImageView.stopAnimatingGIF()
                

                self.motionPetalImageView.alpha = 0
                self.motionFlowerImageView.alpha = 0
                self.flowerTextLabel.alpha = 0
                
            }, completion: { (result) in
                self.motionPetalImageView.isHidden = true
                self.motionFlowerImageView.isHidden = true
                
                self.movePetalView.isHidden = true;
                self.moveFlowerView.isHidden = true;
                
                self.flowerTextLabel.isHidden = true;
                self.likeMotionView.isHidden = true
            })
        })
    }
}

extension MDBoardViewController : UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.textColor == UIColor(hexString: "#979797") {
            textView.text = ""
            textView.textColor = UIColor.white
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if(textView.text.count == 0){
            textView.textColor = UIColor(hexString: "#979797")
            textView.text = "가까운 영혼에게 위로 한 마디.."
        }
        return true;
    }
}
