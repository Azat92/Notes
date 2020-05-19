//
//  Services.swift
//  Notes
//
//  Created by Azat Almeev on 29.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

final class Services {

    static let shared = Services()

    private lazy var dbService: DBServiceProtocol & DBServiceObservableProtocol = DBService()

    private lazy var categoriesService: CategoriesServiceProtocol = CategoriesService(dbService: self.dbService)

    private lazy var notesService: NotesServiceProtocol = NotesService(dbService: self.dbService)

    private lazy var attachmentsService: AttachmentsServiceProtocol = AttachmentsService(dbService: self.dbService)

    var dbServiceObservable: DBServiceObservableProtocol {
        self.dbService
    }

    var categoriesManager: CategoriesManager {
        CategoriesManager(service: self.categoriesService)
    }

    var notesManager: NotesManager {
        NotesManager(service: self.notesService)
    }

    var attachmentsManager: AttachmentsManager {
        AttachmentsManager(service: self.attachmentsService)
    }
}
