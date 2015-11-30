//
//  CategoriesViewModel.swift
//  SseContacts
//
//  Created by Alexander Schramm on 19.11.15.
//  Copyright © 2015 Alexander Schramm. All rights reserved.
//

import UIKit
import RealmSwift
import ReactiveCocoa

class ContactsViewModel {
    
    
    let searchSignal: SignalProducer<String, NoError>
    let contactViewModels: MutableProperty<[ContactViewModel]>
    let category: Category
    
    init(withSearchSignal searchSignal: SignalProducer<String, NoError>, category: Category) {
        self.searchSignal = searchSignal
        self.category = category
        
        let allContactsViewModel = Contact.withCategory(category).map{ contact in ContactViewModel.init(withContact: contact) }
        contactViewModels = MutableProperty.init(allContactsViewModel)
        
        
        let contactViewModelsProducer = searchSignal.map { query in
            Contact.filter(query, category: category )
        }.map { results in
                results.map { contact in
                    ContactViewModel.init(withContact: contact)
                }
        }
        contactViewModels <~ contactViewModelsProducer
    }
    
    subscript(index: Int) -> ContactViewModel {
        return contactViewModels.value[index]
    }
    
    var count: Int {
        return contactViewModels.value.count
    }
    
    func deleteContact(index: Int) {
        let contact = self[index].contact
        
        contactViewModels.value.removeAtIndex(index)
        
        contact.delete()
    }
}
