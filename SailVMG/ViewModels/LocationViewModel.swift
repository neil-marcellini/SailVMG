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
    
    let locationManager = CLLocationManager()
    let trackpointRepository = TrackpointRespository()
    var track: Track? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    
    func pause() {
        self.locationManager.stopUpdatingLocation()
    }
    func resume() {
        self.locationManager.startUpdatingLocation()
    }
    
    func setTrack(_ new_track: Track) {
        self.track = new_track
    }
    
    
    
}
extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        speed = mpsToKts(location.speed)
        course = location.course
        let trackpoint = Trackpoint(id: UUID(), track_id: track!.id!, time: Date(), latitude: latitude, longitude: longitude, speed: speed, course: course, vmg: nil, twa: nil)
        trackpointRepository.addTrackPoint(to: track!, trackpoint: trackpoint)
    }
    func mpsToKts(_ speedMps: CLLocationSpeed) -> Double {
        return speedMps * 1.94384
    }
}
