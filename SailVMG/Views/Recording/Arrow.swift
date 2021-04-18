//
//  Arrow.swift
//  SailVMG
//
//  Created by Neil Marcellini on 4/13/21.
//

import Foundation
import SwiftUI

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let arrowWidth = rect.size.width / 2
        let arrowHeight = arrowWidth * 2
        let lineWidth = arrowWidth / 4
        
        let centerX = rect.size.width / 2
        path.move(to: CGPoint(x: centerX, y: 0))
        path.addLine(to: CGPoint(x: centerX + arrowWidth, y: 0 + arrowHeight))
        path.addLine(to: CGPoint(x: centerX + lineWidth, y: 0 + arrowHeight))
        path.addLine(to: CGPoint(x: centerX + lineWidth, y: rect.size.height))
        path.addLine(to: CGPoint(x: centerX - lineWidth, y: rect.size.height))
        path.addLine(to: CGPoint(x: centerX - lineWidth, y: 0 + arrowHeight))
        path.addLine(to: CGPoint(x: centerX - arrowWidth, y: 0 + arrowHeight))
        path.closeSubpath()
        return path
    }
    
}
