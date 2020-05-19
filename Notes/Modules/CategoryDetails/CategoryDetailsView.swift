//
//  CategoryDetailsView.swift
//  Notes
//
//  Created by Azat Almeev on 23.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct CategoryDetailsView: View {

    @Binding private(set) var isVisible: Bool
    @State private var title = ""

    let controller: CategoryDetailsController

    var body: some View {
        NavigationView {
            Form {
                self.titleTextField
            }
            .navigationBarTitle("business.category.title", displayMode: .inline)
            .navigationBarItems(trailing: self.saveButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.title = self.controller.category?.title ?? ""
        }
    }

    private var titleTextField: some View {
        TextField("placeholder.name.title", text: self.$title)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }

    private var saveButton: some View {
        Button(
            action: {
                self.controller.save(title: self.title)
                self.isVisible = false
            },
            label: {
                Text("general.save.title").bold()
            })
            .disabled(self.title.isEmpty)
    }
}
