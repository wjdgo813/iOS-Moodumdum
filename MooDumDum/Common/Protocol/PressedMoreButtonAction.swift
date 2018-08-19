//
//  MoreProtocol.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 7. 17..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
import Toaster


protocol PressedMoreButtonAction where Self : UIViewController{
    var detailData : MDDetailCategoryData? {get set}
    var navigationController: UINavigationController? { get }
    var viewController : UIViewController {get set}
    func deleteAction()
}

extension PressedMoreButtonAction{
    func deleteAction(){
        let deleteAlert = UIAlertController(title: "글 삭제", message: "내가 묻은 기억을 지워버리시겠어요?", preferredStyle: .alert)
        let deleteConfirmButton = UIAlertAction(title: "네", style: .default, handler: { (result) in
            MDAPIManager.sharedManager.deleteBoard(board_id: (self.detailData?.id)!, completion: { (result) -> (Void) in
                
                Toast(text: "묻은 기억이 삭제 되었습니다.", duration: Delay.long).show()
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MDWriteSubmit"), object: nil)
            })
        })
        let deleteCancelButton = UIAlertAction(title: "아니오", style: .default, handler: { (result) in
        })
        
        deleteAlert.addAction(deleteCancelButton)
        deleteAlert.addAction(deleteConfirmButton)
        
        self.navigationController!.present(deleteAlert, animated: true, completion: nil)
    }
    
    func blockUser(){
        let blockUserAlert = UIAlertController(title: "차단하기", message: "앞으로 이 사용자가 묻은 모든 기억을 받지 않으시겠습니까?", preferredStyle: .alert)
        
        let blockConfirmButton = UIAlertAction(title: "네", style: .default, handler: { (result) in
            MDAPIManager.sharedManager.requestBlockUser(blockUser: (self.detailData?.userObject.UUID)!, completion: { (result) -> (Void) in
                Toast(text: "이제부터 이 사용자의 모든 기억을 받지 않습니다.", duration: Delay.long).show()
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MDWriteSubmit"), object: nil)
                
            })
        })
        let deleteCancelButton = UIAlertAction(title: "아니오", style: .default, handler: { (result) in
        })
        
        
        blockUserAlert.addAction(deleteCancelButton)
        blockUserAlert.addAction(blockConfirmButton)
        
        
        self.navigationController!.present(blockUserAlert, animated: true, completion: nil)
        
    }
}



