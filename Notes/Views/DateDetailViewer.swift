//
//  DateDetailViewer.swift
//  Notes
//
//  Created by Azat Almeev on 04.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct DateDetailViewer: View {

    @Binding private(set) var isVisible: Bool

    let date: Date
    let mode: DateAttachmentMode

    var body: some View {
        NavigationView {
            self.content
                .padding()
                .navigationBarTitle("business.attachments.type.date-time.title", displayMode: .inline)
                .navigationBarItems(trailing: self.doneButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var content: some View {
        VStack {
            ForEach(self.displayComponents, id: \.self, content: Text.init)
        }
    }

    private var doneButton: some View {
        Button(
            action: {
                self.isVisible = false
            }, label: {
                Text("general.done.title").bold()
            })
    }

    private var displayComponents: [String] {
        [self.dateDetailed, self.timeDetailed].compactMap { $0 }
    }

    private var dateDetailed: String? {
        switch mode {
        case .date, .dateTime:
            return DateFormatter.localizedString(from: self.date, dateStyle: .full, timeStyle: .none)
        case .time:
            return nil
        }
    }

    private var timeDetailed: String? {
        switch self.mode {
        case .dateTime, .time:
            return DateFormatter.localizedString(from: self.date, dateStyle: .none, timeStyle: .full)
        case .date:
            return nil
        }
    }
}
