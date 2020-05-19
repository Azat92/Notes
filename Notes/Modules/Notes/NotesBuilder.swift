//
//  NotesBuilder.swift
//  Notes
//
//  Created by Azat Almeev on 07.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

extension NotesView {

    static func make(category: NoteCategoryModel) -> NotesView {
        let controller = NotesController(
            category: category,
            categoriesManager: Services.shared.categoriesManager,
            notesManager: Services.shared.notesManager)
        return NotesView(title: category.title, controller: controller)
    }
}
