//
//  LocationViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationViewModel: NSObject, ObservableObject {
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var speed: Double = 0
    @Published var course: Double = 0
    @Published var vmg: Double = 0
    @Published var twa: Int = 0
    @Published var twd: Double = 180
 
    @Published var isRecording = false
    @Published var isPaused = false
    let trackManager = TrackManager()
    let trackpointRepository = TrackpointRespository()
    var track: Track? = nil
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
    }
    
    
    func pause() {
        isPaused = true
        self.locationManager.stopUpdatingLocation()
    }
    func resume() {
        isPaused = false
        self.locationManager.startUpdatingLocation()
    }
    
    func setTrack(_ new_track: Track) {
        track = new_track
    }
    func startRecording() {
        track = Track(id: nil, start_time: Date(), end_time: nil)
        let track_id = trackManager.createTrack(track!)
        track!.id = track_id
        setTrack(track!)
        isRecording = true
        resume()
    }
    
    
    func saveTrack() {
        isRecording = false
    }
    
    func discardTrack() {
        isRecording = false
        guard let curr_track = track else {
            print("No track exists to delete")
            return
        }
        trackManager.discardTrack(curr_track)
    }
    func plusTwd(){
        twd += 1
    }
    func minusTwd() {
        twd -= 1
    }
    func directionSubtract(_ d1: Int, _ d2: Int) -> Int {
        var delta = d1 - d2
        if delta < 0 {
            delta += 360
        }
        return delta
    }
    
    func boatRotation()->Double {
        let delta = directionSubtract(Int(round(twd)), Int(round(course)))
        return Double(delta) * .pi / 180.0
    }
    
    func direction_diff(_ d1: Int, _ d2: Int) -> Int {
        // finds the smallest distance around compass between two angles
        let delta1 = directionSubtract(d1, d2)
        let delta2 = directionSubtract(d2, d1)
        return min(delta1, delta2)
    }
    
    func calculateTwa(twd: Double, course: Double)->Int {
        // return the minimum difference bewteen
        // true wind direction and course
        let twd_rounded = Int(round(twd))
        let course_rounded = Int(round(course))
        return direction_diff(twd_rounded, course_rounded)
        
    }
    
    func calculateVMG(speed: Double, course: Double, twd: Double) -> Double {
        // Return the component of speed towards true wind angle.
        twa = calculateTwa(twd: twd, course: course)
        let vmg = speed * cos(Double(twa) * .pi / 180)
        return vmg
    }
    
    func recordTrackpoint(_ trackpoint: Trackpoint, track: Track) {
        vmg = calculateVMG(speed: trackpoint.speed, course: trackpoint.course, twd: twd)
        let updated_trackpoint = Trackpoint(id: trackpoint.id, track_id: track.id!, time: trackpoint.time, latitude: trackpoint.latitude, longitude: trackpoint.longitude, speed: trackpoint.speed, course: trackpoint.course, vmg: vmg, twd: twd)
        speed = trackpoint.speed
        course = trackpoint.course
        trackpointRepository.addTrackPoint(to: track, trackpoint: updated_trackpoint)
    }
    
    
    
}
extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        speed = mpsToKts(location.speed)
        course = location.course
        let trackpoint = Trackpoint(id: UUID(), track_id: "", time: Date(), latitude: latitude, longitude: longitude, speed: speed, course: course, vmg: nil, twd: nil)
        recordTrackpoint(trackpoint, track: track!)
    }
    
    func mpsToKts(_ speedMps: CLLocationSpeed) -> Double {
        return speedMps * 1.94384
    }
}
