//
//  MDFirstContentViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 4. 10..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class MDFirstContentViewController: UIViewController {

    
    var descriptionText          : String?
    var pageIndex                  : Int!
    var firstImage                   : UIImage?
    var titleImage                   : UIImage?
    var termsOfButtonImage : UIImage?
    @IBOutlet weak var imageHeightConst: NSLayoutConstraint!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var termsOfServiceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageHeightConst.constant = self.view.frame.height * (3/5)
        firstImageView.image = firstImage
        titleImageView.image = titleImage
        termsOfServiceButton.setImage(termsOfButtonImage, for: .normal)
        self.descriptionLabel.text = descriptionText
        
        if pageIndex == 1 {
            self.startButton.isHidden = false
        }else{
            self.startButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startMoodumdum(_ sender: Any) {
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
    
    
    func getRandomNickName()->String{
        let nickNameArr = ["지나가는 영혼","상처받은 영혼","떠도는 영혼","배회하는 영혼","마음다친 영혼","녹초가 된 영혼","기진맥진 영혼","떠도는 영혼","가여운 영혼","굶주린 영혼","끄적이는 영혼","목마른 영혼"]
        let randomIndex = Int(arc4random_uniform(UInt32(nickNameArr.count)))
        
        return nickNameArr[randomIndex]
    }
    
    
    @IBAction func pressedTermOfService(_ sender: Any) {
        let vc = MDTermsOfServiceViewController(nibName: "MDTermsOfServiceViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
}
