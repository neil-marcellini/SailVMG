//
//  TWDControl.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/12/21.
//

import SwiftUI

struct TWDControl: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var nav: NavigationControl
    let labelColor = Color(.label)
    var body: some View {
        HStack {
            Button(action: { locationViewModel.minusTwd() }){
                Image(systemName: "minus.square.fill")
                    .font(.custom("BButton", size: 80, relativeTo: .body))
                    .foregroundColor(labelColor)
            }
            Button(action: { locationViewModel.plusTwd() }){
                Image(systemName: "plus.app.fill")
                    .font(.custom("BButton", size: 80, relativeTo: .body))
                    .foregroundColor(labelColor)
            }
        }
        
    }
}

struct TWDControl_Previews: PreviewProvider {
    static var previews: some View {
        TWDControl()
    }
}
