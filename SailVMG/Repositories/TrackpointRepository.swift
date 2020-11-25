//
//  TrackpointRepository.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/24/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
class TrackpointRespository: ObservableObject {
    let db = Firestore.firestore()
    @Published var trackpoints = [Trackpoint]()
    
    func addTrackPoint(to track: Track, trackpoint: Trackpoint) {
        do {
            let _ = try db.collection("Trackpoints").addDocument(from: trackpoint)
        } catch {
            fatalError("Unable to encode task \(error.localizedDescription)")
        }
        
    }
    
    func getEndTime(track: Track) -> Date? {
        var trackpoints = [Trackpoint]()
        guard let track_id = track.id else {
            print("Error, track has no id in getEndTime")
            return nil
        }
        let trackpointCollection = db.collection("Trackpoints")
        trackpointCollection
            .whereField("track_id", isEqualTo: track_id)
            .order(by: "time")
            .limit(to: 1)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting last trackpoint: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
        guard let trackpoint = trackpoints.first else {
            print("no trackpoints getEndTime")
            return nil
        }
        return trackpoint.time
        
    }
    
}
