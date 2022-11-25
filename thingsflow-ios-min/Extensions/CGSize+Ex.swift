//
//  CGSize+Ex.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit

extension CGSize {
    init(wp width: Pixel, hp height: Pixel) {
        let widthValue = Size.default.pixel(width)
        let heightValue = Size.default.pixel(height)
        
        self.init(width: widthValue, height: heightValue)
    }
}
