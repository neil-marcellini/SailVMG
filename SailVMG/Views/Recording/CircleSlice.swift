//
//  CircleSlice.swift
//  SailVMG
//
//  Created by Neil Marcellini on 4/14/21.
//

import Foundation
import SwiftUI
struct CircleSlice: Shape {
    let start: Double
    let delta: Double
    func path(in rect: CGRect) -> Path {
        let radius = rect.size.width / 2
        let centerX = radius
        let centerY = radius
        
        
        var path = Path()
        path.move(to: CGPoint(x: centerX, y: centerY))
        path.addRelativeArc(center: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: Angle(degrees: start), delta: Angle(degrees: delta))
//        path.addArc(center: CGPoint(x: centerX, y: centerY),
//                    radius: radius,
//                    startAngle: Angle(degrees: start),
//                    endAngle: Angle(degrees: end),
//                    clockwise: drawClockwise)
        return path
    }
}
