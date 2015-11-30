//
//  CategoryViewModel.swift
//  SseContacts
//
//  Created by Alexander Schramm on 19.11.15.
//  Copyright © 2015 Alexander Schramm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ContactViewModel {
    
    let contact: Contact
    var cell: ContactTableViewCell! {
        didSet {
            cell.textLabel!.rex_text <~ name
            //cell.detailTextLabel!.rac_text <~ color
        }
    }
    
    let name = MutableProperty<String>("")
    //let color = MutableProperty<String>("")
    
    init(withContact contact: Contact) {
        self.contact = contact
        self.name.value = contact.name
        //self.color.value = contact.color
    }
}
