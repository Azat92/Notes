//
//  WebView.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {

    @Binding private(set) var url: String
    @Binding private(set) var shouldLoad: Bool

    func makeUIView(context: UIViewRepresentableContext<Self>) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<Self>) {
        guard self.shouldLoad, let url = URL(string: self.url) else { return }
        uiView.load(URLRequest(url: url))
    }
}
