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
    
    func getTrackVMs() {
        let userId = Auth.auth().currentUser?.uid
        db.collection("Tracks")
            .whereField("userId", isEqualTo: userId)
            .order(by: "start_time", descending: true)
            .getDocuments() { (querySnapshot, err) in
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
    
    func setEndTime(track: Track, completion: @escaping ((Date?) -> Void)) {
        guard let track_id = track.id else {
            print("Error track has no id discardTrack")
            return
        }
        let end_time = Date()
        db.collection("Tracks").document(track_id).updateData([
            "end_time": end_time
        ]){ err in
            if let err = err {
                print("Error setting end time: \(err)")
                completion(nil)
            } else {
                completion(end_time)
            }
        }
        
    }
    
    func addTrackVM(track: Track) {
        var trackCopy = track
        setEndTime(track: track) { end_time in
            if end_time != nil {
                trackCopy.end_time = end_time
                var newTrackVM = TrackViewModel(trackCopy)
                self.trackVMs.insert(newTrackVM, at: 0)
            }
        }  
    }

}
