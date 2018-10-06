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
            backgroundColor = isSelected ? UIColor(red: 149/256, green: 210/256, blue: 107/256, alpha: 1.0) : UIColor.darkGray
            topicTitleLabel.textColor = isSelected ? UIColor.darkGray : UIColor.white
        }
    }
    
    
//    func configureCell(topic: ArticleTopic, initialCell: Bool){
    func configureCell(topic: ArticleTopic) {
//        if initialCell {self.isSelected = true}
        topicTitleLabel.text = topic.rawValue.capitalized
        topicImageView.image = UIImage(named: topic.rawValue)
    }
}
