//
//  NoteItemDBModel.swift
//  Notes
//
//  Created by Azat Almeev on 19.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

struct NoteItemDBModel: DBModelProtocol {

    enum CodingKeys: String, CodingKey {
        case version, id, categoryId, title, body, order
    }

    private let version = 1

    let id: String
    let categoryId: String
    let title: String
    let body: String
    let order: Int

    var key: String {
        self.id
    }

    static var collection: DBService.Collection {
        .notes
    }

    init(id: String = NSUUID().uuidString, categoryId: String, title: String, body: String, order: Int) {
        self.id = id
        self.categoryId = categoryId
        self.title = title
        self.body = body
        self.order = order
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _ = try values.decode(Int.self, forKey: .version) // for versioning
        self.id = try values.decode(String.self, forKey: .id)
        self.categoryId = try values.decode(String.self, forKey: .categoryId)
        self.title = try values.decode(String.self, forKey: .title)
        self.body = try values.decode(String.self, forKey: .body)
        self.order = try values.decode(Int.self, forKey: .order)
    }
}

extension NoteItemDBModel {

    func updatingOrder(_ order: Int) -> Self {
        NoteItemDBModel(id: self.id, categoryId: self.categoryId, title: self.title, body: self.body, order: order)
    }
}
