//
//  ColorScale.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/9/21.
//

import SwiftUI

struct ColorScale: View {
    let trackVM: TrackViewModel
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: trackVM.getSwiftUIColors()), startPoint: .leading, endPoint: .trailing))
                .frame(width: 300, height: 10)
                .cornerRadius(5.0)
            HStack {
                Text(String(format: "%.2f", trackVM.max_downwind_vmg ?? 0) + " kts")
                    .font(.body)
                Spacer()
                Text(String(format: "%.2f", trackVM.max_upwind_vmg ?? 0) + " kts")
                    .font(.body)
            }
        }
        
        
    }
}

struct ColorScale_Previews: PreviewProvider {
    static var previews: some View {
        ColorScale(trackVM: TrackViewModel(Track(id: nil, start_time: Date(), end_time: nil)))
    }
}
