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


// Custom Object
struct MyObject {
    var name: String
    var address: String
}


class CoreSataService {
    
    private init() {}
    static let shared = CoreSataService()

    // MARK: - Stack
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
        case MyObject = "MyObject"
        
        enum EntityValues: String {
            case name = "name"
            case address = "address"
        }
    }
    

    // MARK: - Insert (Create)
    
    func insert(newObject: MyObject) {

        let context = persistentContainer.viewContext

         // Retrieving an Entity with a given Name
         //An NSEntityDescription - a description of an entity in Core Data
        let entity = NSEntityDescription.entity(forEntityName: Entities.MyObject.rawValue,
                                                in: context)!
        
        // Initialize a managed object and insert it into the specified managed object context
        let myObject = NSManagedObject(entity: entity,
                                     insertInto: context)
        myObject.setValue(newObject.name, forKeyPath: Entities.EntityValues.name.rawValue)
        myObject.setValue(newObject.address, forKeyPath: Entities.EntityValues.address.rawValue)
        
        // commit changes to object and save to disk (managed object context). save can throw an error, which is why you call it using the try keyword within a do-catch block.
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - fetch (Read)
 
    func retrieveObject(entityName: CoreSataService.Entities, for objectName: String) -> MyObject? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@", objectName)

        do {
            let myObject = try context.fetch(fetchRequest)
            return myObject as? MyObject
        } catch let error as NSError {
            print("Could not fetch Object from Core Data. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func retrieveObjects(entityName: CoreSataService.Entities) -> [MyObject]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]

        do {
            let myObjects = try context.fetch(fetchRequest)
            return myObjects as? [MyObject]
        } catch let error as NSError {
            print("Could not fetch Objects from Core Data. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    
    // MARK: - Update
    
    func update(for myObject : MyObject, withName newName: String, withAddress newAddress: String) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Entities.MyObject.rawValue)
        fetchRequest.predicate = NSPredicate(format: "name == %@", myObject.name)
        
        do {
            let objects = try context.fetch(fetchRequest)
            let object = objects[0] as! NSManagedObject
            
            object.setValue(newName, forKey: Entities.EntityValues.name.rawValue)
            object.setValue(newAddress, forKey: Entities.EntityValues.address.rawValue)
            
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
    
    func delete(name: String) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entities.MyObject.rawValue)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let objects = try context.fetch(fetchRequest)
            let objectToDelete = objects[0] as! NSManagedObject
            context.delete(objectToDelete)
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving after deleting object from Core Data: \(error), \(error.userInfo)")
            }
            return true
        } catch let error as NSError {
            print("Error Could not de. \(error), \(error.userInfo)")
            return false
        }
        
    }

    
}

