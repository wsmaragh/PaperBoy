//
//  UpdatedCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

final class UpdatedCell: UITableViewCell {

    @IBOutlet weak var updatedLabel: UILabel!
    
    static var cellID: String {
        return String(describing: self)
    }
    
    func configureCell(date: Date){
        updatedLabel.text = DateFormatterService.shared.getUpdatedString(from: date)
    }
    
}
