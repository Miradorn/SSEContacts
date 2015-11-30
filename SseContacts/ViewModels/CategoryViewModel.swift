//
//  CategoryViewModel.swift
//  SseContacts
//
//  Created by Alexander Schramm on 19.11.15.
//  Copyright © 2015 Alexander Schramm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class CategoryViewModel {
    
    let category: Category
    var cell: CategoryTableViewCell! {
        didSet {
            cell.textLabel!.rex_text <~ name
            cell.detailTextLabel!.rex_text <~ color
        }
    }
    
    let name = MutableProperty<String>("")
    let color = MutableProperty<String>("")
    
    init(withCategory category: Category) {
        self.category = category
        self.name.value = category.name
        self.color.value = category.color
    }
}
