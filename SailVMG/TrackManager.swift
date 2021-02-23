//
//  TrackManager.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/23/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TrackManager {
    let db = Firestore.firestore()
    
    func createTrack(_ track: Track) -> String {
        var addTrack = track
        addTrack.userId = Auth.auth().currentUser?.uid
        do {
            let document = try db.collection("Tracks").addDocument(from: addTrack)
            return document.documentID
        } catch {
            fatalError("Unable to encode task \(error.localizedDescription)")
        }
    }
    
    func setEndTime(track: Track) {
        guard let track_id = track.id else {
            print("Error track has no id discardTrack")
            return
        }
        db.collection("Tracks").document(track_id).updateData([
            "end_time": Date()
        ]){ err in
            if let err = err {
                print("Error setting end time: \(err)")
            }
        }
        
    }
    
    func discardTrack(_ track: Track) {
        guard let track_id = track.id else {
            print("Error track has no id discardTrack")
            return
        }
        db.collection("Tracks").document(track_id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
