//
//  MDCategoryModel.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 2. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension MDCategoryData : Item{
    
}

class MDCategoryModel{
    var categoryData : MDCategorySet!
    
    func loadCategory(){
        ///api/board/
        Alamofire.request("http://13.125.76.112/api/board/category/").responseJSON { response in
            let json = JSON(response.result.value)
            print("iwant : \(json)")
            print("iwant : \(json["results"])")
            
            self.categoryData = MDCategorySet(rawJson: json)
            self.postNotification()
            
        }
    }
    
    func postNotification(){
        NotificationCenter.default.post(name: Notification.Name.CategoryModel.changedLists, object: nil)
    }
    
}
