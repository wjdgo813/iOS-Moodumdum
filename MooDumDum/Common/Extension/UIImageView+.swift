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
        let processor = ResizingImageProcessor(referenceSize: self.frame.size, mode: .aspectFill)
        self.kf.setImage(with: url,
                         placeholder: UIImage(named: ""),
                         options: [
                            .processor(processor),
                            .transition(.fade(1)),
                            .cacheOriginalImage
            ])
    }
}
