//
//  CategoriesManager.swift
//  Notes
//
//  Created by Azat Almeev on 01.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

final class CategoriesManager {

    let service: CategoriesServiceProtocol

    init(service: CategoriesServiceProtocol) {
        self.service = service
    }

    func getCategories() -> [NoteCategoryModel] {
        self.service.getCategories().map(StoregeToPresentationModelMapper.map)
    }

    func getCategory(withId id: String) -> NoteCategoryModel? {
        self.service.getCategory(withId: id).flatMap(StoregeToPresentationModelMapper.map)
    }

    func addCategory(withTitle title: String) {
        self.service.addCategory(withTitle: title)
    }

    func updateCategory(_ category: NoteCategoryModel) {
        self.service.updateCategory(PresentationToStorageModelMapper.map(category))
    }

    func removeCategory(_ category: NoteCategoryModel) {
        self.service.removeCategory(PresentationToStorageModelMapper.map(category))
    }

    func moveCategory(_ category: NoteCategoryModel, toPosition position: Int) {
        self.service.moveCategory(withId: category.id, toPosition: position)
    }
}
