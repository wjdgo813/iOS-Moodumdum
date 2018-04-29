//
//  MDCardViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 2. 12..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MDCardViewController: MDPullUpController,MDDraggableViewBackgroundDelegate {

    
    
    @IBOutlet weak var writeButton: UIButton!
    var draggableView : MDDraggableViewBackground!
    var cardYPoiny = CGFloat(0)
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(completeWriteSubmit), name: NSNotification.Name(rawValue: "MDWriteSubmit"), object: nil)
        
        
        self.draggableView = MDDraggableViewBackground(frame: self.view.frame)
        self.draggableView.delegate = self
        
        self.willMoveToStickyPoint = { point in
            print("willMoveToStickyPoint \(point)")
            
        }
        
        self.didMoveToStickyPoint = { point in
            print("didMoveToStickyPoint \(point)")
            self.cardYPoiny = point
            UIApplication.shared.statusBarStyle = .lightContent
            self.draggableView.allCardAddGesture()
        }
        
        
        cardView.addSubview(draggableView)
        
        if MDDeviceInfo.isIphoneX() {
            self.writeButton.setImage(UIImage(named: "writeButtonForX"), for: .normal)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @objc func completeWriteSubmit(){
        self.draggableView = nil
        self.draggableView = MDDraggableViewBackground(frame: self.view.frame)
        self.draggableView.delegate = self
        
        for cardSubview in cardView.subviews {
            cardSubview.removeFromSuperview()
        }
        
        cardView.addSubview(draggableView)
        
        if MDDeviceInfo.isIphoneX() {
            self.writeButton.setImage(UIImage(named: "writeButtonForX"), for: .normal)
        }
    }
    
    
    func completeCreateCard() {
        if cardYPoiny == self.view.frame.height {
            self.draggableView.allCardAddGesture()
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    func pressedCardView(draggableView:DraggableView, data: MDDetailCategoryData) {
        let sb = UIStoryboard(name: "Board", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MDBoardViewController") as? MDBoardViewController
        vc?.data = data
        vc?.prevView = draggableView
        
        self.navigationController?.pushViewController(vc!, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: data.color)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    

    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    override var pullUpControllerPreviewOffset: CGFloat {
        return self.view.frame.height / 2
    }
    
    override var pullUpControllerIsBouncingEnabled: Bool {
        return false
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 5, y: 5, width: 280, height: UIScreen.main.bounds.height - 10)
    }
}


