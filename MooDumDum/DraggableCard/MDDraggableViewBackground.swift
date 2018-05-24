//
//  DraggableViewBackground.swift
//  SwiftTinderCards
//
//  Created by Lukasz Gandecki on 3/23/15.
//  Copyright (c) 2015 Lukasz Gandecki. All rights reserved.
//

import Foundation
import UIKit

import Alamofire
import Gifu
import SwiftyJSON

protocol  MDDraggableViewBackgroundDelegate:class {
    func pressedCardView(draggableView:DraggableView,data:MDDetailCategoryData)
    func completeCreateCard()
}

class MDDraggableViewBackground: UIView, DraggableViewDelegate,UIGestureRecognizerDelegate {
    
    func cardSwiped(_ card: UIView!) {
        processCardSwipe()
    }
    
    
    let MAX_BUFFER_SIZE = 2;
    let CARD_HEIGHT = CGFloat(386.0);
    let CARD_WIDTH = CGFloat(290.0);
    
    let menuButton = UIButton()
    let messageButton = UIButton()
    let checkButton = UIButton()
    let xButton = UIButton()
    
    let exampleCardLabels = ["first", "second", "third", "fourth", "last"]
    var loadedCards = NSMutableArray()
    var allCards =  NSMutableArray()
    var cardsLoadedIndex = 0
    var numLoadedCardsCap = 0
    var nextURL : String?
    
