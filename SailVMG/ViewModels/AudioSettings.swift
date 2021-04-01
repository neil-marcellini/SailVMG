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
    @Published var updatePitch: Bool = UserDefaults.standard.bool(forKey: "updatePitch") {
        didSet {
            UserDefaults.standard.setValue(updatePitch, forKey: "updatePitch")
        }
    }
    @Published var updateFrequency: Bool = UserDefaults.standard.bool(forKey: "updateFrequency"){
        didSet {
            UserDefaults.standard.setValue(updateFrequency, forKey: "updateFrequency")
        }
    }
    @Published var pitchValue: Measureable = Measureable(rawValue: UserDefaults.standard.string(forKey: "pitchValue")!)! {
        didSet {
            UserDefaults.standard.setValue(pitchValue.rawValue, forKey: "pitchValue")
        }
    }
    @Published var frequencyValue: Measureable = Measureable(rawValue: UserDefaults.standard.string(forKey: "frequencyValue")!)! {
        didSet {
            UserDefaults.standard.setValue(frequencyValue.rawValue, forKey: "frequencyValue")
        }
    }

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
        guard let vmg_delta = trackpoint.vmg_delta else {return}
        var pitchMeasurement = vmg
        switch pitchValue {
        case .vmg_acceleration:
            pitchMeasurement = vmg_delta
        default:
            pitchMeasurement = vmg
        }
        if updatePitch {
            self.soundControl.adjustPitch(measurement: pitchMeasurement)
        } else {
            // set pitch to 0
            self.soundControl.adjustPitch(measurement: 0)
        }
        var frequencyMeasurement = vmg_delta
        switch frequencyValue {
        case .vmg:
            frequencyMeasurement = vmg
        default:
            frequencyMeasurement = vmg_delta
        }
        // assume that max vmg change is 30kts per second
        let maxVMGChage = 30.0
        if updateFrequency {
            self.soundControl.adjustSpeed(measurement: abs(frequencyMeasurement), maxMeasurement: maxVMGChage)
        } else {
            // set frequency to 1
            self.soundControl.adjustSpeed(measurement: 0, maxMeasurement: maxVMGChage)
        }
        
    }
}
