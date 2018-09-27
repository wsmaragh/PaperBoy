//
//  ArticleVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class ArticleVC: UIViewController {

    var article: Article!
    weak var articleView: ArticleView!

    
    init(article: Article) {
        super.init(nibName: ArticleView.id, bundle: nil)
        self.article = article
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupView()
        setupNavBar()
        setupPageFromArticle()
        
        
    }
    
    private func setupNavBar(){
        self.view.backgroundColor = .white
    }
    
    private func setupPageFromArticle(){
        
        
    }
    
//    func setupView(){
//        self.articleView = Bundle.main.loadNibNamed("ArticleView", owner: self, options: nil)![0] as! ArticleView
//        self.view.addSubview(articleView)
//    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}



extension ArticleVC {
    
    
}
