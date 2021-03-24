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
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()
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
        engine.attach(pitchControl)
        engine.attach(speedControl)

        // 4: arrange the parts so that output from one is input to another
        engine.connect(audioPlayer, to: speedControl, format: audioFormat)
        engine.connect(speedControl, to: pitchControl, format: audioFormat)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: audioFormat)

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
    
    func newPlay() {
        let path = Bundle.main.path(forResource: "432hz.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.enableRate = true
            audioPlayer?.play()
        } catch {
            // couldn't load file :(
            print(error)
        }
    }
    
    func adjustPitch(measurement: Double){
        self.pitchControl.pitch = Float(measurement) * 50
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
