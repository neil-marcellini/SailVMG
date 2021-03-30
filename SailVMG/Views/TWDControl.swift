//
//  TWDControl.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/12/21.
//

import SwiftUI

struct TWDControl: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    let labelColor = Color(.label)
    var body: some View {
        VStack {
            Text("TWD")
                .font(.title)
                .foregroundColor(labelColor)
            HStack {
                Button(action: { locationViewModel.minusTwd() }){
                    Image(systemName: "minus.square.fill")
                        .font(.system(size: 50))
                        .foregroundColor(labelColor)
                }
                Text(locationViewModel.twdDisplay())
                    .frame(width: 50)
                Button(action: { locationViewModel.plusTwd() }){
                    Image(systemName: "plus.app.fill")
                        .font(.system(size: 50))
                        .foregroundColor(labelColor)
                }
            }
            
            Slider(value: $locationViewModel.twd, in: 0...359, step: 1)
                .frame(width: 150)
        }
        
    }
}

struct TWDControl_Previews: PreviewProvider {
    static var previews: some View {
        TWDControl()
    }
}
