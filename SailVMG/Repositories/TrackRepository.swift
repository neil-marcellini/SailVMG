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
    @Published var trackCount = 0
    @Published var loading = true
    @Published var showDeleteConfirmation = false
    var launchCount = UserDefaults.standard.integer(forKey: "launchCount")
    
    init() {
        if launchCount != 1 {
            print("offline fetch trackVMs")
            db.disableNetwork() { error in
                self.getTrackVMs()
                self.db.enableNetwork(completion: nil)
            }
        } else {
            getTrackVMs()
        }
        
    }
    
    func getTrackVMs() {
        let userId = Auth.auth().currentUser?.uid
        db.collection("Tracks")
            .whereField("userId", isEqualTo: userId)
            .order(by: "start_time", descending: true)
            .getDocuments() { (querySnapshot, err) in
                do {
                    if let querySnapshot = querySnapshot {
                        if querySnapshot.documents.isEmpty {
                            self.loading = false
                        }
                        for document in querySnapshot.documents {
                            guard let track = try document.data(as: Track.self) else {continue}
                            self.trackCount += 1
                            self.trackpointRepository.getTrackpoints(track, completion: self.afterTrackpoints)
                        }
                    }
                }
                catch {
                    print(err as Any)
                }
            
        }
    }
    
    func hasNoTracks()->Bool {
        if trackCount == 0 && !loading {
            return true
        } else {
            return false
        }
    }
    
    func afterTrackpoints(track: Track, trackpoints: [Trackpoint]) -> Void {
        let trackVM = TrackViewModel(track: track, trackpoints: trackpoints)
        trackVMs.append(trackVM)
        sortTrackVMs()
        setLoading()
    }
    
    func setLoading() {
        if trackVMs.count == trackCount {
            loading = false
        }
    }
    
    func sortTrackVMs() {
        trackVMs.sort(by: {$0.track.start_time > $1.track.start_time})
    }
    
    func afterNewTrackpoints(track: Track, trackpoints: [Trackpoint]) -> Void {
        let trackVM = TrackViewModel(track: track, trackpoints: trackpoints)
        trackVMs.insert(trackVM, at: 0)
        setLoading()
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
        loading = true
        trackCount += 1
        setEndTime(track: track) { success in
            if success {
                self.trackpointRepository.getTrackpoints(track, completion: self.afterNewTrackpoints)
            }
        }  
    }
    
    func removeTrackVM(index: Int) {
        trackVMs.remove(at: index)
        trackCount -= 1
    }
    
    func deleteAll() {
        for trackVM in trackVMs {
            discardTrack(trackVM.track)
        }
        trackVMs = [TrackViewModel]()
        trackCount = 0
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
