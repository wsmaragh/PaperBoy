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
class ArticleView: UIView {
    
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fullLabel: UITextView!
    @IBOutlet weak var browserButton: UIButton!
    
    var contentView : UIView?
    
    weak var delegate: ArticleViewDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup() {
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView!)
    }
    
    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ArticleView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public func configureView(article: Article){
        topicLabel.text = article.source.name ?? "No Source"
        titleLabel.text = article.title
        subtitleLabel.text = article.subtitle ?? "No Subtitle"
        if let imageURLStr = article.imageStr {
            articleImageView.loadImage(imageURLString: imageURLStr)
        }
        authorLabel.text = article.author ?? "No Author"
        dateLabel.text = article.dateStr ?? "No date"
        fullLabel.text = article.content ?? "No Full details"
    }
    
    @IBAction func broswerButtonPressed(_ sender: UIButton) {
        print("browser button pressed")
        delegate?.browserButtonPressed()
    }
    
}
