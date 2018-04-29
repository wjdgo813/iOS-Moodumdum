//
//  MD_ProfilePic.swift
//  MooDumDum
//
//  Created by 김혜리 on 2018. 3. 14..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit
import Alamofire

class MD_ProfilePic: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectimage = ""
    var index = 0
    var images:[String] = []
    var profileimages:[String] = []
    var user = MD_UserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        loadData()
        
        if (UserDefaults.standard.string(forKey: "profilepic") == nil){
            profileImage.image = UIImage(named:"ghost1")
        }else{
            profileImage.setImageFromURl(stringImageUrl:"\(UserDefaults.standard.string(forKey: "profilepic")!)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MD_ProfileCell
        cell.imageView.setImageFromURl(stringImageUrl: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! MD_ProfileCell
        print(indexPath.row)
        profileImage.image = selectedCell.imageView.image
        selectimage = profileimages[indexPath.row]
        index = indexPath.row
        selectedCell.selectImage.image = UIImage(named: "select")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let beforeCell = collectionView.cellForItem(at: indexPath) as? MD_ProfileCell
        beforeCell?.selectImage.image = nil
    }
    
    @IBAction func selectPic(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        Alamofire.request("http://13.125.76.112:8000/api/profileimage/").responseJSON {
            (response) in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject>{
                if let innerdict = dict["results"] as? [[String:Any]]{
                    for innerdictIndex in innerdict{
                        self.images.append(innerdictIndex["image_url"] as! String)
                        self.profileimages.append(innerdictIndex["image_url"] as! String)
                    }
                }
            }
            DispatchQueue.main.async(){
                print(self.images)
                self.collectionView.reloadData()
            }
        }
    }
}

