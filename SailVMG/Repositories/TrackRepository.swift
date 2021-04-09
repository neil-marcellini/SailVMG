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
import Combine

class TrackRespository: ObservableObject {
    let db = Firestore.firestore()
    @Published var trackVMs = [TrackViewModel]()
    let trackpointRepository = TrackpointRespository()
    @Published var loading = true
    @Published var showDeleteConfirmation = false
    var launchCount = UserDefaults.standard.integer(forKey: "launchCount")
    //callback
    var afterTracks: (([Track]) -> Void)? = nil
    var trackUpdates: AnyCancellable?
    
    var newTrackVM: TrackViewModel? = nil
    
    init() {
//        if launchCount != 1 {
//            print("offline fetch trackVMs")
//            db.disableNetwork() { error in
//                self.getTracks()
//                self.db.enableNetwork(completion: nil)
//            }
//        } else {
//            getTracks()
//        }
        getTracks()
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
    
    func createTrack() -> Track? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error, no currentUser id")
            return nil
        }
        var track = Track(id: nil, start_time: Date(), end_time: nil)
        let trackRef = getTrackRef(track: track)
        track.id = trackRef.documentID
        track.userId = userId
        updateTrack(newTrack: track)
        return track
    }
    
    
    func getTrackRef(track: Track) -> DocumentReference {
        let newTrackRef = db.collection("Tracks").document()
        return newTrackRef
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
    
    
    func addTrackVM(track: Track, trackpoints: [Trackpoint]) {
        newTrackVM = TrackViewModel(track: track)
        trackUpdates = newTrackVM!.$track.sink(receiveValue: updateTrack)
        newTrackVM!.calculateMetrics(new_trackpoints: trackpoints)
        newTrackVM!.loading = true
        trackVMs.insert(newTrackVM!, at: 0)   
    }
    
    func afterPreviewURL(previewURL: URL) {
        guard let trackVM = newTrackVM else {
            print("Error, no trackVM afterMap")
            return
        }
        trackVM.track.preview_url = previewURL
    }
    
    func afterPreviewImage(preview: UIImage) {
        guard let trackVM = newTrackVM else {
            print("Error, no trackVM afterPreviewImage")
            return
        }
        trackVM.trackPreview = preview
    }
    
    func updateTrack(newTrack: Track) {
        guard let track_id = newTrack.id else {
            print("Error track has no id")
            return
        }
        print("Updating track")
        do {
            try db.collection("Tracks").document(track_id).setData(from: newTrack, merge: true)
        } catch {
            print("Error updating track")
        }
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
