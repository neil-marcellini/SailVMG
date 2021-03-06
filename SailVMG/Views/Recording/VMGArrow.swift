//
//  VMGArrow.swift
//  SailVMG
//
//  Created by Neil Marcellini on 4/13/21.
//

import SwiftUI

struct VMGArrow: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    let size: CGFloat
    var body: some View {
        let vmg_len = locationViewModel.arrowLen(metric: locationViewModel.vmg, compass_size: size)
        if locationViewModel.vmg < 0 {
            let flippedAngle = locationViewModel.mod(locationViewModel.twd + 180, 360)
            Arrow()
                .frame(width: 10, height: abs(vmg_len))
                .foregroundColor(.green)
                .offset(x: 0, y: -(abs(vmg_len) / 2))
                .rotationEffect(Angle(degrees: Double(flippedAngle)))
        } else {
            Arrow()
                .frame(width: 10, height: vmg_len)
                .foregroundColor(.green)
                .offset(x: 0, y: -(abs(vmg_len) / 2))
                .rotationEffect(Angle(degrees: Double(locationViewModel.twd)))
        }
    }
}

struct VMGArrow_Previews: PreviewProvider {
    static var previews: some View {
        VMGArrow(size: 150)
    }
}
