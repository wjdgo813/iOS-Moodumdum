//
//  NickNameViewController.swift
//  MooDumDum
//
//  Created by 김혜리 on 2018. 2. 10..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MD_NickNameViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var countNick: UILabel!
    @IBOutlet weak var NickTextField: UITextField!
    
    var user = MD_UserInfo()
    var nickname : String = ""
     let limitLength = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NickTextField.text = nickname
        NickTextField.delegate = self as UITextFieldDelegate
        let nickcount = nickname.characters.count
        self.countNick.text = "(\(nickcount)/10)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        if(newLength <= limitLength){
            self.countNick.text = "(\(limitLength - newLength)/10)"
        }
        return newLength <= limitLength
    }
    
    @IBAction func nickSave(_ sender: Any) {
        
        
        MDAPIManager.sharedManager.requestChangeNickname(nickname: self.NickTextField.text!) { (result) -> (Void) in
            UserDefaults.standard.set(self.NickTextField.text, forKey: "nickname")
//            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
