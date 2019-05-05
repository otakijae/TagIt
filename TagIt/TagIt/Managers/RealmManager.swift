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
