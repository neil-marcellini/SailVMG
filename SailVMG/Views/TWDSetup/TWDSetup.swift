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
            Spacer()
            Text("TWD")
                .font(.largeTitle)
            Text(locationViewModel.headingDisplay())
                .font(.largeTitle)
            Spacer()
            Compass()
            Spacer()
            Button(action: {
                locationViewModel.twd = locationViewModel.heading
                guard let track = trackRepository.createTrack() else {
                    nav.selection = nil
                    return
                }
                locationViewModel.startRecording(track: track)
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