    weak var delegate : MDDraggableViewBackgroundDelegate!
    lazy var model = MDDraggableModel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        setupView()
        setLoadedCardsCap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveCardInfo(noti:)), name: Notification.Name.DraggableModel.changedLists, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveCardMoreInfo(noti:)), name: Notification.Name.DraggableMoreModel.changedLists, object: nil)
        
        self.model.loadCard()
        
        
    }
    
    func setupView() {
        setBackgroundColor()

    }
    
    func setBackgroundColor() {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1);
    }
    

    
    func setLoadedCardsCap() {
        numLoadedCardsCap = 0;
        if (exampleCardLabels.count > MAX_BUFFER_SIZE) {
            numLoadedCardsCap = MAX_BUFFER_SIZE
        } else {
            numLoadedCardsCap = exampleCardLabels.count
        }
        
    }
    

    func createCards(cardInfo : Array<MDDetailCategoryData>) {
        if (numLoadedCardsCap > 0) {
            for cardData in cardInfo {
                let card = makeCardBy(cardData: cardData)
                card.delegate = self;
                allCards.add(card)
            }
        }
    }
    
    func moreCreateCards(cardInfo : Array<MDDetailCategoryData>){
        if (numLoadedCardsCap > 0) {
            
            for cardData in cardInfo {
                let card = makeCardBy(cardData: cardData)
                card.delegate = self;
                card.panGestureAdd()
                allCards.add(card)
            }
        }
    }
    
    func makeCardBy(cardData:MDDetailCategoryData)->DraggableView{
        var cardData = cardData
        let cardFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let newCard = DraggableView(frameForXIB: cardFrame)
        newCard?.content.text = cardData.description
        newCard?.backgroundImageView.kf.setImage(with: cardData.image_url)
        newCard?.commentCount.text = String((cardData.comment_counnt))
        newCard?.likeCount.text = String((cardData.like_count))
        newCard?.content.textColor = UIColor(hexString: cardData.color)
        newCard?.is_liked = cardData.is_liked
        

        if cardData.color == "#ffffff"{
            newCard?.commentImageView.image = UIImage(named: "commentWh")
            newCard?.likeButton.setImage(UIImage(named: "beforeLikeWhiteButton"), for: .normal)
            newCard?.commentCount.textColor = UIColor.white
            newCard?.likeCount.textColor = UIColor.white
            
        }else{
            newCard?.commentImageView.image = UIImage(named: "commentBl")
            newCard?.likeButton.setImage(UIImage(named: "beforeLikeButton"), for: .normal)
            newCard?.commentCount.textColor = UIColor.black
            newCard?.likeCount.textColor = UIColor.black
        }
        
        if(cardData.is_liked){
            newCard?.likeButton.setImage(UIImage(named: "afterLikeButton"), for: UIControlState.normal)
        }
        
        newCard?.pressedCard = {
            self.delegate.pressedCardView(draggableView: newCard!, data: cardData)
        }
        
        newCard?.removeLike = {
            MDAPIManager.sharedManager.requestRemoveLike(boardID: cardData.id, completion: { (result) -> (Void) in
                cardData.like_count = cardData.like_count - 1
                cardData.is_liked = false
                newCard?.likeCount.text = String(cardData.like_count)
                newCard?.is_liked = false
                if cardData.color == "#ffffff"{
                    newCard?.likeButton.setImage(UIImage(named: "beforeLikeWhiteButton"), for: .normal)
                }else{
                    newCard?.likeButton.setImage(UIImage(named: "beforeLikeButton"), for: .normal)
                }
            })
        }
        
        let petalImageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 130))
        let flowerImageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: 75, height: 137.5))
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 137.5))
        textLabel.text = "애도합니다."
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont(name: "System", size: 17)
        textLabel.sizeToFit()
        
        petalImageView.center = CGPoint(x: (newCard?.center.x)!, y: petalImageView.center.y)
        flowerImageView.center = (newCard?.center)!
        textLabel.center = CGPoint(x: (newCard?.center.x)!, y: flowerImageView.center.y + flowerImageView.frame.height)
        
        newCard?.addSubview(petalImageView)
        newCard?.addSubview(flowerImageView)
        newCard?.addSubview(textLabel)

        
        petalImageView.isHidden = true
        flowerImageView.isHidden = true
        textLabel.isHidden = true
        
        petalImageView.alpha = 0
        flowerImageView.alpha = 0
        textLabel.alpha = 0

        
        
        
        newCard?.backgroundAlpahView.alpha = 0
        newCard?.doubleTapCard = {
            if  petalImageView.isAnimatingGIF ||
                flowerImageView.isAnimatingGIF {
                return
            }
          
            petalImageView.isHidden = false
            textLabel.isHidden = false
            flowerImageView.isHidden = false
            
            petalImageView.alpha = 1
            flowerImageView.alpha = 1
            textLabel.alpha = 1
            
            petalImageView.animate(withGIFNamed: "movePetal.gif", loopCount: 1, completionHandler: nil)
            flowerImageView.animate(withGIFNamed: "moveFlower", loopCount: 1, completionHandler: nil)
            
            
            UIView.animate(withDuration: 1, animations: {
                newCard?.backgroundAlpahView.alpha = 0.5
            })
            
            
            newCard?.backgroundAlpahView.isHidden = false;
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                
                
                UIView.animate(withDuration: 0.3, animations: {
                    petalImageView.stopAnimatingGIF()
                    flowerImageView.stopAnimatingGIF()
                    
                    petalImageView.alpha = 0
                    flowerImageView.alpha = 0
                    textLabel.alpha = 0
                    
                }, completion: { (result) in
                    petalImageView.isHidden = true
                    flowerImageView.isHidden = true
                    textLabel.isHidden = true
                    newCard?.backgroundAlpahView.isHidden = true;
                })
            })
            
            
            guard !cardData.is_liked else{return}
            
            let parameters: Parameters = [
                "board_id": cardData.id,
                "user":MDDeviceInfo.getCurrentDeviceID(),
                ]
            
        
            MDAPIManager.sharedManager.reqeustBoardLike(parameters: parameters, completion: { (result) -> (Void) in
                cardData.like_count = cardData.like_count + 1
                cardData.is_liked = true
                newCard?.likeCount.text = String(cardData.like_count)
                newCard?.is_liked = true
                newCard?.likeButton.setImage(UIImage(named: "afterLikeButton"), for: UIControlState.normal)
            })
        }
        return newCard!
    }
    
    func requestMoreCardInfo(){
        self.model.loadMoreCard()
    }
    
    @objc func receiveCardInfo(noti:Notification){
        let info = noti.object as! Dictionary<String,Any>
        nextURL = info["nextURL"] as? String
        let arr = info["dataArr"] as? Array<MDDetailCategoryData>
        
        createCards(cardInfo: arr!)
        displayCards()
        delegate.completeCreateCard()
        
    }
    
    @objc func receiveCardMoreInfo(noti:Notification){
        let info = noti.object as! Dictionary<String,Any>
        nextURL = info["nextURL"] as? String
        let arr = info["dataArr"] as? Array<MDDetailCategoryData>
        
        moreCreateCards(cardInfo: arr!)
    }
    
    func displayCards() {
        for i in 0..<numLoadedCardsCap {
            loadACardAt(index: i)
        }
        
    }
    
    func cardSwipedLeft(card: DraggableView) {
        processCardSwipe()
    }
    
    func cardSwipedRight(card: DraggableView) {
        processCardSwipe()
    }


    func allCardAddGesture(){
        for cardView in allCards{
            (cardView as! DraggableView).panGestureAdd()
        }
    }
    
    
    func processCardSwipe() {
        loadedCards.removeObject(at: 0)
        
        if loadedCards.count <= 2 {
            requestMoreCardInfo()
        }
        
        if (moreCardsToLoad()) {
            loadNextCard()
        }
    }
    
    func moreCardsToLoad() -> Bool {
        return cardsLoadedIndex < allCards.count;
    }
    
    func loadNextCard() {
        loadACardAt(index: cardsLoadedIndex)
    }
    
    func loadACardAt(index: Int) {
        loadedCards.add(allCards[index])
        if (loadedCards.count > 1) {
            insertSubview(loadedCards[loadedCards.count-1] as! DraggableView, belowSubview: loadedCards[loadedCards.count-2] as! DraggableView)
            // is there a way to define the array with UIView elements so I don't have to cast?
        } else {
            addSubview(loadedCards[0] as! DraggableView)
        }
        cardsLoadedIndex = cardsLoadedIndex + 1;
    }
    
    func swipeRight() {
        let dragView = loadedCards[0] as! DraggableView
        print ("Clicked right", terminator: "")
        dragView.rightClickAction()
    }
    
    func swipeLeft() {
        let dragView = loadedCards[0] as! DraggableView
        print ("clicked left", terminator: "")
        dragView.leftClickAction()
    }
    
    @objc func handleCardDoubleTap(tapGesture : UITapGestureRecognizer){
        
    }
    
    
    
}

