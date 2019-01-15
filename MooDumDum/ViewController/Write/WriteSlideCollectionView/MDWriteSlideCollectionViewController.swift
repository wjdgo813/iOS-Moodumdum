//
//  MDWriteSlideCollectionViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 5. 1..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MDWriteSlideCollectionViewController: UIViewController {
    var categoryNumber = 1
    var collectionView : UICollectionView?
    lazy var categoryStringArr = ["가정사","기타","연애사","자존감","직장사","흑역사"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCollectionView()
        registerCell()
    }
    
    func makeCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 74, height: 30)
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 48), collectionViewLayout: layout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.view.addSubview(self.collectionView!)
        self.view.backgroundColor = UIColor.clear
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
    
    func registerCell(){
        self.collectionView?.register(UINib(nibName: "MDWirteCategorySlideCell", bundle: nil), forCellWithReuseIdentifier: "MDWirteCategorySlideCell")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension MDWriteSlideCollectionViewController : UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryStringArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 35)
    }
}

extension MDWriteSlideCollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MDWirteCategorySlideCell", for: indexPath)
            as? MDWirteCategorySlideCell
        
        if categoryNumber == indexPath.row {
            cell?.categoryButton.backgroundColor = UIColor.clear
            cell?.categoryButton.layer.borderColor = UIColor(hexString: "9E9E9E").cgColor
            cell?.categoryButton.layer.borderWidth = 1
        }else{
            cell?.categoryButton.layer.borderColor = UIColor.clear.cgColor
            cell?.categoryButton.layer.borderWidth = 1
            cell?.categoryButton.backgroundColor = UIColor.white
        }
        
        
        cell?.pressedCategoryButton = {
            
            self.categoryNumber = indexPath.row
            
            var modelInfo = Dictionary<String, Any>()
            modelInfo = ["categoryNumber":self.categoryNumber]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCategoryNumber"), object: modelInfo)
            
            collectionView.reloadData()
            
        }
        cell?.categoryLabel.text = categoryStringArr[indexPath.row]
        return cell!;
    }
}

extension MDWriteSlideCollectionViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
}
