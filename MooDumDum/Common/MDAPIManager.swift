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

class MDAPIManager{
    static let sharedManager = MDAPIManager()
    let api_url = "http://13.125.76.112:8000/"
    
    private init() {
        
    }
    
    /*
     사용자의 기기가 회원가입이 되어있는지 체크
     */
    func isRegisterUser(completion:@escaping (_ result : Bool)->(Void)){
        
        Alamofire.request("\(api_url)api/user/\(MDDeviceInfo.getCurrentDeviceID())/").validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                completion(false)
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
                completion(json)
                break
            case .failure:
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
                break
            }
        }
    }
    
}
