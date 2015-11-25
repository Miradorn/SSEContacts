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
        
        
        let catViewModelProducer = searchSignal.map { query in
            Contact.filter(query)
            }.map { results in
                results.map{ category in
                    CategoryViewModel.init(withCategory: category)
                }
        }
        categoryViewModels <~ catViewModelProducer
    }
    
    subscript(index: Int) -> CategoryViewModel {
        return categoryViewModels.value[index]
    }
    
    var count: Int {
        return categoryViewModels.value.count
    }
    
    func deleteCategory(index: Int) {
        let cat = self[index].category
        
        categoryViewModels.value.removeAtIndex(index)
        
        cat.delete()
    }
}
