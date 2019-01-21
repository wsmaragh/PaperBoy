//
//  UpdatedHeaderView.swift
//  PaperBoy
//
//  Created by Winston Maragh on 11/8/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

final class UpdatedHeaderView: UITableViewHeaderFooterView {
    
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
