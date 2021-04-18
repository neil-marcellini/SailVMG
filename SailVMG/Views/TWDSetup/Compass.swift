//
//  TWDSetup.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/30/21.
//

import SwiftUI

struct Compass: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    let size: CGFloat
    var body: some View {
            ZStack {
                ForEach(Array(stride(from: 0, to: 360, by: 2)), id: \.self) { degree in
                    if degree % 90 == 0 {
                        LargeCompassTick(circle_size: size, degree: degree)
                    } else {
                        CompassTick(circle_size: size, degree: degree)
                    }
                }
                .rotationEffect(Angle(degrees: -locationViewModel.heading))
                Capsule()
                    .frame(width: 3, height: 40)
                    .offset(x: 0, y: -size)
                    .foregroundColor(.blue)
                Image(systemName: "location.north.fill")
                    .font(.system(size: 150))
                    .foregroundColor(.blue)
            }.padding()
    }
}

struct Compass_Previews: PreviewProvider {
    static var previews: some View {
        Compass(size: 150.0)
    }
}
