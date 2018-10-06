//
//  ContainerVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController {

    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    var sideMenuOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        addMyObservers()
    }
    
    deinit {
        removeMyObservers()
    }
    
    private func addMyObservers(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name("ToggleSideMenu"),
                                               object: nil)
    }
    
    private func removeMyObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc func toggleSideMenu() {
        sideMenuConstraint.constant = sideMenuOpen ? -200 : 0
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
        sideMenuOpen = !sideMenuOpen
    }
}
