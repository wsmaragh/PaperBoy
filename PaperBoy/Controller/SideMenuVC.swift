//
//  SideMenuVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


protocol SideMenuVCDelegate {
    func didSelectMenuItem(_ menuItem: Int)
}


class SideMenuVC: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    var menuItems = MenuItem.allCases
    
    enum MenuItem: String {
        case Article
        case Video
        case Radio
        case Profile
        
        static var allCases: [MenuItem] {
            return [.Article, .Video, .Radio, .Profile]
        }
    }
    
    var delegate: SideMenuVCDelegate?

    override func viewDidLoad() {
        setupTableView()
    }
    
    func setupTableView(){
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
}


extension SideMenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.id, for: indexPath) as! MenuCell
        let menuItem = menuItems[indexPath.row].rawValue
        cell.configureCell(menuItem: menuItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension SideMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Pressed", self.menuItems[indexPath.row])
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
}

