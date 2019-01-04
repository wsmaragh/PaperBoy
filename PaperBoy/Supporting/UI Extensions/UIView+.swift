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

    func pinToSuperview(top: CGFloat? = 0,
                        left: CGFloat? = 0,
                        bottom: CGFloat? = 0,
                        right: CGFloat? = 0) {
        guard let superView = superview else { fatalError("not in a view hierarchy") }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let t = top {
            topAnchor.constraint(equalTo: preservesSuperviewLayoutMargins
                ? superView.layoutMarginsGuide.topAnchor
                : superView.topAnchor, constant: t).isActive = true
        }
        
        if let b = bottom {
            bottomAnchor.constraint(equalTo: preservesSuperviewLayoutMargins
                ? superView.layoutMarginsGuide.bottomAnchor
                : superView.bottomAnchor, constant: -b).isActive = true
        }
        
        if let l = left {
            leadingAnchor.constraint(equalTo: preservesSuperviewLayoutMargins
                ? superView.layoutMarginsGuide.leadingAnchor
                : superView.leadingAnchor, constant: l).isActive = true
        }
        
        if let r = right {
            trailingAnchor.constraint(equalTo: preservesSuperviewLayoutMargins
                ? superView.layoutMarginsGuide.trailingAnchor
                : superView.trailingAnchor, constant: -r).isActive = true
        }
    }
    
    func pinToSuperview(withInsets insets: UIEdgeInsets) {
        pinToSuperview(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
    }
}
