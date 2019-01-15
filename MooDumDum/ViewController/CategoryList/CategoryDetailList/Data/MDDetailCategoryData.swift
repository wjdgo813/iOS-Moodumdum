//
//  MDDetailCategoryData.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 3. 19..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MDDetailCategoryData : MDListProtocol{
    let id : String
    let category_id : String
    let userObject : MDUserAPIData
    let name : String
    let description : String
    let views : Int
    var comment_counnt : Int
    let image_url : URL
    let color : String
    var is_liked : Bool
    var like_count : Int
    let created : String
    let updated : String
    
    init(rawJson: Any) {
        let json = JSON(rawJson)
        
        id = json["id"].stringValue
        category_id = json["category_id"].stringValue
        userObject = MDUserAPIData(rawJson: json["user_id"])
        name = json["name"].stringValue
        description = json["description"].stringValue
        views = json["views"].intValue
        comment_counnt = json["comment_count"].intValue
        image_url         = URL(string: json["image_url"].stringValue)!
        color = json["color"].stringValue
        is_liked = json["is_liked"].boolValue
        like_count = json["like_count"].intValue
        created = json["created"].stringValue
        updated = json["updated"].stringValue
        
    }
}
