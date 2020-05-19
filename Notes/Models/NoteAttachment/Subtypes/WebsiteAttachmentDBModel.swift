//
//  WebsiteAttachmentDBModel.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

struct WebsiteAttachmentDBModel: Codable {

    enum CodingKeys: String, CodingKey {
        case version, url
    }

    private let version = 1

    let url: String

    init(url: String) {
        self.url = url
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _ = try values.decode(Int.self, forKey: .version) // for versioning
        self.url = try values.decode(String.self, forKey: .url)
    }
}
