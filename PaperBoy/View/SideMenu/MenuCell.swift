//
//  MenuCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

final class MenuCell: UITableViewCell {

    @IBOutlet weak var menulabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    
    static var cellID: String {
        return String(describing: self)
    }
    
    func configureCell(menuItem: String){
        menulabel.text = menuItem
        menuImageView.loadImage(imageURLString: menuItem, defaultImageStr: "noImage")
    }

}
