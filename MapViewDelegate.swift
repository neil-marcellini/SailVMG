//
//  MapViewDelegate.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/7/21.
//

import Foundation
import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate {
    let trackVM: TrackViewModel
    
    init(_ trackVM: TrackViewModel) {
        self.trackVM = trackVM
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        let c1 = UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1)
        let c2 = UIColor(hue: 0.5, saturation: 1, brightness: 1, alpha: 1)
        let c3 = UIColor(hue: 0.99, saturation: 1, brightness: 1, alpha: 1)
        renderer.lineWidth = 3.0
        let locations = renderer.locations
        renderer.setColors([c1, c2, c3], locations: locations)
        return renderer
    }
}
