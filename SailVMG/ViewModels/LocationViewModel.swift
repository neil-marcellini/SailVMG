//
//  LocationViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import Foundation
import CoreLocation

class LocationViewModel: NSObject, ObservableObject {
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var speed: Double = 0
    @Published var course: Double = 0
    var track: Track? = nil
    
    let locationManager = CLLocationManager()
    let trackRepository = TrackRespository()
    let trackpointRepository = TrackpointRespository()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startRecording() {
        track = Track(id: nil, start_time: Date(), end_time: nil)
        let track_id = trackRepository.createTrack(track!)
        track!.id = track_id
        resume()
    }
    
    func pause() {
        self.locationManager.stopUpdatingLocation()
    }
    func resume() {
        self.locationManager.startUpdatingLocation()
    }
    
    func saveTrack() {
        trackRepository.setEndTime(track: track!)
    }
    
    func discardTrack() {
        guard let curr_track = track else {
            print("No track exists to delete")
            return
        }
        trackRepository.discardTrack(curr_track)
    }
}
extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        speed = location.speed
        course = location.course
        let trackpoint = Trackpoint(id: UUID(), track_id: track!.id!, time: Date(), latitude: latitude, longitude: longitude, speed: speed, course: course, vmg: nil, twa: nil)
        trackpointRepository.addTrackPoint(to: track!, trackpoint: trackpoint)
    }
}
