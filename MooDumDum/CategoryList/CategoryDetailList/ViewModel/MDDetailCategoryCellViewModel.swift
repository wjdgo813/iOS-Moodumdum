//
//  MDDetailCategoryCellViewModel.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 3. 19..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation


import Foundation

class MDDetailCategoryCellViewModel : MDCategoryItemCellViewModel{
    private var data : MDDetailCategoryData
    init(data:MDDetailCategoryData) {
        self.data = data
    }
 
    var id : String {
        return data.id
    }
    
    var category_id : String{
        return data.category_id
    }
    
    var user : String{
        return data.user
    }
    
    var name : String{
        return data.name
    }
    
    var description : String{
        return data.description
    }
    
    var views: Int{
        return data.views
    }
    
    var comment_count : Int{
        return data.comment_counnt
    }
    
    var image_url : URL{
        return data.image_url
    }
    
    var color : String{
        return data.color
    }
    
    var like_count : Int{
        return data.like_count
    }
    
    var is_liked:Bool{
        return data.is_liked
    }
    
    var created : String{
        return data.created
    }
    
    var updated : String{
        return data.updated
    }
}
