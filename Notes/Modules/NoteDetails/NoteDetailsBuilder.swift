//
//  NoteDetailsBuilder.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

extension NoteDetailsView {

    static func make(isVisible: Binding<Bool>, category: NoteCategoryModel) -> NoteDetailsView {
        let controller = NoteDetailsController(
            category: category,
            manager: Services.shared.notesManager)
        return NoteDetailsView(isVisible: isVisible, controller: controller)
    }
}
