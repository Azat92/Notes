//
//  GeolocationPickerView.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

protocol GeolocationPickerViewDelegate: class {

    func geolocationPickerView(_ geolocationPickerView: GeolocationPickerView, didPickPoints points: [GeoPoint])
}

struct GeolocationPickerView: View {

    @Binding private(set) var isVisible: Bool
    @State private var points: [GeoPoint] = []
    
    private(set) weak var delegate: GeolocationPickerViewDelegate?

    var body: some View {
        NavigationView {
            self.mapView.navigationBarTitle("business.attachments.type.geolocation.title", displayMode: .inline)
            .navigationBarItems(trailing: self.saveButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var mapView: some View {
        MapView(points: self.$points, mode: .picker)
    }

    private var saveButton: some View {
        Button(
            action: {
                self.delegate?.geolocationPickerView(self, didPickPoints: self.points)
                self.isVisible = false
            },
            label: {
                Text("general.save.title").bold()
            })
    }
}
