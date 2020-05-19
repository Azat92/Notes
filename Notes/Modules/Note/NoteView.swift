//
//  NoteView.swift
//  Notes
//
//  Created by Azat Almeev on 23.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

private class NoteAttachmentHolder {
    
    var value: NoteAttachmentModel?
}

struct NoteView: View {

    private enum PickerType {
        case dateTime, gallery, camera, website, map
    }

    @State private var attachments: [NoteAttachmentModel] = []

    @State private var isKeyboardVisible = false
    @State private var isNoteBodyFirstResponder = false
    @State private var isAttachmentTypeActionSheetVisible = false
    @State private var isAttachmentPickerViewVisible = false
    @State private var attachmentPickerViewType: PickerType? {
        didSet {
            self.isAttachmentPickerViewVisible = true
        }
    }
    @State private var isAttachmentActionsActionSheetVisible = false
    @State private var isAttachmentPreviewViewVisible = false

    @State private(set) var title: String
    @State private(set) var noteBody: String

    let controller: NoteController

    private let selectedAttachment = NoteAttachmentHolder()

    var body: some View {
        VStack {
            self.titleTextField.padding(.init([.leading, .trailing, .top])).padding(.bottom, 4)
            Divider()
            self.bodyDescriptionTitlePanel.padding(.bottom, -16)
            self.bodyTextView.padding()
            if self.attachments.count > 0 {
                self.attachmentsView.padding(.horizontal, 10)
            }
            Divider()
            self.editPanel.padding()
        }
        .navigationBarTitle(Text(self.title), displayMode: .inline)
        .navigationBarItems(trailing: self.doneButton)
        .keyboardResponsive(isKeyboardVisible: self.$isKeyboardVisible).animation(.easeOut(duration: 0.3))
        .onAppear {
            self.controller.activate(attachemnts: self.$attachments)
        }
        .onDisappear {
            self.controller.save(title: self.title, body: self.noteBody)
        }
    }

    private var titleTextField: some View {
        TextField("business.note-title.title", text: self.$title)
    }

    private var bodyDescriptionTitlePanel: some View {
        HStack {
            self.bodyDescriptionTitle
            Spacer()
        }
    }

    private var bodyDescriptionTitle: some View {
        Text("business.note-description.title")
            .foregroundColor(.gray)
            .padding(.horizontal)
            .onTapGesture {
                self.isNoteBodyFirstResponder = true
            }
    }

    private var bodyTextView: some View {
        TextView(text: self.$noteBody, isFirstResponder: self.$isNoteBodyFirstResponder)
    }

    private var attachmentsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(self.attachments) { attachment in
                    self.noteAttachmentView(attachment)
                        .frame(width: 170, height: 60)
                        .border(Color.gray, width: 1)
                        .onTapGesture {
                            self.selectedAttachment.value = attachment
                            self.isAttachmentActionsActionSheetVisible = true
                        }
                }
            }
        }
        .actionSheet(isPresented: self.$isAttachmentActionsActionSheetVisible) {
            self.attachmentActionsActionSheet
        }
        .sheet(isPresented: self.$isAttachmentPreviewViewVisible) {
            self.attachmentPreviewView
        }
    }

    private var editPanel: some View {
        HStack {
            Spacer()
            self.pickAttachmentButton
        }
    }

    private var doneButton: some View {
        if self.isKeyboardVisible {
            return AnyView(Button(
                action: {
                    UIApplication.shared.resignFirstResponder()
                },
                label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }))
        } else {
            return AnyView(Text(""))
        }
    }

    private var pickAttachmentButton: some View {
        Button(
            action: {
                self.isAttachmentTypeActionSheetVisible = true
            },
            label: {
                Image(systemName: "paperclip")
            })
            .actionSheet(isPresented: self.$isAttachmentTypeActionSheetVisible) {
                self.attachmentTypeActionSheet
            }
            .sheet(isPresented: self.$isAttachmentPickerViewVisible) {
                self.attachmentPickerView
            }
    }

    private var attachmentTypeActionSheet: ActionSheet {
        ActionSheet(title: Text("business.attachments.title"), buttons:
            [.default(Text("business.attachments.type.date-time.title")) { self.attachmentPickerViewType = .dateTime },
             .default(Text("business.attachments.type.gallery.title")) { self.attachmentPickerViewType = .gallery },
             .default(Text("business.attachments.type.camera.title")) { self.attachmentPickerViewType = .camera },
             .default(Text("business.attachments.type.web-link.title")) { self.attachmentPickerViewType = .website },
             .default(Text("business.attachments.type.geolocation.title")) { self.attachmentPickerViewType = .map },
             .cancel()]
        )
    }

    private var attachmentPickerView: some View {
        switch self.attachmentPickerViewType {
        case .dateTime:
            return AnyView(DatePickerView(isVisible: self.$isAttachmentPickerViewVisible, delegate: self.controller))
        case .gallery:
            return AnyView(ImagePickerView(mode: .gallery, delegate: self.controller))
        case .camera:
            return AnyView(ImagePickerView(mode: .camera, delegate: self.controller))
        case .website:
            return AnyView(WebsitePickerView(isVisible: self.$isAttachmentPickerViewVisible, delegate: self.controller))
        case .map:
            return AnyView(GeolocationPickerView(isVisible: self.$isAttachmentPickerViewVisible, delegate: self.controller))
        case .none:
            fatalError()
        }
    }

    private var attachmentActionsActionSheet: ActionSheet {
        var buttons: [Alert.Button] = [.destructive(Text("general.delete.title"), action: self.handleRemoveAttachment), .cancel()]
        switch self.selectedAttachment.value?.attachment {
        case .date, .image, .website, .geolocation:
            buttons.insert(.default(Text("general.preview.title")) { self.isAttachmentPreviewViewVisible = true }, at: 0)
        case .some(.none), .none:
            break
        }
        return ActionSheet(title: Text("general.actions.title"), buttons: buttons)
    }

    private var attachmentPreviewView: some View {
        switch self.selectedAttachment.value?.attachment {
        case let .date(date, mode):
            return AnyView(DateDetailViewer(isVisible: self.$isAttachmentPreviewViewVisible, date: date, mode: mode))
        case let .image(_, payload):
            return AnyView(ImageDetailViewer(isVisible: self.$isAttachmentPreviewViewVisible, image: payload))
        case let .website(url):
            return AnyView(WebsiteDetailViewer(isVisible: self.$isAttachmentPreviewViewVisible, url: url))
        case let .geolocation(point, location):
            return AnyView(GeolocationDetailViewer(isVisible: self.$isAttachmentPreviewViewVisible, points: [point], location: location))
        case .some, .none:
            fatalError()
        }
    }

    private func noteAttachmentView(_ attachment: NoteAttachmentModel) -> some View {
        switch attachment.attachment {
        case let .date(date, mode) where mode == .date:
            return AnyView(FullDateAttachmentView(date: date))
        case let .date(date, mode: mode) where mode == .dateTime:
            return AnyView(DateTimeAttachmentView(date: date))
        case let .date(date, mode: mode) where mode == .time:
            return AnyView(TimeAttachmentView(date: date))
        case let .image(preview, _):
            return AnyView(ImageAttachmentView(image: preview))
        case let .website(url):
            return AnyView(LinkAttachmentView(url: url))
        case let .geolocation(point, location):
            return AnyView(GeolocationAttachmentView(location: location, title: point.title))
        case .date, .none:
            return AnyView(Image(systemName: "doc").resizable().scaledToFit().padding())
        }
    }

    private func handleRemoveAttachment() {
        self.selectedAttachment.value.flatMap(self.controller.removeAttachment)
    }
}
