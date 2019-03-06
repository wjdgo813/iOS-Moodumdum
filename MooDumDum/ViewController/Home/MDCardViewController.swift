//
//  MDCardViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 2. 12..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MDCardViewController: MDPullUpController, MDDraggableViewBackgroundDelegate, MDCanShowAlert {

    
    
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
        if cardYPoiny == self.view.frame.height {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    @objc func completeWriteSubmit(){

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MD_MyPageViewController")
        
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
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
        vc?.detailData = data
        vc?.prevView = draggableView
        
        self.navigationController?.pushViewController(vc!, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: data.color)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    
    @IBAction func pressedWriteButton(_ sender: Any) {
        //MD_WriteViewController
        
        let goWriteVC = {
            let sb = UIStoryboard(name: "Write", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MD_WriteViewController")
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
        
        if !MDSettingData.firstWriteButton() {
            self.showAlert(title: "알림", message: "타인을 불편하게 하는 게시글일 경우 통보없이 삭제될 수 있으며 계정에 제재가 가해질 수 있습니다.", confirmButtonTitle: "확인", completion: {
                MDSettingData.setFirstWriteButton(enabled: true)
                goWriteVC()
            })
        }else{
            goWriteVC()
        }
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


