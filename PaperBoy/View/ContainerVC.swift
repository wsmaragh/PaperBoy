//
//  ContainerVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

final class ContainerVC: UIViewController {

    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    
    var sideMenuOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        addMyObservers()
    }
    
    deinit {
        removeMyObservers()
    }
    
    private func addMyObservers(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleSideMenu),
            name: NSNotification.Name(NotificationNames.toggleSideMenu.rawValue),
            object: nil)
    }
    
    private func removeMyObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func toggleSideMenu() {
        sideMenuLeadingConstraint.constant = sideMenuOpen ? -350 : 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        sideMenuOpen = !sideMenuOpen
    }
    
    private weak var mainTabBarVC: UITabBarController? {
        didSet {
            mainTabBarVC?.tabBar.isHidden = true
        }
    }
    
    private weak var sideMenuVC: SideMenuVC? {
        didSet {
            sideMenuVC?.selectionDelegate = self
        }
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardIDs.containerToMainTabBarVC.rawValue {
            if let mainTab = segue.destination as? UITabBarController {
                self.mainTabBarVC = mainTab
            }
        }
        if segue.identifier == StoryboardIDs.containerToSideMenuVC.rawValue {
            if let sideMenuNav = segue.destination as? UINavigationController {
                self.sideMenuVC = sideMenuNav.viewControllers.first as? SideMenuVC
            }
        }
    }
    
}


extension ContainerVC: SideMenuDelegate {
    
    func selectedTabIndex(index: Int) {
        mainTabBarVC?.selectedIndex = index
    }
    
}
