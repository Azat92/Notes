//
//  NoteAttachmentModel.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import UIKit

enum DateAttachmentMode: String {
    case dateTime, date, time
}

struct GeoPoint {
    
    let latitude: Double
    let longitude: Double
    let title: String
}

struct NoteAttachmentModel: Identifiable {

    enum Attachment {
        case date(Date, mode: DateAttachmentMode)
        case image(preview: UIImage, payload: UIImage)
        case website(URL)
        case geolocation(GeoPoint, location: String)
        case none
    }
    
    let id: String
    let noteId: String
    let order: Int
    let attachment: Attachment
}
