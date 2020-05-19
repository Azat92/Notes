//
//  ImageDetailViewer.swift
//  Notes
//
//  Created by Azat Almeev on 04.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct ImageDetailViewer: View {

    @Binding private(set) var isVisible: Bool

    let image: UIImage

    var body: some View {
        NavigationView {
            self.content
                .navigationBarTitle("business.attachments.type.image.title", displayMode: .inline)
                .navigationBarItems(trailing: self.doneButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var content: some View {
        Image(uiImage: self.image).resizable().scaledToFit()
    }

    private var doneButton: some View {
        Button(
            action: {
                self.isVisible = false
            }, label: {
                Text("general.done.title").bold()
            })
    }
}
