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
    let trackpointRepository = TrackpointRespository()
    
    init() {
        getTrackVMs()
    }
    
    func getTrackVMs() {
        let userId = Auth.auth().currentUser?.uid
        db.collection("Tracks")
            .whereField("userId", isEqualTo: userId)
            .order(by: "start_time", descending: true)
            .getDocuments() { (querySnapshot, err) in
                do {
                    if let querySnapshot = querySnapshot {
                        for document in querySnapshot.documents {
                            guard let track = try document.data(as: Track.self) else {continue}
                            self.trackpointRepository.getTrackpoints(track, completion: self.afterTrackpoints)
                        }
                    }
                }
                catch {
                    print(err as Any)
                }
            
        }
    }
    
    func afterTrackpoints(track: Track, trackpoints: [Trackpoint]) -> Void {
        let trackVM = TrackViewModel(track: track, trackpoints: trackpoints)
        trackVMs.append(trackVM)
    }
    
    func afterNewTrackpoints(track: Track, trackpoints: [Trackpoint]) -> Void {
        let trackVM = TrackViewModel(track: track, trackpoints: trackpoints)
        trackVMs.insert(trackVM, at: 0)
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
                self.trackpointRepository.getTrackpoints(track, completion: self.afterNewTrackpoints)
            }
        }  
    }

}
