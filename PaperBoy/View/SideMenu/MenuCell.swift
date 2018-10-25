//
//  MenuCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/6/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import AlamofireImage


class MenuCell: UITableViewCell {

    @IBOutlet weak var menulabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    
    static var cellID: String {
        return String(describing: self)
    }
    
    func configureCell(menuItem: String){
        menulabel.text = menuItem
        loadImage(imageView: menuImageView, imageString: menuItem)
    }
    
    private func loadImage(imageView: UIImageView, imageString: String, defaultImageStr: String = "station"){
        imageView.loadImage(imageURLString: imageString, defaultImageStr: "noImage")
    }

}
