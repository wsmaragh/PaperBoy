//
//  ArticleAPIService.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import Alamofire


enum ArticleTopic: String, CaseIterable {
    case general, business, technology, science, health, sports, entertainment
}


class ArticleAPIService {
    
    private init(){}
    static let shared = ArticleAPIService()
    

    func getTopArticles(topic: ArticleTopic, completion: @escaping ([Article]) -> Void) {
        
        let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(APIKeys.NewsAPI_ApiKey)&sortBy=publishedAt&category=\(topic.rawValue)"
        
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                if let data = response.data {
                    do {
                        let JSON = try JSONDecoder().decode(ArticlesJSON.self, from: data)
                        let articles = JSON.articles
                        completion(articles)
                    }
                    catch {print("Error processing data. Error: \(error)")}
                }
            } else {
                print("Error\(String(describing: response.result.error))")
            }
        }
    }
    
    
    func getArticles(searchTerm: String, completion: @escaping ([Article]) -> Void) {

        let q = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = "https://newsapi.org/v2/everything?apiKey=\(APIKeys.NewsAPI_ApiKey)&sortBy=publishedAt&language=en&q=\(q!)"

        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                if let data = response.data {
                    do {
                        let JSON = try JSONDecoder().decode(ArticlesJSON.self, from: data)
                        let articles = JSON.articles
                        completion(articles)
                    }
                    catch {print("Error processing data. Error: \(error)")}
                }
            } else {
                print("Error\(String(describing: response.result.error))")
            }
        }
    }
}












