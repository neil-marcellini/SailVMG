//
//  TrackViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/27/20.
//

import Foundation
import CoreLocation
import UIKit
import SwiftUI

class TrackViewModel: ObservableObject {
    let track: Track
    @Published var trackpoints = [Trackpoint]()
    @Published var loading = true
    @Published var location = ""
    @Published var maxVMG = "Max VMG: -- / -- kts"
    var max_upwind_vmg: Double?
    var max_downwind_vmg: Double?
    let maxHueDegree: Double
    let maxHue: Double
    
    init (_ track: Track) {
        self.track = track
        maxHueDegree = 238.0
        maxHue = maxHueDegree / 360.0
        let trackpointRespository = TrackpointRespository()
        trackpointRespository.getTrackpoints(track) { trackpoints in
            self.trackpoints = trackpoints
            self.getLocation(completionHandler: self.formatLocation)
            self.getMaxVMG()
            self.loading = false
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
                print("geocoding error")
                print(error as Any)
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
            self.max_upwind_vmg = max_upwind_vmg
            upwind_display = String(format: "%.2f", max_upwind_vmg)
        }
        let max_downwind = trackpoints.min { a, b in a.vmg ?? 0 < b.vmg ?? 0 }
        if let max_downwind_vmg = max_downwind?.vmg {
            if max_downwind_vmg < 0 {
                self.max_downwind_vmg = max_downwind_vmg
                downwind_display = String(format: "%.2f", max_downwind_vmg)
            }
        }
        self.maxVMG = "Max VMG: \(downwind_display) / \(upwind_display) kts"
    }
    func getVMGs()->[Double] {
        let vmgs = trackpoints.compactMap { trackpoint in
            trackpoint.vmg
        }
        return vmgs
    }
    
    func getColors()->[UIColor] {
        let vmgs = getVMGs()
        let colors = vmgs.map { vmg in
            return vmgToColor(vmg)
        }
        return colors
    }
    
    func getSwiftUIColors() -> [Color] {
        let hueValues = Array(0...Int(maxHueDegree))
        return hueValues.map { hue in
            Color(UIColor(hue: CGFloat(hue) / 360.0 ,
                          saturation: 1.0,
                          brightness: 1.0,
                          alpha: 1.0))
        }
    }
    
    
    func vmgToColor(_ vmg: Double) -> UIColor {
        // 0.66 is a dark blue in HSV
        var ratio: Double = 1
        if let max_vmg = max_upwind_vmg, let min_vmg = max_downwind_vmg {
            ratio = abs((min_vmg - vmg) / (max_vmg - min_vmg))
        }
        print("ratio = \(ratio)")
        let hue = CGFloat(ratio * maxHue)
        print("hue value: \(hue)")
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        
    }
    
    func getLocations()->[CGFloat] {
        let length: Double = 1 / Double(trackpoints.count)
        let unit_length = CGFloat(length)
        let location_units = Array(repeating: unit_length, count: trackpoints.count)
        return location_units
        
    }
}
