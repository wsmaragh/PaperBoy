//
//  SearchVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/28/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class SearchVC: UIViewController {

    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var viewForEmptyTableView: UIView!
    
    var articles: [Article] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupNavBar()
        setupTableView()
    }
    
    private func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Search for articles"
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.darkGray
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        if ((searchController.searchBar.responds(to: NSSelectorFromString("searchBarStyle")))){
            searchController.searchBar.searchBarStyle = .minimal
        }
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
    }
    
    private func setupNavBar(){
        if #available(iOS 11.0, *) {
            navigationItem.title = "Search Articles"
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        let smallArticleCellNib = UINib(nibName: SmallArticleRightCell.id, bundle: nil)
        tableView.register(smallArticleCellNib, forCellReuseIdentifier: SmallArticleRightCell.id)
    }
    
    fileprivate func fetchArticles(searchTerm: String) {
        ArticleAPIService.shared.getArticles(searchTerm: searchTerm) { (onlineArticles) in
            self.articles = onlineArticles
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SearchVCToArticleVC" {
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
    
}



// MARK: SearchController
extension SearchVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        
    }
}



// MARK: SearchBar
extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchController.searchBar.text {
             fetchArticles(searchTerm: searchTerm)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.text = nil
        searchBar.resignFirstResponder()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
}



// MARK: TableView setup
extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles.count == 0 {
            tableView.backgroundView = viewForEmptyTableView
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.separatorStyle = .singleLine
            return articles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SmallArticleRightCell.id, for: indexPath) as! SmallArticleRightCell
        let article = articles[indexPath.row]
        cell.configureCell(article: article, hideButtons: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SearchVCToArticleVC", sender: self)
    }
    
}
