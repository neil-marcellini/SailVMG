//
//  CompassTick.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/30/21.
//

import SwiftUI

struct CompassTick: View {
    let circle_size: CGFloat
    let degree: Int
    var body: some View {
        Capsule()
            .frame(width: 1, height: 20)
            .offset(x: 0, y: -(circle_size + 10))
            .rotationEffect(Angle(degrees: Double(degree)))
    }
}

struct CompassTick_Previews: PreviewProvider {
    static var previews: some View {
        CompassTick(circle_size: 130, degree: 0)
    }
}
