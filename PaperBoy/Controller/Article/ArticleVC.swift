//
//  ViewController.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/8/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import RealmSwift


class ArticleVC: UIViewController {

    @IBOutlet weak var sideMenu: UIBarButtonItem!
    
    @IBOutlet weak var topicCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var topics: [ArticleTopic] = ArticleTopic.allCases
    var selectedtopic: ArticleTopic!
    var initialTopicSet: Bool = false
    
    var articles: [Article] = [] {
        didSet {
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        addRefreshControl()
        setupCollectionView()
        loadInitialArticles()
    }
    
    @IBAction func sideMenuPressed() {
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
    
    
    private func setupNavBar(){
        if let image = UIImage(named: "paperboyName_high") {
            let imageView = UIImageView(image: image)

            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 44))
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)
            
            self.navigationItem.titleView = titleView
        }
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableView.automaticDimension
        let updatedCellNib = UINib(nibName: UpdatedCell.id, bundle: nil)
        tableView.register(updatedCellNib, forCellReuseIdentifier: UpdatedCell.id)
        let articleCellNib = UINib(nibName: ArticleCell.id, bundle: nil)
        tableView.register(articleCellNib, forCellReuseIdentifier: ArticleCell.id)
        let smallArticleLeftCellNib = UINib(nibName: SmallArticleLeftCell.id, bundle: nil)
        tableView.register(smallArticleLeftCellNib, forCellReuseIdentifier: SmallArticleLeftCell.id)
        let smallArticleRightCellNib = UINib(nibName: SmallArticleRightCell.id, bundle: nil)
        tableView.register(smallArticleRightCellNib, forCellReuseIdentifier: SmallArticleRightCell.id)
    }
    
    fileprivate func addRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.backgroundColor = UIColor(red: 149/256, green: 210/256, blue: 107/256, alpha: 1.0)
        refreshControl.alpha = 1.0
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching more data, hold on", attributes: [NSAttributedString.Key.foregroundColor: refreshControl.tintColor])
    }
    
    @objc private func refreshData(){
        fetchArticles(topic: selectedtopic)
        refreshControl.endRefreshing()
    }
    
    private func setupCollectionView() {
        topicCollectionView.delegate = self
        topicCollectionView.dataSource = self
        let topicNib = UINib(nibName: TopicCell.id, bundle: nil)
        topicCollectionView.register(topicNib, forCellWithReuseIdentifier: TopicCell.id)
        topicCollectionView.allowsMultipleSelection = false
        let layout = topicCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        let cellSpacing: CGFloat = 5.0
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        let numberOfItemsPerRow: CGFloat = 4.2
        let numSpaces: CGFloat = numberOfItemsPerRow + 1
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numberOfItemsPerRow, height: topicCollectionView.bounds.height - (cellSpacing * 2))

    }
    
    private func loadInitialArticles(){
        if topicCollectionView != nil {
            let indexPathForFirstRow = IndexPath(row: 0, section: 0)
            topicCollectionView.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
            self.collectionView(topicCollectionView, didSelectItemAt: indexPathForFirstRow)
        }
    }
    
    fileprivate func fetchArticles(topic: ArticleTopic) {
        ArticleAPIService.shared.getTopArticles(topic: topic) { (onlineArticles) in
            self.articles = onlineArticles
            self.tableView.reloadData()
            self.animateTable()
            self.selectedtopic = topic
        }
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
    
    
    fileprivate func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainVCToArticleVC" {
            guard let articleVC = segue.destination as? ArticleDVC else {
                print("Error downcasting destination to ArticleVC in Segue");
                return
            }
            guard let indexPath = tableView.indexPathForSelectedRow else {
                print("Error getting indexPath in Segue");
                return
            }
            let article = articles[indexPath.row]
            articleVC.article = article
        }
        
        
    }
    
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
        
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
//        let segue =
//        segue.perform()
    }

}


// MARK: CollectionView setup
extension ArticleVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.id, for: indexPath) as! TopicCell
        let topic = topics[indexPath.item]
        cell.configureCell(topic: topic)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchArticles(topic: topics[indexPath.item])
    }
    

}


// MARK: TableView setup
extension ArticleVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        enum ArticleCellType {
            case normal, smallLeft, smallRight
        }
    
        var type: ArticleCellType
        
        if ((indexPath.row == 0) || (indexPath.row % 4 == 0)) {
            type = .normal
        } else if (indexPath.row % 2 == 0) {
            type = .smallLeft
        } else {
            type = .smallRight
        }
        
        switch type {
        case .normal:
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.id, for: indexPath) as! ArticleCell
            let article = articles[indexPath.row]
            cell.configureCell(article: article)
            cell.delegate = self
            return cell
        case .smallLeft:
            let cell = tableView.dequeueReusableCell(withIdentifier: SmallArticleLeftCell.id, for: indexPath) as! SmallArticleLeftCell
            let article = articles[indexPath.row]
            cell.configureCell(article: article, hideButtons: false)
            cell.delegate = self
            return cell
        case .smallRight:
            let cell = tableView.dequeueReusableCell(withIdentifier: SmallArticleRightCell.id, for: indexPath) as! SmallArticleRightCell
            let article = articles[indexPath.row]
            cell.configureCell(article: article, hideButtons: false)
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((indexPath.row == 0) || (indexPath.row % 4 == 0)) { return 400 }
        return 115
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let updatedCell = tableView.dequeueReusableCell(withIdentifier: UpdatedCell.id) as! UpdatedCell
        updatedCell.configureCell(date: Date())
        return updatedCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MainVCToArticleVC", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = (scrollView.contentOffset.y * -1)
            var message: String = "Keep Pulling."
            switch offset {
            case 0...25: message = "Keep Pulling."
            case 26...40: message = "Keep Pulling..."
            case 41...60: message = "Keep Pulling......"
            case 61...80: message = "Keep Pulling........."
            case 81...100: message = "Keep Pulling............"
            case 101...120: message = "Keep Pulling..............."
            case 121...150: message = "Keep Pulling.................."
            case _ where offset > 150: message = "Getting data"
            default: break
            }
            refreshControl.attributedTitle = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor: refreshControl.tintColor])
            refreshControl.backgroundColor = UIColor(red: 149/256, green: 210/256, blue: 107/256, alpha: 1.0)
    }
    
}


extension ArticleVC: ArticleCellDelegate {
    func savePressed(article: Article) {
        RealmService.shared.create(article)
        showAlert(title: "Article Saved", message: "This article has been added to your Favorites")
    }
    
    func sharePressed(article: Article) {
        guard let websiteStr = article.websiteStr else {return}
        let activityVC = UIActivityViewController(activityItems: [websiteStr], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }

    
}
