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
        guard let track_id = track.id else {
            print("Error, track has no id in addTrackPoint")
            return
        }
        do {
            let _ = try db.collection("Trackpoints").addDocument(from: trackpoint)
        } catch {
            fatalError("Unable to encode task \(error.localizedDescription)")
        }
        
    }
    
}
