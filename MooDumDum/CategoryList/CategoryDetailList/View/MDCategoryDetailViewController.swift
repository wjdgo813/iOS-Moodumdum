//
//  MDCategoryDetailViewController.swift
//  MooDumDum
//
//  Created by JHH on 2018. 2. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

enum CategorySortType{
    case recentSort
    case favoriteSort
}

class MDCategoryDetailViewController: MDItemViewController {
    var myTitle : String?
    var category_id : Int?
    var sortType : CategorySortType?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var recentButton: UIButton!
    
    override func viewDidLoad() {
        delegate = self
        myCollectionView = collectionView
        viewModel = MDCategoryDetailViewModel()
        
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        sortType = .recentSort
        registerCollectionViewCell()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name.CategoryDetailViewModel.changedLists, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.numberOfItems == 0 {
            self.viewModel.loadDetailCategoryList(category_id: category_id!,sortType:sortType!)
        }
        navigationController?.navigationBar.tintColor = UIColor.black;
        UIApplication.shared.statusBarStyle = .default
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func registerCollectionViewCell(){
        self.collectionView?.register(UINib(nibName: "MDCategoryDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ItemCellType.categoryDetailCell.reuseIdentifier())
    }
    
    @IBAction func pressedFavoritebutton(_ sender: Any) {
        if sortType == .favoriteSort {
            return
        }
        sortType = .favoriteSort
        self.favoriteButton.setTitleColor(UIColor(hexString: "#000000"), for: UIControlState.normal)
        self.recentButton.setTitleColor(UIColor(hexString:"#D3D3D3"), for: UIControlState.normal)
        
        changeSortComment()
    }
    
    
    @IBAction func pressedRecentButton(_ sender: Any) {
        if sortType == .recentSort {
            return
        }
        sortType = .recentSort
        self.favoriteButton.setTitleColor(UIColor(hexString: "#D3D3D3"), for: UIControlState.normal)
        self.recentButton.setTitleColor(UIColor(hexString:"#000000"), for: UIControlState.normal)
        changeSortComment()
    }
    
    func changeSortComment(){
        
        self.viewModel.loadDetailCategoryList(category_id: category_id!,sortType:sortType!)
    }
    
}

extension MDCategoryDetailViewController: MDItemViewControllerDelegate{

    
    func itemViewController(_ itemViewController: MDItemViewController, cellForItem indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = itemViewController.myCollectionView?.dequeueReusableCell(withReuseIdentifier: "MDCategoryDetailCollectionViewCell", for: indexPath)
        if let myCell = cell as? MDCategoryDetailCollectionViewCell {
            myCell.viewModel = viewModel.itemCellViewModel(atIndex: indexPath.row) as? MDDetailCategoryCellViewModel
        }
        return cell!
    }
    
    func itemViewController(_ itemViewController: MDItemViewController, didSelectItem item: Item, cellType: ItemCellType, atIndexPath indexPath: IndexPath) {
        print("didSelect")
        
        let sb = UIStoryboard(name: "Board", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MDBoardViewController") as? MDBoardViewController
        if let cellItem = item as? MDDetailCategoryData{
            vc?.data = cellItem
            
        }
        vc?.prevView = itemViewController.myCollectionView.cellForItem(at: indexPath)
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: (vc?.data?.color)!)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        
    }
    
    func itemViewController(_ itemViewController: MDItemViewController, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func itemViewController(_ itemViewController: MDItemViewController, heightForRowAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width , height: 220)
    }
}
