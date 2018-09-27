//
//  SmallArticleCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class SmallArticleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    static let id = "SmallArticleCell"

    public func configureCell(article: Article) {
        titleLabel.text = article.title
        
        if let dateString = article.publishedAt {
            let date = DateFormatterService.shared.getDate(from: dateString, inputDateStringFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
            let formattedDateString = DateFormatterService.shared.timeAgoSinceDate(date)
            timeLabel.text = formattedDateString
        }
        else {
            timeLabel.text = "-----"
        }
        
        //        articleImageView.image =
    }

    
    @IBAction func savePressed(_ sender: UIButton) {
        if sender.image(for: .normal) == UIImage(named: "button_star_empty") {
            sender.setImage(UIImage(named: "button_star_filled"), for: .normal)
            print("Adding to saves")
        } else {
            sender.setImage(UIImage(named: "button_star_empty"), for: .normal)
            print("Removing from saves")
        }
    }
    
    
    @IBAction func sharePressed(_ sender: UIButton) {
        print("Share Pressed")
    }
    
    
    
    
}
