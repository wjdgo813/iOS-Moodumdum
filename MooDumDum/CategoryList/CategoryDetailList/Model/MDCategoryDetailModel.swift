//
//  MDCategoryDetailModel.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 3. 19..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


extension MDDetailCategoryData : Item{
    
}

class MDCategoryDetailModel {
    var categoryData : MDDetailCategorySet!
    func loadCategoryDetailList(categoryId : Int,sortType:CategorySortType){
        switch sortType {
        case .recentSort:
            Alamofire.request("http://13.125.76.112/api/board/search/category/\(categoryId)?user=\(MDDeviceInfo.getCurrentDeviceID())").responseJSON { response in
                let json = JSON(response.result.value)
                print("iwant : \(json)")
                
                self.categoryData = MDDetailCategorySet(rawJson: json)
                self.postNotification()
            }
        case .favoriteSort:
            Alamofire.request("http://13.125.76.112/api/board/search/category/favorite/\(categoryId)?user=\(MDDeviceInfo.getCurrentDeviceID())").responseJSON { response in
                let json = JSON(response.result.value)
                print("iwant : \(json)")
                
                self.categoryData = MDDetailCategorySet(rawJson: json)
                self.postNotification()
            }
        
        }
    }
    
    func loadMore(){
        guard categoryData != nil else { return }
        guard categoryData.nextUrl != nil else { return }
        guard categoryData.nextUrl != "" else { return }
        
        Alamofire.request(categoryData.nextUrl!).responseJSON { response in
            let json = JSON(response.result.value)
            print("iwant : \(json)")
            
            self.categoryData.loadMore(rawJson: json)
            self.postNotification()
        }
    }
    
    func postNotification(){
        NotificationCenter.default.post(name: Notification.Name.CategoryDetailModel.changedLists, object: nil)
    }
}

