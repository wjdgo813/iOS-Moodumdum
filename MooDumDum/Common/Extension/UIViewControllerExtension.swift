//
//  UIViewControllerExtension.swift
//  MooDumDum
//
//  Created by JHH on 2018. 5. 15..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation

extension UIViewController {
    func hideKeyBoardAddGesture(){
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyBoard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard(){
        view.endEditing(true)
    }
}
