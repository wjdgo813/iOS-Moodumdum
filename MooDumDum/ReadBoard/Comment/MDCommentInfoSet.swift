//
//  MDCommentInfoSet.swift
//  MooDumDum
//
//  Created by JHH on 2018. 3. 21..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MDCommentInfoSet : MDListProtocol{
    var count : Int?
    var totalCount : Int?
    var nextURL : String?
    lazy var commentList = Array<MDCommentItem>()
    
    init(rawJson: Any) {
        let json = JSON(rawJson)
        totalCount = json["count"].intValue
        nextURL = json["next"].stringValue
        for data in json["results"].arrayValue {
            commentList.append(MDCommentItem(rawJson: data))
        }
        
        count = commentList.count
    }
    
    mutating func loadMore(rawJson:Any) {
        let json = JSON(rawJson)
        
        nextURL = json["next"].stringValue
        for data in json["results"].arrayValue {
            commentList.append(MDCommentItem(rawJson: data))
        }
        count = count! + json["results"].arrayValue.count
    }
    
}

struct MDCommentItem : MDListProtocol{
    var comment_id : String?
    var board_id : String?
    var created : String?
    var updated : String?
    var like_count : Int?
    var userObject : MDUserAPIData?
    var description : String?
    var category_id : Int?
    var is_liked : Bool?
    
    init(rawJson: Any) {
        let json = JSON(rawJson)
        description = json["description"].stringValue
        category_id = json["category_id"].intValue
        
        
        comment_id = json["id"].stringValue
        board_id = json["board_id"].stringValue
        
        created = json["created"].stringValue
        updated = json["updated"].stringValue
        like_count = json["like_count"].intValue
        userObject = MDUserAPIData(rawJson: json["user_id"])
        is_liked = json["is_liked"].boolValue
        
    }
}
