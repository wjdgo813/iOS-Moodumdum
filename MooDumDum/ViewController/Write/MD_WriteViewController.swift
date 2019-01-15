//
//  WriteViewController.swift
//  MooDumDum
//
//  Created by 김혜리 on 2018. 2. 3..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MD_WriteViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var WriteText: UITextView!
    @IBOutlet weak var buttonNext: UIBarButtonItem!
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var containerViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var categortCollectionview: UICollectionView!
    
    var placeholderLabel : UILabel!
    var category : Int = 2
    var nickname : String = ""
    let screenSize: CGRect = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()

        WriteText.delegate = self
        WriteText.becomeFirstResponder()
        
        
        initPlaceholderLabel()
        
        self.categortCollectionview.register(UINib(nibName: "MDWirteCategorySlideCell", bundle: nil), forCellWithReuseIdentifier: "MDWirteCategorySlideCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategoryNumber(notification:)), name: NSNotification.Name(rawValue: "updateCategoryNumber"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavi()
    }
    
    
    func initPlaceholderLabel(){
        placeholderLabel = UILabel()
        placeholderLabel.text = "당신의 잊고 싶은 기억, 여기에 적어두세요."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (WriteText.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        WriteText.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (WriteText.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !WriteText.text.isEmpty
    }
    
    
    private func setupNavi(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        
        if self.WriteText.text.isEmpty{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "cancel"), style: .plain , target: self, action: #selector(exitButton))
        self.navigationItem.leftBarButtonItem = leftItem
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.tintColor = UIColor.black;
    }
    
    
    
    //다음 버튼 눌렀을 경우 사진 선택
    @IBAction func WriteSave(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "pickPhoto", sender: self)
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
    
    
    @objc func updateCategoryNumber(notification:NSNotification) {
        let info = notification.object as! Dictionary<String,Any>
        category = (info["categoryNumber"] as? Int)! + 1
        
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            containerViewBottomConst.constant = keyboardHeight;
        }
        

    }
    
    @objc func exitButton() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension MD_WriteViewController : UICollectionViewDelegateFlowLayout{
    
    
}
extension MD_WriteViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
   
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MDWirteCategorySlideCell", for: indexPath) as? MDWirteCategorySlideCell
        cell?.slideCollectionView = MDWriteSlideCollectionViewController()
        cell?.slideCollectionView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        cell?.slideCollectionView?.categoryNumber = category - 1
        cell?.addSubview((cell?.slideCollectionView?.view)!)
        return cell!
        
    }
    
    
}
extension MD_WriteViewController : UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 48)
    }
}
