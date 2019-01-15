//
//  RootRouter.swift
//  MooDumdum
//
//  Created by Haehyeon Jeong on 2018. 2. 10..
//  Copyright © 2018년 Haehyeon Jeong. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class RootRouter{
    func presentArticlesScreen(in window: UIWindow) {
        window.makeKeyAndVisible()
        
        MDAPIManager.sharedManager.isRegisterUser { result -> (Void) in
            if result {
                //닉네임이 있음.
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "MDHomeViewController")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                    window.rootViewController = UINavigationController(rootViewController: vc)
                })
            }else{
//                닉네임이 없음.
                let sb = UIStoryboard(name: "Home", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "MDFirstDescriptViewController")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                    window.rootViewController = vc
                })
            }
        }
        
        let splashVc = MDSplashViewController(nibName: "MDSplashViewController", bundle: nil)
        window.rootViewController = splashVc
    }
    
    @objc func loadMyinfo(){
        print("clicked!!")
    }
    
    @objc func loadCategoryList(){

        let sb = UIStoryboard(name: "MDCategoryListViewController", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MDCategoryListViewController")
        
        let rightBarButtonItem = UIBarButtonItem(title: "my info", style: .plain, target: self, action: #selector(loadMyinfo))
        vc.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        UIApplication.shared.delegate?.window??.rootViewController?.navigationController?.pushViewController(vc, animated: true)
        
    }
}
