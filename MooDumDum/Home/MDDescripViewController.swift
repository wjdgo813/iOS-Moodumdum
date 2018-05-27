//
//  MDDescripViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 5. 27..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MDDescripViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        MDSettingData.setFirstPullUpGuide(enabled: true)
        self.dismiss(animated: false, completion: nil)
    }
}
