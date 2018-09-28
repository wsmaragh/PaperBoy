//
//  ArticleAPI.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation


struct ArticlesJSON: Codable {
    var totalResults: Int //4941
    var articles: [Article]
}

struct Article: Codable {
    var title: String
    var author: String?
    var subtitle: String?
    var websiteStr: String?
    var imageStr: String?
    var dateStr: String?
    var source: ArticleSource
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case subtitle = "description"
        case websiteStr = "url"
        case imageStr = "urlToImage"
        case dateStr = "publishedAt"
        case source
        case content
    }
}

struct ArticleSource: Codable {
    var name: String?
}
