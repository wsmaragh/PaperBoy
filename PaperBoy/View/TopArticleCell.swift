//
//  TopArticleCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class TopArticleCell: UITableViewCell {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    
    
    static let id = "TopArticleCell"
    
    func configureCell(article: Article) {
        if let author = article.author {
            topicLabel.text = author
        }
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        
        if let dateString = article.publishedAt {
            let date = DateFormatterService.shared.getDate(from: dateString, inputDateStringFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
            let formattedDateString = DateFormatterService.shared.timeAgoSinceDate(date)
            timeLabel.text = formattedDateString
        }
        
        if let author = article.author {
            authorLabel.text = "by \(author)"
        }
        
    }
    
}

