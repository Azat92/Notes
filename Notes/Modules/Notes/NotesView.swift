//
//  CategoryView.swift
//  Notes
//
//  Created by Azat Almeev on 19.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct NotesView: View {

    @State private(set) var title: String
    @State private var notes: [NoteItemModel] = []
    @State private var isNoteDetailViewVisible = false
    @State private var isCategoryDetailViewVisible = false

    let controller: NotesController

    var body: some View {
        VStack {
            self.notesList
            Divider()
            self.editPanel.padding()
        }
        .navigationBarTitle(Text(self.title), displayMode: .inline)
        .navigationBarItems(trailing: self.categoryEditButton)
        .onAppear {
            self.controller.activate(notes: self.$notes, title: self.$title)
        }
    }

    private var notesList: some View {
        List {
            ForEach(self.notes) { note in
                NavigationLink(note.title, destination: NoteView.make(note: note))
            }
            .onDelete(perform: self.delete)
            .onMove(perform: self.move)
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
                self.isNoteDetailViewVisible = true
            },
            label: {
                Image(systemName: "plus")
            })
            .sheet(isPresented: self.$isNoteDetailViewVisible) {
                NoteDetailsView.make(isVisible: self.$isNoteDetailViewVisible, category: self.controller.category)
            }
    }

    private var categoryEditButton: some View {
        Button(
            action: {
                self.isCategoryDetailViewVisible = true
            },
            label: {
                Image(systemName: "pencil")
            })
            .sheet(isPresented: self.$isCategoryDetailViewVisible) {
                CategoryDetailsView.make(
                    isVisible: self.$isCategoryDetailViewVisible,
                    category: self.controller.category)
            }
    }

    private func delete(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        self.controller.delete(note: self.notes[index])
    }

    private func move(from source: IndexSet, to destination: Int) {
        guard let index = source.first else { return }
        self.controller.move(note: self.notes[index], to: destination)
    }
}
