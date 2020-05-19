//
//  AttachmentsService.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

protocol AttachmentsServiceProtocol {

    func getAttahcments(noteId: String) -> [NoteAttachmentDBModel]
    func addAttachment(_ attachment: DateAttachmentDBModel, noteId: String)
    func addAttachment(_ attachment: ImageAttachmentDBModel, noteId: String)
    func addAttachment(_ attachment: WebsiteAttachmentDBModel, noteId: String)
    func addAttachment(_ attachment: GeolocationAttachmentDBModel, noteId: String)
    func removeAttachment(_ attachment: NoteAttachmentDBModel)
}

final class AttachmentsService: AttachmentsServiceProtocol {

    private let dbService: DBServiceProtocol

    init(dbService: DBServiceProtocol) {
        self.dbService = dbService
    }

    func getAttahcments(noteId: String) -> [NoteAttachmentDBModel] {
        self.dbService
            .getAllObjects()
            .filter { $0.noteId == noteId }
            .sorted { $0.order < $1.order }
    }

    func addAttachment(_ attachment: DateAttachmentDBModel, noteId: String) {
        let model = NoteAttachmentDBModel(
            noteId: noteId,
            order: self.getNextOrder(noteId: noteId),
            dateAttahcment: attachment)
        self.dbService.setObject(model, edge: .init(collection: .notes, key: noteId))
    }

    func addAttachment(_ attachment: ImageAttachmentDBModel, noteId: String) {
        let model = NoteAttachmentDBModel(
            noteId: noteId,
            order: self.getNextOrder(noteId: noteId),
            imageAttachment: attachment)
        self.dbService.setObject(model, edge: .init(collection: .notes, key: noteId))
    }

    func addAttachment(_ attachment: WebsiteAttachmentDBModel, noteId: String) {
        let model = NoteAttachmentDBModel(
            noteId: noteId,
            order: self.getNextOrder(noteId: noteId),
            websiteAttachment: attachment)
        self.dbService.setObject(model, edge: .init(collection: .notes, key: noteId))
    }

    func addAttachment(_ attachment: GeolocationAttachmentDBModel, noteId: String) {
        let model = NoteAttachmentDBModel(
            noteId: noteId,
            order: self.getNextOrder(noteId: noteId),
            geolocationAttachment: attachment)
        self.dbService.setObject(model, edge: .init(collection: .notes, key: noteId))
    }

    func removeAttachment(_ attachment: NoteAttachmentDBModel) {
        self.dbService.removeObject(attachment)
    }

    private func getNextOrder(noteId: String) -> Int {
        self.getAttahcments(noteId: noteId)
            .map { $0.order }
            .max()
            .flatMap { $0 + 1} ?? 0
    }
}
