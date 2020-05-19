//
//  MapView.swift
//  Notes
//
//  Created by Azat Almeev on 14.03.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import SwiftUI

struct MapView: UIViewRepresentable {

    @Binding private(set) var points: [GeoPoint]

    let mode: InteractiveMapView.Mode

    final class Coordinator: NSObject, InteractiveMapViewDelegate {

        private var points: Binding<[GeoPoint]>
        private var annotations: [InteractiveAnnotation] {
            didSet {
                self.points.wrappedValue = annotations.map { $0.point }
            }
        }

        init(points: Binding<[GeoPoint]>) {
            self.points = points
            self.annotations = points.wrappedValue.map(InteractiveAnnotation.init)
        }

        func configure(mapView: InteractiveMapView) {
            mapView.configure(withAnnotations: self.annotations)
        }

        func mapView(_ mapView: InteractiveMapView, didAddAnnotation annotation: InteractiveAnnotation) {
            self.annotations.append(annotation)
        }

        func mapView(_ mapView: InteractiveMapView, didUpdateAnnotations annotations: [InteractiveAnnotation]) {
            self.annotations = annotations
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(points: self.$points)
    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> InteractiveMapView {
        let mapView = InteractiveMapView(mode: self.mode)
        mapView.uiDelegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: InteractiveMapView, context: UIViewRepresentableContext<Self>) {
        context.coordinator.configure(mapView: uiView)
    }
}
