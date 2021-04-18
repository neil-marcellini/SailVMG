//
//  LargeCompassTick.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/30/21.
//

import SwiftUI

struct LargeCompassTick: View {
    let circle_size: CGFloat
    let degree: Int
    var body: some View {
        VStack(spacing: 0) {
            Text("\(degree)°")
            Capsule()
                .frame(width: 2, height: 30)
        }
        .offset(x: 0, y: -(circle_size + 25))
        .rotationEffect(Angle(degrees: Double(degree)))
    }
}

struct LargeCompassTick_Previews: PreviewProvider {
    static var previews: some View {
        LargeCompassTick(circle_size: -130, degree: 0)
    }
}
