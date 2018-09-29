//
//  FaveArticlesVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import RealmSwift


class FaveArticlesVC: UIViewController {
    
    @IBOutlet var noDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deleteAllButton: UIBarButtonItem!
    
    
    @IBAction func deleteAllPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Delete All?", message: "Are you sure you want to delete all saved articles?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            RealmService.shared.deleteAll()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    var favoriteArticles: Results<Article>!
    
    var favoriteArticlesRealmNotificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRealm()
        setupNavBar()
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingRealm()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Favorite Articles"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let smallArticleCellNib = UINib(nibName: SmallArticleRightCell.id, bundle: nil)
        tableView.register(smallArticleCellNib, forCellReuseIdentifier: SmallArticleRightCell.id)
    }
    
    private func setupRealm(){
        favoriteArticles = RealmService.shared.read(Article.self)
        
        self.favoriteArticlesRealmNotificationToken = favoriteArticles.observe { (changes: RealmCollectionChange) in
            
            switch changes {
            case .initial:
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                fatalError("\(err)")
                break
            }
        }
        
    }
    
    private func stopObservingRealm(){
        favoriteArticlesRealmNotificationToken?.invalidate()
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
            guard let articleVC = segue.destination as? ArticleVC else {
                print("Error downcasting destination to ArticleVC in Segue");
                return
            }
            guard let indexPath = tableView.indexPathForSelectedRow else {
                print("Error getting indexPath in Segue");
                return
            }
            let article = favoriteArticles[indexPath.row]
            articleVC.article = article
        }
    }
    
}


// MARK: Tableview setup
extension FaveArticlesVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoriteArticles.count == 0 {
            tableView.backgroundView = noDataView
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.separatorStyle = .singleLine
            return favoriteArticles.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SmallArticleRightCell.id, for: indexPath) as! SmallArticleRightCell
        let article = favoriteArticles[indexPath.row]
        cell.configureCell(article: article, hideButtons: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FaveArticlesVCToArticleVC", sender: self)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let favoriteArticle = favoriteArticles[indexPath.row]
            RealmService.shared.delete(favoriteArticle)
        }
    }
    
}
