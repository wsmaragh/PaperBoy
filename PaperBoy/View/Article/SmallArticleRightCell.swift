//
//  SmallArticleCell.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class SmallArticleRightCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    weak var delegate: ArticleCellDelegate?

    static let id = "SmallArticleRightCell"

    weak var article: Article?


    public func configureCell(article: Article, hideButtons: Bool) {
        if hideButtons {
            saveButton.isHidden = true
            shareButton.isHidden = true
        }
        self.article = article
        
        titleLabel.text = article.title
        sourceLabel.text = article.source._rlmInferWrappedType().name
        if let dateString = article.dateStr {
            timeLabel.text = DateFormatterService.shared.getCustomDateTimeAgoForArticleCell(dateStr: dateString)
        }
        else {
            timeLabel.text = ""
        }
        
        articleImageView.image = UIImage(named: "newspaper")
        if let imageURLStr = article.imageStr {
            articleImageView.loadImage(imageURLString: imageURLStr)
        }
        articleImageView.layer.cornerRadius = 10
        articleImageView.layer.masksToBounds = true
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
