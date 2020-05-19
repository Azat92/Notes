//
//  PresentationToStorageModelMapper.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

enum PresentationToStorageModelMapper {

    static func map(_ model: NoteCategoryModel) -> NoteCategoryDBModel {
        NoteCategoryDBModel(id: model.id, title: model.title, order: model.order)
    }

    static func map(_ model: NoteItemModel) -> NoteItemDBModel {
        NoteItemDBModel(id: model.id, categoryId: model.categoryId, title: model.title, body: model.body, order: model.order)
    }

    static func map(_ model: NoteAttachmentModel) -> NoteAttachmentDBModel {
        NoteAttachmentDBModel(id: model.id, noteId: model.noteId, order: model.order)
    }
}
