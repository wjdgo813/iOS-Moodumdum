//
//  MD_PhotoViewController.swift
//  MooDumDum
//
//  Created by 김혜리 on 2018. 2. 19..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit
import Alamofire
import Toaster

class MD_PhotoViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myPhoto: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userinfo = MD_UserInfo()
    var textview : String = ""
    var category : Int = 0
    var nickname : String = ""
    var myImages = [String]()
    var myFont = [String]()
    var selectImage : String = ""
    var selectfont : String = ""
    var url : String = "http://13.125.76.112/api/boardimage/random/?limit=20"
    var post : String = "http://13.125.76.112/api/board/?user=\(MDDeviceInfo.getCurrentDeviceID())"
    var nextPage = ""
    var isMoreLoading = false

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MD_PhotoCell
        cell.imageView.setImageFromURl(stringImageUrl: myImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 4
        let cellWidth = collectionView.bounds.width / numberOfCell
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.myLabel.text = textview
        myLabel.lineBreakMode = .byWordWrapping 
        myLabel.numberOfLines = 0
        UIApplication.shared.statusBarStyle = .default
            Alamofire.request(url).responseJSON {
                (response) in
                let result = response.result
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let nextpage = dict["next"] as? String
                    {
                        self.nextPage = nextpage
                    }
                    else
                    {
                        self.nextPage = "null"
                    }
                    if let innerdict = dict["results"] as? [[String:Any]]{
                        for innerdictIndex in innerdict{
                            self.myImages.append(innerdictIndex["image_url"] as! String)
                            self.myFont.append(innerdictIndex["font_color"] as! String)
                        }
                    }
                }
                DispatchQueue.main.async(){
                    self.collectionView.reloadData()
                    self.myPhoto.setImageFromURl(stringImageUrl: self.myImages[0])
                    if(self.myFont[0] == "#ffffff"){
                        self.myLabel.textColor = UIColor.white
                    }else{
                        self.myLabel.textColor = UIColor.black
                    }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! MD_PhotoCell
        myPhoto.image = selectedCell.imageView.image
        if(myFont[indexPath.row] == "#ffffff"){
            myLabel.textColor = UIColor.white
        }else{
            myLabel.textColor = UIColor.black
        }
        selectImage = myImages[indexPath.row]
        selectfont = myFont[indexPath.row]
    }
    
    //묻기 눌렀을 때
    @IBAction func WriteSubmit(_ sender: Any) {
        
        let param : [String : Any] = [
            "category_id" : self.category,
            "description" : textview,
            "image_url" : selectImage,
            "color" : selectfont
            ]
        

        Alamofire.request(post, method: .post, parameters: param, encoding: JSONEncoding.default)
        
        let vc = self.navigationController?.viewControllers
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    func reloadData() {
        if self.nextPage == "null" {return}
        Alamofire.request(self.nextPage).responseJSON {
            (response) in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject>{
                if let nextpage = dict["next"] as? String
                {
                    self.nextPage = nextpage
                }
                else
                {
                    self.nextPage = "null"
                }
                if let innerdict = dict["results"] as? [[String:Any]]{
                    for innerdictIndex in innerdict{
                        self.myImages.append(innerdictIndex["image_url"] as! String)
                        self.myFont.append(innerdictIndex["font_color"] as! String)
                    }
                }
            }
            DispatchQueue.main.async(){
                self.collectionView.reloadData()
                self.myPhoto.setImageFromURl(stringImageUrl: self.myImages[0])
                self.isMoreLoading = false
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isMoreLoading == false {
            let scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y
            if scrollPosition > 0 && scrollPosition < scrollView.contentSize.height*0.2{
                reloadData()
                self.isMoreLoading = true
            }
        }
    }
}



