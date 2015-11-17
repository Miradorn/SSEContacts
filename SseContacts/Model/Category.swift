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

class Category: Base, Mappable {
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
    
    override func delete() -> Self {
        let realm = try! Realm()
        try! realm.write({
            let _ = self.contacts.map({ (contact: Contact) -> Contact in
                contact.delete()
            })
            realm.delete(self)
        })
        return self
    }

    
    
}
