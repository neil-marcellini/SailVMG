//
//  TWDSetup.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/30/21.
//

import SwiftUI

struct TWDSetup: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var trackRepository: TrackRespository
    @EnvironmentObject var nav: NavigationControl
    var body: some View {
        VStack {
            Text("TWD")
                .font(.largeTitle)
            Text("\(locationViewModel.heading)°")
                .font(.largeTitle)
            Spacer()
            Compass()
                .onAppear {
                    locationViewModel.locationManager.startUpdatingHeading()
                }
                .onDisappear {
                    locationViewModel.locationManager.stopUpdatingHeading()
                }
                .rotationEffect(Angle(degrees: locationViewModel.heading))
            Spacer()
            
            Button(action: {
                locationViewModel.startRecording()
                nav.selection = "RecordingView"
            }){
                Image(systemName: "checkmark.circle").font(.system(size: 100))
            }
                
        }.navigationTitle("TWD Setup")
    }
}

struct TWDSetup_Previews: PreviewProvider {
    static var previews: some View {
        TWDSetup()
    }
}
