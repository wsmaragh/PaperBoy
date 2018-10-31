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
    }
    
    func removeCustomSkeleton() {
        isUserInteractionEnabled = true
        articleImageView.backgroundColor = backgroundColor
        sourceLabel.backgroundColor = backgroundColor
        timeLabel.backgroundColor = backgroundColor
        titleLabel.backgroundColor = backgroundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        timeLabel.text = (article.dateStr != nil) ? Date.timeAgoSinceDate(dateString: article.dateStr!) : ""
        removeCustomSkeleton()
    }
    
    @IBAction private func savePressed(_ sender: UIButton) {
        if let article = self.article {
            delegate?.savePressed(article: article)
        }
    }
    
    @IBAction private func sharePressed(_ sender: UIButton) {
        if let article = self.article {
            delegate?.sharePressed(article: article)
        }
    }
    
}
