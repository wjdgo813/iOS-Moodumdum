//
//  MDDeclareViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 7. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MDDeclareViewController: UIViewController {

    @IBOutlet weak var selectDeclareReason: UIButton!
    @IBOutlet weak var reportContentTextView: UITextView!
    @IBOutlet weak var sendReportButton: UIButton!
    var board_id : String?
    private var reasonString : String = "" {
        didSet{
            self.selectDeclareReason.setTitle(self.reasonString, for: UIControlState.normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendReportButton.layer.cornerRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func dismissDeclareButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pressedSelectReason(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        let delcareReason = UIAlertAction(title: "음란성 글", style: .default, handler: { (action) -> Void in
            self.reasonString = "음란성 글"
        })
        
        let delcareReason2 = UIAlertAction(title: "광고성 글", style: .default, handler: { (action) -> Void in
            self.reasonString = "광고성 글"
        })
        
        let delcareReason3 = UIAlertAction(title: "부적절한 언행", style: .default, handler: { (action) -> Void in
            self.reasonString = "부적절한 글"
        })
        
        let delcareReason4 = UIAlertAction(title: "상대방을 모함하는 내용", style: .default, handler: { (action) -> Void in
            self.reasonString = "상대방을 모함하는 내용"
        })
        
        let delcareReason5 = UIAlertAction(title: "직접적인 상호/타인 언급", style: .default, handler: { (action) -> Void in
            self.reasonString = "직접적인 상호/타인 언급"
        })
        
        let delcareReason6 = UIAlertAction(title: "기타(개인 작성)", style: .default, handler: { (action) -> Void in
            self.reasonString = "기타(개인 작성)"
        })
        
        alertController.addAction(cancelButton)
        alertController.addAction(delcareReason)
        alertController.addAction(delcareReason2)
        alertController.addAction(delcareReason3)
        alertController.addAction(delcareReason4)
        alertController.addAction(delcareReason5)
        alertController.addAction(delcareReason6)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func pressedReport(_ sender: Any) {
        guard reasonString != "" else {
            let alertController = UIAlertController(title: "", message: "신고 사유를 선택해주세요.", preferredStyle: .alert)
            let confirmAlert = UIAlertAction(title: "확인", style: .default, handler: { (result) in
            
            })
            
            alertController.addAction(confirmAlert)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        /*
        user : 신고 유저
        title : 신고사유
        description : 글 내용
        board_id : id(pk)
        */
        
        let parameters: Parameters = [
            "user": MDDeviceInfo.getCurrentDeviceID(),
            "title":reasonString,
            "description":(self.reportContentTextView.text)!,
            "board_id":self.board_id ?? ""
        ]
        
        MDAPIManager.sharedManager.requestDeclare(parameters: parameters) { (result) -> (Void) in
            let alertController = UIAlertController(title: "신고 접수 완료", message: "신고가 접수되었습니다.\n서비스 이용에 불편함을 드려서 죄송합니다.\n\n빠른 시일 내에 개발팀이 해당 컨텐츠를 확인 후 조치를 취하겠습니다.\n\n 감사합니다!", preferredStyle: .alert)
            let confirmAlert = UIAlertAction(title: "눈감아드리죠.", style: .default, handler: { (result) in
                self.dismiss(animated: true, completion: {
                    
                })
            })
            
            alertController.addAction(confirmAlert)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
}
