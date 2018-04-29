//
//  MDCategoryItemViewModel.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 2. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation

protocol MDCategoryItemViewModel :class{

    var numberOfItems:Int{get}
    
    func itemCellViewModel(atIndex index:Int)->MDCategoryItemCellViewModel?
    func itemCellType(atIndex index:Int)->ItemCellType
    func item(atIndex index:Int) -> Item
    func load()
    func loadNext()
    func loadDetailCategoryList(category_id:Int,sortType:CategorySortType)
}
