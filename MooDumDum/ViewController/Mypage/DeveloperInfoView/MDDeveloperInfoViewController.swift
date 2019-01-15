//
//  MDDeveloperInfoViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 7. 11..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MDDeveloperInfoViewController: UIViewController {
    @IBOutlet weak var infoTableView: UITableView!
    fileprivate var nameArray: [String]?
    fileprivate var emailArray: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "연락처"
        
        self.infoTableView.register(UINib.init(nibName:"MDDeveloperTableViewCell",bundle:nil), forCellReuseIdentifier: "MDDeveloperTableViewCell")
        self.infoTableView.isScrollEnabled = false
        self.infoTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.infoTableView.allowsSelection = false
        
        nameArray = ["정해현","이주연","인정민","김소연","장호동"]
        emailArray = ["wjdgo50@gmail.com","dprocess@naver.com","wud4510@gmail.com","ese2003@naver.com","jhd9206@gmail.com"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MDDeveloperInfoViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
    
}

extension MDDeveloperInfoViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let reuseCell : MDDeveloperTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "MDDeveloperTableViewCell") as? MDDeveloperTableViewCell)!
        reuseCell.nameLabel.text = nameArray?[indexPath.row]
        reuseCell.emailLabel.text = emailArray?[indexPath.row]
        
        if indexPath.row == (nameArray?.count)!-1 {
            reuseCell.lineView.isHidden = true
        }
        return reuseCell
    }
    
    
}
