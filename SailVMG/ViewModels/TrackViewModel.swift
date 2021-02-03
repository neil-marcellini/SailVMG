//
//  TrackViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/27/20.
//

import Foundation

class TrackViewModel: ObservableObject {
    let track: Track
    let dateFormatter = DateFormatter()
    @Published var trackpoints = [Trackpoint]()
    @Published var maxVMG = ""
    
    init (_ track: Track) {
        self.track = track
        let trackpointRespository = TrackpointRespository()
        trackpointRespository.getTrackpoints(track) { trackpoints in
            self.trackpoints = trackpoints
            self.getMaxVMG()
        }
    }
    
    func startTime()->String {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: track.start_time)
    }
    func endTime()->String {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        guard let end_time = track.end_time else {
            return ""
        }
        return dateFormatter.string(from: end_time)
    }
    func getMaxVMG() {
        var upwind_display = "--"
        var downwind_display = "--"
        guard trackpoints.count > 0 else {return}
        let max_upwind = trackpoints.max { a, b in a.vmg ?? 0 < b.vmg ?? 0 }
        if let max_upwind_vmg = max_upwind?.vmg {
            upwind_display = String(format: "%.2f", max_upwind_vmg)
        }
        let max_downwind = trackpoints.max { a, b in a.vmg ?? 0 < b.vmg ?? 0 }
        if let max_downwind_vmg = max_downwind?.vmg {
            if max_downwind_vmg < 0 {
                downwind_display = String(format: "%.2f", max_downwind_vmg)
            }
        }
        self.maxVMG = "Max VMG: \(upwind_display) / \(downwind_display) kts"
    }
}
