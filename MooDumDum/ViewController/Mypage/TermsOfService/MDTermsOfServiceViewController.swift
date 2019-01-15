//
//  MDTermsOfServiceViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 15/01/2019.
//  Copyright © 2019 MooDumdum. All rights reserved.
//

import UIKit

class MDTermsOfServiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "사용자 약관동의"
    }

    @IBAction func pressedClosed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
