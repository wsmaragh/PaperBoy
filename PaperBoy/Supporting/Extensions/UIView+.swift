//
//  UIView+.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit.UIView

extension UIView {
    
    func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

}
