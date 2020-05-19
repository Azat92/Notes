//
//  ImageAttachmentDBModel.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

struct ImageAttachmentDBModel: Codable {

    enum CodingKeys: String, CodingKey {
        case version, previewData, payloadData
    }

    private let version = 1

    let previewData: Data
    let payloadData: Data

    init(previewData: Data, payloadData: Data) {
        self.previewData = previewData
        self.payloadData = payloadData
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _ = try values.decode(Int.self, forKey: .version) // for versioning
        self.previewData = try values.decode(Data.self, forKey: .previewData)
        self.payloadData = try values.decode(Data.self, forKey: .payloadData)
    }
}
