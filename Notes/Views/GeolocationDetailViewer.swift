//
//  GeolocationDetailViewer.swift
//  Notes
//
//  Created by Azat Almeev on 04.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct GeolocationDetailViewer: View {

    @Binding private(set) var isVisible: Bool
    @State private(set) var points: [GeoPoint]

    let location: String

    var body: some View {
        NavigationView {
            self.content
                .navigationBarTitle("business.attachments.type.geolocation.title", displayMode: .inline)
                .navigationBarItems(trailing: self.doneButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var content: some View {
        MapView(points: self.$points, mode: .viewer)
    }

    private var doneButton: some View {
        Button(
            action: {
                self.isVisible = false
            }, label: {
                Text("general.done.title").bold()
            })
    }
}
