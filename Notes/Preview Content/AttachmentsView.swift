//
//  AttachmentsView.swift
//  Notes
//
//  Created by Azat Almeev on 03.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct AttachmentsView: View {

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                GeolocationAttachmentView(location: "Germany, München", title: "My Home")
                    .frame(width: 60, height: 60)
                    .border(Color.red, width: 1)
                LinkAttachmentView(url: URL(string: "https://google.com")!)
                    .frame(width: 60, height: 60)
                    .border(Color.red, width: 1)
                ImageAttachmentView(image: UIImage(systemName: "trash")!)
                    .frame(width: 100, height: 100)
                    .border(Color.red, width: 1)
                TimeAttachmentView(date: Date())
                    .frame(width: 60, height: 60)
                    .border(Color.red, width: 1)
                DateTimeAttachmentView(date: Date())
                    .frame(width: 60, height: 60)
                    .border(Color.red, width: 1)
                FullDateAttachmentView(date: Date())
                    .frame(width: 60, height: 60)
                    .border(Color.red, width: 1)
            }
        }
    }
}

struct AttachmentsView_Previews: PreviewProvider {

    static var previews: some View {
        AttachmentsView()
    }
}
