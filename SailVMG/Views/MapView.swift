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
    @ObservedObject var mapVM: MapViewModel
    let mapViewDelegate: MapViewDelegate

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.delegate = mapViewDelegate                          // (1) This should be set in makeUIView, but it is getting reset to `nil`
        view.translatesAutoresizingMaskIntoConstraints = false   // (2) In the absence of this, we get constraints error on rotation; and again, it seems one should do this in makeUIView, but has to be here
        mapVM.addRoute(to: view)
    }
}


