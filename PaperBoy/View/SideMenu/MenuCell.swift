//
//  MenuCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class MenuCell: UITableViewCell {

    @IBOutlet weak var menulabel: UILabel!
    @IBOutlet weak var menuImageV: UIImageView!
    
    static let id = "MenuCell"
    
    func configureCell(menuItem: String){
        menulabel.text = menuItem
        menuImageV.image = UIImage(named: menuItem)
    }


}
