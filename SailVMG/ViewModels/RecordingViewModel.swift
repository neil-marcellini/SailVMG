//
//  RecordingViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 12/1/20.
//

import Foundation
class RecordingViewModel: ObservableObject {

    func speedDisplay(_ speed: Double) ->  String {
        return String(format: "%.2f kts", speed)
    }
    
    func courseDisplay(_ course: Double) ->  String {
        return String(format: "%.0f°", course)
    }
    
    func twdDisplay(_ twd: Double) ->  String {
        return String(format: "%03.0f°", twd)
    }
    
    func vmgDisplay(_ vmg: Double) ->  String {
        return String(format: "%.2f kts", vmg)
    }
    
}
