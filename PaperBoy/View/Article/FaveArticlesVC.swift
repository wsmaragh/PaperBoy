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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewForEmptyTableView: UIView!
    
    @IBOutlet weak var deleteAllButton: UIBarButtonItem!
    
    @IBOutlet weak var dismissButton: UIButton!

    @IBAction func deleteAllPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Delete All?", message: "Are you sure you want to delete all saved articles?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            print("Delete pressed")
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
        tableView.rowHeight = UITableView.automaticDimension
        let smallArticleCellNib = UINib(nibName: SmallArticleRightCell.cellID, bundle: nil)
        tableView.register(smallArticleCellNib, forCellReuseIdentifier: SmallArticleRightCell.cellID)
    }

    private func setupRealm(){
        favoriteArticles = RealmService.shared.read(Article.self)

        self.favoriteArticlesRealmNotificationToken = favoriteArticles.observe { (changes: RealmCollectionChange) in

            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
            case .error(let err):
                fatalError("\(err)")
            }
        }
        
    }
    
    private func stopObservingRealm() {
        favoriteArticlesRealmNotificationToken?.invalidate()
    }

    fileprivate func animateTable() {
        self.tableView.reloadData()
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
        }
    }
    
    @IBAction func dismiss(_ sender: UIButton) {

        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == StoryboardIDs.faveArticlesVCToArticleVC.rawValue {
            guard let articleVC = segue.destination as? ArticleDVC else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
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
            tableView.backgroundView = viewForEmptyTableView
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.separatorStyle = .singleLine
            return favoriteArticles.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SmallArticleRightCell.cellID, for: indexPath) as! SmallArticleRightCell
        let article = favoriteArticles[indexPath.row]
        cell.configureCell(article: article, hideButtons: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: StoryboardIDs.faveArticlesVCToArticleVC.rawValue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favoriteArticle = favoriteArticles[indexPath.row]
            RealmService.shared.delete(favoriteArticle)
        }
    }
    
}
