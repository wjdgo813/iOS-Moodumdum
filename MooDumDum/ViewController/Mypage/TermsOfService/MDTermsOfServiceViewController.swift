//
//  MDTermsOfServiceViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 15/01/2019.
//  Copyright © 2019 MooDumdum. All rights reserved.
//

import UIKit

enum MDServiceType{
    case termsOfService(String,String)
    case privacyPolicy(String,String)
}

class MDTermsOfServiceViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UITextView!
    var type : MDServiceType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let type = self.type else {
            return
        }
        
        switch type {
        case .privacyPolicy(let title, let content):
            self.titleLabel.text = title
            self.contentView.text = content
        case .termsOfService(let title, let content):
            self.titleLabel.text = title
            self.contentView.text = content
        }
//        self.title = "사용자 약관동의"
        
    }

    @IBAction func pressedClosed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
