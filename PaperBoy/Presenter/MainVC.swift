//
//  ViewController.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/8/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import RealmSwift


class MainVC: UIViewController {

    @IBOutlet weak var topicCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchBarButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSearchVC", sender: self)
    }
    
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var topics: [ArticleTopic] = ArticleTopic.allCases
    var selectedtopic: ArticleTopic!
    var initialTopicSet: Bool = false
    
    var articles: [Article] = [] {
        didSet {
            tableView.reloadData()
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
    
    private func setupNavBar(){
        if let image = UIImage(named: "bg_PaperBoy") {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            self.navigationItem.titleView = imageView
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let updatedCellNib = UINib(nibName: UpdatedCell.id, bundle: nil)
        tableView.register(updatedCellNib, forCellReuseIdentifier: UpdatedCell.id)
        let articleCellNib = UINib(nibName: ArticleCell.id, bundle: nil)
        tableView.register(articleCellNib, forCellReuseIdentifier: ArticleCell.id)
        let smallArticleCellNib = UINib(nibName: SmallArticleCell.id, bundle: nil)
        tableView.register(smallArticleCellNib, forCellReuseIdentifier: SmallArticleCell.id)
    }
    
    fileprivate func addRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .blue
        refreshControl.backgroundColor = .yellow
        refreshControl.alpha = 1.0
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching more data, hold on", attributes: [NSAttributedStringKey.foregroundColor: refreshControl.tintColor])
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
            topicCollectionView.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: UICollectionViewScrollPosition.left)
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
            guard let articleVC = segue.destination as? ArticleVC else {print("Error downcasting destination to DetailExerciseVC in Segue"); return}
            guard let indexPath = tableView.indexPathForSelectedRow else {print("Error getting indexPath in Segue"); return}
            let article = articles[indexPath.row]
            articleVC.article = article
        }
        if segue.identifier == "toSearchVC" {
            guard let searchVC = segue.destination as? SearchVC else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
        }
        
        
    }

}


// MARK: CollectionView setup
extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.id, for: indexPath) as! TopicCell
        let topic = topics[indexPath.item]
        cell.configureCell(topic: topic)
        
        #warning ("Remove commented code")
//        if indexPath.item == 0 {
//            self.collectionView(topicCollectionView, didSelectItemAt: indexPath)
//        }
        //    let initialCell = indexPath.item == 0 ? true : false
        //    cell.configureCell(topic: topic, initialCell: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchArticles(topic: topics[indexPath.item])
    }
    

}


// MARK: TableView setup
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        enum ArticleCellType {
            case normal, small
        }
    
        let type: ArticleCellType = ((indexPath.row == 0) || (indexPath.row % 4 == 0)) ? .normal : .small
        
        switch type {
        case .normal:
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.id, for: indexPath) as! ArticleCell
            let article = articles[indexPath.row]
            cell.configureCell(article: article)
            cell.delegate = self
            return cell
        case .small:
            let cell = tableView.dequeueReusableCell(withIdentifier: SmallArticleCell.id, for: indexPath) as! SmallArticleCell
            let article = articles[indexPath.row]
            cell.configureCell(article: article)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) { return 470 }
        if (indexPath.row % 4 == 0) {return 470}
        return 110
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
            case _ where offset > 150: message = "NOW LET GO"
            default: break
            }
            refreshControl.attributedTitle = NSAttributedString(string: message, attributes: [NSAttributedStringKey.foregroundColor: refreshControl.tintColor])
            refreshControl.backgroundColor = .yellow
    }
    
}

extension MainVC: ArticleCellDelegate {
    func savePressed(article: Article) {    
        RealmService.shared.create(article)
    }
    
    func sharePressed(article: Article) {
        guard let websiteStr = article.websiteStr else {return}
        let activityVC = UIActivityViewController(activityItems: [websiteStr], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }

    
}
