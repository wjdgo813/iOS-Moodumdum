//
//  MDCategoryListViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 2. 11..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MDCategoryListViewController: MDItemViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        delegate = self
        myCollectionView = collectionView
        viewModel = MDCategoryViewModel()
        super.viewDidLoad()
//        initNavigationBar()
        registerCollectionViewCell()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name.CategoryViewModel.changedLists, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
        if viewModel.numberOfItems == 0 {
            self.viewModel.load()
        }
    }
    
    func registerCollectionViewCell(){
        self.collectionView?.register(UINib(nibName: "MDCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ItemCellType.categoryCell.reuseIdentifier())
    }
    
    func initNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        navigationController?.navigationBar.tintColor = UIColor.black;
        UIApplication.shared.statusBarStyle = .default
    }
    
    
}

extension MDCategoryListViewController: MDItemViewControllerDelegate{

    func itemViewController(_ itemViewController: MDItemViewController, cellForItem indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = itemViewController.myCollectionView?.dequeueReusableCell(withReuseIdentifier: "MDCategoryCollectionViewCell", for: indexPath)
        if let myCell = cell as? MDCategoryCollectionViewCell {
            myCell.viewModel = viewModel.itemCellViewModel(atIndex: indexPath.row) as? MDCategoryCellViewModel
        }
        return cell!
    }
    
    func itemViewController(_ itemViewController: MDItemViewController, didSelectItem item: Item, cellType: ItemCellType, atIndexPath indexPath: IndexPath) {
        let sb = UIStoryboard(name: "MDCategoryList", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MDCategoryDetailViewController") as? MDCategoryDetailViewController
        if let cellItem = item as? MDCategoryData{
            vc?.myTitle = cellItem.title
            vc?.category_id = cellItem.category_id
            
        }
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:vc?.myTitle, style:.plain, target:nil, action:nil)
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func itemViewController(_ itemViewController: MDItemViewController, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func itemViewController(_ itemViewController: MDItemViewController, heightForRowAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.size.width)/2 - 4 , height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 2, 0, 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
