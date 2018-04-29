//
//  MDCategoryDetailViewModel.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 3. 19..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation


class MDCategoryDetailViewModel : MDCategoryItemViewModel {
    
    private var category_id : Int?
    private var categorySortType : CategorySortType?
    
    let model : MDCategoryDetailModel?
    init(){
        self.model = MDCategoryDetailModel()
        NotificationCenter.default.addObserver(self, selector: #selector(onChangedIssues(noti:)), name: Notification.Name.CategoryDetailModel.changedLists, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var numberOfItems: Int {
        if let count = self.model?.categoryData?.count{
            return count
        }
        return 0
    }
    
    func itemCellViewModel(atIndex index: Int) -> MDCategoryItemCellViewModel? {
        let data = item(atIndex: index)
        return MDDetailCategoryCellViewModel(data: data as! MDDetailCategoryData) as! MDCategoryItemCellViewModel
    }
    
    func itemCellType(atIndex index: Int) -> ItemCellType {
        return .categoryDetailCell
    }
    
    func item(atIndex index: Int) -> Item {
        
        return (model?.categoryData.categoryDetailList[index])!
    
    }
    
    func loadDetailCategoryList(category_id:Int,sortType:CategorySortType){
        self.category_id = category_id
        self.categorySortType = sortType
        load()
    }
    
    func load() {
        model?.loadCategoryDetailList(categoryId:self.category_id!,sortType: self.categorySortType!)
    }
    
    func loadNext() {
        model?.loadMore()
    }
    
    @objc func onChangedIssues(noti:Notification) {
        NotificationCenter.default.post(name: Notification.Name.CategoryDetailViewModel.changedLists, object: nil)
    }
}

