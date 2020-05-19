//
//  NotesController.swift
//  Notes
//
//  Created by Azat Almeev on 26.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

final class NotesController {

    private(set) var category: NoteCategoryModel
    private var notes: Binding<[NoteItemModel]>?
    private var title: Binding<String>?

    private let categoriesManager: CategoriesManager
    private let notesManager: NotesManager

    init(category: NoteCategoryModel, categoriesManager: CategoriesManager, notesManager: NotesManager) {
        self.category = category
        self.categoriesManager = categoriesManager
        self.notesManager = notesManager
    }

    func activate(notes: Binding<[NoteItemModel]>, title: Binding<String>) {
        let isSubscribed = self.notes != nil || self.title != nil
        self.notes = notes
        self.title = title
        DispatchQueue.main.async(execute: self.reloadData)
        guard !isSubscribed else { return }
        Services.shared.dbServiceObservable.addObserver(self, selector: #selector(self.reloadData))
    }

    func delete(note: NoteItemModel) {
        self.notesManager.removeNote(note)
    }

    func move(note: NoteItemModel, to destination: Int) {
        self.notesManager.moveNote(note, toPosition: destination)
    }

    @objc private func reloadData() {
        self.categoriesManager.getCategory(withId: self.category.id).flatMap { category in
            self.category = category
            self.title?.wrappedValue = category.title
        }
        self.notes?.wrappedValue = self.notesManager.getNotes(categoryId: self.category.id)
    }
}
