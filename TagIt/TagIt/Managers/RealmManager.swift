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
    func saveObject(object: Photograph) {
        try! realm.write ({
            realm.add(object, update: false)
        })
    }
    
    // editing the object
    func editObject(object: Photograph) {
        try! realm.write ({
            realm.add(object, update: true)
        })
    }
	
		// editing the object's color
		func editColorObject(object: Photograph, selectedColorId: String) {
				try! realm.write({
						object.colorId = selectedColorId
						realm.add(object, update: true)
				})
		}
	
		// delete tags
		func deleteTagObject(object: Photograph, tagIndexPath: IndexPath) {
				try! realm.write({
						object.tagList.remove(at: tagIndexPath.row)
				})
		}
	
		// append tags
		func appendTagObject(object: Photograph, tag: String) {
				try! realm.write ({
						object.tagList.append(tag)
				})
		}
    
    func getObjects(type: Photograph.Type) -> Results<Photograph>? {
        return realm.objects(type)
    }
    
    func incrementID() -> Int {
        return (realm.objects(Photograph.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}






//
//class RealmAssistant {
//
//	static func writeBlock(block: () -> Void ) {
//		do {
//			try Realm().write {
//				block()
//			}
//		} catch let error {
//			Log.print(error: error)
//		}
//	}
//
//	static func add(object: Object, update: Bool = false) {
//		do {
//			try Realm().write {	try Realm().add(object, update: update) }
//		} catch let error {
//			Log.print(error: error)
//		}
//	}
//
//	static func add<S: Sequence>(objects: S, update: Bool = false) where S.Iterator.Element: Object {
//		do {
//			try Realm().write {	try Realm().add(objects, update: update) }
//		} catch let error {
//			Log.print(error: error)
//		}
//	}
//
//	static func delete(object: Object) {
//		do {
//			try Realm().write { try Realm().delete(object) }
//		} catch let error {
//			Log.print(error: error)
//		}
//	}
//
//	static func delete<S: Sequence>(objects: S) where S.Iterator.Element: Object {
//		do {
//			try Realm().write { try Realm().delete(objects) }
//		} catch let error {
//			Log.print(error: error)
//		}
//	}
//
//	static func didChangeNotifictionBlock(block: @escaping () -> Void) -> NotificationToken {
//		do {
//			return try Realm().observe{ changes,arg  in
//				switch changes {
//				case .didChange:
//					block()
//					break
//				default:
//					break
//				}
//			}
//		} catch let error {
//			Log.print(error: error)
//			fatalError()
//		}
//	}
//}
