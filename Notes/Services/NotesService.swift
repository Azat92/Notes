//
//  NotesService.swift
//  Notes
//
//  Created by Azat Almeev on 01.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

protocol NotesServiceProtocol {

    func getNotes(categoryId: String) -> [NoteItemDBModel]
    func addNote(categoryId: String, title: String)
    func removeNote(_ note: NoteItemDBModel)
    func moveNote(_ note: NoteItemDBModel, toPosition position: Int)
    func updateNote(_ note: NoteItemDBModel)
}

final class NotesService: NotesServiceProtocol {

    private let dbService: DBServiceProtocol

    init(dbService: DBServiceProtocol) {
        self.dbService = dbService
    }

    func getNotes(categoryId: String) -> [NoteItemDBModel] {
        self.dbService
            .getAllObjects()
            .filter { $0.categoryId == categoryId }
            .sorted { $0.order < $1.order }
    }

    func addNote(categoryId: String, title: String) {
        let notes = self.getNotes(categoryId: categoryId)
        let order = notes
            .map { $0.order }
            .max()
            .flatMap { $0 + 1} ?? 0
        let note = NoteItemDBModel(categoryId: categoryId, title: title, body: "", order: order)
        self.dbService.setObject(note, edge: .init(collection: .categories, key: categoryId))
    }

    func removeNote(_ note: NoteItemDBModel) {
        self.dbService.removeObject(note)
    }

    func moveNote(_ note: NoteItemDBModel, toPosition position: Int) {
        var notes = self.getNotes(categoryId: note.categoryId)
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes.move(fromOffsets: IndexSet(integer: index), toOffset: position)
            let updateNotes = notes.enumerated().map { index, note in
                note.updatingOrder(index)
            }
            self.dbService.setObjects(updateNotes)
        }
    }

    func updateNote(_ note: NoteItemDBModel) {
        self.dbService.setObject(note)
    }
}
