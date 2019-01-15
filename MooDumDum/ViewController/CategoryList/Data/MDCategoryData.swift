//
//  MDCategoryData.swift
//  MooDumDum
//
//  Created by JHH on 2018. 2. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MDCategoryData: MDListProtocol {
    let background_url : URL
    let image_url : URL
    let color : String
    let category_id : Int
    let title : String
    
    init(rawJson: Any) {
        let json = JSON(rawJson)
        
        background_url = URL(string: json["background_url"].stringValue)!
        image_url         = URL(string: json["image_url"].stringValue)!
        color                = json["color"].stringValue
        category_id      = json["id"].intValue
        title                 = json["title"].stringValue
        
    }
}



