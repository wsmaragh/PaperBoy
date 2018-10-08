//
//  TopicCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class TopicCell: UICollectionViewCell {
    
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var topicTitleLabel: UILabel!
    
    static let id = "TopicCell"
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.appYellow : UIColor(red: 199/255, green: 199/255, blue: 199/255, alpha: 1.0)
            topicTitleLabel.textColor = isSelected ? UIColor.darkGray : UIColor.lightGray
        }
    }
    
    func configureCell(topic: ArticleTopic) {
        topicTitleLabel.text = topic.rawValue.capitalized
        topicImageView.image = UIImage(named: topic.rawValue)
    }
}
