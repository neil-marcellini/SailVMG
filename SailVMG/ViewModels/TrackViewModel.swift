//
//  TrackViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/27/20.
//

import Foundation

class TrackViewModel {
    let track: Track
    let dateFormatter = DateFormatter()
    
    init(_ track: Track) {
        self.track = track
    }
    
    func startTime()->String {
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: track.start_time)
    }
    func endTime()->String {
        dateFormatter.dateStyle = .short
        guard let end_time = track.end_time else {
            return ""
        }
        return dateFormatter.string(from: end_time)
    }
}
