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
