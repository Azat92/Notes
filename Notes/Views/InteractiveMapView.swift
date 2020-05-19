//
//  EditableMapView.swift
//  Notes
//
//  Created by Azat Almeev on 09.05.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import MapKit

private extension InteractiveMapView.Mode {

    var isEditable: Bool {
        switch self {
        case .picker:
            return true
        case .viewer:
            return false
        }
    }
}

protocol InteractiveMapViewDelegate: class {

    func mapView(_ mapView: InteractiveMapView, didAddAnnotation annotation: InteractiveAnnotation)
    func mapView(_ mapView: InteractiveMapView, didUpdateAnnotations annotations: [InteractiveAnnotation])
}

final class InteractiveAnnotation: NSObject, MKAnnotation {

    fileprivate let id = NSUUID().uuidString
    let coordinate: CLLocationCoordinate2D

    fileprivate var text: String

    var title: String? {
        self.text
    }

    var point: GeoPoint {
        GeoPoint(
            latitude: self.coordinate.latitude,
            longitude: self.coordinate.longitude,
            title: self.text)
    }

    convenience init(point: GeoPoint) {
        self.init(
            coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude),
            title: point.title)
    }

    fileprivate init(coordinate: CLLocationCoordinate2D, title: String? = nil) {
        self.coordinate = coordinate
        self.text = title ?? NSLocalizedString("business.attachments.type.geolocation.tap-to-see-details.title", comment: "")
    }
}

final class InteractiveMapView: MKMapView {

    enum Mode {
        case picker, viewer
    }

    weak var uiDelegate: InteractiveMapViewDelegate?
    
    private let mode: Mode
    private let locationManager = CLLocationManager()

    private var interactiveAnnotations: [InteractiveAnnotation] {
        self.annotations.compactMap { $0 as? InteractiveAnnotation }
    }

    init(mode: Mode) {
        self.mode = mode
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.delegate = self
        switch self.mode {
        case .viewer:
            break
        case .picker:
            self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.gestureRecognizerDidFire)))
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        guard self.superview != nil else { return }
        self.locationManager.requestWhenInUseAuthorization()
        self.showsUserLocation = true
    }

    func configure(withAnnotations annotations: [InteractiveAnnotation]) {
        self.removeAnnotations(self.interactiveAnnotations)
        self.addAnnotations(annotations)

        switch self.mode {
        case .picker:
            break
        case .viewer:
            if let annotation = annotations.first {
                self.configure(withCoordinate: annotation.coordinate)
            }
        }
    }

    private func configure(withCoordinate coordinate: CLLocationCoordinate2D) {
        self.camera.centerCoordinate = coordinate
        self.camera.centerCoordinateDistance = 5000
    }

    @objc private func gestureRecognizerDidFire(sender: UIGestureRecognizer) {
        guard sender.state == .began else { return }
        let annotation = InteractiveAnnotation(coordinate: self.convert(sender.location(in: self), toCoordinateFrom: self))
        self.uiDelegate?.mapView(self, didAddAnnotation: annotation)
    }
}

extension InteractiveMapView: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? InteractiveAnnotation else { return nil }
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        view.displayPriority = .required
        view.canShowCallout = self.mode.isEditable
        view.leftCalloutAccessoryView = self.mode.isEditable ? UIButton(type: .detailDisclosure) : nil
        return view
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard self.mode.isEditable, let annotation = view.annotation as? InteractiveAnnotation else { return }
        var responder: UIResponder? = mapView
        repeat {
            responder = responder?.next
        } while !(responder is UIViewController)
        guard let viewController = responder as? UIViewController else { return }
        let alert = UIAlertController(
            title: NSLocalizedString("business.attachments.type.geolocation.title", comment: ""),
            message: nil,
            preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("placeholder.name.title", comment: "")
            textField.autocapitalizationType = .sentences
            textField.text = view.annotation?.title ?? nil
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("general.ok.title", comment: ""), style: .default) { [weak alert] _ in
            guard let text = alert?.textFields?.first?.text, !text.isEmpty,
                let annotation = self.interactiveAnnotations.first(where: { $0.id == annotation.id }) else { return }
            annotation.text = text
            self.uiDelegate?.mapView(self, didUpdateAnnotations: self.interactiveAnnotations)
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("general.cancel.title", comment: ""), style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
