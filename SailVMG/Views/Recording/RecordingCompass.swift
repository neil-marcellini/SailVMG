//
//  RecordingCompass.swift
//  SailVMG
//
//  Created by Neil Marcellini on 4/13/21.
//

import SwiftUI

struct RecordingCompass: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    let size: CGFloat
    var body: some View {
        let sogArrowLen = locationViewModel.arrowLen(metric: locationViewModel.speed, compass_size: size)
        ZStack {
            ForEach(0..<360) { degree in
                if degree == locationViewModel.twd {
                    Capsule()
                        .frame(width: 2, height: 30)
                        .offset(x: 0, y: -(size + 15))
                        .rotationEffect(Angle(degrees: Double(degree)))
                        .foregroundColor(.red)
                } else if degree % 90 == 0 {
                    LargeCompassTick(circle_size: size, degree: degree)
                } else if degree % 2 == 0 {
                    CompassTick(circle_size: size, degree: degree)
                }
            }
            .rotationEffect(Angle(degrees: -locationViewModel.course))
            Capsule()
                .frame(width: 3, height: 30)
                .offset(x: 0, y: -(size + 15))
                .foregroundColor(.blue)
            Arrow()
                .frame(width: 10, height: sogArrowLen)
                .foregroundColor(.blue)
                .offset(x: 0, y: -(sogArrowLen / 2))
            VMGArrow(size: size)
                .rotationEffect(Angle(degrees: -locationViewModel.course))
            Circle()
                .frame(width: 8, height: 8)
                .foregroundColor(Color(.label))
        }.padding()
    }
}



struct RecordingCompass_Previews: PreviewProvider {
    static var previews: some View {
        RecordingCompass(size: 130)
    }
}
