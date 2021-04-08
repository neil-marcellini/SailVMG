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
    var track: Track
    @Published var trackpoints: [Trackpoint]? = nil
    let maxHueDegree: Double
    let maxHue: Double
    
    init (track: Track) {
        self.track = track
        maxHueDegree = 238.0
        maxHue = maxHueDegree / 360.0
    }
    
    func calculateMetrics(new_trackpoints: [Trackpoint]) {
        trackpoints = new_trackpoints
        getLocation(completionHandler: formatLocation)
        getMaxVMG()
    }
    
    func locationDisplay() -> String {
        guard let city = track.city else {return ""}
        guard let state = track.state else {return ""}
        let location = "\(city), \(state)"
        return location
    }
    
    
    func getLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the first reported location.
        guard let curr_trackpoints = trackpoints else {return}
        guard let firstPoint = curr_trackpoints.first else { return }
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
            track.city = city
            track.state = state
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
    
    func getDuration() -> String {
        guard let end_time = track.end_time else {
            return ""
        }
        let duration = end_time.timeIntervalSince(track.start_time)
        let durationDisplay = formatDuration(seconds: duration)
        return durationDisplay
    }
    
    func formatDuration(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        guard let duration = formatter.string(from: seconds) else {
            return ""
        }
        return duration
    }
    
    
    func displayMaxVMG() -> String {
        var maxVMG = "-- / -- kts"
        guard let max_downwind = track.max_downwind_vmg else {return maxVMG}
        guard let max_upwind = track.max_upwind_vmg else {return maxVMG}
        let downwind_display = String(format: "%.2f", max_downwind)
        let upwind_display = String(format: "%.2f", max_upwind)
        maxVMG = "\(downwind_display) / \(upwind_display) kts"
        return maxVMG
    }
    
    func getMaxVMG() {
        guard let curr_trackpoints = trackpoints else {return}
        let max_upwind = curr_trackpoints.max { a, b in a.vmg ?? 0 < b.vmg ?? 0 }
        if let max_upwind_vmg = max_upwind?.vmg {
            track.max_upwind_vmg = max_upwind_vmg
        }
        let max_downwind = curr_trackpoints.min { a, b in a.vmg ?? 0 < b.vmg ?? 0 }
        if let max_downwind_vmg = max_downwind?.vmg {
            if max_downwind_vmg < 0 {
                track.max_downwind_vmg = max_downwind_vmg
            }
        }
        
    }
    func getVMGs()->[Double] {
        guard let curr_trackpoints = trackpoints else {return []}
        let vmgs = curr_trackpoints.compactMap { trackpoint in
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
        if let max_vmg = track.max_upwind_vmg, let min_vmg = track.max_downwind_vmg {
            ratio = abs((min_vmg - vmg) / (max_vmg - min_vmg))
        }
        print("ratio = \(ratio)")
        let hue = CGFloat(ratio * maxHue)
        print("hue value: \(hue)")
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        
    }
    
    func getLocations()->[CGFloat] {
        guard let curr_trackpoints = trackpoints else {return []}
        let length: Double = 1 / Double(curr_trackpoints.count)
        let unit_length = CGFloat(length)
        let location_units = Array(repeating: unit_length, count: curr_trackpoints.count)
        return location_units
        
    }
}
