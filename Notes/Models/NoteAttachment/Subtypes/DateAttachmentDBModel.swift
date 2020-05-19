//
//  DateAttachmentDBModel.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

struct DateAttachmentDBModel: Codable {

    enum CodingKeys: String, CodingKey {
        case version, date, mode
    }

    private let version = 1

    let date: Date
    let mode: String

    init(date: Date, mode: String) {
        self.date = date
        self.mode = mode
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _ = try values.decode(Int.self, forKey: .version) // for versioning
        self.date = try values.decode(Date.self, forKey: .date)
        self.mode = try values.decode(String.self, forKey: .mode)
    }
}
