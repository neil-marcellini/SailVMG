//
//  TWDArrow.swift
//  SailVMG
//
//  Created by Neil Marcellini on 4/13/21.
//

import SwiftUI

struct TWDArrow: View {
    let circle_size: CGFloat
    let degree: Int
    var body: some View {
        VStack(spacing: 0) {
            Text("\(degree)°")
            Arrow()
                .frame(width: 10, height: 50)
                .rotationEffect(Angle(degrees: 180))
        }
        .offset(x: 0, y: -(circle_size + 15))
        .rotationEffect(Angle(degrees: Double(degree)))
        .foregroundColor(.red)
    }
}

struct TWDArrow_Previews: PreviewProvider {
    static var previews: some View {
        TWDArrow(circle_size: 50, degree: 23)
    }
}
