//
//  LinkView.swift
//  Notes
//
//  Created by Azat Almeev on 30.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI
import LinkPresentation

final class LinkViewContainer: UIView {

    private let linkView: LPLinkView

    init(url: URL) {
        self.linkView = LPLinkView(url: url)
        super.init(frame: .zero)
        self.clipsToBounds = true
        self.linkView.isUserInteractionEnabled = false
        self.linkView.frame = self.bounds.insetBy(dx: -3, dy: -3)
        self.linkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.linkView)

        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { metadata, _ in
            guard let metadata = metadata else { return }
            DispatchQueue.main.async {
                self.linkView.metadata = metadata
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct LinkView: UIViewRepresentable {

    let url:URL

    func makeUIView(context: Context) -> LinkViewContainer {
        LinkViewContainer(url: self.url)
    }

    func updateUIView(_ view: LinkViewContainer, context: Context) {
        
    }
}
