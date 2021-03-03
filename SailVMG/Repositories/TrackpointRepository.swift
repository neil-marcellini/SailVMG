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
class TrackpointRespository: ObservableObject {
    let db = Firestore.firestore()
    
    func addTrackPoint(to track: Track, trackpoint: Trackpoint) {

        do {
            let _ = try db.collection("Trackpoints").addDocument(from: trackpoint)
        } catch {
            fatalError("Unable to encode task \(error.localizedDescription)")
        }
        
    }

    func getTrackpoints(_ track: Track, completion: @escaping (Track, [Trackpoint]) -> Void) {
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
                completion(track, trackpoints)
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
