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
                                                  "ratePerKnot": 0.25])
    }
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(locationViewModel)
        }
    }
}
