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
    func play() throws {

        let path = Bundle.main.path(forResource: "432hz.mp3", ofType:nil)!
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
        engine.connect(audioPlayer, to: speedControl, format: nil)
        engine.connect(speedControl, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
//        audioPlayer.scheduleFile(file, at: nil)

        // 6: start the engine and player
        try engine.start()
        audioPlayer.play()
        audioPlayer.scheduleBuffer(audioFileBuffer, at: nil, options: .loops, completionHandler: nil)
    }
    
    func stop() {
        engine.stop()
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
}
