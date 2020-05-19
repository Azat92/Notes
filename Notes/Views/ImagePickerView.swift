//
//  ImagePickerView.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

protocol ImagePickerViewDelegate: class {

    func imagePickerView(_ imagePickerView: ImagePickerView, didPickImage image: UIImage)
}

struct ImagePickerView: UIViewControllerRepresentable {

    enum Mode {
        case gallery, camera
    }

    @Environment(\.presentationMode)
    var presentationMode

    let mode: Mode
    weak private(set) var delegate: ImagePickerViewDelegate?

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding private var presentationMode: PresentationMode
        private let handler: (UIImage) -> Void

        init(presentationMode: Binding<PresentationMode>, handler: @escaping (UIImage) -> Void) {
            self._presentationMode = presentationMode
            self.handler = handler
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.handler(image)
            }
            self.presentationMode.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.presentationMode.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode) { image in
            self.delegate?.imagePickerView(self, didPickImage: image)
        }
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        switch self.mode {
        case .gallery:
            picker.sourceType = .photoLibrary
        case .camera:
            picker.sourceType = .camera
        }
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<ImagePickerView>) {

    }
}
