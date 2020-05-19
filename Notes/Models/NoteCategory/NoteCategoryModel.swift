//
//  NoteCategoryModel.swift
//  Notes
//
//  Created by Azat Almeev on 19.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

struct NoteCategoryModel: Identifiable {

    let id: String
    let title: String
    let order: Int
}

extension NoteCategoryModel {

    func updateingTitle(_ title: String) -> Self {
        NoteCategoryModel(id: self.id, title: title, order: self.order)
    }
}
