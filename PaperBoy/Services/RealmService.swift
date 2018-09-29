//
//  RealmService.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/28/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import RealmSwift


class RealmService {
    
    private init() {}
    static let shared = RealmService()
    
    var realm = try! Realm()
    
    func create<T: Object>(_ realmObject: T) {
//        let myPrimaryKey = (realmObject as! Article).title
//        print("myPrimaryKey: ", myPrimaryKey)
//        let articleExists = realm.object(ofType: Article.self, forPrimaryKey: myPrimaryKey)
//        guard articleExists == nil else {return}
        do {
            try realm.write {
                realm.add(realmObject, update: true)
            }
        } catch {
            print("Realm Create Error: ", error)
            print("Realm Create Error Description: ", error.localizedDescription)
        }
    }
    
    func read<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func update<T: Object>(_ realmObject: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    realmObject.setValue(value, forKey: key)
                }
            }
        } catch {
            print("Realm Update Error: ", error)
            print("Realm Update Error Description: ", error.localizedDescription)
        }
    }
    
    func delete<T: Object>(_ realmObject: T) {
        do {
            try realm.write {
                realm.delete(realmObject)
            }
        } catch {
            print("Realm Delete Error: ", error)
            print("Realm Delete Error Description: ", error.localizedDescription)
            
        }
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Realm Delete Error: ", error)
            print("Realm Delete Error Description: ", error.localizedDescription)
            
        }
    }
    
}


