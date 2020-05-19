//
//  ContentView.swift
//  Notes
//
//  Created by Azat Almeev on 19.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {

    @ObservedObject private(set) var controller: CategoriesController
    @State private var isAddCategoryViewVisible = false

    var body: some View {
        NavigationView {
            VStack {
                self.categoriesList
                Divider()
                self.editPanel.padding()
            }
            .navigationBarTitle("business.categories.title")
            .navigationBarItems(trailing: self.infoButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var categoriesList: some View {
        List {
            ForEach(self.controller.categories) { category in
                NavigationLink(
                    category.title,
                    destination: NotesView.make(category: category))
            }
            .onDelete(perform: self.controller.delete)
            .onMove(perform: self.controller.move)
        }
    }

    private var editPanel: some View {
        HStack {
            EditButton()
            Spacer()
            self.addButton
        }
    }

    private var addButton: some View {
        Button(
            action: {
                self.isAddCategoryViewVisible = true
            },
            label: {
                Image(systemName: "plus")
            })
            .sheet(isPresented: self.$isAddCategoryViewVisible) {
                CategoryDetailsView.make(isVisible: self.$isAddCategoryViewVisible)
            }
    }

    private var infoButton: some View {
        Button(
            action: {
                guard let url = URL(string: "https://vk.com/supp0rtit") else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }, label: {
                Image(systemName: "questionmark.circle")
            })
    }
}
