//
//  MyPageViewController.swift
//  MooDumDum
//
//  Created by 김혜리 on 2018. 2. 2..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit
import Alamofire

enum MDMySelfListType {
    case MDMySelfWriteBoard
    case MDMySelfLikeBoard
}



class MD_MyPageViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nickView: UIView!
    @IBOutlet weak var Received: UILabel!
    @IBOutlet weak var myPost: UILabel!
    @IBOutlet weak var myBoardCollectionView: UICollectionView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var segmentContainer: UISegmentedControl!
    
    
    var fetchedmypost : Int = 0
    var fetchedreceived : Int = 0
    var isMoreLoading = false
    let buttonBar = UIView()
    var user = MD_UserInfo()
    var mySelfListType : MDMySelfListType?
    private var data : MDDetailCategorySet?
    
    var myUrl : String = "http://13.125.76.112/api/user/info/"+MDDeviceInfo.getCurrentDeviceID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNav()
        mySelfListType = .MDMySelfWriteBoard
        self.requestMyBoardList(listType: self.mySelfListType!)
        
        self.myBoardCollectionView?.register(UINib(nibName: "MDMyBoardCell", bundle: nil), forCellWithReuseIdentifier: "MDMyBoardCell")
        self.myBoardCollectionView?.register(UINib(nibName: "MDMyBoardEmptyCell", bundle: nil), forCellWithReuseIdentifier: "MDMyBoardEmptyCell")
        self.myBoardCollectionView?.register(UINib(nibName: "MDMySelfLikeEmptyCell", bundle: nil), forCellWithReuseIdentifier: "MDMySelfLikeEmptyCell")
        
        nickView.layer.cornerRadius = 15
        nickView.clipsToBounds = true
        
        segmentContainer.backgroundColor = .clear
        segmentContainer.tintColor = .clear
        
        segmentContainer.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0),
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        segmentContainer.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16.0),
            NSAttributedStringKey.foregroundColor: UIColor.black
            ], for: .selected)
        
        view.addSubview(buttonBar)
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.black
        buttonBar.topAnchor.constraint(equalTo: segmentContainer.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: segmentContainer.leftAnchor, constant: 8).isActive = true
        buttonBar.widthAnchor.constraint(equalToConstant: (self.view.frame.width / 2) - 8).isActive = true
        
        if MDDeviceInfo.isIphoneX() {
            self.button.setImage(UIImage(named: "writeButtonForX"), for: .normal)
        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initNav()
        dataLoad(url: myUrl)
        segmentContainer.selectedSegmentIndex = 0
        mySelfListType = .MDMySelfWriteBoard
        self.requestMyBoardList(listType: self.mySelfListType!)
    }
    
    
    
    
    
    
    
    func initNav(){
        let leftItem = UIBarButtonItem(image: UIImage(named: "cancel"), style: .plain , target: self, action: #selector(exitButton))
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.tintColor = UIColor.black;
        UIApplication.shared.statusBarStyle = .default
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    
    
    @IBAction func ChangeContainer(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.2) {
            self.buttonBar.frame.origin.x = (self.segmentContainer.frame.width / CGFloat(self.segmentContainer.numberOfSegments)) * CGFloat(self.segmentContainer.selectedSegmentIndex) + 8
        }
        if(sender.selectedSegmentIndex == 0) {
            self.mySelfListType = .MDMySelfWriteBoard
            self.requestMyBoardList(listType: self.mySelfListType!)
        } else {
            self.mySelfListType = .MDMySelfLikeBoard
            self.requestMyBoardList(listType: self.mySelfListType!)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isMoreLoading == false {
            let scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y
            if scrollPosition > 0 && scrollPosition < scrollView.contentSize.height*0.2{
                requestMoreMyBoardList(listType: self.mySelfListType!)
                self.isMoreLoading = true
            }
        }
    }
    
    
    @IBAction func EditNickName(_ sender: Any) {
        let storyboard = UIStoryboard(name: "NickName", bundle: nil)
        let nvc = storyboard.instantiateViewController(withIdentifier: "NVC") as! MD_NickNameViewController
        nvc.nickname = self.nickName.text!
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    
    
    
    
    @objc func exitButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    func requestMyBoardList(listType:MDMySelfListType){
        switch listType {
        case .MDMySelfLikeBoard:
            MDAPIManager.sharedManager.requestBoardSelfLikeBoardList { (result) -> (Void) in
                self.data = nil
                self.data = MDDetailCategorySet(rawJson: result)
                self.myBoardCollectionView.reloadData()
            }
            break;
        case .MDMySelfWriteBoard:
            MDAPIManager.sharedManager.requestBoardSelfWriteBoardList{ (result) -> (Void) in
                self.data = nil
                self.data = MDDetailCategorySet(rawJson: result)
                self.myBoardCollectionView.reloadData()
            }
            break;
        }
    }
    
    func requestMoreMyBoardList(listType:MDMySelfListType){
        guard data != nil else { return }
        guard data?.nextUrl != nil else { return }
        guard data?.nextUrl != "" else { return }
        
        MDAPIManager.sharedManager.requestBoardSelfMoreBoardList(nextUrl: (data?.nextUrl)!) { (result) -> (Void) in
            self.data?.loadMore(rawJson: result)
            self.myBoardCollectionView.reloadData()
            self.isMoreLoading = false
        }
    }
}


extension MD_MyPageViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.data != nil else{ return 0 }
        if self.data?.count == 0 {
            return 1
        }
        return (self.data?.count)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.data?.count == 0 {
            if self.mySelfListType == .MDMySelfWriteBoard {
                
                let cell : MDMyBoardEmptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MDMyBoardEmptyCell", for: indexPath) as! MDMyBoardEmptyCell
                return cell
                
            }else if self.mySelfListType == .MDMySelfLikeBoard{
                
                let cell : MDMySelfLikeEmptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MDMySelfLikeEmptyCell", for: indexPath) as! MDMySelfLikeEmptyCell
                return cell
            }
            
            
        }
        
        let cell : MDMyBoardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MDMyBoardCell", for: indexPath) as! MDMyBoardCell
        cell.backgroundImageView.kf.setImage(with: self.data?.categoryDetailList[indexPath.row].image_url)
        cell.descriptionLabel.text = self.data?.categoryDetailList[indexPath.row].description
        cell.descriptionLabel.textColor = UIColor(hexString: (self.data?.categoryDetailList[indexPath.row].color)!)
        
        return cell
    }


}

extension MD_MyPageViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.data?.count == 0 {
            return CGSize(width: self.view.frame.size.width, height: 200)
        }
        
        let cellWidth = (self.view.frame.size.width) / 2 - 5
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension MD_MyPageViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.data?.count != 0 else { return }
        
        let boardData = self.data?.categoryDetailList[indexPath.row]
        let sb = UIStoryboard(name: "Board", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MDBoardViewController") as? MDBoardViewController
        vc?.data = boardData
        
        self.navigationController?.pushViewController(vc!, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: (boardData?.color)!)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
}





