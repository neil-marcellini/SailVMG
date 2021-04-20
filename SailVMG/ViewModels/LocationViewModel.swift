//
//  LocationViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import Foundation
import CoreLocation
import SwiftUI
import Firebase

class LocationViewModel: NSObject, ObservableObject {
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var speed: Double = 0
    @Published var course: Double = 0
    @Published var vmg: Double = 0
    @Published var prev_vmg: Double = 0
    @Published var vmg_delta: Double = 0
    @Published var twa: Int = 0
    @Published var twd: Int = 180
    @Published var isPaused = false
    @Published var trackpoint: Trackpoint? = nil
    
    // for compass
    @Published var heading: Double = 0
    var track: Track? = nil
    
    let locationManager = CLLocationManager()
    @Published var promptLocation = false
    
    // callback to send out updated trackpoints
    var updateHook: ((Trackpoint) -> Void)? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.showsBackgroundLocationIndicator = true
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    
    func pause() {
        isPaused = true
        self.locationManager.stopUpdatingLocation()
    }
    func resume() {
        isPaused = false
        self.locationManager.startUpdatingLocation()
    }
  
    func startRecording(track: Track) {
        self.track = track
        resume()
    }
    
    // this function does an actual modulus, as opposed to
    // % which does not work for negative values!
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
    
    func plusTwd(){
        twd = mod(twd + 1, 360)
    }
    func minusTwd() {
        twd = mod(twd - 1, 360)
    }
    
    func speedDisplay() ->  String {
        return String(format: "%.2f kts", speed)
    }
    
    func roundMetric(metric: Double) -> Int {
        let rounded = metric.rounded()
        return Int(rounded)
    }
    
    func courseDisplay() ->  String {
        if course == -1.0 {
            return "000°"
        }
        let cog = roundMetric(metric: course)
        return String(format: "%03d°", cog)
    }
    
    func twdDisplay() ->  String {
        return String(format: "%03d°", twd)
    }
    func twaDisplay() ->  String {
        return String(format: "%03d°", twa)
    }
    
    func vmgDisplay() ->  String {
        return String(format: "%.2f kts", vmg)
    }
    
    func headingDisplay() -> String {
        return String(format: "%03.0f°", heading)
    }
    
    
    func directionSubtract(_ d1: Int, _ d2: Int) -> Int {
        var delta = d1 - d2
        if delta < 0 {
            delta += 360
        }
        return delta
    }
    
    func boatRotation()->Double {
        let delta = directionSubtract(twd, Int(round(course)))
        return Double(delta) * .pi / 180.0
    }
    
    func direction_diff(_ d1: Int, _ d2: Int) -> Int {
        // finds the smallest distance around compass between two angles
        let delta1 = directionSubtract(d1, d2)
        let delta2 = directionSubtract(d2, d1)
        return min(delta1, delta2)
    }
    
    
    func calculateTwa(twd: Int, course: Double)->Int {
        // return the minimum difference bewteen
        // true wind direction and course
        if course == -1 {
            return 0
        }
        let course_rounded = Int(round(course))
        return direction_diff(twd, course_rounded)
        
    }
    
    func calculateVMG(speed: Double, course: Double, twd: Int) -> Double {
        // Return the component of speed towards true wind angle.
        twa = calculateTwa(twd: twd, course: course)
        let vmg = speed * cos(Double(twa) * .pi / 180)
        return vmg
    }
    
    func recordTrackpoint(_ trackpoint: Trackpoint, track: Track) {
        prev_vmg = vmg
        vmg = calculateVMG(speed: trackpoint.speed, course: trackpoint.course, twd: twd)
        vmg_delta = vmg - prev_vmg
        print("prev_vmg = \(prev_vmg)")
        print("vmg = \(vmg)")
        print("vmg_delta = \(vmg_delta)")
        let updated_trackpoint = Trackpoint(id: trackpoint.id, track_id: track.id!, time: trackpoint.time, latitude: trackpoint.latitude, longitude: trackpoint.longitude, speed: trackpoint.speed, course: trackpoint.course, vmg: vmg, vmg_delta: vmg_delta, twd: twd)
        self.trackpoint = updated_trackpoint
        speed = trackpoint.speed
        course = trackpoint.course
        
        if let updateCallback = updateHook {
            updateCallback(updated_trackpoint)
        }
        
    }
    
    func arrowLen(metric: Double, compass_size: CGFloat) -> CGFloat {
        let min_size: CGFloat = 10
        if metric == 0 {
            return min_size
        }
        let max_vmg = 40.0
        var ratio = abs(metric / max_vmg)
        print("ratio = \(ratio)")
        if ratio > 1 {
            ratio = 1
        }
        let arrow_len = CGFloat(CGFloat(ratio) * (1 - (min_size / compass_size)) * compass_size) + min_size
        print("arrow_len = \(arrow_len)")
        return arrow_len
    }
    
    
}
extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        speed = mpsToKts(location.speed)
        course = location.course
        let trackpoint = Trackpoint(id: UUID(), track_id: "", time: Date(), latitude: latitude, longitude: longitude, speed: speed, course: course, vmg: nil, vmg_delta: nil, twd: nil)
        recordTrackpoint(trackpoint, track: track!)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
    }
    
    func mpsToKts(_ speedMps: CLLocationSpeed) -> Double {
        return speedMps * 1.94384
    }
}
