//
//  NoteAttachmentDBModel.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

struct NoteAttachmentDBModel: DBModelProtocol {

    enum CodingKeys: String, CodingKey {
        case version, id, noteId, order, dateAttahcment, imageAttachment, websiteAttachment, geolocationAttachment
    }

    private let version = 1

    let id: String
    let noteId: String
    let order: Int

    var key: String {
        self.id
    }

    static var collection: DBService.Collection {
        .attachments
    }

    let dateAttahcment: DateAttachmentDBModel?
    let imageAttachment: ImageAttachmentDBModel?
    let websiteAttachment: WebsiteAttachmentDBModel?
    let geolocationAttachment: GeolocationAttachmentDBModel?

    init(id: String = NSUUID().uuidString,
         noteId: String,
         order: Int,
         dateAttahcment: DateAttachmentDBModel? = nil,
         imageAttachment: ImageAttachmentDBModel? = nil,
         websiteAttachment: WebsiteAttachmentDBModel? = nil,
         geolocationAttachment: GeolocationAttachmentDBModel? = nil) {
        self.id = id
        self.noteId = noteId
        self.order = order
        self.dateAttahcment = dateAttahcment
        self.imageAttachment = imageAttachment
        self.websiteAttachment = websiteAttachment
        self.geolocationAttachment = geolocationAttachment
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _ = try values.decode(Int.self, forKey: .version) // for versioning
        self.id = try values.decode(String.self, forKey: .id)
        self.noteId = try values.decode(String.self, forKey: .noteId)
        self.order = try values.decode(Int.self, forKey: .order)
        self.dateAttahcment = try values.decodeIfPresent(DateAttachmentDBModel.self, forKey: .dateAttahcment)
        self.imageAttachment = try values.decodeIfPresent(ImageAttachmentDBModel.self, forKey: .imageAttachment)
        self.websiteAttachment = try values.decodeIfPresent(WebsiteAttachmentDBModel.self, forKey: .websiteAttachment)
        self.geolocationAttachment = try values.decodeIfPresent(GeolocationAttachmentDBModel.self, forKey: .geolocationAttachment)
    }
}
