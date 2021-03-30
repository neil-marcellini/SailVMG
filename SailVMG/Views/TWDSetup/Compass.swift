//
//  TWDSetup.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/30/21.
//

import SwiftUI

struct Compass: View {
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
            }.padding()
    }
}

struct Compass_Previews: PreviewProvider {
    static var previews: some View {
        Compass()
    }
}
