//
//  MapView.swift
//  MapExperiments
//
//  Created by Neil Marcellini on 11/6/20.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var route: MKPolyline?
    let mapViewDelegate: MapViewDelegate

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.delegate = mapViewDelegate                          // (1) This should be set in makeUIView, but it is getting reset to `nil`
        view.translatesAutoresizingMaskIntoConstraints = false   // (2) In the absence of this, we get constraints error on rotation; and again, it seems one should do this in makeUIView, but has to be here
        addRoute(to: view)
    }
}

private extension MapView {
    func addRoute(to view: MKMapView) {
        if !view.overlays.isEmpty {
            view.removeOverlays(view.overlays)
        }

        guard let route = route else { return }
        let mapRect = route.boundingMapRect
        view.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: true)
        view.addOverlay(route)
    }
}


