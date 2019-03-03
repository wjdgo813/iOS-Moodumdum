//
//  MDAPIManager.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 4. 15..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON
import Toaster

class MDAPIManager{
    static let sharedManager = MDAPIManager()
    let api_url = "http://13.125.76.112/"
    
    private init() {
        
    }
    
    /*
     사용자의 기기가 회원가입이 되어있는지 체크
     */
    func isRegisterUser(completion:@escaping (_ result : Int)->(Void)){
        
        Alamofire.request("\(api_url)api/user/\(MDDeviceInfo.getCurrentDeviceID())",method:.get).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                completion(response.response?.statusCode ?? 0)
            case .failure(let error):
                completion(response.response?.statusCode ?? 0)
            }
        }
    }
    
    /*
     해당 board의 댓글 리스트 호출
     */
    func requestCommentInfo(commentId : String, completion:@escaping (_ result : JSON)->(Void)) {
        Alamofire.request("\(api_url)api/board/search/comment/\(commentId)?user=\(MDDeviceInfo.getCurrentDeviceID())").responseJSON { response in
            let json = JSON(response.result.value)
            completion(json)
        }
    }
    
    /*
     해당 게시글에 댓글 등록
     */
    func requestRegisterReply(parameters:Parameters,completion:@escaping (_ result : JSON)->(Void)){
        Alamofire.request("http://13.125.76.112/api/board/comment/?user=\(MDDeviceInfo.getCurrentDeviceID())",method:.post,parameters:parameters).validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    /*
     해당 board의 좋아요
     */
    func reqeustBoardLike(parameters:Parameters,completion:@escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(api_url)api/board/like/",method:.post,parameters:parameters).validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    /*
     해당 board 좋아요 취소
     */
    func requestRemoveLike(boardID:String,completion:@escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(api_url)api/board/like/\(MDDeviceInfo.getCurrentDeviceID())/\(boardID)",method:.delete).validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    
    /*
     글쓰기에 등록할 이미지 배경 불러오기
     */
    func requestWriteBackgroundImageList(completion:@escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(api_url)api/boardimage?limit=30").responseJSON { response in
            let json = JSON(response.result.value)
            print("write background image list : \(json)")
            completion(json)
        }
    }
    
    /*
     글쓰기에 등록할 이미지 더 불러오기
     */
    func requestMoreWriteBackgroundImageList(url:String,completion:@escaping (_ result : JSON)->(Void)){
        Alamofire.request(url).responseJSON { response in
            let json = JSON(response.result.value)
            print("write background image list : \(json)")
            completion(json)
        }
    }
    
    
    /*
     글쓰기 제출하기 api
     */
    func writeSubmit(parameters:Parameters,completion:@escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(api_url)api/board/?user=\(MDDeviceInfo.getCurrentDeviceID())",method:.post,parameters:parameters).validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                Toast(text: "글이 등록되었습니다.", duration: Delay.long).show()
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    /*
     글 삭제하기 api
     */
    func deleteBoard(board_id:String,completion:@escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(api_url)api/board/\(board_id)",method:.delete).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                Toast(text: "묻은 기억이 삭제 되었습니다.", duration: Delay.long).show()
                let json = JSON(response.result.value)
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    func deleteComment(commentId : String,completion:@escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(api_url)api/board/comment/\(commentId)/?user=\(MDDeviceInfo.getCurrentDeviceID())",method:.delete).validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    
    /*
     글 상세보기 데이터 가져오기.
     */
    func requestBoardInfo(boardId:String,completion:@escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(api_url)api/board/\(boardId)/?user=\(MDDeviceInfo.getCurrentDeviceID())").validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                print("BoardInfo : \(json)")
                completion(json)
                
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    /*
     내가 쓴 글 조회하는 api
     */
    func requestBoardSelfWriteBoardList(completion: @escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(api_url)api/board/search/user/\(MDDeviceInfo.getCurrentDeviceID())").validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    
    /*
     내가 쓴 글 조회하는 더 불러오는 api
     */
    func requestBoardSelfMoreBoardList(nextUrl : String,completion: @escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(nextUrl)").validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    /*
     내가 좋아요 누른 글 조회하는 api
     */
    func requestBoardSelfLikeBoardList(completion: @escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(api_url)api/board/user/like/\(MDDeviceInfo.getCurrentDeviceID())").validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    
    /*
     닉네임 변경 요청 api
     */
    func requestChangeNickname(nickname : String,completion: @escaping (_ result : JSON)->(Void)){
        let parameters: Parameters = [
            "user" : MDDeviceInfo.getCurrentDeviceID(),
            "name" : nickname,
            ]
        
        Alamofire.request("\(api_url)api/user/\(MDDeviceInfo.getCurrentDeviceID())/",method:.put,parameters:parameters).validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    /*
     신고하기 API
     @param
     user : 신고 유저
     title : 신고사유
     description : 글 내용
     board_id : id(pk)
     */
    func requestDeclare(parameters : Parameters,completion: @escaping (_ result : JSON)->(Void)){
        Alamofire.request("\(api_url)api/declare/",method:.post,parameters:parameters).validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    
    func requestBlockUser(blockUser:String,completion: @escaping (_ result : JSON)->(Void)){
        
        let parameter : Parameters = ["from_user":MDDeviceInfo.getCurrentDeviceID(),
                                      "to_user":blockUser]
        
        Alamofire.request("\(api_url)api/block/user",method:.post,parameters:parameter).validate(statusCode: 200..<300).responseJSON { response in
            let json = JSON(response.result.value)
            switch response.result {
            case .success:
                completion(json)
                break
            case .failure:
                self.showFailMessage()
                break
            }
        }
    }
    
    
    func showFailMessage(){
        Toast(text: "네트워크에 문제가 있습니다. 네트워크 상태를 확인해주세요.", duration: Delay.long).show()
    }
    
    func showBlockMessage(){
        Toast(text: "이용 정지된 유저입니다. 문의 사항은 개발팀에게 연락 부탁드립니다.", duration: Delay.long).show()
    }
}
