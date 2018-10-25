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

    let articleDataService = ArticleDataService()

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

    private func setupSearchController() {
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
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }

        if searchController.searchBar.responds(to: NSSelectorFromString("searchBarStyle")) {
            searchController.searchBar.searchBarStyle = .minimal
        }

        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
    }

    private func setupNavBar() {
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
        let smallArticleCellNib = UINib(nibName: SmallArticleRightCell.cellID, bundle: nil)
        tableView.register(smallArticleCellNib, forCellReuseIdentifier: SmallArticleRightCell.cellID)
    }

    fileprivate func fetchArticles(searchTerm: String) {
        articleDataService.getArticles(searchTerm: searchTerm) { (onlineArticles) in
            self.articles = onlineArticles
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardIDs.searchVCToArticleVC.rawValue {
            guard let articleVC = segue.destination as? ArticleDVC else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
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


// MARK: TableView

extension SearchVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles.isEmpty {
            tableView.backgroundView = viewForEmptyTableView
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SmallArticleRightCell.cellID, for: indexPath) as! SmallArticleRightCell
        let article = articles[indexPath.row]
        cell.configureCell(article: article, hideButtons: true)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: StoryboardIDs.searchVCToArticleVC.rawValue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
