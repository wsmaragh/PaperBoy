//
//  FaveArticlesVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class FaveArticlesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteArticles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        fetchArticlesFromCoreData()

    }
    
    private func setupNavBar() {
        navigationItem.title = "Favorite Articles"
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let smallArticleCellNib = UINib(nibName: SmallArticleCell.id, bundle: nil)
        tableView.register(smallArticleCellNib, forCellReuseIdentifier: SmallArticleCell.id)
    }
    
    
    fileprivate func fetchArticlesFromCoreData() {
        self.favoriteArticles = FileManagerService.shared.getArticles()
        self.favoriteArticles = FileStorageManager.manager.getArticles()
//        if let articles =  CoreSataService.shared.fetchArticles(entityName: .Article) {
//            favoriteArticles = articles
//        }
    }

    fileprivate func animateTable() {
        self.tableView.reloadData()
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FaveArticlesVCToArticleVC" {
            guard let articleVC = segue.destination as? ArticleVC else {print("Error downcasting destination to DetailExerciseVC in Segue"); return}
            guard let indexPath = tableView.indexPathForSelectedRow else {print("Error getting indexPath in Segue"); return}
            let article = favoriteArticles[indexPath.row]
            articleVC.article = article
        }
    }
    

}



extension FaveArticlesVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SmallArticleCell.id, for: indexPath) as! SmallArticleCell
        let article = favoriteArticles[indexPath.row]
        cell.configureCell(article: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FaveArticlesVCToArticleVC", sender: self)
    }

    
}
