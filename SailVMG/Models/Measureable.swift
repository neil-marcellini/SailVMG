//
//  Measurable.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/31/21.
//

import Foundation

// a value that can related through audio feedback
enum Measureable:String, CaseIterable, Identifiable {
    case vmg = "VMG"
    case vmg_acceleration = "VMG Acceleration"
    
    var id: String { self.rawValue }
    
}
