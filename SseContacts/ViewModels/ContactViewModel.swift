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
            cell.textLabel!.rac_text <~ name
            cell.detailTextLabel!.rac_text <~ color
        }
    }
    
    let name = MutableProperty<String>("")
    let color = MutableProperty<String>("")
    
    init(withContact contact: Contact) {
        self.contact = contact
        self.name.value = category.name
        self.color.value = category.color
    }
}
