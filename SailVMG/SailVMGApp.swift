//
//  SailVMGApp.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/13/20.
//

import SwiftUI
import Firebase

@main
struct SailVMGApp: App {
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var trackRepository = TrackRespository()
    init(){
        FirebaseApp.configure()
        Auth.auth().signInAnonymously()
        // set default values
        UserDefaults.standard.register(defaults: ["audioFeedback": true,
                                                  "updatePitch": true,
                                                  "updateFrequency": true,
                                                  "pitchValue": "VMG",
                                                  "frequencyValue": "VMG Acceleration",
                                                  "semitonesPerKnot": 0.5,
                                                  "ratePerKnot": 0.25,
                                                  "launchCount": 0])
        var launchCount = UserDefaults.standard.integer(forKey: "launchCount")
        launchCount += 1
        print("launchCount = \(launchCount)")
        UserDefaults.standard.set(launchCount, forKey: "launchCount")
    }
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(locationViewModel)
                .environmentObject(trackRepository)        }
    }
}
