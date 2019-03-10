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

    
    var descriptionText    : String?
    var pageIndex          : Int!
    var firstImage         : UIImage?
    var titleImage         : UIImage?
    
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
        let vc = MDAgreeAlertViewController(nibName: "MDAgreeAlertViewController", bundle: nil)
        vc.providesPresentationContextTransitionStyle = true;
        vc.definesPresentationContext = true;
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(vc, animated: false, completion: nil)
    }
    
    
    
}
