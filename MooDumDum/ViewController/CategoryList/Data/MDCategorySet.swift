//
//  MDCategorySet.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 2. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//


import Foundation
import SwiftyJSON

/*
 count = 6;
 next = "<null>";
 previous = "<null>";
 results =     (
 )
 */

struct MDCategorySet : MDListProtocol {
    let count : Int?
    lazy var categoryList = Array<MDCategoryData>()
    init(rawJson: Any){
        let json = JSON(rawJson)
        count = json["count"].intValue
        
        for data in json["results"].arrayValue {
            categoryList.append(MDCategoryData(rawJson: data))
        }
    }
}
