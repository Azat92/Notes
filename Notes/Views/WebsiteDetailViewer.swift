//
//  WebsiteDetailViewer.swift
//  Notes
//
//  Created by Azat Almeev on 04.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct WebsiteDetailViewer: View {

    @Binding private(set) var isVisible: Bool

    let url: URL

    var body: some View {
        NavigationView {
            self.content
                .navigationBarTitle("business.attachments.type.web-link.title", displayMode: .inline)
                .navigationBarItems(trailing: self.doneButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var content: some View {
        WebView(
            url: Binding<String>(get: { self.url.absoluteString }, set: { _ in }),
            shouldLoad: Binding<Bool>(get: { true }, set: { _ in }))
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
