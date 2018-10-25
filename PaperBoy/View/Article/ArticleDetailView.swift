//
//  DesignableXibView.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


@objc protocol ArticleViewDelegate {
    @objc func browserButtonPressed()
}


@IBDesignable
class ArticleDetailView: UIView {
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fullLabel: UILabel!
    @IBOutlet weak var browserButton: UIButton!
    
    var contentView: UIView?
    
    weak var delegate: ArticleViewDelegate?

    static var nibName: String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
        roundedCorners()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    private func roundedCorners() {
        browserButton.layer.cornerRadius = 8
        browserButton.layer.masksToBounds = true
    }
    
    private func setupXib() {
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView!)
    }
    
    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: ArticleDetailView.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public func configureView(article: Article){
        sourceLabel.text = article.source._rlmInferWrappedType().name
        titleLabel.text = article.title
        subtitleLabel.text = article.subtitle
        authorLabel.text = article.author != nil ? "by \(article.author!)" : ""
        articleImageView.loadImage(imageURLString: article.imageStr, defaultImageStr: "newspaper")
        fullLabel.text = (article.content != nil) ? article.content! : ""
        dateLabel.text = (article.dateStr != nil) ? DateFormatterService.shared.getCustomDateStringForArticleView(dateStr: article.dateStr!) : ""
    }
    
    @IBAction func broswerButtonPressed(_ sender: UIButton) {
        delegate?.browserButtonPressed()
    }

}
