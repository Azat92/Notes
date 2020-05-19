//
//  NoteController.swift
//  Notes
//
//  Created by Azat Almeev on 07.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI
import CoreLocation

final class NoteController {

    private(set) var note: NoteItemModel
    private var attachemnts: Binding<[NoteAttachmentModel]>?

    private let notesManager: NotesManager
    private let attachmentsManager: AttachmentsManager
    private lazy var geocoder = CLGeocoder()

    init(note: NoteItemModel, notesManager: NotesManager, attachmentsManager: AttachmentsManager) {
        self.note = note
        self.notesManager = notesManager
        self.attachmentsManager = attachmentsManager
    }

    func activate(attachemnts: Binding<[NoteAttachmentModel]>) {
        let isSubscribed = self.attachemnts != nil
        self.attachemnts = attachemnts
        DispatchQueue.main.async(execute: self.reloadData)
        guard !isSubscribed else { return }
        Services.shared.dbServiceObservable.addObserver(self, selector: #selector(self.reloadData))
    }

    func save(title: String, body: String) {
        self.note = self.note.updatingTitle(title, body: body)
        self.notesManager.updateNote(self.note)
    }

    func removeAttachment(_ attachment: NoteAttachmentModel) {
        self.attachmentsManager.removeAttachment(attachment)
    }

    @objc private func reloadData() {
        self.attachemnts?.wrappedValue = self.attachmentsManager.getAttahcments(note: self.note)
    }
}

extension NoteController: DatePickerViewDelegate {

    func datePickerView(_ datePickerView: DatePickerView, didPickDate date: Date, mode: DateAttachmentMode) {
        self.attachmentsManager.addAttachment(.date(date, mode: mode), note: self.note)
    }
}

extension NoteController: ImagePickerViewDelegate {

    func imagePickerView(_ imagePickerView: ImagePickerView, didPickImage image: UIImage) {
        let image = image.normalizedImage()
        self.attachmentsManager.addAttachment(.image(preview: image.previewImage(), payload: image), note: self.note)
    }
}

extension NoteController: WebsitePickerViewDelegate {

    func websitePickerView(_ websitePickerView: WebsitePickerView, didPickUrl url: String) {
        guard let url = URL(string: url) else { return }
        self.attachmentsManager.addAttachment(.website(url), note: self.note)
    }
}

extension NoteController: GeolocationPickerViewDelegate {

    func geolocationPickerView(_ geolocationPickerView: GeolocationPickerView, didPickPoints points: [GeoPoint]) {
        guard let point = points.first else { return }
        self.geocoder.reverseGeocodeLocation(CLLocation(latitude: point.latitude, longitude: point.longitude)) { place, error in
            defer { self.geolocationPickerView(geolocationPickerView, didPickPoints: Array(points.suffix(from: 1))) }
            guard let place = place?.first, let country = place.country else { return }
            let location = [country, place.locality].compactMap { $0 }.joined(separator: ", ")
            self.attachmentsManager.addAttachment(.geolocation(point, location: location), note: self.note)
        }
    }
}
