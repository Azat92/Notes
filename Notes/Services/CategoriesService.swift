//
//  CategoriesService.swift
//  Notes
//
//  Created by Azat Almeev on 10.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

protocol CategoriesServiceProtocol {

    func getCategories() -> [NoteCategoryDBModel]
    func addCategory(withTitle title: String)
    func getCategory(withId id: String) -> NoteCategoryDBModel?
    func updateCategory(_ category: NoteCategoryDBModel)
    func removeCategory(_ category: NoteCategoryDBModel)
    func moveCategory(withId id: String, toPosition position: Int)
}

final class CategoriesService: CategoriesServiceProtocol {

    private let dbService: DBServiceProtocol

    init(dbService: DBServiceProtocol) {
        self.dbService = dbService
    }

    func getCategories() -> [NoteCategoryDBModel] {
        self.dbService
            .getAllObjects()
            .sorted { $0.order < $1.order }
    }

    func addCategory(withTitle title: String) {
        let order = self.getCategories()
            .map { $0.order }
            .max()
            .flatMap { $0 + 1} ?? 0
        let category = NoteCategoryDBModel(title: title, order: order)
        self.dbService.setObject(category)
    }

    func getCategory(withId id: String) -> NoteCategoryDBModel? {
        self.dbService.findObject(key: id)
    }

    func updateCategory(_ category: NoteCategoryDBModel) {
        self.dbService.setObject(category)
    }

    func removeCategory(_ category: NoteCategoryDBModel) {
        self.dbService.removeObject(category)
    }

    func moveCategory(withId id: String, toPosition position: Int) {
        var categories = self.getCategories()
        if let index = categories.firstIndex(where: { $0.id == id }) {
            categories.move(fromOffsets: IndexSet(integer: index), toOffset: position)
            let updatedCategories = categories.enumerated().map { index, category in
                category.updatingOrder(index)
            }
            self.dbService.setObjects(updatedCategories)
        }
    }
}
