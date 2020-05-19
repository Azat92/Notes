//
//  AttachmentsManager.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

final class AttachmentsManager {

    let service: AttachmentsServiceProtocol

    init(service: AttachmentsServiceProtocol) {
        self.service = service
    }

    func getAttahcments(note: NoteItemModel) -> [NoteAttachmentModel] {
        self.service.getAttahcments(noteId: note.id).map(StoregeToPresentationModelMapper.map)
    }

    func addAttachment(_ attachment: NoteAttachmentModel.Attachment, note: NoteItemModel) {
        switch attachment {
        case let .date(date, mode):
            self.service.addAttachment(DateAttachmentDBModel(date: date, mode: mode.rawValue), noteId: note.id)
        case let .image(preview, payload):
            if let previewData = preview.pngData(), let payloadData = payload.pngData() {
                self.service.addAttachment(ImageAttachmentDBModel(previewData: previewData, payloadData: payloadData), noteId: note.id)
            }
        case let .website(url):
            self.service.addAttachment(WebsiteAttachmentDBModel(url: url.absoluteString), noteId: note.id)
        case let .geolocation(geoPoint, location):
            self.service.addAttachment(GeolocationAttachmentDBModel(latitude: geoPoint.latitude, longitude: geoPoint.longitude, title: geoPoint.title, location: location), noteId: note.id)
        case .none:
            break
        }
    }

    func removeAttachment(_ attachment: NoteAttachmentModel) {
        self.service.removeAttachment(PresentationToStorageModelMapper.map(attachment))
    }
}
