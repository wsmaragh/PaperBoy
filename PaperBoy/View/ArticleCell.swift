//
//  ArticleCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

@objc protocol ArticleCellDelegate {
    @objc func savePressed()
    @objc func sharePressed()
}


class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    weak var delegate: ArticleCellDelegate?

    static let id = "ArticleCell"
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    public func configureCell(article: Article) {
        sourceLabel.text = article.source.name ?? "Topic"
        titleLabel.text = article.title
        descriptionLabel.text = article.description ?? ""
        
        if let author = article.author {
            authorLabel.text = "by \(author)"
        }
        else {
            authorLabel.text = "by: No Author"
        }
        
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
        } else {
            sender.setImage(UIImage(named: "button_star_empty"), for: .normal)
        }
    }

    
    @IBAction func sharePressed(_ sender: UIButton) {
        delegate?.sharePressed()
    }
    
}
