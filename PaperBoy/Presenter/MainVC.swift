//
//  ViewController.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/8/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var topicCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var topics: [ArticleTopic] = ArticleTopic.allCases
    var selectedtopic: ArticleTopic!
    
    var articles: [Article] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupCollectionView()
        fetchArticles(topic: .Headlines)
        topicCollectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
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
        let updatedCellNib = UINib(nibName: UpdatedCell.id, bundle: nil)
        tableView.register(updatedCellNib, forCellReuseIdentifier: UpdatedCell.id)
        let articleCellNib = UINib(nibName: ArticleCell.id, bundle: nil)
        tableView.register(articleCellNib, forCellReuseIdentifier: ArticleCell.id)
        let smallArticleCellNib = UINib(nibName: SmallArticleCell.id, bundle: nil)
        tableView.register(smallArticleCellNib, forCellReuseIdentifier: SmallArticleCell.id)
    }
    
    private func setupCollectionView() {
        topicCollectionView.delegate = self
        topicCollectionView.dataSource = self
        let topicNib = UINib(nibName: TopicCell.id, bundle: nil)
        topicCollectionView.register(topicNib, forCellWithReuseIdentifier: TopicCell.id)
        let layout = topicCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        let cellSpacing: CGFloat = 5.0
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: 0.0, bottom: cellSpacing, right: 0.0)
        let numberOfItemsPerRow: CGFloat = 4.8
        let numSpaces: CGFloat = numberOfItemsPerRow + 1
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numberOfItemsPerRow, height: topicCollectionView.bounds.height)
    }
    
    fileprivate func fetchArticles(topic: ArticleTopic) {
        ArticleAPIService.shared.getArticles(topic: topic) { (onlineArticles) in
            self.articles = onlineArticles
            self.tableView.reloadData()
            self.animateTable()
            self.selectedtopic = topic
        }
    }
    
    func animateTable() {
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
    
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
        if indexPath.item == 0 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell tapped")
        fetchArticles(topic: topics[indexPath.item])
        let cell = collectionView.cellForItem(at: indexPath) as! TopicCell
        cell.backgroundColor = UIColor.yellow
        cell.topicTitleLabel.textColor = UIColor.darkGray
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TopicCell
        cell.backgroundColor = UIColor.clear
        cell.topicTitleLabel.textColor = UIColor.white

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
        if (indexPath.row == 0) { return 500 }
        if (indexPath.row % 4 == 0) {return 500}
        return 110
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

extension MainVC: ArticleCellDelegate {
    func savePressed() {
        print("Save Pressed in VC")
    }
    
    func sharePressed() {
        let activityVC = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    
}
