//
//  FileManagerService.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//


import Foundation
import UIKit



class FileManagerService {
    
    private init(){}
    static let shared = FileManagerService()
    
    // FileNames
    static let kFilePath = "SavedArticles.plist"
    
    
    // MARK: Properties
    private var savedArticles: [Article] {
        get {return decodeArticlesFromDocuments()}
        set {encodeArticlesToDocuments(withArticles: savedArticles)}
    }
    
    
    // returns documents directory path (URL) for the app sandbox
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]  // 0 is the document folder
    }
    
    // returns the path (URL) for documents directory of specified filename
    func dataFilePath(withPathName path: String) -> URL { return FileManagerService.shared.documentDirectory().appendingPathComponent(path)
    }
    
    
    //ENCODE - save to documents directory - write to path: /Documents/
    func encodeArticlesToDocuments(withArticles articles: [Article]){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(articles)
            try data.write(to: dataFilePath(withPathName: FileManagerService.kFilePath), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
    }
    
    //DECODE - load from documents directory
    func decodeArticlesFromDocuments() -> [Article] {
        let path = dataFilePath(withPathName: FileManagerService.kFilePath)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            let articles = try decoder.decode([Article].self, from: data)
            return articles
        } catch {
            print("decoding error: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func getArticles() -> [Article] {
        return savedArticles
    }
    
    func saveArticle(article: Article) -> Bool  {
        // checking for uniqueness
        let indexExist = savedArticles.index{ $0.title == article.title }
        if indexExist != nil { print("Test: Article Exist"); return false }
        savedArticles.append(article)
        return true
    }
    
    
    func saveArticleWithImage(article: Article, andImage image: UIImage) -> Bool  {
        // checking for uniqueness
        let indexExist = savedArticles.index{ $0.title == article.title }
        if indexExist != nil { print("Test: Article Exist"); return false }
        
        // 1) save image
        let imageSaveSuccess = saveImageToDisk(image: image, andArticle: article)
        if !imageSaveSuccess { return false }
        
        // 2) save object
        savedArticles.append(article)
        return true
    }
    
    func saveImageToDisk(image: UIImage, andArticle article: Article) -> Bool {
        guard let imageData = UIImagePNGRepresentation(image) else { return false }
        let imageURL = FileManagerService.shared.dataFilePath(withPathName: "\(article.title)")
        do {
            try imageData.write(to: imageURL)
            return true
        }
        catch {
            print("image saving error: \(error.localizedDescription)")
            return false
        }
    }
    
    
    func deleteArticle(fromIndex index: Int) -> Bool {
        guard savedArticles[index] != nil else {return false}
        savedArticles.remove(at: index)
        return true
    }
    
    func deleteArticleWithImage(fromIndex index: Int, andImage article: Article) -> Bool {
        savedArticles.remove(at: index)
        
        // delete image from Documents Folder
        let imageURL = FileManagerService.shared.dataFilePath(withPathName: "\(article.title)")
        do {
            try FileManager.default.removeItem(at: imageURL)
            return true
        }
        catch {
            print("error removing: \(error.localizedDescription)")
            return false
        }
    }
    
}


//import Foundation
//import UIKit
//
//
//class FileStorageManager {
//    // MARK: FileName
//    static let kPathname = "Favorites.plist"
//
//    // MARK: Singleton
//    private init(){}
//    static let manager = FileStorageManager()
//
//    // MARK: Properties
//    private var favorites = [Favorite]() {
//        didSet{ saveToDisk() }
//    }
//
//    // MARK: Methods
//    // returns (URL) documents directory path for app sandbox
//    func documentDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]  //the 0 is the document folder
//    }
//
//    // returns (URL) the path for supplied name from the dcouments directory -     documents/Favorites.plist
//    func dataFilePath(withPathName path: String) -> URL { return FileStorageManager.manager.documentDirectory().appendingPathComponent(path)
//    }
//
//    //ENCODE - save to documents directory - write to path: /Documents/
//    func saveToDisk() {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(favorites)
//            // Does the writing to disk
//            try data.write(to: dataFilePath(withPathName: FileStorageManager.kPathname), options: .atomic)
//        } catch { print("encoding error: \(error.localizedDescription)") }
//    }
//
//    //DECODE - load from documents directory
//    func load() {
//        // what's the path we are reading from?
//        let path = dataFilePath(withPathName: FileStorageManager.kPathname)
//        let decoder = PropertyListDecoder()
//        do {
//            let data = try Data.init(contentsOf: path)
//            favorites = try decoder.decode([Favorite].self, from: data)
//        } catch {
//            print("decoding error: \(error.localizedDescription)")
//        }
//    }
//
//    //READ (GET)
//    func getFavorites() -> [Favorite] { return favorites }
//
//    //ADD
//    // does 2 tasks:
//    // 1. stores image in documents folder
//    // 2. appends favorite item to array
//    func addToFavorites(movie: Movie, andImage image: UIImage) -> Bool  {
//        // checking for uniqueness
//        let indexExist = favorites.index{ $0.trackId == movie.trackId }
//        if indexExist != nil { print("FAVORITE EXIST"); return false }
//
//        // 1) save image from favorite photo
//        let success = storeImageToDisk(image: image, andMovie: movie)
//        if !success { return false }
//
//        // 2) save favorite object
//        let newFavorite = Favorite.init(collectionName: movie.collectionName, collectionId: movie.collectionId, trackId: movie.trackId, longDescription: movie.longDescription, artworkUrl100: movie.artworkUrl100, artworkUrl60: movie.artworkUrl60)
//        favorites.append(newFavorite)
//        return true
//    }
//
//    // STORE IMAGE
//    func storeImageToDisk(image: UIImage, andMovie movie: Movie) -> Bool {
//        // packing data from image
//        guard let imageData = UIImagePNGRepresentation(image) else { return false }
//
//        // Writing & Saving to Documents Folder
//        // 1) save image from favorite photo
//        let imageURL = FileStorageManager.manager.dataFilePath(withPathName: "\(movie.trackId)")
//        do { try imageData.write(to: imageURL); return true}
//        catch {print("image saving error: \(error.localizedDescription)"); return false}
//        //        return true
//    }
//
//    // REMOVE
//    func removeFavorite(fromIndex index: Int, andMovieImage favorite: Favorite) -> Bool {
//        //remove from favorites array
//        favorites.remove(at: index)
//
//        // remove image from Documents Folder
//        let imageURL = FileStorageManager.manager.dataFilePath(withPathName: "\(favorite.trackId)")
//        do { try FileManager.default.removeItem(at: imageURL); return true}
//        catch {print("error removing: \(error.localizedDescription)");return false}
//    }
//
//}
//

