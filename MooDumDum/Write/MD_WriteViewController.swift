//
//  WriteViewController.swift
//  MooDumDum
//
//  Created by 김혜리 on 2018. 2. 3..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MD_WriteViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var WriteText: UITextView!
    @IBOutlet weak var buttonNext: UIBarButtonItem!
    
    var placeholderLabel : UILabel!
    var category : Int = 2
    var nickname : String = ""
    let screenSize: CGRect = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        WriteText.delegate = self
        WriteText.becomeFirstResponder()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let leftItem = UIBarButtonItem(image: UIImage(named: "cancel"), style: .plain , target: self, action: #selector(exitButton))
        self.navigationItem.leftBarButtonItem = leftItem
        UIApplication.shared.statusBarStyle = .default
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "당신의 잊고 싶은 기억, 여기에 적어두세요."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (WriteText.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        WriteText.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (WriteText.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !WriteText.text.isEmpty
        
        scrollView.contentSize = CGSize(width: btn6.frame.origin.x + 85, height: scrollView.frame.height)
        //self.contentSize = NSLayoutConstraint(btn6.frame.origin.x + 85)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    //다음 버튼 눌렀을 경우 사진 선택
    @IBAction func WriteSave(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "pickPhoto", sender: self)
    }
    
    var checked1 = false
    var checked2 = false
    var checked3 = false
    var checked4 = false
    var checked5 = false
    var checked6 = false
    
    @IBAction func Button1(_ sender: UIButton) {
        self.category = 4
        if checked1 {
            self.btn1.setImage(UIImage(named: "relationshipUnact"), for: .normal)
            checked1 = false
        } else {
            self.btn1.setImage(UIImage(named: "relationshipAct"), for: .normal)
            checked1 = true
        }
        if (checked1 == checked2 && checked2 == true) {
            self.Button2(btn2)
        }else if(checked1 == checked3 && checked3 == true){
            self.Button3(btn3)
        }else if(checked1 == checked4 && checked4 == true){
            self.Button4(btn4)
        }else if(checked1 == checked5 && checked5 == true) {
            self.Button5(btn5)
        }else if(checked1 == checked6 && checked6 == true){
            self.Button6(btn6)
        }
      
    }
    @IBAction func Button2(_ sender: Any) {
        self.category = 3
        if checked2 {
            self.btn2.setImage(UIImage(named: "familyUnact"), for: .normal)
            checked2 = false
        } else {
            self.btn2.setImage(UIImage(named: "familyAct"), for: .normal)
            checked2 = true
        }
        
        if (checked2 == checked1 && checked1 == true) {
            self.Button1(btn1)
        }else if(checked2 == checked3 && checked3 == true){
            self.Button3(btn3)
        }else if(checked2 == checked4 && checked4 == true){
            self.Button4(btn4)
        }else if(checked2 == checked5 && checked5 == true) {
            self.Button5(btn5)
        }else if(checked2 == checked6 && checked6 == true){
            self.Button6(btn6)
        }
    }
    @IBAction func Button3(_ sender: Any) {
        self.category = 6
        if checked3 {
            self.btn3.setImage(UIImage(named: "jobUnact"), for: .normal)
            checked3 = false
        } else {
            self.btn3.setImage(UIImage(named: "jobAct"), for: .normal)
            checked3 = true
        }
        
        if (checked3 == checked2 && checked2 == true) {
            self.Button2(btn2)
        }else if(checked3 == checked3 && checked1 == true){
            self.Button1(btn1)
        }else if(checked3 == checked4 && checked4 == true){
            self.Button4(btn4)
        }else if(checked3 == checked5 && checked5 == true) {
            self.Button5(btn5)
        }else if(checked3 == checked6 && checked6 == true){
            self.Button6(btn6)
        }
    }
    @IBAction func Button4(_ sender: Any) {
        self.category = 5
        if checked4 {
            self.btn4.setImage(UIImage(named: "selfEsteemUnact"), for: .normal)
            checked4 = false
        } else {
            self.btn4.setImage(UIImage(named: "selfEsteemAct"), for: .normal)
            checked4 = true
        }
        
        if (checked4 == checked2 && checked2 == true) {
            self.Button2(btn2)
        }else if(checked4 == checked3 && checked3 == true){
            self.Button3(btn3)
        }else if(checked4 == checked4 && checked1 == true){
            self.Button1(btn1)
        }else if(checked4 == checked5 && checked5 == true) {
            self.Button5(btn5)
        }else if(checked4 == checked6 && checked6 == true){
            self.Button6(btn6)
        }
    }
    @IBAction func Button5(_ sender: Any) {
        self.category = 1
        if checked5 {
            self.btn5.setImage(UIImage(named: "darkHistoryUnact"), for: .normal)
            checked5 = false
        } else {
            self.btn5.setImage(UIImage(named: "darkHistoryAct"), for: .normal)
            checked5 = true
        }
        
        if (checked5 == checked2 && checked2 == true) {
            self.Button2(btn2)
        }else if(checked5 == checked3 && checked3 == true){
            self.Button3(btn3)
        }else if(checked5 == checked4 && checked4 == true){
            self.Button4(btn4)
        }else if(checked5 == checked5 && checked1 == true) {
            self.Button1(btn1)
        }else if(checked5 == checked6 && checked6 == true){
            self.Button6(btn6)
        }
    }
    @IBAction func Button6(_ sender: Any) {
        print("ect")
        self.category = 2
        if checked6 {
            self.btn6.setImage(UIImage(named: "etc_unact"), for: .normal)
            checked6 = false
        } else {
            self.btn6.setImage(UIImage(named: "ect_act"), for: .normal)
            checked6 = true
        }
        
        if (checked6 == checked2 && checked2 == true) {
            self.Button2(btn2)
        }else if(checked6 == checked3 && checked3 == true){
            self.Button3(btn3)
        }else if(checked6 == checked4 && checked4 == true){
            self.Button4(btn4)
        }else if(checked6 == checked5 && checked5 == true) {
            self.Button5(btn5)
        }else if(checked6 == checked1 && checked1 == true){
            self.Button1(btn1)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        guard let pto = dest as? MDPickPhotoViewController else { return }
        pto.textview = self.WriteText.text!
        pto.category = self.category
    }

    func textViewDidChange(_ WriteText: UITextView) {
        placeholderLabel.isHidden = !WriteText.text.isEmpty
        if WriteText == self.WriteText {
            if WriteText.text.isEmpty{
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }else{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomMargin.constant = keyboardHeight
        }
        

    }
    
    @objc func exitButton() {
        navigationController?.popViewController(animated: true)
    }
}
