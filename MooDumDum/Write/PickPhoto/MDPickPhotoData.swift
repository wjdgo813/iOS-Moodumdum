//
//  MDPickPhotoData.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 4. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MDPickPhotoData : MDListProtocol{
    let font_color : String
    let image_url : URL
    
    init(rawJson: Any) {
        let json = JSON(rawJson)
        font_color = json["font_color"].stringValue
        image_url = URL(string: json["image_url"].stringValue)!
    }
}
