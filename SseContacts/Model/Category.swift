//
//  Category.swift
//  Contacts
//
//  Created by Alexander Schramm on 05.11.15.
//  Copyright © 2015 Alexander Schramm. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Category: Object, Mappable {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var color = ""
    
    
    var contacts: [Contact] {
        return linkingObjects(Contact.self, forProperty: "category")
    }
    
    required convenience init?(_ map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        name    <- map["name"]
        color   <- map["color"]
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    // MARK: - accessors
    
    static func all() -> Results<Category> {
        let realm = try! Realm()
        return realm.objects(Category)
    }
    
    static func filter(query: String) -> Results<Category> {
        let realm = try! Realm()
        return realm.objects(Category).filter("name CONTAINS[c] %@ OR color CONTAINS[c] %@", query, query)
    }
    
    func delete() -> Self {
        let _ = self.contacts.map({ (contact: Contact) -> Contact in
            contact.delete()
        })
        
        let realm = try! Realm()
        try! realm.write({
            
            realm.delete(self)
        })
        return self
    }
    
}
