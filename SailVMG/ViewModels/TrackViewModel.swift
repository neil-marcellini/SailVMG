//
//  TrackViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/27/20.
//

import Foundation
import CoreLocation

class TrackViewModel: ObservableObject {
    let track: Track
    @Published var trackpoints = [Trackpoint]()
    @Published var location = ""
    @Published var maxVMG = "Max VMG: -- / -- kts"
    
    init (_ track: Track) {
        self.track = track
        let trackpointRespository = TrackpointRespository()
        trackpointRespository.getTrackpoints(track) { trackpoints in
            self.trackpoints = trackpoints
            self.getLocation(completionHandler: self.formatLocation)
            self.getMaxVMG()
        }
    }
    func getLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        guard trackpoints.count > 0 else {return}
        guard let firstPoint = trackpoints.first else { return }
        let startLocation = CLLocation(latitude: firstPoint.latitude, longitude: firstPoint.longitude)
        let geocoder = CLGeocoder()
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(startLocation, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
               // An error occurred during geocoding.
                print(error)
            }
        })
    }

    func formatLocation(_ place: CLPlacemark?) {
        guard let place = place else {return}
        if let city = place.locality,
            let state = place.administrativeArea {
            location = "\(city), \(state)"
        }
    }
    func getDate()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: track.start_time)
    }
    
    func startTime()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: track.start_time)
    }
    func endTime()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        guard let end_time = track.end_time else {
            return ""
        }
        return dateFormatter.string(from: end_time)
    }
    func getMaxVMG() {
        var upwind_display = "--"
        var downwind_display = "--"
        guard trackpoints.count > 0 else {return}
        let max_upwind = trackpoints.max { a, b in a.vmg ?? 0 < b.vmg ?? 0 }
        if let max_upwind_vmg = max_upwind?.vmg {
            upwind_display = String(format: "%.2f", max_upwind_vmg)
        }
        let max_downwind = trackpoints.min { a, b in a.vmg ?? 0 < b.vmg ?? 0 }
        if let max_downwind_vmg = max_downwind?.vmg {
            if max_downwind_vmg < 0 {
                downwind_display = String(format: "%.2f", max_downwind_vmg)
            }
        }
        self.maxVMG = "Max VMG: \(upwind_display) / \(downwind_display) kts"
    }
}
