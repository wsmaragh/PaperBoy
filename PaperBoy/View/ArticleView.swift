//
//  ArticleView.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class ArticleView: UIView {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UITextView!
    
    
    static let id = "ArticleView"
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let _ = loadViewFromNib()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "ArticleView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        return view
    }
    
    
//    func configureView(article: Article){
//        topicLabel.text = article.source.name ?? "General"
//        titleLabel.text = article.title
//        subTitleLabel.text = article.description
//
//        if let imageURLStr = article.urlToImage {
//            articleImageView.loadImage(imageURLString: imageURLStr)
//        }
//
//        authorLabel.text = article.author ?? ""
//        dateLabel.text = article.publishedAt ?? "today"
//        bodyLabel.text = article.description
//    }
    
    


    
}
