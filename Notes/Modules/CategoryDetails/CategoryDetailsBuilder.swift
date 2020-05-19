//
//  CategoryDetailsBuilder.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

extension CategoryDetailsView {

    static func make(isVisible: Binding<Bool>, category: NoteCategoryModel? = nil) -> CategoryDetailsView {
        let controller = CategoryDetailsController(
            category: category,
            manager: Services.shared.categoriesManager)
        return CategoryDetailsView(isVisible: isVisible, controller: controller)
    }
}
