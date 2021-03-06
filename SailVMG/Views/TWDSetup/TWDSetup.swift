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
    let isReset: Bool
    var body: some View {
        VStack {
            Spacer()
            Text("TWD")
                .font(.largeTitle)
            Text(locationViewModel.headingDisplay())
                .font(.largeTitle)
            Spacer()
            GeometryReader { geo in
                VStack {
                    Compass(size: geo.size.width / 2)
                }.frame(width: geo.size.width,
                        height: geo.size.height,
                        alignment: .center)
            }.padding(60)
            Spacer()
            Button(action: {
                locationViewModel.twd = locationViewModel.roundMetric(metric: locationViewModel.heading)
                if isReset {
                    nav.showTWDReset = false
                    return
                }
                guard let track = trackRepository.createTrack() else {
                    nav.selection = nil
                    return
                }
                locationViewModel.startRecording(track: track)
                nav.selection = "RecordingView"
                
            }){
                Image(systemName: "checkmark.circle").font(.custom("BButton", size: 80, relativeTo: .body))
            }
            
        }.navigationTitle("TWD Setup")
        .onAppear {
            locationViewModel.locationManager.startUpdatingHeading()
        }
        .onDisappear {
            locationViewModel.locationManager.stopUpdatingHeading()
        }
    }
}

struct TWDSetup_Previews: PreviewProvider {
    static var previews: some View {
        TWDSetup(isReset: false)
    }
}
