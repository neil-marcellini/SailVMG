//
//  LargeCompassTick.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/30/21.
//

import SwiftUI

struct LargeCompassTick: View {
    let circle_size: Int
    let degree: Int
    var body: some View {
        VStack(spacing: 0) {
            Text("\(degree)°")
            Capsule()
                .frame(width: 2, height: 30)
        }
        .offset(x: 0, y: -(CGFloat(circle_size + 15)))
        .rotationEffect(Angle(degrees: Double(degree)))
    }
}

struct LargeCompassTick_Previews: PreviewProvider {
    static var previews: some View {
        LargeCompassTick(circle_size: -130, degree: 0)
    }
}
