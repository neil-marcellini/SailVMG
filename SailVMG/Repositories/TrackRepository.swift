//
//  TrackRepository.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


class TrackRespository: ObservableObject {
    let db = Firestore.firestore()
    @Published var tracks = [Track]()
    
    func createTrack(_ track: Track) -> String {
        do {
            let document = try db.collection("Tracks").addDocument(from: track)
            return document.documentID
        } catch {
            fatalError("Unable to encode task \(error.localizedDescription)")
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
