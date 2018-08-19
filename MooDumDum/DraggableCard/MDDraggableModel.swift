//
//  MDDraggableModel.swift
//  MooDumDum
//
//  Created by JHH on 2018. 3. 20..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire



class MDDraggableModel{
    var boardData : MDDetailCategorySet!
    
    func loadCard(){
        Alamofire.request("http://13.125.76.112/api/board/?user=\(MDDeviceInfo.getCurrentDeviceID())").responseJSON { response in
            let json = JSON(response.result.value)
            print("iwant : \(json)")
            print("iwant : \(json["results"])")
            self.boardData = MDDetailCategorySet(rawJson: json)
            
            self.postNotification(postName: Notification.Name.DraggableModel.changedLists)
        }
    }

    func loadMoreCard(){
        guard boardData != nil else { return }
        guard boardData.nextUrl != nil else { return }
        guard boardData.nextUrl != "" else { return }
        
        Alamofire.request(boardData.nextUrl!).responseJSON { response in
            let json = JSON(response.result.value)
            print("iwant : \(json)")
            print("iwant : \(json["results"])")
            self.boardData = MDDetailCategorySet(rawJson: json)
            
            self.postNotification(postName: Notification.Name.DraggableMoreModel.changedLists)
        }
    }
    
    func postNotification(postName:Notification.Name){
        var modelInfo = Dictionary<String, Any>()
        modelInfo = ["nextURL":boardData.nextUrl ?? "","dataArr":boardData.categoryDetailList]
        NotificationCenter.default.post(name: postName, object: modelInfo)
    }
}
