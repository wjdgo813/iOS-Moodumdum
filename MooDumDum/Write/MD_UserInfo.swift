//
//  UserInfo.swift
//  MooDumDum
//
//  Created by hyerikim on 2018. 4. 5..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import Alamofire

class MD_UserInfo {
    var user : String = ""
    var name : String = ""
    var profile_image : String = ""
    var URL = "http://13.125.76.112:8000/api/user/\(MDDeviceInfo.getCurrentDeviceID())/"

    init(){
        self.user = MDDeviceInfo.getCurrentDeviceID()
        self.name = UserDefaults.standard.string(forKey: "nickname")!
    }

    let param : [String: Any] = [
        "user" : MDDeviceInfo.getCurrentDeviceID(),
        "name" : UserDefaults.standard.string(forKey: "nickname")!,
    ]
    
    func load() {
        Alamofire.request("http://13.125.76.112/api/user/",method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { response in
            print("Result: \(response.result)")
            }
        }
    
    func put(putparam : [String:Any]) {
        print(URL)
        Alamofire.request(URL,method: .put, parameters: putparam, encoding: JSONEncoding.default).responseJSON{ response in
            print("Result: \(response.result)")            
        }
    }
    
    func delete() {
        Alamofire.request(URL,method: .delete, parameters: nil)
    }
}

