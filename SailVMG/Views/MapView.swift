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
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var trackVM: TrackViewModel

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let delegate = MapViewDelegate(trackVM)
        view.delegate = delegate                         // (1) This should be set in makeUIView, but it is getting reset to `nil`
        view.translatesAutoresizingMaskIntoConstraints = false   // (2) In the absence of this, we get constraints error on rotation; and again, it seems one should do this in makeUIView, but has to be here
        mapVM.addRoute(to: view)
    }
}


