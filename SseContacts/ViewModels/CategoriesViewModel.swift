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

class CategoriesViewModel {
    
    
    let searchSignal: SignalProducer<String, NoError>
    let categoryViewModels: MutableProperty<[CategoryViewModel]>
    
    init(withSearchSignal searchSignal: SignalProducer<String, NoError>) {
        self.searchSignal = searchSignal
        
        
        let allCatsViewModel = Category.all().map{ cat in CategoryViewModel.init(withCategory: cat) }
        categoryViewModels = MutableProperty.init(allCatsViewModel)

        
        let catViewModelProducer = searchSignal.map { query in
            Category.filter(query)
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
