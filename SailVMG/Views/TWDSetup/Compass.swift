//
//  TWDSetup.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/30/21.
//

import SwiftUI

struct Compass: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    let size = 150
    var body: some View {
            ZStack {
                
                ForEach(0..<360) { degree in
                    if degree % 90 == 0 {
                        LargeCompassTick(circle_size: size, degree: degree)      
                    } else {
                        CompassTick(circle_size: size, degree: degree)
                    }
                }
                .rotationEffect(Angle(degrees: -locationViewModel.heading))
                Capsule()
                    .frame(width: 3, height: 40)
                    .offset(x: 0, y: -CGFloat(size))
                    .foregroundColor(.blue)
                Image(systemName: "location.north.fill")
                    .font(.system(size: 150))
                    .foregroundColor(.blue)
            }.padding()
            .onAppear {
                locationViewModel.locationManager.startUpdatingHeading()
            }
            .onDisappear {
                locationViewModel.locationManager.stopUpdatingHeading()
            }
    }
}

struct Compass_Previews: PreviewProvider {
    static var previews: some View {
        Compass()
    }
}
