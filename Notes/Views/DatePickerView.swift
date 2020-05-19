//
//  DatePickerView.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

protocol DatePickerViewDelegate: class {

    func datePickerView(_ datePickerView: DatePickerView, didPickDate date: Date, mode: DateAttachmentMode)
}

struct DatePickerView: View {

    @Binding private(set) var isVisible: Bool
    @State private var pickerMode = 0
    @State private var selectedDate = Date()

    private(set) weak var delegate: DatePickerViewDelegate?

    var body: some View {
        NavigationView {
            Form {
                self.pickerSection
            }
            .navigationBarTitle("business.attachments.type.date-time.title", displayMode: .inline)
            .navigationBarItems(trailing: self.saveButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var pickerSection: some View {
        Section {
            self.modePicker
            self.datePicker
        }
    }

    private var modePicker: some View {
        Picker(selection: $pickerMode, label: Text("business.general-mode.title")) {
            Text("business.attachments.type.date-time.mode.date-and-time.title").tag(DateAttachmentMode.dateTime.code)
            Text("business.attachments.type.date-time.mode.date.title").tag(DateAttachmentMode.date.code)
            Text("business.attachments.type.date-time.mode.time.title").tag(DateAttachmentMode.time.code)
        }
    }

    private var datePicker: some View {
        DatePicker(selection: $selectedDate, displayedComponents: DateAttachmentMode(code: self.pickerMode).dateComponents) {
            Text("general.choose.title")
        }
    }

    private var saveButton: some View {
        Button(
            action: {
                self.delegate?.datePickerView(self, didPickDate: self.selectedDate, mode: DateAttachmentMode(code: self.pickerMode))
                self.isVisible = false
            },
            label: {
                Text("general.save.title").bold()
            })
    }
}

private extension DateAttachmentMode {

    var code: Int {
        switch self {
        case .dateTime:
            return 0
        case .date:
            return 1
        case .time:
            return 2
        }
    }

    var dateComponents: DatePickerComponents {
        switch self {
        case .dateTime:
            return [.date, .hourAndMinute]
        case .date:
            return [.date]
        case .time:
            return [.hourAndMinute]
        }
    }

    init(code: Int) {
        switch code {
        case 1:
            self = .date
        case 2:
            self = .time
        default:
            self = .dateTime
        }
    }
}
