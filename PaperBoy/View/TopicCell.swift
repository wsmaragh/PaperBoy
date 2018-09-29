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
            backgroundColor = isSelected ? #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) : UIColor.darkGray
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
