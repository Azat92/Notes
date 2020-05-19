//
//  NoteDetailsView.swift
//  Notes
//
//  Created by Azat Almeev on 01.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct NoteDetailsView: View {

    @Binding private(set) var isVisible: Bool
    @State private var title: String = ""

    let controller: NoteDetailsController

    var body: some View {
        NavigationView {
            Form {
                self.titleTextField
            }
            .navigationBarTitle(Text(self.controller.category.title), displayMode: .inline)
            .navigationBarItems(trailing: self.saveButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
