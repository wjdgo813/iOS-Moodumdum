//
//  MDCategoryNoficationExtension.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 2. 22..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation
extension Notification.Name{
    
    /*
     CategoryList Notification
     */
    struct CategoryModel{
        static let changedLists:Notification.Name = Notification.Name("categoryModel")
    }
    
    struct CategoryViewModel {
        static let changedLists:Notification.Name = Notification.Name("categoryViewModel")
    }
    
    
    /*
     CategoryDetailList Notification
     */
    struct CategoryDetailModel{
        static let changedLists:Notification.Name = Notification.Name("categoryDetailModel")
    }
    
    struct CategoryDetailViewModel {
        static let changedLists:Notification.Name = Notification.Name("categoryDetailViewModel")
    }
    
    /*
     DraggableViewModel Notification
     */
    struct DraggableModel {
        static let changedLists:Notification.Name = Notification.Name("draggableModel")
    }
    
    struct DraggableMoreModel {
        static let changedLists:Notification.Name = Notification.Name("draggableMoreModel")
    }
    
    
    struct LikeBoardInfoNotiAtMyInfo {
        static let likeBoardInfoNotiAtMyInfo:Notification.Name = Notification.Name("likeBoardInfoNotiAtMyInfo")
    }
    
    
    
    
}
