//
//  SideMenuVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


@objc protocol SideMenuDelegate {
    @objc func selectedTabIndex(index: Int)
}


class SideMenuVC: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    enum MenuItem: String {
        case Article
        case Video
        case Radio
        
        static var allCases: [MenuItem] {
            return [.Article, .Video, .Radio]
        }
    }
    
    var menuItems = MenuItem.allCases
    
    var selectionDelegate: SideMenuDelegate?

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


extension SideMenuVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionDelegate?.selectedTabIndex(index: indexPath.row)
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
}
