//
//  WebsitePickerView.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

protocol WebsitePickerViewDelegate: class {

    func websitePickerView(_ websitePickerView: WebsitePickerView, didPickUrl url: String)
}

struct WebsitePickerView: View {
    
    @Binding private(set) var isVisible: Bool
    @State private var url = ""
    @State private var isTextVisible = true
    private(set) weak var delegate: WebsitePickerViewDelegate?

    var body: some View {
        NavigationView {
            VStack {
                if isTextVisible {
                    self.urlTextField.padding()
                    Spacer()
                } else {
                    self.webView
                }
            }
            .navigationBarTitle("business.attachments.type.web-link.title", displayMode: .inline)
            .navigationBarItems(trailing: self.saveButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var webView: some View {
        WebView(
            url: self.$url,
            shouldLoad: Binding<Bool>(get: { !self.isTextVisible }, set: { _ in }))
    }

    private var urlTextField: some View {
        TextField("https://", text: self.$url) {
            self.isTextVisible.toggle()
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .keyboardType(.URL)
    }

    private var saveButton: some View {
        Button(
            action: {
                self.delegate?.websitePickerView(self, didPickUrl: self.url)
                self.isVisible = false
            },
            label: {
                Text("general.save.title").bold()
            })
    }
}
