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
    
    func createTrack(_ track: Track) {
        do {
            let _ = try db.collection("Tracks").addDocument(from: track)
        } catch {
            fatalError("Unable to encode task \(error.localizedDescription)")
        }
    }
}
