//
//  MDDetailCategorySet.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 3. 19..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 "count": 12,
 "next": "http://13.125.76.112:8000/api/board/search/category/3/?limit=10&offset=10",
 "previous": null,
 "results": [ ]
 */

struct MDDetailCategorySet : MDListProtocol {
    var count : Int?
    var nextUrl : String?
    lazy var categoryDetailList = Array<MDDetailCategoryData>()
    init(rawJson: Any){
        let json = JSON(rawJson)
        
        nextUrl = json["next"].stringValue
        for data in json["results"].arrayValue {
            categoryDetailList.append(MDDetailCategoryData(rawJson: data))
        }
        count = categoryDetailList.count
   }
    
    mutating func loadMore(rawJson:Any) {
        let json = JSON(rawJson)
        
        nextUrl = json["next"].stringValue
        for data in json["results"].arrayValue {
            categoryDetailList.append(MDDetailCategoryData(rawJson: data))
        }
        count = count! + json["results"].arrayValue.count
    }
}
