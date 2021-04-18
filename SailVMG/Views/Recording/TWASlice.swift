//
//  SliceTest.swift
//  SailVMG
//
//  Created by Neil Marcellini on 4/14/21.
//

import SwiftUI

struct TWASlice: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    var body: some View {
        CircleSlice(start: 0, delta: Double(locationViewModel.twd) - locationViewModel.course)
            .frame(width: 300, height: 300)
            .foregroundColor(Color(.label))
            .rotationEffect(Angle(degrees: 0))
    }
}
extension TWASlice {
    func drawClockwise() -> Bool {
        let cog = locationViewModel.roundMetric(metric: locationViewModel.course)
        let diff = locationViewModel.twd - cog
        if diff > 0 {
            return diff > 180
        } else {
            return diff >= -180
        }
    }
}

struct SliceTest_Previews: PreviewProvider {
    static var previews: some View {
        TWASlice()
    }
}
