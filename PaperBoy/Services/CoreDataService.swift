//
//  CoreDataService.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/8/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import CoreData


// Application Project name
let appName = "PaperBoy"


class CoreSataService {
    
    private init() {}
    static let shared = CoreSataService()

    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: appName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                //TODO: Remove before Deploying
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //TODO: Remove before Deploying
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



extension CoreSataService {
    
    enum Entities: String {
        case Article = "Article"
        
        enum EntityValues: String {
            case title = "title"
            case author = "author"
            case subtitle = "subtitle"
            case websiteStr = "websiteStr"
            case imageStr = "imageStr"
            case dateStr = "dateStr"
            case sourceName = "sourceName"
            case content = "content"
        }
    }
    

    // MARK: - Create
    
    func insert(newArticle: Article) {

        let context = persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: Entities.Article.rawValue, in: context)!
        
        let saveArticle = NSManagedObject(entity: entity, insertInto: context)

        saveArticle.setValue(newArticle.title, forKeyPath: Entities.EntityValues.title.rawValue)
        saveArticle.setValue(newArticle.author, forKeyPath: Entities.EntityValues.author.rawValue)
        saveArticle.setValue(newArticle.subtitle, forKeyPath: Entities.EntityValues.subtitle.rawValue)
        saveArticle.setValue(newArticle.websiteStr, forKeyPath: Entities.EntityValues.websiteStr.rawValue)
        saveArticle.setValue(newArticle.imageStr, forKeyPath: Entities.EntityValues.imageStr.rawValue)
        saveArticle.setValue(newArticle.dateStr, forKeyPath: Entities.EntityValues.dateStr.rawValue)
        saveArticle.setValue(newArticle.source.name, forKeyPath: Entities.EntityValues.sourceName.rawValue)
        saveArticle.setValue(newArticle.content, forKeyPath: Entities.EntityValues.content.rawValue)

        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - Read
 
    func fetchArticle(entityName: CoreSataService.Entities, for articleName: String) -> Article? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
        
        fetchRequest.fetchLimit = 1
        
        fetchRequest.predicate = NSPredicate(format: "title == %@", articleName)

        do {
            let article = try context.fetch(fetchRequest)
            return article as? Article
        } catch let error as NSError {
            print("Could not fetch Object from Core Data. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchArticles(entityName: CoreSataService.Entities) -> [Article]? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "title", ascending: true)]

        do {
            let articles = try context.fetch(fetchRequest)
            return articles as? [Article]
        } catch let error as NSError {
            print("Could not fetch Objects from Core Data. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    
    // MARK: - Update
    
    func update(for article : Article, withAuthor newAuthor: String, withURL newURL: String) -> Bool {
        
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Entities.Article.rawValue)
        
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
        
        do {
            let objects = try context.fetch(fetchRequest)
            let object = objects[0] as! NSManagedObject
            
            object.setValue(article.title, forKeyPath: Entities.EntityValues.title.rawValue)
            object.setValue(article.author, forKeyPath: Entities.EntityValues.author.rawValue)
            object.setValue(article.subtitle, forKeyPath: Entities.EntityValues.subtitle.rawValue)
            object.setValue(article.websiteStr, forKeyPath: Entities.EntityValues.websiteStr.rawValue)
            object.setValue(article.imageStr, forKeyPath: Entities.EntityValues.imageStr.rawValue)
            object.setValue(article.dateStr, forKeyPath: Entities.EntityValues.dateStr.rawValue)
            object.setValue(article.source.name, forKeyPath: Entities.EntityValues.sourceName.rawValue)
            object.setValue(article.content, forKeyPath: Entities.EntityValues.content.rawValue)
            
            do {
                try context.save()
                return true
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
                return false
            }
            
        } catch {
            print("Error with request: \(error)")
            return false
        }
    }
    
    
    
    // MARK: - Delete
    
    func delete(title: String) -> Bool {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entities.Article.rawValue)
        
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            
            let objects = try context.fetch(fetchRequest)
            let objectToDelete = objects[0]
            context.delete(objectToDelete)
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving after deleting object from Core Data: \(error), \(error.userInfo)")
            }
            return true
        } catch let error as NSError {
            print("Error Could not decode. \(error), \(error.userInfo)")
            return false
        }
        
    }

    
}

