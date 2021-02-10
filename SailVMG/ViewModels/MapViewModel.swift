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
    let snapShotter: MKMapSnapshotter
    @Published var preview: UIImage? = nil
    @Published var route: MKPolyline?
    let trackpointRepository = TrackpointRespository()
    
    init(trackVM: TrackViewModel) {
        self.trackVM = trackVM
        let mapSnapshotOptions = MKMapSnapshotter.Options()

        // Set the region of the map that is rendered.
        let location = CLLocationCoordinate2DMake(37.332077, -122.02962) // Apple HQ
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapSnapshotOptions.region = region


        // Set the size of the image output.
        mapSnapshotOptions.size = CGSize(width: 300, height: 300)

        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true

        snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snapshot: MKMapSnapshotter.Snapshot?, error: Error?) in
            self.preview = snapshot?.image
        }
    }
    
    func addTrack() {
        trackpointRepository.getCoordinates(trackVM.track) { coordinates in
            let track_line = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.route = track_line
        }
        
    }
   
}
