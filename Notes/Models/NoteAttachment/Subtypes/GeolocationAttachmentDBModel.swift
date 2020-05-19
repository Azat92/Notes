//
//  GeolocationAttachmentDBModel.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

struct GeolocationAttachmentDBModel: Codable {

    enum CodingKeys: String, CodingKey {
        case version, latitude, longitude, title, location
    }

    private let version = 1

    let latitude: Double
    let longitude: Double
    let title: String
    let location: String

    init(latitude: Double, longitude: Double, title: String, location: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.location = location
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _ = try values.decode(Int.self, forKey: .version) // for versioning
        self.latitude = try values.decode(Double.self, forKey: .latitude)
        self.longitude = try values.decode(Double.self, forKey: .longitude)
        self.title = try values.decode(String.self, forKey: .title)
        self.location = try values.decode(String.self, forKey: .location)
    }
}
