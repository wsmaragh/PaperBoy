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
    weak var article: Article?

    static var cellID: String {
        return String(describing: self)
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        roundedCorners()
        addCustomSkeleton()
    }
    
    private func roundedCorners() {
        articleImageView.layer.cornerRadius = 10
        articleImageView.layer.masksToBounds = true
    }
    
    func addCustomSkeleton() {
        isUserInteractionEnabled = false
        articleImageView.backgroundColor = UIColor.skeletonColor
        sourceLabel.backgroundColor = UIColor.skeletonColor
        timeLabel.backgroundColor = UIColor.skeletonColor
        titleLabel.backgroundColor = UIColor.skeletonColor
        authorLabel.backgroundColor = UIColor.skeletonColor
        descriptionLabel.backgroundColor = UIColor.skeletonColor
    }
    
    func removeCustomSkeleton() {
        isUserInteractionEnabled = true
        articleImageView.backgroundColor = backgroundColor
        sourceLabel.backgroundColor = backgroundColor
        timeLabel.backgroundColor = backgroundColor
        titleLabel.backgroundColor = backgroundColor
        authorLabel.backgroundColor = backgroundColor
        descriptionLabel.backgroundColor = backgroundColor
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureCell(article: Article) {
        self.article = article
        sourceLabel.text = article.source._rlmInferWrappedType().name
        titleLabel.text = article.title
        descriptionLabel.text = article.subtitle
        authorLabel.text = article.author != nil ? "by \(article.author!)" : ""
        articleImageView.loadImage(imageURLString: article.imageStr, defaultImageStr: "newspaper")
        timeLabel.text = (article.dateStr != nil) ? Date.timeAgoSinceDate(dateString: article.dateStr!) : ""
        removeCustomSkeleton()
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
