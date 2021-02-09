//
//  MapViewDelegate.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/7/21.
//

import Foundation
import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate, ObservableObject {
    let trackVM: TrackViewModel
    
    init(_ trackVM: TrackViewModel) {
        self.trackVM = trackVM
    }


    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        let colors = trackVM.getColors()
        renderer.lineWidth = 3.0
        let locations = renderer.locations
        renderer.setColors(colors, locations: locations)
        return renderer
    }
}
