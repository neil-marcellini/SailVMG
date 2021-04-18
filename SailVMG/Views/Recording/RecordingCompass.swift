//
//  RecordingCompass.swift
//  SailVMG
//
//  Created by Neil Marcellini on 4/13/21.
//

import SwiftUI

struct RecordingCompass: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    let size: CGFloat = 150
    var body: some View {
        let sogArrowLen = locationViewModel.arrowLen(metric: locationViewModel.speed, compass_size: size)
        ZStack {
            ForEach(0..<360) { degree in
                if degree % 90 == 0 {
                    LargeCompassTick(circle_size: size, degree: degree)
                } else {
                    CompassTick(circle_size: size, degree: degree)
                }
            }
                .rotationEffect(Angle(degrees: -locationViewModel.course))
            ForEach(0..<360) { degree in
                if degree == Int(locationViewModel.twd) {
                    TWDArrow(circle_size: size, degree: degree)
                }
            }
                .rotationEffect(Angle(degrees: -locationViewModel.course))
            TWASlice()
                .frame(width: size * 2, height: size * 2)
                .foregroundColor(.gray)
                .opacity(0.7)
                .rotationEffect(Angle(degrees: -90.0))
            Capsule()
                .frame(width: 3, height: 40)
                .offset(x: 0, y: -size)
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
        RecordingCompass()
    }
}
