//
//  MapPreviewViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/9/21.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    var trackVM: TrackViewModel
    @Published var preview: UIImage? = nil
    @Published var route: MKPolyline? = nil
    let trackpointRepository = TrackpointRespository()
    var coordinates = [CLLocationCoordinate2D]()
    
    init(trackVM: TrackViewModel) {
        self.trackVM = trackVM
        self.addTrack()
    }
    
    func addTrack() {
        trackpointRepository.getCoordinates(trackVM.track) { coordinates in
            self.coordinates = coordinates
            let track_line = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.route = track_line
            self.makePreview()
            
        }
    }
    
    func makePreview() {
        let view = MKMapView()
        addRoute(to: view)
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        mapSnapshotOptions.mapRect = self.route!.boundingMapRect
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snapshot: MKMapSnapshotter.Snapshot?, error: Error?) in
            self.drawImageRoute(snapshot: snapshot)
        }
        
    }
    
    func addRoute(to view: MKMapView) {
        if !view.overlays.isEmpty {
            view.removeOverlays(view.overlays)
        }

        guard let route = route else { return }
        let mapRect = route.boundingMapRect
        view.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: true)
        view.addOverlay(route)
    }
    
    func drawImageRoute(snapshot: MKMapSnapshotter.Snapshot?) {
        let image = snapshot?.image
        UIGraphicsBeginImageContextWithOptions((image?.size)!, true, (image?.scale)!)
        image?.draw(at: CGPoint(x: 0, y: 0))

        let context = UIGraphicsGetCurrentContext()
        context!.setStrokeColor(UIColor.blue.cgColor)
        context!.setLineWidth(3.0)
        context!.beginPath()

        for (index, coordinate) in self.coordinates.enumerated() {
            let point = snapshot?.point(for: coordinate)
            if index == 0 {
                context?.move(to: point!)
            } else {
                context?.addLine(to:point!)
            }
        }
        context?.strokePath()
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.preview = finalImage
    }
   
}
