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
import Toaster

class RootRouter : MDCanShowAlert{
    func presentArticlesScreen(in window: UIWindow) {
        window.makeKeyAndVisible()
        
        MDAPIManager.sharedManager.isRegisterUser { result -> (Void) in
            if result == 404 {
                let sb = UIStoryboard(name: "Home", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "MDFirstDescriptViewController")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                    window.rootViewController = vc
                })
            } else if result == 403 {
                //이용 정지 유저
                let sb = UIStoryboard(name: "Home", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "MDFirstDescriptViewController")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                    window.rootViewController = vc
                    self.showAlert(title: "알림", message: "이용 정지된 유저입니다. 문의 사항은 개발팀에게 연락 부탁드립니다.", confirmButtonTitle: "확인", completion: {
                        exit(0)
                    })
                })
            }else {
                //닉네임이 있음.
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "MDHomeViewController")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                    window.rootViewController = UINavigationController(rootViewController: vc)
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
    
    private func showBlockMessage(){
        Toast(text: "이용 정지된 유저입니다. 문의 사항은 개발팀에게 연락 부탁드립니다.", duration: Delay.long).show()
    }
}
