//
//  TextView.swift
//  Notes
//
//  Created by Azat Almeev on 22.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {

    typealias UIViewType = NoPaddingTextView

    @Binding var text: String
    @Binding var isFirstResponder: Bool

    final class Coordinator: NSObject, UITextViewDelegate {

        private var text: Binding<String>
        private var isFirstResponder: Binding<Bool>

        init(text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }

        func textViewDidChange(_ uiView: UITextView) {
            self.text.wrappedValue = uiView.text
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            self.isFirstResponder.wrappedValue = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: self.$text, isFirstResponder: self.$isFirstResponder)
    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
        let textView = UIViewType()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Self>) {
        if uiView.text != text {
            uiView.text = text
        }
        if self.isFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        }
    }
}
