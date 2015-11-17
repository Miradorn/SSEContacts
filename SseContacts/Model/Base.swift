//
//  Base.swift
//  SseContacts
//
//  Created by Alexander Schramm on 06.11.15.
//  Copyright © 2015 Alexander Schramm. All rights reserved.
//

import Foundation
import RealmSwift

class Base: Object {
    
    func delete() -> Self {
        let realm = try! Realm()
        try! realm.write({
            realm.delete(self)
        })
        return self
    }
    
    static func all() -> Results<Category> {
        let realm = try! Realm()
        return realm.objects(Category)
    }
    
}
