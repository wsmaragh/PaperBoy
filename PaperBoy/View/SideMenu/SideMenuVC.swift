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
    
    @IBOutlet weak var linkedInButton: UIButton!
    
    
    @IBAction func linkedInButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "https://www.linkedin.com/in/wsmaragh/"){
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func githubButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "https://github.com/wsmaragh"){
            UIApplication.shared.open(url)
        }
    }
    
    enum MenuItem: String {
        case Article
        case Video
        case Radio
        case Games
        
        static var allCases: [MenuItem] {
            return [.Article, .Video, .Radio, .Games]
        }
    }
    
    var menuItems = MenuItem.allCases
    
    var selectionDelegate: SideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        addLeftSwipeGestureToSideMenu()
    }
    
    private func setupTableView(){
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    private func setupNavBar(){
        if let image = UIImage(named: "githubLogo") {
            let imageView = UIImageView(image: image)
            
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 44))
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)
            
            self.navigationItem.titleView = titleView
        }
        
    }
    
    private func addLeftSwipeGestureToSideMenu() {
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(slideToMenu))
        swipeGesture.direction = .left
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func slideToMenu(){
        NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.toggleSideMenu.rawValue), object: nil)
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sections"
    }
}


extension SideMenuVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionDelegate?.selectedTabIndex(index: indexPath.row)
        slideToMenu()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
