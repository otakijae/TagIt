//
//  DatabaseManager.swift
//  TagIt
//
//  Created by 신재혁 on 28/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager {
    private let realm = try! Realm()
    static let sharedInstance = RealmManager()
    
    // delete table
    func deleteDatabase() {
        try! realm.write({
            realm.deleteAll()
        })
    }
    
    // delete particular object
    func deleteObject(object : Photograph) {
        try! realm.write ({
            realm.delete(object)
        })
    }
    
    //Save array of objects to database
    func saveObjects(object: Photograph) {
        try! realm.write ({
            realm.add(object, update: false)
        })
    }
    
    // editing the object
    func editObjects(object: Photograph) {
        try! realm.write ({
            realm.add(object, update: true)
        })
    }
    
    func getObjects(type: Photograph.Type) -> Results<Photograph>? {
        return realm.objects(type)
    }
    
    func incrementID() -> Int {
        return (realm.objects(Photograph.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
