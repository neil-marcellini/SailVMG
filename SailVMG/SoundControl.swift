//
//  SoundControl.swift
//  SolidSail
//
//  Created by Neil Marcellini on 8/23/20.
//  Copyright © 2020 Neil Marcellini. All rights reserved.
//

import Foundation
import AVKit
import SwiftUI
class SoundControl {
    let engine = AVAudioEngine()
    let audioControl = AVAudioUnitTimePitch()
    var audioPlayer: AVAudioPlayer?
    let sound_file = "bing1s.mp3"
    
    func play() throws {
        self.configureAudioSession()
        self.setAudioSession(active: true)
        let path = Bundle.main.path(forResource: sound_file, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        // 1: load the file
        let file = try AVAudioFile(forReading: url)
        let audioFormat = file.processingFormat
        let audioFrameCount = UInt32(file.length)
        guard let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount) else {return}
        try file.read(into: audioFileBuffer, frameCount: audioFrameCount)

        // 2: create the audio player
        let audioPlayer = AVAudioPlayerNode()

        // 3: connect the components to our playback engine
        engine.attach(audioPlayer)
        engine.attach(audioControl)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(audioPlayer, to: audioControl, format: audioFormat)
        engine.connect(audioControl, to: engine.mainMixerNode, format: audioFormat)

        // 5: prepare the player to play its file from the beginning
//        audioPlayer.scheduleFile(file, at: nil)

        // 6: start the engine and player
        try engine.start()
        audioPlayer.play()
        audioPlayer.scheduleBuffer(audioFileBuffer, at: nil, options: .loops, completionHandler: nil)
    }
    
    func stop() {
        engine.stop()
        self.setAudioSession(active: false)
    }
    
    
    func adjustPitch(measurement: Double){
        self.audioControl.pitch = Float(measurement) * 50
    }
    
    func adjustSpeed(measurement: Double, maxMeasurement: Double) {
        // range of rate = 1/32 to 32.0, default = 1
        // squish measurement between 1 and 32 based on maxMeasurment
        let fractionOfMax = measurement / maxMeasurement
        // change by a fraction of the ratio
        let rateStrength = 0.25
        let newRate = fractionOfMax * 31 * rateStrength + 1
        print("newRate = \(newRate)")
        self.audioControl.rate = Float(newRate)
    }
    
    func configureAudioSession() {
        // Access the shared, singleton audio session instance
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure the audio session for movie playback
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: AVAudioSession.Mode.default,
                                    options: [])
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }
    }
    func setAudioSession(active: Bool) {
        // Access the shared, singleton audio session instance
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(active)
        } catch let error as NSError {
            print("Unable to activate audio session: \(error.localizedDescription)")
        }
    }
    
}
