//
//  ContactImporter.swift
//  Contacts
//
//  Created by Alexander Schramm on 06.11.15.
//  Copyright © 2015 Alexander Schramm. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
import RealmSwift

class ContactImporter {
    
    
    func importContacts(completionHandler: () -> ()) {
        
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            
            Alamofire.request(.GET, "https://contactsampleprovider.herokuapp.com").responseJSON { response in
                
                
                let json = JSON(data: response.data!)
                let categoriesJson = json["categories"]
                let contactsJson = json["contacts"]
                
                
                try! realm.write {
                    for (_,categoryJson):(String, JSON) in categoriesJson {
                        print(categoryJson.rawString()!)
                        if let category = Mapper<Category>().map(categoryJson.rawString()!) {
                            realm.add(category)
                            
                        }
                    }
                    for (_,contactJson):(String, JSON) in contactsJson {
                        print(contactJson.rawString()!)
                        if let contact = Mapper<Contact>().map(contactJson.rawString()!) {
                            realm.add(contact)
                            
                        }
                    }
                    
                    completionHandler()
                }
            }
        
    }
    
}
