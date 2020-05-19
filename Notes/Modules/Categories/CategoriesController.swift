//
//  CategoriesController.swift
//  Notes
//
//  Created by Azat Almeev on 23.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

final class CategoriesController: ObservableObject {

    @Published private(set) var categories: [NoteCategoryModel] = []

    private let manager: CategoriesManager

    init(manager: CategoriesManager) {
        self.manager = manager
        self.reloadData()
        Services.shared.dbServiceObservable.addObserver(self, selector: #selector(self.reloadData))
    }

    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        self.manager.removeCategory(self.categories[index])
    }

    func move(from source: IndexSet, to destination: Int) {
        guard let index = source.first else { return }
        self.manager.moveCategory(self.categories[index], toPosition: destination)
    }

    @objc private func reloadData() {
        self.categories = self.manager.getCategories()
    }
}
