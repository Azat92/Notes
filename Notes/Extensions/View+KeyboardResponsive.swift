//
//  View+KeyboardResponsive.swift
//  Notes
//
//  Created by Azat Almeev on 22.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct KeyboardResponsiveModifier: ViewModifier {

    @State private var offset: CGFloat = 0
    @Binding private(set) var isKeyboardVisible: Bool

    func body(content: Content) -> some View {
        content
            .padding(.bottom, self.offset)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification) { userInfo in
                    guard let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                    let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
                    self.offset = rect.height - bottomInset
                    self.isKeyboardVisible = true
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification) { _ in
                    self.offset = 0
                    self.isKeyboardVisible = false
                }
            }
    }
}

extension View {
    
    func keyboardResponsive(isKeyboardVisible: Binding<Bool>) -> ModifiedContent<Self, KeyboardResponsiveModifier> {
        modifier(KeyboardResponsiveModifier(isKeyboardVisible: isKeyboardVisible))
    }
}
