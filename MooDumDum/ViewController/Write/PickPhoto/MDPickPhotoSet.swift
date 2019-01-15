//
//  MDPickPhotoSet.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 4. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MDPickPhotoSet : MDListProtocol {
    var count : Int?
    var nextUrl : String?
    lazy var pickPhotoList = Array<MDPickPhotoData>()
    
    init(rawJson: Any){
        let json = JSON(rawJson)
        
        nextUrl = json["next"].stringValue
        for data in json["results"].arrayValue {
            pickPhotoList.append(MDPickPhotoData(rawJson: data))
        }
        count = pickPhotoList.count
    }
    
    mutating func loadMore(rawJson:Any) {
        let json = JSON(rawJson)
        
        nextUrl = json["next"].stringValue
        for data in json["results"].arrayValue {
            pickPhotoList.append(MDPickPhotoData(rawJson: data))
        }
        count = count! + json["results"].arrayValue.count
    }
}
