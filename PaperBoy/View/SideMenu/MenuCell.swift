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
        loadImage(imageView: menuImageV, imageString: menuItem)
    }
    
    private func loadImage(imageView: UIImageView, imageString: String, defaultImageStr: String = "station"){
        if imageString.contains("http") {
            imageView.loadImage(imageURLString: imageString)
        } else if imageString != "" {
            imageView.image = UIImage(named: imageString)
        } else {
            imageView.image = UIImage(named: defaultImageStr)
        }
    }

}
