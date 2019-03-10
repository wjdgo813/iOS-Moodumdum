//
//  MDAgreeAlertViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 10/03/2019.
//  Copyright © 2019 MooDumdum. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class MDAgreeAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func pressedTermsOfService(_ sender: Any) {
        let vc = MDTermsOfServiceViewController(nibName: "MDTermsOfServiceViewController", bundle: nil)
        vc.type = .termsOfService("사용자 약관동의",String.termsOfServiceContent)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pressedPrivacyPolicy(_ sender: Any) {
        let vc = MDTermsOfServiceViewController(nibName: "MDTermsOfServiceViewController", bundle: nil)
        vc.type = .termsOfService("개인정보 처리방침",String.privacyPolicyContent)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func pressedAgreeButton(_ sender: Any) {
        UserDefaults.standard.set(getRandomNickName(), forKey: "nickname")
        let parameters: Parameters = [
            "user":MDDeviceInfo.getCurrentDeviceID(),
            "name":UserDefaults.standard.string(forKey: "nickname") ?? ""
        ]
        
        Alamofire.request("http://13.125.76.112/api/user/",method:.post,parameters:parameters).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result{
            case .success:
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "MDHomeViewController")
                self.present(UINavigationController(rootViewController: vc), animated: true, completion:nil)
                
                break
            case .failure:
                Toast(text: "알 수 없는 오류가 발생하였습니다. 잠시 후에 다시 시도해주세요.", duration: Delay.long).show()
                break
            }
        }
    }
    
    
    @IBAction func pressedCancelButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    private func getRandomNickName()->String{
        let nickNameArr = ["지나가는 영혼","상처받은 영혼","떠도는 영혼","배회하는 영혼","마음다친 영혼","녹초가 된 영혼","기진맥진 영혼","떠도는 영혼","가여운 영혼","굶주린 영혼","끄적이는 영혼","목마른 영혼"]
        let randomIndex = Int(arc4random_uniform(UInt32(nickNameArr.count)))
        
        return nickNameArr[randomIndex]
    }
    
}
