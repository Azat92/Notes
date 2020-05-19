//
//  DBService+Migration.swift
//  Notes
//
//  Created by Azat Almeev on 11.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import YapDatabase

struct NoteCategory: DBModelProtocol {

    let id: String
    let title: String
    let order: Int

    var key: String {
        self.id
    }
}

struct NoteItem: DBModelProtocol {

    let id: String
    let categoryId: String
    let title: String
    let body: String
    let order: Int

    var key: String {
        self.id
    }
}

struct NoteAttachment: DBModelProtocol {

    let id: String
    let noteId: String
    let order: Int

    let dateAttahcment: DateAttachment?
    let imageAttachment: ImageAttachment?
    let websiteAttachment: WebsiteAttachment?
    let geolocationAttachment: GeolocationAttachment?

    var key: String {
        self.id
    }
}

struct DateAttachment: Codable {

    enum Mode: String, Codable {
        case dateTime, date, time
    }

    let date: Date
    let mode: Mode
}

struct ImageAttachment: Codable {

    let previewData: Data
    let payloadData: Data
}

struct WebsiteAttachment: Codable {

    let url: String
}

struct GeolocationAttachment: Codable {

    let latitude: Double
    let longitude: Double
    let title: String
    let location: String
}

extension DBService {

    func migrate(db: YapDatabase) {

        let isStep1 = false
        let isStep2 = false
        let isStep3 = true

        if isStep1 { // step 1
            db.registerCodableSerialization(NoteCategory.self, forCollection: "categories")
            db.registerCodableSerialization(NoteItem.self, forCollection: "notes")
            db.registerCodableSerialization(NoteAttachment.self, forCollection: "attachments")

            db.registerCodableSerialization(NoteCategoryDBModel.self, forCollection: "categoriesdb")
            db.registerCodableSerialization(NoteItemDBModel.self, forCollection: "notesdb")
            db.registerCodableSerialization(NoteAttachmentDBModel.self, forCollection: "attachmentsdb")
        }

        if isStep2 {

            db.registerCodableSerialization(NoteCategoryDBModel.self, forCollection: "categories")
            db.registerCodableSerialization(NoteItemDBModel.self, forCollection: "notes")
            db.registerCodableSerialization(NoteAttachmentDBModel.self, forCollection: "attachments")

            db.registerCodableSerialization(NoteCategoryDBModel.self, forCollection: "categoriesdb")
            db.registerCodableSerialization(NoteItemDBModel.self, forCollection: "notesdb")
            db.registerCodableSerialization(NoteAttachmentDBModel.self, forCollection: "attachmentsdb")
        }

        if isStep1 {

            let categories: [NoteCategory] = self.readCollection(.categories)
            let notes: [NoteItem] = self.readCollection(.notes)
            let attachemnts: [NoteAttachment] = self.readCollection(.attachments)

            for category in categories {
                let categoryDbModel = NoteCategoryDBModel(id: category.id, title: category.title, order: category.order)
                self.setObject(categoryDbModel, to: "categoriesdb", db: db)

                let notes = notes.filter { $0.categoryId == category.id }
                for note in notes {
                    let noteDbModel = NoteItemDBModel(id: note.id, categoryId: note.categoryId, title: note.title, body: note.body, order: note.order)
                    self.setObject(noteDbModel, to: "notesdb", db: db)

                    let attachemnts = attachemnts.filter { $0.noteId == note.id }
                    for attachment in attachemnts {
                        let dateAttachmentDbModel = attachment.dateAttahcment.flatMap {
                            DateAttachmentDBModel(date: $0.date, mode: $0.mode.rawValue)
                        }
                        let imageAttachmentDbModel = attachment.imageAttachment.flatMap {
                            ImageAttachmentDBModel(previewData: $0.previewData, payloadData: $0.payloadData)
                        }
                        let websiteAttachmentDbModel = attachment.websiteAttachment.flatMap {
                            WebsiteAttachmentDBModel(url: $0.url)
                        }
                        let geolocationAttachmentDbModel = attachment.geolocationAttachment.flatMap {
                            GeolocationAttachmentDBModel(latitude: $0.latitude, longitude: $0.longitude, title: $0.title, location: $0.location)
                        }
                        let attachmentDbModel = NoteAttachmentDBModel(
                            id: attachment.id,
                            noteId: attachment.noteId,
                            order: attachment.order,
                            dateAttahcment: dateAttachmentDbModel,
                            imageAttachment: imageAttachmentDbModel,
                            websiteAttachment: websiteAttachmentDbModel,
                            geolocationAttachment: geolocationAttachmentDbModel)
                        self.setObject(attachmentDbModel, to: "attachmentsdb", db: db)
                    }
                }
            }

            db.newConnection().readWrite { transaction in
                transaction.removeAllObjects(inCollection: "categories")
                transaction.removeAllObjects(inCollection: "notes")
                transaction.removeAllObjects(inCollection: "attachments")
            }
        }

        if isStep2 {

            let categories: [NoteCategoryDBModel] = self.readCollection(.categories)
            let notes: [NoteItemDBModel] = self.readCollection(.notes)
            let attachemnts: [NoteAttachmentDBModel] = self.readCollection(.attachments)

            for category in categories {
                self.setObject(category, to: "categories", db: db)

                let notes = notes.filter { $0.categoryId == category.id }
                for note in notes {
                    self.setObject(note, to: "notes", db: db)

                    let attachemnts = attachemnts.filter { $0.noteId == note.id }
                    for attachment in attachemnts {
                        self.setObject(attachment, to: "attachments", db: db)
                    }
                }
            }
        }

        if isStep3 {

            db.newConnection().readWrite { transaction in
                transaction.removeAllObjects(inCollection: "categoriesdb")
                transaction.removeAllObjects(inCollection: "notesdb")
                transaction.removeAllObjects(inCollection: "attachmentsdb")
            }
        }

        print("success")
    }

    func setObject<T: DBModelProtocol>(_ object: T, to collection: String, db: YapDatabase) {
        db.newConnection().readWrite { transaction in
            transaction.setObject(object, forKey: object.key, inCollection: collection)
        }
    }
}
