//
//  ArticleAPI.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import RealmSwift


class ArticlesJSON: Codable {
    var totalResults: Int
    var articles: [Article]
}

@objcMembers
class Article: Object, Codable {
    dynamic var title: String = ""
    dynamic var author: String? = nil
    dynamic var subtitle: String? = nil
    dynamic var websiteStr: String?  = nil
    dynamic var imageStr: String? = nil
    dynamic var dateStr: String? = nil
    dynamic var source: ArticleSource?
    dynamic var content: String? = nil
    
    override class func primaryKey() -> String? {
        return "title"
    }
    
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
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.author = try container.decode(String?.self, forKey: .author)
        self.subtitle = try container.decode(String?.self, forKey: .subtitle)
        self.websiteStr = try container.decode(String?.self, forKey: .websiteStr)
        self.imageStr = try container.decode(String?.self, forKey: .imageStr)
        self.dateStr = try container.decode(String?.self, forKey: .dateStr)
        self.source = try container.decode(ArticleSource.self, forKey: .source)
        self.content = try container.decode(String?.self, forKey: .content)
    }
}

class ArticleSource: Object, Codable {
    @objc dynamic var name: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
}
