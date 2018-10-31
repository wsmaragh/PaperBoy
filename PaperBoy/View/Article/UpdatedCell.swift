//
//  UpdatedCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class UpdatedCell: UITableViewCell {

    @IBOutlet weak var updatedLabel: UILabel!
    
    static var cellID: String {
        return String(describing: self)
    }
    
    func configureCell(date: Date){
        updatedLabel.text = DateFormatterService.shared.getUpdatedString(from: date)
    }
    
}


class UpdatedHeaderView: UITableViewHeaderFooterView {
    
    var date: Date!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(date: Date) {
        self.date = date
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = UIColor.lightGray
    }
}
