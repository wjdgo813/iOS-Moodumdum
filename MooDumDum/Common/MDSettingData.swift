//
//  MDSettingData.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 5. 27..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation

class MDSettingData{
    
    class func setFirstPullUpGuide(enabled:Bool) {
        let pref = UserDefaults.standard
        pref.set(enabled, forKey: "firstPullUpGuide")
        pref.synchronize()
    }
    
    class func firstPullUpGuide() -> Bool {
        let pref = UserDefaults.standard
        if pref.bool(forKey: "firstPullUpGuide") {
            return pref.bool(forKey: "firstPullUpGuide")
        }else{
            return false
        }
    }
}
