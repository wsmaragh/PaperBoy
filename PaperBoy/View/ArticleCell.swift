//
//  ArticleCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import RealmSwift


@objc protocol ArticleCellDelegate {
    @objc func savePressed(article: Article)
    @objc func sharePressed(article: Article)
}


class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    weak var delegate: ArticleCellDelegate?

    static let id = "ArticleCell"
    
    weak var article: Article?
    
    public func configureCell(article: Article) {
        self.article = article
        sourceLabel.text = article.source._rlmInferWrappedType().name
        titleLabel.text = article.title
        descriptionLabel.text = article.subtitle
        authorLabel.text = article.author != nil ? "by \(article.author!)" : ""
        articleImageView.image = UIImage(named: "newspaper")
        if let imageURLStr = article.imageStr {
            articleImageView.loadImage(imageURLString: imageURLStr)
        }        
        if let dateString = article.dateStr {
            timeLabel.text = DateFormatterService.shared.getCustomDateTimeAgoForArticleCell(dateStr: dateString)
        }
        else { timeLabel.text = ""}
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        if let article = self.article {
            delegate?.savePressed(article: article)
        }
    }
    
    @IBAction func sharePressed(_ sender: UIButton) {
        if let article = self.article {
            delegate?.sharePressed(article: article)
        }
    }
    
}
