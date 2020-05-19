//
//  NotesManager.swift
//  Notes
//
//  Created by Azat Almeev on 26.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

final class NotesManager {

    let service: NotesServiceProtocol

    init(service: NotesServiceProtocol) {
        self.service = service
    }

    func getNotes(categoryId: String) -> [NoteItemModel] {
        self.service.getNotes(categoryId: categoryId).map(StoregeToPresentationModelMapper.map)
    }

    func addNote(categoryId: String, title: String) {
        self.service.addNote(categoryId: categoryId, title: title)
    }

    func removeNote(_ note: NoteItemModel) {
        self.service.removeNote(PresentationToStorageModelMapper.map(note))
    }

    func moveNote(_ note: NoteItemModel, toPosition position: Int) {
        self.service.moveNote(PresentationToStorageModelMapper.map(note), toPosition: position)
    }

    func updateNote(_ note: NoteItemModel) {
        self.service.updateNote(PresentationToStorageModelMapper.map(note))
    }
}
