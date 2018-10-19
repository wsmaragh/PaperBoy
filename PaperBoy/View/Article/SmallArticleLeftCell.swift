//
//  SmallArticleCellLeft.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/29/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class SmallArticleLeftCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    weak var delegate: ArticleCellDelegate?
    
    static var cellID: String {
        return String(describing: self)
    }
    
    weak var article: Article?
    
    override func awakeFromNib(){
        super.awakeFromNib()
        articleImageView.layer.cornerRadius = 10
        articleImageView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text  = nil
        articleImageView.image = nil
        sourceLabel.text  = nil
        timeLabel.text  = nil
    }
    
    public func configureCell(article: Article, hideButtons: Bool) {
        if hideButtons {
            saveButton.isHidden = true
            shareButton.isHidden = true
        }
        
        self.article = article
        titleLabel.text = article.title
        articleImageView.loadImage(imageURLString: article.imageStr, defaultImageStr: "newspaper")
        sourceLabel.text = article.source._rlmInferWrappedType().name
        timeLabel.text = (article.dateStr != nil) ? DateFormatterService.shared.getCustomDateTimeAgoForArticleCell(dateStr: article.dateStr!) : ""
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
