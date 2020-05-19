//
//  CategoryDetailsController.swift
//  Notes
//
//  Created by Azat Almeev on 23.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

final class CategoryDetailsController {

    private(set) var category: NoteCategoryModel?
    
    private let manager: CategoriesManager

    init(category: NoteCategoryModel?, manager: CategoriesManager) {
        self.category = category
        self.manager = manager
    }

    func save(title: String) {
        if let category = self.category {
            let updatedCategory = category.updateingTitle(title)
            self.manager.updateCategory(updatedCategory)
            self.category = updatedCategory
        } else {
            self.manager.addCategory(withTitle: title)
        }
    }
}
