//
//  MDSettingData.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 5. 27..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//


/*
 + (void)setFirstListPopupGuide:(BOOL)enabled
 {
 NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
 [prefs setBool:enabled forKey:@"firstListPopupGuide"];
 [prefs synchronize];
 
 }
 
 + (BOOL)firstListPopupGuide
 {
 NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
 
 if([prefs boolForKey:@"firstListPopupGuide"]) {
 return [prefs boolForKey:@"firstListPopupGuide"];
 } else {
 return NO;
 }
 }
 */
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
