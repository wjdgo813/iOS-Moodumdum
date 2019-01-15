
//
//  MD_UrlString.swift
//  MooDumDum
//
//  Created by hyerikim on 2018. 4. 18..
//  Copyright © 2018년 MooDumdum. All rights reserved.
//

import Foundation

extension UIImageView{
    func setImageFromURl(stringImageUrl url: String){
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
