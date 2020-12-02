//
//  RecordingViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 12/1/20.
//

import Foundation
import SwiftUI
class RecordingViewModel: ObservableObject {
    
    func getSpeed(speed: Double)->String {
        return String(format: "%.2f kts", speed)
    }
    
    func getCourse(cog: Double) -> String {
        return String(format: "%.0f°", cog)
    }
    
}
