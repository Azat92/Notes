//
//  NoteDetailsController.swift
//  Notes
//
//  Created by Azat Almeev on 01.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

final class NoteDetailsController {

    let category: NoteCategoryModel

    private let manager: NotesManager

    init(category: NoteCategoryModel, manager: NotesManager) {
        self.category = category
        self.manager = manager
    }

    func save(title: String) {
        self.manager.addNote(categoryId: self.category.id, title: title)
    }
}
