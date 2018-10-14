//
//  UIColor+.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


// MARK: UIColor

extension UIColor {
    static let appYellow = UIColor(red: 255/255, green: 255/255, blue: 75/255, alpha: 0.9)
    static let appYellow2 = UIColor(red: 229/255, green: 255/255, blue: 186/255, alpha: 0.9)
    static let appLightGray = UIColor(red: 199/255, green: 199/255, blue: 199/255, alpha: 1.0)
    static let appTableGray = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.9)
    
    static var randomColor: UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: 1)
    }
    
}
