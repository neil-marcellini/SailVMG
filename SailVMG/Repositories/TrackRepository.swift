//
//  TrackRepository.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift



class TrackRespository: ObservableObject {
    let db = Firestore.firestore()
    @Published var trackVMs = [TrackViewModel]()
    init() {
        getTrackVMs()
    }
    
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
    
    func getTrackVMs() {
        let userId = Auth.auth().currentUser?.uid
        db.collection("Tracks")
            .whereField("userId", isEqualTo: userId)
            .order(by: "start_time", descending: true)
            .addSnapshotListener() { (querySnapshot, err) in
            if let querySnapshot = querySnapshot {
                self.trackVMs = querySnapshot.documents.compactMap { document in
                    do {
                        guard let track = try document.data(as: Track.self) else {return nil}
                        let trackVM = TrackViewModel(track)
                        return trackVM
                    } catch {
                        print(error)
                    }
                    return nil
                }
            }
        }
    }

}
