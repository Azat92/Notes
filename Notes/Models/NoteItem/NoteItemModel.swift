//
//  NoteItemModel.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

struct NoteItemModel: Identifiable {

    let id: String
    let categoryId: String
    let title: String
    let body: String
    let order: Int
}

extension NoteItemModel {

    func updatingTitle(_ title: String, body: String) -> NoteItemModel {
        NoteItemModel(id: self.id, categoryId: self.categoryId, title: title, body: body, order: self.order)
    }
}
