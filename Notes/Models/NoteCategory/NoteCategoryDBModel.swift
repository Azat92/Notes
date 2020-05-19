//
//  NoteCategoryDBModel.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

struct NoteCategoryDBModel: DBModelProtocol {

    enum CodingKeys: String, CodingKey {
        case version, id, title, order
    }

    private let version = 1

    let id: String
    let title: String
    let order: Int

    var key: String {
        self.id
    }

    static var collection: DBService.Collection {
        .categories
    }

    init(id: String = NSUUID().uuidString, title: String, order: Int) {
        self.id = id
        self.title = title
        self.order = order
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _ = try values.decode(Int.self, forKey: .version) // for versioning
        self.id = try values.decode(String.self, forKey: .id)
        self.title = try values.decode(String.self, forKey: .title)
        self.order = try values.decode(Int.self, forKey: .order)
    }
}

extension NoteCategoryDBModel {

    func updatingOrder(_ order: Int) -> Self {
        NoteCategoryDBModel(id: self.id, title: self.title, order: order)
    }
}
