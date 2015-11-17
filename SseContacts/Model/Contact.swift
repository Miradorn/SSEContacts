//
//  File.swift
//  Contacts
//
//  Created by Alexander Schramm on 05.11.15.
//  Copyright © 2015 Alexander Schramm. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class RealmString : Object {
    dynamic var stringValue = ""
}

class Contact : Object, Mappable {
    dynamic var category: Category?
    dynamic var name = ""
    dynamic var dateOfBirth = NSDate()
    
    var addresses: [String] {
        get {
            return _backingAddresses.map { $0.stringValue }
        }
        set {
            _backingAddresses.removeAll()
            _backingAddresses.appendContentsOf(newValue.map({ RealmString(value: [$0]) }))
        }
    }
    var _backingAddresses = List<RealmString>()
    
    var phones: [String] {
        get {
            return _backingPhones.map { $0.stringValue }
        }
        set {
            _backingPhones.removeAll()
            _backingPhones.appendContentsOf(newValue.map({ RealmString(value: [$0]) }))
        }
        
    }
    var _backingPhones = List<RealmString>()
    
    var emails: [String] {
        get {
            return _backingEmails.map { $0.stringValue }
        }
        set {
            _backingEmails.removeAll()
            _backingEmails.appendContentsOf(newValue.map({ RealmString(value: [$0]) }))
        }
    }
    var _backingEmails = List<RealmString>()
    
    override static func ignoredProperties() -> [String] {
        return ["addresses", "phones", "emails"]
    }
    
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        let realm = try! Realm()
        let categoryTransform = TransformOf<Category, Int>(fromJSON: { (value: Int?) -> Category? in
            realm.objects(Category).filter("id = %@", value!).first
            }, toJSON: { (value: Category?) -> Int? in
                value!.id
        })
        
        category        <- (map["categorie"], categoryTransform)
        name            <- map["name"]
        addresses       <- map["addresses"]
        phones          <- map["phones"]
        emails          <- map["emails"]
        dateOfBirth     <- map["dateOfBirth"]
    }
    
    // MARK: - accessors
    
    static func all() -> Results<Contact> {
        let realm = try! Realm()
        return realm.objects(Contact)
    }
    
    func delete() -> Self {
        let realm = try! Realm()
        try! realm.write({
            realm.delete(self._backingAddresses)
            realm.delete(self._backingPhones)
            realm.delete(self._backingEmails)
            realm.delete(self)
        })
        return self
    }
}
