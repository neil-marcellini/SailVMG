//
//  RecordingState.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import Foundation
class RecordingState: ObservableObject {
    @Published var isRecording = false
    @Published var isPaused = false
    
}
