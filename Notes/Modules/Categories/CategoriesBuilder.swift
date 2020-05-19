//
//  CategoriesBuilder.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

extension CategoriesView {

    static func make() -> CategoriesView {
        CategoriesView(controller: CategoriesController(manager: Services.shared.categoriesManager))
    }
}
