//
//  MD_LoadData.swift
//  MooDumDum
//
//  Created by hyerikim on 2018. 4. 19..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension MD_MyPageViewController {

    func dataLoad(url: String) {
        Alamofire.request(url).responseJSON {
            (response) in
            let result = response.result
            if let dict = result.value as? [String: AnyObject]{
                if let like = dict["like_count"] as? Int {
                    self.fetchedreceived = like
                    self.Received.text = String(self.fetchedreceived)
                }
                if let board = dict["board_count"] as? Int {
                    self.fetchedmypost = board
                    self.myPost.text = String(self.fetchedmypost)
                    
                }
            }
            DispatchQueue.main.async(){
                print("is ready for UI")
            }
        }
    }
}
