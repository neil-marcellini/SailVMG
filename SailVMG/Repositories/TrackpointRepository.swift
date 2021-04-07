//
//  TrackpointRepository.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/24/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import Combine

class TrackpointRespository: ObservableObject {
    let db = Firestore.firestore()
    var trackpointCancel: AnyCancellable? = nil
    @Published var trackpoints: [Track.ID: [Trackpoint]] = [:]
    
    func getAllTrackpoints(trackList: [Track]) {
        for track in trackList {
            getTrackpoints(track) { trackpoints in
                self.trackpoints[track.id] = trackpoints
            }
        }
    }
    
    
    func getTrackpoints(_ track: Track, completion: @escaping ([Trackpoint]) -> Void) {
        // get all trackpoints given a list of tracks
        var trackpoints = [Trackpoint]()
        guard let track_id: String = track.id else {
            print("error with getTrackpoints")
            return
        }
        db.collection("Trackpoints")
            .whereField("track_id", isEqualTo: track_id)
            .order(by: "time")
            .getDocuments() { (querySnapshot, err) in
                if let querySnapshot = querySnapshot {
                    trackpoints = querySnapshot.documents.compactMap { document in
                        do {
                            guard let trackpoint = try document.data(as: Trackpoint.self) else {return nil}
                            return trackpoint
                        } catch {
                            print(error)
                        }
                        return nil
                    }
                }
                completion(trackpoints)
            }
    }
    
    func addTrackpoint(to track: Track, trackpoint: Trackpoint) {
        if let curr_trackpoints = trackpoints[track.id] {
            var new_trackpoints = curr_trackpoints
            new_trackpoints.append(trackpoint)
            trackpoints[track.id] = new_trackpoints
            
        } else {
            // no trackpoints for this track yet, make new list
            trackpoints[track.id] = [trackpoint]
        }
        saveTrackpoint(trackpoint)
        
    }
    
    func saveTrackpoint(_ trackpoint: Trackpoint) {
        do {
            let _ = try db.collection("Trackpoints").addDocument(from: trackpoint)
        } catch {
            fatalError("Unable to encode task \(error.localizedDescription)")
        }
    }
    
    
    
    func getCoordinates(_ track: Track, completion: @escaping ([CLLocationCoordinate2D]) -> Void) {
        var trackpoints = [CLLocationCoordinate2D]()
        guard let track_id: String = track.id else {
            print("error with getCoordinates")
            completion(trackpoints)
            return
        }
        db.collection("Trackpoints")
            .whereField("track_id", isEqualTo: track_id)
            .order(by: "time")
            .getDocuments() { (querySnapshot, err) in
                if let querySnapshot = querySnapshot {
                    trackpoints = querySnapshot.documents.compactMap { document in
                        do {
                            guard let trackpoint = try document.data(as: Trackpoint.self) else {return nil}
                            return CLLocationCoordinate2D(latitude: Double(trackpoint.latitude), longitude: Double(trackpoint.longitude))
                        } catch {
                            print(error)
                        }
                        return nil
                    }
                }
                completion(trackpoints)
            }
    }
    
    
}
