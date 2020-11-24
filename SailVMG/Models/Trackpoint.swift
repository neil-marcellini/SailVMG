//
//  Trackpoint.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
struct Trackpoint: Codable, Identifiable {
    let id: UUID
    let time: Date
    let latitude: Double
    let longitude: Double
    let speed: Double
    let course: Double
    let vmg: Double
}
