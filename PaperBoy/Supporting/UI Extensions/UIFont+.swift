//
//  UIFont+.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/10/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit.UIFont

enum FontName: String {
    case didot = "Didot"
}

enum FontSize: Int {
    case maintTitle = 17
    case subTitle = 14
}

extension UIFont {
    convenience init?(fontName: FontName, fontSize: FontSize) {
        self.init(name: fontName.rawValue, size: CGFloat(fontSize.rawValue))
    }
}
