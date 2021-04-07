//
//  Track.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Track: Codable, Identifiable {
    @DocumentID var id: String?
    var start_time: Date
    var end_time: Date?
    var userId: String?
    var preview_url: URL?
    var city: String?
    var state: String?
    var max_upwind_vmg: Double?
    var max_downwind_vmg: Double?
}
