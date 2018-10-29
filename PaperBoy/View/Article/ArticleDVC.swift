//
//  ArticleVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class ArticleDVC: UIViewController {

    @IBOutlet var articleView: ArticleDetailView!

    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupPageFromArticle()
        articleView.delegate = self
    }
    
    private func preloadWebView() {
        let _webVC = WebVC()
        _webVC.view.setNeedsLayout()
        _webVC.view.layoutIfNeeded()
    }
    
    private func setupNavBar() {
        view.backgroundColor = .white
        navigationItem.title = "Article"
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setupPageFromArticle() {
        articleView.configureView(article: article)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {_ in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardIDs.articleVCToWebVC.rawValue {
            guard let webVC = segue.destination as? WebVC else {return}
            webVC.article = article
        }
    }

}

// MARK: - Delegate
extension ArticleDVC: ArticleViewDelegate {

    func browserButtonPressed() {
        performSegue(withIdentifier: StoryboardIDs.articleVCToWebVC.rawValue, sender: self)
    }

}
