//
//  KingFisher+.swift
//  MooDumDum
//
//  Created by Haehyeon Jeong on 15/02/2019.
//  Copyright © 2019 MooDumdum. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func cacheSetImage(url : URL){
        self.kf.setImage(with: url,
                         placeholder: UIImage(named: ""),
                         options: [.transition(.fade(1)),
                                   .cacheOriginalImage
                                   ])
    }
}
