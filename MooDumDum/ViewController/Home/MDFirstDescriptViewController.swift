//
//  MDFirstDescriptViewController.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 2018. 4. 10..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import UIKit

class MDFirstDescriptViewController: UIViewController,UIPageViewControllerDataSource {
    @IBOutlet weak var pageControls: UIPageControl!
    
    var pageViewController : UIPageViewController!
    var pageTitles : NSArray!
    private var pendingIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageTitles = ["안녕하세요!\n무덤덤에 오신 걸\n진심으로 환영해요.","당신의 잊고 싶은 순간,\n혼자 앓지 말아요.\n우리 모두가 애도해줄게요."]
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MDFirstPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        
        let startVC = self.viewControllerAtIndex(index:0) as MDFirstContentViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController] , direction: .forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
        view.bringSubview(toFront: pageControls)
        pageControls.numberOfPages = pageTitles.count
        pageControls.currentPage = 0
        
    }

    func viewControllerAtIndex (index : Int) -> MDFirstContentViewController {
        
        let vc : MDFirstContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MDFirstContentViewController") as! MDFirstContentViewController
        vc.pageIndex = index
        switch index {
        case 0:
            vc.descriptionText = (self.pageTitles[index] as? String)!
            vc.firstImage = UIImage(named: "firstBackground")
            vc.titleImage = UIImage(named: "titleImage")
        case 1:
            vc.descriptionText = (self.pageTitles[index] as? String)!
            vc.firstImage = UIImage(named: "firstBackground2")
            vc.titleImage = UIImage(named: "titleImage2")
        default: break
            
        }
        
        return vc
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! MDFirstContentViewController
        var index = vc.pageIndex as Int
        pageControls.currentPage = index
        if( index == NSNotFound) {
            return nil
        }
        
        index = index + 1
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index : index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! MDFirstContentViewController
        var index = vc.pageIndex as Int
        pageControls.currentPage = index
        if( index == 0 || index == NSNotFound) {
            return nil
        }
        
        index = index - 1
        
        return viewControllerAtIndex(index: index)

    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    

    
    
}
