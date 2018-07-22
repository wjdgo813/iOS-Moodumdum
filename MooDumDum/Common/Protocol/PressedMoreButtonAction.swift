//
//  MoreProtocol.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 7. 17..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation

protocol PressedMoreButtonAction{
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
                self.viewController.dismiss(animated: true, completion: nil)
            })
        })
        let deleteCancelButton = UIAlertAction(title: "아니오", style: .default, handler: { (result) in
        })
        
        deleteAlert.addAction(deleteCancelButton)
        deleteAlert.addAction(deleteConfirmButton)
        
        self.navigationController!.present(deleteAlert, animated: true, completion: nil)
    }
}



