//
//  MDCategoryCellViewModel.swift
//  MooDumDum
//
//  Created by JHH on 2018. 2. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation

class MDCategoryCellViewModel : MDCategoryItemCellViewModel{
    private var data : MDCategoryData
    init(data:MDCategoryData) {
        self.data = data
    }
    
    var title : String{
        return data.title
    }
    var category_id : Int{
        return data.category_id
    }
    var color : String{
        return data.color
    }
    var image_url : URL{
        return data.image_url
    }
    var background_url : URL {
        return data.background_url
    }
}
