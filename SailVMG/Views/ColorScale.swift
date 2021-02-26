//
//  ColorScale.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/9/21.
//

import SwiftUI

struct ColorScale: View {
    @EnvironmentObject var trackVM: TrackViewModel
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            VStack {
                Text(String(format: "%.2f", trackVM.max_upwind_vmg ?? 0) + " kts")
                    .font(.body)
                Spacer()
                Text(String(format: "%.2f", trackVM.max_downwind_vmg ?? 0) + " kts")
                    .font(.body)
                
                
            }
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: trackVM.getSwiftUIColors()), startPoint: .bottom, endPoint: .top))
                .frame(width: 10, height: 300)
                .cornerRadius(5.0)
                .padding(.leading, 5)
            
        }.frame(height: 300)
        .padding()
        
        
    }
}

struct ColorScale_Previews: PreviewProvider {
    static var previews: some View {
        ColorScale()
    }
}
