//
//  ViewController.swift
//  MooDumdum
//
//  Created by Haehyeon Jeong on 2018. 1. 28..
//  Copyright © 2018년 Haehyeon Jeong. All rights reserved.
//

import UIKit

class MDHomeViewController: UIViewController,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !MDSettingData.firstPullUpGuide() {
            let sb = UIStoryboard(name: "Home", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MDDescripViewController")
            vc.providesPresentationContextTransitionStyle = true;
            vc.definesPresentationContext = true;
            vc.modalPresentationStyle = UIModalPresentationStyle.custom
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    
        initNavigation()
        addPullUpController()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    private func addPullUpController() {
        guard
            let pullUpController = UIStoryboard(name: "Home", bundle: nil)
                .instantiateViewController(withIdentifier: "MDCardViewController") as? MDCardViewController
            else { return }
        
        addPullUpController(pullUpController)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //나중에 정리하자
    func initNavigation(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        UIApplication.shared.statusBarStyle = .default
        
        let myPageImage = UIImage(named: "mypage")?.withRenderingMode(.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: myPageImage, style: .plain, target: self, action: #selector(loadMyinfo))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        //category
        let categoryImage = UIImage(named: "categoryButton")?.withRenderingMode(.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: categoryImage, style: .plain, target: self, action: #selector(loadCategoryList))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
    
    @objc func loadMyinfo(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MD_MyPageViewController")
        
        let nav = UINavigationController(rootViewController: vc)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    
    @objc func loadCategoryList(){
        
        let sb = UIStoryboard(name: "MDCategoryList", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MDCategoryListViewController")
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.black;
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
}

