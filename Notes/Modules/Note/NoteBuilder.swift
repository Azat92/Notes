//
//  NoteBuilder.swift
//  Notes
//
//  Created by Azat Almeev on 07.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

extension NoteView {

    static func make(note: NoteItemModel) -> NoteView {
        let controller = NoteController(
            note: note,
            notesManager: Services.shared.notesManager,
            attachmentsManager: Services.shared.attachmentsManager)
        return NoteView(title: note.title, noteBody: note.body, controller: controller)
    }
}
