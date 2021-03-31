//
//  AudioSettings.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/30/21.
//

import Foundation
class AudioSettings: ObservableObject {
    let soundControl = SoundControl()
    @Published var audioFeedback = UserDefaults.standard.bool(forKey: "audioFeedback") {
        didSet {
            UserDefaults.standard.setValue(audioFeedback, forKey: "audioFeedback")
            if audioFeedback {
                startSound()
            } else {
                self.soundControl.stop()
            }
        }
    }
    @Published var showSettings = false
    
    func startSound() {
        do {
            try self.soundControl.play()
        } catch {
            print("play error")
        }
    }
    
    func trackpointUpdated(trackpoint: Trackpoint) {
        if audioFeedback {
            adjustAudio(trackpoint: trackpoint)
        }
    }
    
    func adjustAudio(trackpoint: Trackpoint) {
        guard let vmg = trackpoint.vmg else { return }
        self.soundControl.adjustPitch(measurement: vmg)
        guard let vmg_delta = trackpoint.vmg_delta else { return }
        // assume that max vmg change is 30kts per second
        let maxVMGChage = 30.0
        self.soundControl.adjustSpeed(measurement: abs(vmg_delta), maxMeasurement: maxVMGChage)
    }
}
