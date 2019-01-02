//
//  UIViewController+.swift
//  PaperBoy
//
//  Created by winston on 1/2/19.
//  Copyright © 2019 Winston Maragh. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func dismissViewControllerWithAnimation(_ replacementController: UIViewController) {
        weak var window = UIApplication.shared.keyWindow
        let snapshotImageView = UIImageView(image: window?.snapshot())
        window?.rootViewController = replacementController
        replacementController.view.addSubview(snapshotImageView)
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            snapshotImageView.alpha = 0
        }, completion: { (_) -> Void in
            snapshotImageView.removeFromSuperview()
        })
    }
    
}
