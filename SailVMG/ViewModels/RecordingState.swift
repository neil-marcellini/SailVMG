//
//  RecordingState.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import Foundation
import SwiftUI
class RecordingState: ObservableObject {
    @Published var isRecording = false
    @Published var isPaused = false
    @ObservedObject var trackRepository = TrackRespository()
    @ObservedObject var locationViewModel = LocationViewModel()
    
    var track: Track?
    
    func startRecording() {
        track = Track(id: nil, start_time: Date(), end_time: nil)
        let track_id = trackRepository.createTrack(track!)
        track!.id = track_id
        locationViewModel.setTrack(track!)
        isRecording = true
        locationViewModel.resume()
    }
    
    func pause() {
        isPaused = true
        locationViewModel.pause()
    }
    
    func resume() {
        isPaused = false
        locationViewModel.resume()
    }
    
    
    func saveTrack() {
        isRecording = false
        trackRepository.setEndTime(track: track!)
    }
    
    func discardTrack() {
        isRecording = false
        guard let curr_track = track else {
            print("No track exists to delete")
            return
        }
        trackRepository.discardTrack(curr_track)
    }
    
    
}
