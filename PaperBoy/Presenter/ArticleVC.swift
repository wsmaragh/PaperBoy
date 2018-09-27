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
    @IBOutlet var articleView: ArticleView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupPageFromArticle()
        
    }
    
    private func setupNavBar(){
        self.view.backgroundColor = .white
    }
    
    private func setupPageFromArticle(){
        articleView.configureView(article: article)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}



extension ArticleVC {
    
    
}
