//
//  MDUserAPIData.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 4. 15..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MDUserAPIData:MDListProtocol {
    let name : String
    let UUID : String
    let profile_image : URL
    
    init(rawJson:Any) {
        let json = JSON(rawJson)
        name = json["name"].stringValue
        UUID = json["user"].stringValue
        profile_image = URL(string: json["profile_image"].stringValue)!
    }
}


