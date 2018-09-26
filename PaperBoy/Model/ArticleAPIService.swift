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
    case TopHeadlines
    case Business
    case Politics
    case Sports
    case World
    case US
}


class ArticleAPIService {
    
    private init(){}
    static let shared = ArticleAPIService()
    

    func getArticles(topic: ArticleTopic, completion: @escaping ([Article]) -> Void) {
        
        let q = topic.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var url = ""

        switch topic {
        case .TopHeadlines:
            url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(APIKeys.NewsAPI_ApiKey)"
        case .Business, .Politics, .Sports, .World, .US :
            url = "https://newsapi.org/v2/everything?apiKey=\(APIKeys.NewsAPI_ApiKey)&sortBy=publishedAt&language=en&q=\(q!)"
        }
        
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












