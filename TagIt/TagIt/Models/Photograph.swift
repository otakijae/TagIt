//
//  Photograph.swift
//  TagIt
//
//  Created by 신재혁 on 28/02/2019.
//  Copyright © 2019 ninetyfivejae. All rights reserved.
//

import UIKit
import RealmSwift

final class Photograph: Object {
    @objc dynamic var name: String!
    @objc dynamic var localIdentifier: String!
    @objc dynamic var colorId: String!
    var tagList = List<String>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(name : String, localIdentifier: String, colorId: String, tagArray: [String]) {
        self.init()
        self.name = name
        self.localIdentifier = localIdentifier
        self.colorId = colorId
        self.tagList = arrayToList(objectArray: tagArray)
    }
    
    func arrayToList(objectArray: [String]) -> List<String> {
        var objectList: List<String> = List<String>()
        
        for object in objectArray {
            objectList.append(object)
        }
        
        return objectList
    }
    
    func listToArray(objectList: List<String>) -> [String] {
        var objectArray: [String] = []
        
        for object in objectList {
            objectArray.append(object)
        }
        
        return objectArray
    }
}

class Tag: Object {
    @objc dynamic var id: String?
    @objc dynamic var tagName: String?
}

class Color: Object {
    @objc dynamic var id: String?
    @objc dynamic var colorHexString: String?
}
