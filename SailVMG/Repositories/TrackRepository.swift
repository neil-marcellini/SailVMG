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
    @Published var loading = true
    @Published var showDeleteConfirmation = false
    var launchCount = UserDefaults.standard.integer(forKey: "launchCount")
    //callback
    var afterTracks: (([Track]) -> Void)? = nil
    
    init() {
        if launchCount != 1 {
            print("offline fetch trackVMs")
            db.disableNetwork() { error in
                self.getTracks()
                self.db.enableNetwork(completion: nil)
            }
        } else {
            getTracks()
        }
        
    }
    
    
    func getTracks() {
        let userId = Auth.auth().currentUser?.uid
        db.collection("Tracks")
            .whereField("userId", isEqualTo: userId)
            .order(by: "start_time", descending: true)
            .getDocuments() { (querySnapshot, err) in
                guard let querySnapshot = querySnapshot else {return}
                let tracks: [Track] = querySnapshot.documents.compactMap { document in
                    guard let track = try? document.data(as: Track.self) else { return nil}
                    return track
                }
                self.createTrackVMs(tracks: tracks)
                self.loading = false
                guard let tracksCallback = self.afterTracks else {
                    print("tracksCallback not set")
                    return
                }
                tracksCallback(tracks)
            }
    }
    
    func createTrackVMs(tracks: [Track]) {
        for track in tracks {
            let trackVM = TrackViewModel(track: track)
            trackVMs.append(trackVM)
        }
    }
    
    func hasNoTracks()->Bool {
        let trackCount = trackVMs.count
        if trackCount == 0 && !loading {
            return true
        } else {
            return false
        }
    }
    
    func afterTrackpoints(track: Track, trackpoints: [Trackpoint]) -> Void {
        let trackVM = TrackViewModel(track: track)
        trackVMs.append(trackVM)
    }
    
    func afterNewTrackpoints(track: Track, trackpoints: [Trackpoint]) -> Void {
        let trackVM = TrackViewModel(track: track)
        trackVMs.insert(trackVM, at: 0)
    }
    
    func setEndTime(track: Track, completion: @escaping ((Bool) -> Void)) {
        guard let track_id = track.id else {
            print("Error track has no id")
            return
        }
        
        db.collection("Tracks").document(track_id).updateData([
            "end_time": track.end_time
        ]){ err in
            if let err = err {
                print("Error setting end time: \(err)")
                completion(false)
            } else {
                completion(true)
            }
        }
        
    }
    
    func addTrackVM(track: Track) {
        let newTrackVM = TrackViewModel(track: track)
        trackVMs.insert(newTrackVM, at: 0)
    }
    
    func removeTrackVM(index: Int) {
        trackVMs.remove(at: index)
    }
    
    func deleteAll() {
        for trackVM in trackVMs {
            discardTrack(trackVM.track)
        }
        trackVMs = [TrackViewModel]()
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
