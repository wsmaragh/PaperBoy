//
//  SearchVC.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/28/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class SearchVC: UIViewController {

    var searchController: UISearchController? = nil
    
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupNavBar()
//        setupTableView()
//        addRefreshControl()

    }
    
    private func setupSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.barStyle = .default
        searchController?.searchBar.placeholder = "Search..."
        if ((searchController?.searchBar.responds(to: NSSelectorFromString("searchBarStyle")))!){
            searchController?.searchBar.searchBarStyle = .minimal
        }
        searchController?.searchBar.delegate = self
        searchController?.definesPresentationContext = true
    }
    
    private func setupNavBar(){
        if #available(iOS 11.0, *) {
            navigationItem.title = "Search Articles"
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController?.searchBar
        }
    }
    

    fileprivate func fetchArticles(searchTerm: String) {
        ArticleAPIService.shared.getArticles(searchTerm: searchTerm) { (onlineArticles) in
            self.articles = onlineArticles
        }
    }
    
}


extension SearchVC: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        #warning ("TODO")
    }
}


// MARK: SearchBar
extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController?.searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController?.searchBar.text = nil
        searchBar.resignFirstResponder()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController?.searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
}
