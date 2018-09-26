//
//  ViewController.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/8/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tableViewSections: [String] = ["Exercises By Muscle: ", "My Workouts: ", "Suggested Workouts: ", "Fitness News: "]
    var articles: [Article] = [] {
        didSet {
            print(self.articles)
        }
    }
    

    /*
       dateCell
        mainStory
     
     
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchArticles(topic: .TopHeadlines)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let updatedCellNib = UINib(nibName: UpdatedCell.id, bundle: nil)
        tableView.register(updatedCellNib, forCellReuseIdentifier: UpdatedCell.id)
        let articleCellNib = UINib(nibName: ArticleCell.id, bundle: nil)
        tableView.register(articleCellNib, forCellReuseIdentifier: ArticleCell.id)
        let smallArticleCellNib = UINib(nibName: SmallArticleCell.id, bundle: nil)
        tableView.register(smallArticleCellNib, forCellReuseIdentifier: SmallArticleCell.id)
    }
    
    private func fetchArticles(topic: ArticleTopic) {
        ArticleAPIService.shared.getArticles(topic: topic) { (onlineArticles) in
            self.articles = onlineArticles
            self.tableView.reloadData()
            print(self.articles)
        }
    }
    

}

//extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
//
//
//
//}



// MARK: TableView setup
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        enum ArticleCellTypes: Int {
            case TopStory = 0
            case normal = 1
            case small = 2
        }
        
        switch indexPath.row {
        case 0, 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.id, for: indexPath) as! ArticleCell
            let article = articles[indexPath.row]
            cell.configureCell(article: article)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SmallArticleCell.id, for: indexPath) as! SmallArticleCell
            let article = articles[indexPath.row]
            cell.configureCell(article: article)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SmallArticleCell.id, for: indexPath) as! SmallArticleCell
            let article = articles[indexPath.row]
            cell.configureCell(article: article)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.id, for: indexPath) as! ArticleCell
        let article = articles[indexPath.row]
        cell.configureCell(article: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 500 }
        if indexPath.row == 4 { return 500 }
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let updatedCell = tableView.dequeueReusableCell(withIdentifier: UpdatedCell.id) as! UpdatedCell
        updatedCell.configureCell(date: Date())
        return updatedCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3.0
    }
    
}
