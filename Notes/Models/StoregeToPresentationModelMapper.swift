//
//  StoregeToPresentationModelMapper.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import UIKit

enum StoregeToPresentationModelMapper {

    static func map(_ model: NoteCategoryDBModel) -> NoteCategoryModel {
        NoteCategoryModel(id: model.id, title: model.title, order: model.order)
    }

    static func map(_ model: NoteAttachmentDBModel) -> NoteAttachmentModel {
        let attachment: NoteAttachmentModel.Attachment
        if let payload = model.dateAttahcment {
            switch payload.mode {
            case DateAttachmentMode.dateTime.rawValue:
                attachment = .date(payload.date, mode: .dateTime)
            case DateAttachmentMode.date.rawValue:
                attachment = .date(payload.date, mode: .date)
            case DateAttachmentMode.time.rawValue:
                attachment = .date(payload.date, mode: .time)
            default:
                attachment = .none
            }
        } else if let payload = model.imageAttachment, let previewImage = UIImage(data: payload.previewData), let payloadImage = UIImage(data: payload.payloadData) {
            attachment = .image(preview: previewImage, payload: payloadImage)
        } else if let payload = model.websiteAttachment, let url = URL(string: payload.url) {
            attachment = .website(url)
        } else if let payload = model.geolocationAttachment {
            let geoPoint = GeoPoint(latitude: payload.latitude, longitude: payload.longitude, title: payload.title)
            attachment = .geolocation(geoPoint, location: payload.location)
        } else {
            attachment = .none
        }
        return NoteAttachmentModel(id: model.id, noteId: model.noteId, order: model.order, attachment: attachment)
    }

    static func map(_ model: NoteItemDBModel) -> NoteItemModel {
        NoteItemModel(id: model.id, categoryId: model.categoryId, title: model.title, body: model.body, order: model.order)
    }
}
